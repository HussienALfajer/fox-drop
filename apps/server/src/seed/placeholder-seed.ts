import { Inject, Injectable, Logger, Module } from '@nestjs/common';
import { DATABASE, DatabaseModule } from '../database/database.module.js';
import type { Database } from '../database/database.js';
import {
  CaptainsModule,
  CaptainsService,
  type NewCaptain,
  type PayRate,
} from '../modules/captains/index.js';
import { FxModule, FxService } from '../modules/fx/index.js';
import { GeoModule, GeoRefusedError, GeoService } from '../modules/geo/index.js';
import {
  CaptainAccountsService,
  IdentityModule,
  MerchantAccountsService,
} from '../modules/identity/index.js';
import {
  type MerchantChange,
  MerchantsModule,
  MerchantsService,
  type NewRestaurant,
  type OpeningPeriod,
} from '../modules/merchants/index.js';
import {
  SettingsModule,
  SettingsService,
  type Vehicle,
  vehicles,
} from '../modules/settings/index.js';

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

// One placeholder zone around Azaz's town centre, until the owner draws the
// neighbourhoods (AP §9.12.2).
const azazZone = {
  name: 'أعزاز',
  area: [
    { latitude: 36.57, longitude: 37.025 },
    { latitude: 36.57, longitude: 37.07 },
    { latitude: 36.605, longitude: 37.07 },
    { latitude: 36.605, longitude: 37.025 },
  ],
  active: true,
};

// The placeholder delivery fee: 40 TRY flat, with no minimum and no
// free-delivery threshold (owner decision 2026-11-06), until AP §13 item 5.
const azazFee = {
  kind: 'flat',
  currency: 'TRY',
  flatFee: 4000n,
  minimumFee: null,
  freeDeliveryFrom: null,
} as const;

// The demo restaurant (owner decisions 2026-11-05 and 2026-11-06): active
// and visible, near the town centre, delivering within 3 km, a minimum order
// of 100 TRY, a 15% commission and 20 minutes of prep, open every day from
// 10:00 to 02:00.
const demoRestaurant: NewRestaurant = {
  nameAr: 'مطعم فوكس التجريبي',
  nameEn: 'FOX DROP demo restaurant',
  category: 'وجبات سريعة',
  location: { latitude: 36.5866, longitude: 37.0463 },
  coverage: { kind: 'radius', radiusMetres: 3000 },
  minimumOrder: { amount: 10_000n, currency: 'TRY' },
  commissionBp: 1500,
  defaultPrepMin: 20,
};
const demoHours: OpeningPeriod[] = [0, 1, 2, 3, 4, 5, 6].map((weekday) => ({
  weekday,
  opensAt: 10 * 60,
  closesAt: 2 * 60,
}));
// The demo restaurant's owner and cashier (RA §5.1), with numbers no one
// holds: in development the code sender prints their sign-in codes.
const demoAccounts = [
  { role: 'owner', name: 'مالك تجريبي', phone: '+963900000001' },
  { role: 'cashier', name: 'كاشير تجريبي', phone: '+963900000002' },
] as const;
const try_ = (amount: bigint) => ({ amount, currency: 'TRY' });

// The placeholder captain pay, the same for every vehicle (owner decisions
// 2026-11-05 and 2026-11-06): 25 TRY including the first 3 km, 5 TRY per
// extra km pro rata, no waiting pay, a minimum of 25 TRY. The maximum
// distance stays dispatch.max_distance_km.<vehicle>.
const azazPay: PayRate = {
  basePay: 2_500n,
  includedMetres: 3_000,
  perExtraKm: 500n,
  waitingPerMinute: 0n,
  minimumPay: 2_500n,
};

