import { isDeepStrictEqual } from 'node:util';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { and, eq, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { Valkey } from 'iovalkey';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { VALKEY } from '../../valkey/valkey.module.js';
import { AuditService, type AuditRequestContext } from '../audit/index.js';
import {
  type AdminRole,
  catalogue,
  keyParameter,
  keyParameters,
  type SettingDefinition,
  type SettingKey,
  type SettingValue,
} from './catalogue.js';
import { changes, values } from './schema.js';

// Which setting: the city of a city setting, and the parameter of a key
// written with <...>, such as TRY for currency.<code>.rounding_unit.
export interface SettingTarget {
  cityId?: string | null;
  parameter?: string;
}

export interface SettingChange {
  // An admin account and the roles it holds now (AP §6.1).
  editor: { id: string; roles: readonly AdminRole[] };
  context: AuditRequestContext;
  reason?: string | null;
}

export type SettingRefusal =
  'wrong_scope' | 'wrong_parameter' | 'invalid_value' | 'role_may_not_edit' | 'reason_required';

export class SettingRefusedError extends Error {
  constructor(
    readonly refusal: SettingRefusal,
    readonly key: string,
    message: string,
  ) {
    super(`${key}: ${message}`);
    this.name = 'SettingRefusedError';
  }
}

interface ResolvedSetting {
  // The concrete key, such as currency.TRY.rounding_unit.
  key: string;
  cityId: string | null;
  definition: SettingDefinition;
}

interface StoredState {
  value: unknown;
  isDefault: boolean;
  version: number;
}

// A cached value is kept this long, a bound on a value left stale when Valkey
// could not be reached during a change.
const CACHE_SECONDS = 600;

// Sets the cached value only over an older version, so a read that raced a
// change never puts back the value the change replaced. The value is stored
// as "<version>:<JSON>".
export const SET_IF_NEWER = `
local current = redis.call('GET', KEYS[1])
if current then
  local version = tonumber(string.match(current, '^(%d+):'))
  if version and version >= tonumber(ARGV[1]) then return 0 end
end
redis.call('SET', KEYS[1], ARGV[1] .. ':' .. ARGV[2], 'EX', ARGV[3])
return 1`;

// The settings model of AP §4.4: typed values from the catalogue, overridden
// per scope by a stored value, every change kept in the history and audited.
@Injectable()
export class SettingsService {
  private readonly logger = new Logger(SettingsService.name);

  constructor(
    @Inject(DATABASE) private readonly database: Database,
    @Inject(VALKEY) private readonly valkey: Valkey,
    private readonly audit: AuditService,
  ) {}

  // The value in effect: the stored one, or the default. Null for a value
  // still to be entered before launch.
  async get<Key extends SettingKey>(
    key: Key,
    target: SettingTarget = {},
  ): Promise<SettingValue<Key>> {
    const setting = this.resolve(key, target);
    const cacheKey = this.cacheKey(setting);
    const cached = await this.readCache(cacheKey);
    if (cached !== undefined) return cached as SettingValue<Key>;

    const state = await this.stored(this.database.db, setting);
    const value = this.effective(setting, state);
    await this.writeCache(cacheKey, state.version, value);
    return value as SettingValue<Key>;
  }

  // Sets a new value, in effect at once (AP §4.4).
  async update(
    key: SettingKey,
    target: SettingTarget,
    value: unknown,
    change: SettingChange,
  ): Promise<void> {
    const setting = this.resolve(key, target);
    const parsed = setting.definition.schema.safeParse(value);
    if (!parsed.success) {
      throw new SettingRefusedError('invalid_value', setting.key, parsed.error.message);
    }
    await this.change(setting, { value: parsed.data, isDefault: false }, change);
  }

  // «استعادة القيمة الافتراضية»: the setting follows its default again.
  async reset(key: SettingKey, target: SettingTarget, change: SettingChange): Promise<void> {
    await this.change(this.resolve(key, target), { value: null, isDefault: true }, change);
  }

  private resolve(key: SettingKey, target: SettingTarget): ResolvedSetting {
    const definition: SettingDefinition = catalogue[key];
    const cityId = target.cityId ?? null;
    if ((definition.scope === 'city') !== (cityId !== null)) {
      throw new SettingRefusedError(
        'wrong_scope',
        key,
        definition.scope === 'city'
          ? 'a city setting needs its city'
          : 'a global setting has no city',
      );
    }
    const parameter = keyParameter(key);
    if (parameter === null) {
      if (target.parameter !== undefined) {
        throw new SettingRefusedError('wrong_parameter', key, 'this key takes no parameter');
      }
      return { key, cityId, definition };
    }
    const value = keyParameters[parameter].safeParse(target.parameter);
    if (!value.success) {
      throw new SettingRefusedError('wrong_parameter', key, `expected a ${parameter}`);
    }
    return { key: key.replace(`<${parameter}>`, value.data), cityId, definition };
  }

  private async change(
    setting: ResolvedSetting,
    next: { value: unknown; isDefault: boolean },
    { editor, context, reason }: SettingChange,
  ): Promise<void> {
    if (!editor.roles.some((role) => setting.definition.editRoles.includes(role))) {
      throw new SettingRefusedError(
        'role_may_not_edit',
        setting.key,
        `only ${setting.definition.editRoles.join(', ')} may edit it`,
      );
    }
    const givenReason = reason?.trim() || null;
    if (setting.definition.reasonRequired && givenReason === null) {
      throw new SettingRefusedError('reason_required', setting.key, 'a change needs a reason');
    }

    const saved = await this.database.db.transaction(async (tx) => {
      // Changes of one setting take turns, so each records the value it replaced.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`settings:${setting.key}:${setting.cityId ?? 'global'}`}, 0))`,
      );
      const before = await this.stored(tx, setting);
      if (before.isDefault === next.isDefault && isDeepStrictEqual(before.value, next.value)) {
        return null;
      }
      const after: StoredState = { ...next, version: before.version + 1 };
      if (before.version === 0) {
        await tx.insert(values).values({ key: setting.key, cityId: setting.cityId, ...next });
      } else {
        await tx
          .update(values)
          .set({ ...next, version: after.version, updatedAt: sql`now()` })
          .where(this.row(setting));
      }

      const beforeValue = this.effective(setting, before);
      const afterValue = this.effective(setting, after);
      const action = next.isDefault ? 'reset' : 'update';
      await tx.insert(changes).values({
        key: setting.key,
        cityId: setting.cityId,
        action,
        before: beforeValue,
        after: afterValue,
        editorId: editor.id,
        editorRoles: [...editor.roles],
        reason: givenReason,
      });
      await this.audit.recordWrite(
        {
          actor: { type: 'admin', id: editor.id, role: editor.roles.join(',') },
          context,
          cityId: setting.cityId,
          action: `setting.${action}`,
          target: { type: 'setting', id: setting.key },
          before: { value: beforeValue, isDefault: before.isDefault },
          after: { value: afterValue, isDefault: after.isDefault },
          reason: givenReason,
        },
        tx,
      );
      return { version: after.version, value: afterValue };
    });

    if (saved) await this.writeCache(this.cacheKey(setting), saved.version, saved.value);
  }

  // The stored row, or version 0 when the setting was never changed.
  private async stored(
    executor: Pick<NodePgDatabase, 'select'>,
    setting: ResolvedSetting,
  ): Promise<StoredState> {
    const [row] = await executor
      .select({ value: values.value, isDefault: values.isDefault, version: values.version })
      .from(values)
      .where(this.row(setting));
    return row ?? { value: null, isDefault: true, version: 0 };
  }

  private row(setting: ResolvedSetting) {
    return and(
      eq(values.key, setting.key),
      sql`${values.cityId} IS NOT DISTINCT FROM ${setting.cityId}`,
    );
  }

  private effective(setting: ResolvedSetting, state: StoredState): unknown {
    return state.isDefault ? setting.definition.default : state.value;
  }

  private cacheKey(setting: ResolvedSetting): string {
    return `settings:${setting.cityId ?? 'global'}:${setting.key}`;
  }

  // Valkey is a cache here: when it cannot be reached, reads go to PostgreSQL.
  private async readCache(cacheKey: string): Promise<unknown> {
    try {
      const cached = await this.valkey.get(cacheKey);
      if (cached === null) return undefined;
      return (JSON.parse(cached.slice(cached.indexOf(':') + 1)) as { value: unknown }).value;
    } catch (error) {
      this.logger.warn({ err: error, cacheKey }, 'settings cache read failed');
      return undefined;
    }
  }

  private async writeCache(cacheKey: string, version: number, value: unknown): Promise<void> {
    try {
      await this.valkey.eval(
        SET_IF_NEWER,
        1,
        cacheKey,
        version,
        JSON.stringify({ value }),
        CACHE_SECONDS,
      );
    } catch (error) {
      this.logger.warn({ err: error, cacheKey }, 'settings cache write failed');
    }
  }
}
