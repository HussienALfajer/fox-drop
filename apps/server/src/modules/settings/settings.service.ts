import { createHash } from 'node:crypto';
import { isDeepStrictEqual } from 'node:util';
import { Inject, Injectable, Logger } from '@nestjs/common';
import { and, desc, eq, isNull, or, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { Valkey } from 'iovalkey';
import { z } from 'zod';
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
  type SettingGroup,
  settingGroupOf,
  settingGroups,
  type SettingKey,
  type SettingType,
  type SettingUnit,
  type SettingValue,
} from './catalogue.js';
import { changes, values } from './schema.js';

// Which setting: the city of a city setting, and the parameter of a key
// written with <...>, such as TRY for currency.<code>.rounding_unit.
export interface SettingTarget {
  cityId?: string | null;
  parameter?: string | undefined;
}

export interface SettingChange {
  // An admin account and the roles it holds now (AP §6.1).
  editor: { id: string; roles: readonly AdminRole[] };
  context: AuditRequestContext;
  reason?: string | null;
}

// A setting as the group screens of AP §9.14 show it: the concrete key, its
// catalogue entry, the default and the value in effect.
export interface SettingEntry {
  key: string;
  template: SettingKey;
  parameter: string | null;
  group: SettingGroup;
  type: SettingType;
  unit: SettingUnit | null;
  scope: 'global' | 'city';
  cityId: string | null;
  editRoles: readonly AdminRole[];
  reasonRequired: boolean;
  beforeLaunch: boolean;
  default: unknown;
  value: unknown;
  isDefault: boolean;
}

// One row of a setting's change history (AP §4.4).
export interface SettingHistoryEntry {
  action: 'update' | 'reset';
  before: unknown;
  after: unknown;
  editorId: string;
  editorRoles: string[];
  reason: string | null;
  changedAt: Date;
}

export type SettingRefusal =
  | 'unknown_key'
  | 'wrong_scope'
  | 'wrong_parameter'
  | 'invalid_value'
  | 'role_may_not_edit'
  | 'reason_required'
  | 'no_default';

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
  // The concrete key, such as currency.TRY.rounding_unit, and its catalogue
  // entry's key, such as currency.<code>.rounding_unit.
  key: string;
  template: SettingKey;
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

// The longest reason a change keeps.
const REASON_MAX_LENGTH = 500;

