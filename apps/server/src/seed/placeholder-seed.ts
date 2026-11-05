import { Injectable, Logger, Module } from '@nestjs/common';
import { FxModule, FxService } from '../modules/fx/index.js';
import { GeoModule, GeoService } from '../modules/geo/index.js';
import { SettingsModule, SettingsService } from '../modules/settings/index.js';

// The environments that get the placeholder values. Production never does:
// the owner enters its values before launch (AP §13 items 4 and 5).
const SEEDED_ENVIRONMENTS = ['development', 'staging'];

export function seedsPlaceholders(environment = process.env.FOX_DROP_ENVIRONMENT): boolean {
  return SEEDED_ENVIRONMENTS.includes(environment ?? '');
}

const system = { type: 'system', id: null, role: null } as const;
const noRequest = { ipAddress: null, device: null };

// Azaz's currencies (AP §8.6): TRY as the base, a placeholder until the
// owner's field check (AP §13 item 4); USD and SYP accepted but disabled
// until they get a rate. The rounding units are the spec's examples, placed
// until the owner enters them (owner decision 2026-11-05).
const currencies = [
  { currency: 'TRY', displayOrder: 1, enabled: true, roundingUnitMinor: 500 },
  { currency: 'USD', displayOrder: 2, enabled: false, roundingUnitMinor: 50 },
  { currency: 'SYP', displayOrder: 3, enabled: false, roundingUnitMinor: 50_000 },
];

// The placeholder data of development and staging, set by the API at start
// (src/roles/start-role.ts), never by a migration. Each value is set only
// while it is missing, so a value someone entered is never replaced, and two
// servers starting together set it once.
@Injectable()
export class PlaceholderSeed {
  private readonly logger = new Logger(PlaceholderSeed.name);

  constructor(
    private readonly geo: GeoService,
    private readonly fx: FxService,
    private readonly settings: SettingsService,
  ) {}

  async run(): Promise<void> {
    const cityId = await this.geo.cityIdByCode('AZ');
    if (cityId === null) throw new Error('Azaz is missing; run the migrations first');

    const existing = new Set((await this.fx.cityCurrencies(cityId)).map((entry) => entry.currency));
    for (const { currency, displayOrder, enabled } of currencies) {
      if (existing.has(currency)) continue;
      await this.fx.setCityCurrency(
        cityId,
        { currency, displayOrder, enabled },
        { actor: system, context: noRequest, reason: 'Placeholder for development and staging' },
      );
    }
    if ((await this.fx.baseCurrency(cityId)) === null) {
      await this.fx.setBaseCurrency(cityId, 'TRY', {
        actor: system,
        context: noRequest,
        reason: 'Placeholder until the field check (AP §13 item 4)',
      });
    }
    for (const { currency, roundingUnitMinor } of currencies) {
      const target = { cityId, parameter: currency };
      if ((await this.settings.get('currency.<code>.rounding_unit', target)) !== null) continue;
      await this.settings.update(
        'currency.<code>.rounding_unit',
        target,
        { amountMinor: roundingUnitMinor },
        {
          editor: 'system',
          context: noRequest,
          reason: 'Placeholder for development and staging (AP §13 item 5)',
        },
      );
    }
    this.logger.log('placeholder data in place');
  }
}

@Module({
  imports: [GeoModule, FxModule, SettingsModule],
  providers: [PlaceholderSeed],
})
export class PlaceholderSeedModule {}