// The demo captain (owner decision 2026-11-06): an activated motorbike
// captain with a cash limit of 3000 TRY, and a number no one holds: in
// development the code sender prints their sign-in code.
const demoCaptainPhone = '+963900000003';
const demoCaptain: NewCaptain = {
  name: 'كابتن فوكس التجريبي',
  vehicle: 'motorbike',
  plateNumber: 'DEMO-1',
  custodyLimit: try_(300_000n),
};

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
    private readonly merchants: MerchantsService,
    private readonly merchantAccounts: MerchantAccountsService,
    private readonly captains: CaptainsService,
    private readonly captainAccounts: CaptainAccountsService,
    @Inject(DATABASE) private readonly database: Database,
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
    if ((await this.geo.zones(cityId)).length === 0) {
      // Another server starting at the same time may have added it.
      await this.geo
        .createZone(cityId, azazZone, {
          actor: system,
          context: noRequest,
          reason: 'Placeholder for development and staging',
        })
        .catch((error: unknown) => {
          if (!(error instanceof GeoRefusedError && error.refusal === 'zone_name_taken'))
            throw error;
        });
    }
    if ((await this.geo.deliveryFeeRule(cityId)) === null) {
      await this.geo.setDeliveryFeeRule(cityId, azazFee, {
        actor: system,
        context: noRequest,
        reason: 'Placeholder for development and staging (AP §13 item 5)',
      });
    }
    await this.demoRestaurant(cityId);
    await this.demoCaptain(cityId);
    this.logger.log('placeholder data in place');
  }

  // A restaurant has no natural key, so two servers starting together take
  // turns on a session lock; the second finds the restaurant there. Each part
  // (hours, menu, status) is added while missing, so a run that stopped
  // halfway is finished by the next. A city whose restaurants someone else
  // entered gets no demo.
  private async demoRestaurant(cityId: string): Promise<void> {
    const client = await this.database.pool.connect();
    try {
      await client.query("SELECT pg_advisory_lock(hashtextextended('seed:demo-restaurant', 0))");
      const restaurants = await this.merchants.restaurantIds(cityId);
      const demo = restaurants.find((entry) => entry.nameAr === demoRestaurant.nameAr);
      if (demo === undefined && restaurants.length > 0) return;
      const change = {
        actor: system,
        context: noRequest,
        reason: 'Placeholder for development and staging',
      };
      const id =
        demo?.id ?? (await this.merchants.createRestaurant(cityId, demoRestaurant, change));
      const restaurant = await this.merchants.restaurant(id);
      if (restaurant?.schedule.length === 0) {
        await this.merchants.setWeeklySchedule(id, demoHours, change);
      }
      if ((await this.merchants.menu(id)).categories.length === 0) {
        await this.demoMenu(id, change);
      }
      if (restaurant?.accountStatus === 'draft') {
        await this.merchants.setAccountStatus(id, 'active', change);
      }
      // Each by its role, so a run that stopped between them is finished.
      const roles = new Set((await this.merchantAccounts.accounts(id)).map((user) => user.role));
      for (const account of demoAccounts) {
        if (!roles.has(account.role)) {
          await this.merchantAccounts.addAccount(id, account, change);
        }
      }
    } finally {
      await client
        .query("SELECT pg_advisory_unlock(hashtextextended('seed:demo-restaurant', 0))")
        .finally(() => client.release());
    }
  }

  // The pay table and the demo captain, on a session lock as the demo
  // restaurant: a second pay table would be a new version 7 days on. No demo
  // captain when someone else entered the city's captains.
  private async demoCaptain(cityId: string): Promise<void> {
    const client = await this.database.pool.connect();
    try {
      await client.query("SELECT pg_advisory_lock(hashtextextended('seed:demo-captain', 0))");
      const change = {
        actor: system,
        context: noRequest,
        reason: 'Placeholder for development and staging (AP §13 item 5)',
      };
      if (!(await this.captains.hasPayTable(cityId))) {
        const rates = Object.fromEntries(vehicles.map((vehicle) => [vehicle, azazPay]));
        await this.captains.setPayTable(
          cityId,
          { currency: 'TRY', rates: rates as Record<Vehicle, PayRate> },
          change,
        );
      }
      const captains = await this.captains.captainIds(cityId);
      const demo = captains.find((entry) => entry.name === demoCaptain.name);
      if (demo === undefined && captains.length > 0) return;
      const id = demo?.id ?? (await this.captains.createCaptain(cityId, demoCaptain, change));
      // Apart, so a run that stopped between them is finished.
      if ((await this.captainAccounts.accountOf(id)) === null) {
        await this.captainAccounts.addAccount(id, demoCaptainPhone, change);
      }
    } finally {
      await client
        .query("SELECT pg_advisory_unlock(hashtextextended('seed:demo-captain', 0))")
        .finally(() => client.release());
    }
  }

  // The demo menu: two categories, four items, a required size and add-ons.
  private async demoMenu(id: string, change: MerchantChange): Promise<void> {
    const size = await this.merchants.addOptionGroup(
      id,
      {
        name: 'الحجم',
        minChoices: 1,
        maxChoices: 1,
        options: [
          { name: 'وسط', priceDelta: try_(0n) },
          { name: 'كبير', priceDelta: try_(2_000n) },
        ],
      },
      change,
    );
    const extras = await this.merchants.addOptionGroup(
      id,
      {
        name: 'إضافات',
        minChoices: 0,
        maxChoices: 2,
        options: [
          { name: 'جبنة', priceDelta: try_(500n) },
          { name: 'صوص حار', priceDelta: try_(0n) },
        ],
      },
      change,
    );
    const meals = await this.merchants.addCategory(id, { name: 'وجبات' }, change);
    const drinks = await this.merchants.addCategory(id, { name: 'مشروبات' }, change);
    const items = [
      {
        categoryId: meals,
        name: 'شاورما دجاج',
        price: try_(12_000n),
        optionGroupIds: [size, extras],
      },
      { categoryId: meals, name: 'بطاطا مقلية', price: try_(4_000n), optionGroupIds: [size] },
      { categoryId: drinks, name: 'عيران', price: try_(2_500n) },
      { categoryId: drinks, name: 'مياه', price: try_(1_000n) },
    ];
    for (const item of items) await this.merchants.addItem(id, item, change);
  }
}

@Module({
  imports: [
    DatabaseModule,
    GeoModule,
    FxModule,
    SettingsModule,
    MerchantsModule,
    IdentityModule,
    CaptainsModule,
  ],
  providers: [PlaceholderSeed],
})
export class PlaceholderSeedModule {}