// The most recent changes a history read returns.
const HISTORY_LIMIT = 100;

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
    const setting = this.resolveFor(key, target, change.editor.roles);
    const parsed = setting.definition.schema.safeParse(value);
    if (!parsed.success) {
      throw new SettingRefusedError('invalid_value', setting.key, parsed.error.message);
    }
    await this.change(setting, { value: parsed.data, isDefault: false }, change);
  }

  // «استعادة القيمة الافتراضية»: the setting follows its default again. A
  // value entered before launch has no default to go back to.
  async reset(key: SettingKey, target: SettingTarget, change: SettingChange): Promise<void> {
    const setting = this.resolveFor(key, target, change.editor.roles);
    if (setting.definition.beforeLaunch) {
      throw new SettingRefusedError('no_default', setting.key, 'this setting has no default');
    }
    await this.change(setting, { value: null, isDefault: true }, change);
  }

  // The concrete key of a request, such as currency.TRY.rounding_unit, as
  // its catalogue key and parameter.
  parseKey(key: string): { key: SettingKey; parameter?: string } {
    if (Object.hasOwn(catalogue, key)) return { key: key as SettingKey };
    for (const template of Object.keys(catalogue) as SettingKey[]) {
      const parameter = keyParameter(template);
      if (parameter === null) continue;
      const [prefix, suffix] = keyEnds(template, parameter);
      if (
        key.length > prefix.length + suffix.length &&
        key.startsWith(prefix) &&
        key.endsWith(suffix)
      ) {
        return { key: template, parameter: key.slice(prefix.length, key.length - suffix.length) };
      }
    }
    throw new SettingRefusedError('unknown_key', key, 'not in the settings catalogue');
  }

  // The settings these roles may edit, global and of the city, in the order
  // of the group screens of AP §9.14 (owner decision 2026-11-05: each role
  // sees the settings it edits). A key with <vehicle> or <app> is one entry
  // per value; currency.<code>.* is listed once as itself, to add a
  // currency, and once per currency already stored for the city, since the
  // city's currencies are not data yet (AP §13 item 4).
  async list(cityId: string, roles: readonly AdminRole[]): Promise<SettingEntry[]> {
    if (!z.uuid().safeParse(cityId).success) {
      throw new SettingRefusedError('wrong_scope', 'settings', 'the city is not a city id');
    }
    const keys = (Object.keys(catalogue) as SettingKey[]).filter((key) =>
      mayEdit(catalogue[key], roles),
    );
    if (keys.length === 0) {
      throw new SettingRefusedError('role_may_not_edit', 'settings', 'no setting for these roles');
    }
    const rows = await this.database.db
      .select({
        key: values.key,
        cityId: values.cityId,
        value: values.value,
        isDefault: values.isDefault,
        version: values.version,
      })
      .from(values)
      .where(or(isNull(values.cityId), eq(values.cityId, cityId)));
    const stored = new Map(rows.map((row) => [`${row.cityId ?? 'global'}:${row.key}`, row]));
    const never: StoredState = { value: null, isDefault: true, version: 0 };

    const entries = keys.flatMap((key) => {
      const target = catalogue[key].scope === 'city' ? cityId : null;
      const listed = this.parametersOf(key, rows, target).map((parameter) => {
        const setting = this.resolve(key, { cityId: target, parameter });
        const state = stored.get(`${target ?? 'global'}:${setting.key}`) ?? never;
        return this.entry(setting, state, parameter ?? null);
      });
      if (keyParameter(key) !== 'code') return listed;
      // Owner decision 2026-11-05: the key itself, with no currency, is the
      // panel's «أضف عملة», so every Appendix A setting is always listed.
      const template = { key, template: key, cityId: target, definition: catalogue[key] };
      return [this.entry(template, never, null), ...listed];
    });
    const order = (entry: SettingEntry) => settingGroups.indexOf(entry.group);
    return entries.sort((a, b) => order(a) - order(b));
  }

  // One setting as its group screen shows it, for a role that may edit it.
  async read(
    key: SettingKey,
    target: SettingTarget,
    roles: readonly AdminRole[],
  ): Promise<SettingEntry> {
    const setting = this.resolveFor(key, target, roles);
    const state = await this.stored(this.database.db, setting);
    return this.entry(setting, state, target.parameter ?? null);
  }

  // The most recent changes of one setting, newest first, for a role that
  // may edit it.
  async history(
    key: SettingKey,
    target: SettingTarget,
    roles: readonly AdminRole[],
  ): Promise<SettingHistoryEntry[]> {
    const setting = this.resolveFor(key, target, roles);
    return this.database.db
      .select({
        action: changes.action,
        before: changes.before,
        after: changes.after,
        editorId: changes.editorId,
        editorRoles: changes.editorRoles,
        reason: changes.reason,
        changedAt: changes.changedAt,
      })
      .from(changes)
      .where(
        and(
          eq(changes.key, setting.key),
          // Not IS NOT DISTINCT FROM, which the (key, city, time) index cannot serve.
          setting.cityId === null ? isNull(changes.cityId) : eq(changes.cityId, setting.cityId),
        ),
      )
      .orderBy(desc(changes.changedAt), desc(changes.id))
      .limit(HISTORY_LIMIT);
  }

  // The parameters a key is listed with; undefined for a key without one.
  private parametersOf(
    key: SettingKey,
    rows: { key: string; cityId: string | null }[],
    cityId: string | null,
  ): (string | undefined)[] {
    const parameter = keyParameter(key);
    if (parameter === null) return [undefined];
    if (parameter !== 'code') return [...keyParameters[parameter].options];
    // A currency stored under one <code> key lists every <code> key.
    const codes = new Set<string>();
    for (const template of Object.keys(catalogue) as SettingKey[]) {
      if (keyParameter(template) !== 'code') continue;
      const [prefix, suffix] = keyEnds(template, 'code');
      for (const row of rows) {
        if (row.cityId !== cityId || !row.key.startsWith(prefix) || !row.key.endsWith(suffix)) {
          continue;
        }
        const code = row.key.slice(prefix.length, row.key.length - suffix.length);
        if (keyParameters.code.safeParse(code).success) codes.add(code);
      }
    }
    return [...codes].sort();
  }

  private entry(
    setting: ResolvedSetting,
    state: StoredState,
    parameter: string | null,
  ): SettingEntry {
    const definition = setting.definition;
    return {
      key: setting.key,
      template: setting.template,
      parameter,
      group: settingGroupOf(setting.template),
      type: definition.type,
      unit: definition.unit ?? null,
      scope: definition.scope,
      cityId: setting.cityId,
      editRoles: definition.editRoles,
      reasonRequired: definition.reasonRequired ?? false,
      beforeLaunch: definition.beforeLaunch ?? false,
      default: definition.default,
      value: this.effective(setting, state),
      isDefault: state.isDefault,
    };
  }

  // The setting, for roles that may edit it. The roles are checked before
  // anything else, so a role that may not edit a key learns nothing more
  // about it than 403 (architecture §15.2).
  private resolveFor(
    key: SettingKey,
    target: SettingTarget,
    roles: readonly AdminRole[],
  ): ResolvedSetting {
    if (Object.hasOwn(catalogue, key) && !mayEdit(catalogue[key], roles)) {
      throw new SettingRefusedError(
        'role_may_not_edit',
        key,
        `only ${catalogue[key].editRoles.join(', ')} may edit it`,
      );
    }
    return this.resolve(key, target);
  }

  private resolve(key: SettingKey, target: SettingTarget): ResolvedSetting {
    // Callers pass keys from requests too; the type alone does not prove one.
    if (!Object.hasOwn(catalogue, key)) {
      throw new SettingRefusedError('unknown_key', key, 'not in the settings catalogue');
    }
    const definition: SettingDefinition = catalogue[key];
    const cityId = target.cityId ?? null;
    if (cityId !== null && !z.uuid().safeParse(cityId).success) {
      throw new SettingRefusedError('wrong_scope', key, 'the city is not a city id');
    }
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
      return { key, template: key, cityId, definition };
    }
    const value = keyParameters[parameter].safeParse(target.parameter);
    if (!value.success) {
      throw new SettingRefusedError('wrong_parameter', key, `expected a ${parameter}`);
    }
    return {
      key: key.replace(`<${parameter}>`, value.data),
      template: key,
      cityId,
      definition,
    };
  }

  private async change(
    setting: ResolvedSetting,
    next: { value: unknown; isDefault: boolean },
    { editor, context, reason }: SettingChange,
  ): Promise<void> {
    const givenReason = reason?.trim() || null;
    if (setting.definition.reasonRequired && givenReason === null) {
      throw new SettingRefusedError('reason_required', setting.key, 'a change needs a reason');
    }
    if (givenReason !== null && givenReason.length > REASON_MAX_LENGTH) {
      throw new SettingRefusedError(
        'invalid_value',
        setting.key,
        `the reason is longer than ${REASON_MAX_LENGTH} characters`,
      );
    }

    const saved = await this.database.db.transaction(async (tx) => {
      // Changes of one setting take turns, so each records the value it replaced.
      await tx.execute(
        sql`SELECT pg_advisory_xact_lock(hashtextextended(${`settings:${setting.key}:${setting.cityId ?? 'global'}`}, 0))`,
      );
      const before = await this.stored(tx, setting);
      const after: StoredState = { ...next, version: before.version + 1 };
      const beforeValue = this.effective(setting, before);
      const afterValue = this.effective(setting, after);
      // Setting the value in effect, or resetting a setting at its default,
      // changes nothing.
      if (isDeepStrictEqual(beforeValue, afterValue)) return null;
      if (before.version === 0) {
        await tx.insert(values).values({ key: setting.key, cityId: setting.cityId, ...next });
      } else {
        await tx
          .update(values)
          .set({ ...next, version: after.version, updatedAt: sql`now()` })
          .where(this.row(setting));
      }

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

  // A stored value the catalogue no longer accepts, after a deploy that
  // tightened its schema, gives way to the default.
  private effective(setting: ResolvedSetting, state: StoredState): unknown {
    if (state.isDefault) return setting.definition.default;
    const parsed = setting.definition.schema.safeParse(state.value);
    if (parsed.success) return parsed.data;
    this.logger.warn({ setting: setting.key }, 'stored setting no longer valid, default used');
    return setting.definition.default;
  }

  // The key holds a fingerprint of the catalogue entry, so a deploy that
  // changes a default or a schema never reads a value cached before it.
  private cacheKey(setting: ResolvedSetting): string {
    return `settings:${fingerprint(setting.template)}:${setting.cityId ?? 'global'}:${setting.key}`;
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

function mayEdit(definition: SettingDefinition, roles: readonly AdminRole[]): boolean {
  return roles.some((role) => definition.editRoles.includes(role));
}

// The two ends of a key around its <parameter>.
function keyEnds(key: SettingKey, parameter: string): [string, string] {
  return key.split(`<${parameter}>`) as [string, string];
}

const fingerprints = new Map<SettingKey, string>();

function fingerprint(key: SettingKey): string {
  let found = fingerprints.get(key);
  if (found === undefined) {
    const definition: SettingDefinition = catalogue[key];
    const schema = z.toJSONSchema(definition.schema, { unrepresentable: 'any' });
    found = createHash('sha256')
      .update(JSON.stringify({ default: definition.default, schema }))
      .digest('hex')
      .slice(0, 12);
    fingerprints.set(key, found);
  }
  return found;
}
