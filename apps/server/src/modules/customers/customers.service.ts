import { Inject, Injectable } from '@nestjs/common';
import { and, desc, eq, inArray, isNull, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { DATABASE } from '../../database/database.module.js';
import type { Database } from '../../database/database.js';
import { GeoService, type Point } from '../geo/index.js';
import { PhoneCipher } from '../identity/index.js';
import { MerchantsService } from '../merchants/index.js';
import { type addressLabels, addresses, type genders, profiles } from './schema.js';

export type CustomersRefusal =
  'terms_required' | 'invalid_birthday' | 'outside_zones' | 'address_limit' | 'unknown_address';

// A change the customers module refuses, with the reason its routes answer.
export class CustomersRefusedError extends Error {
  override readonly name = 'CustomersRefusedError';
  constructor(
    readonly refusal: CustomersRefusal,
    message: string,
  ) {
    super(message);
  }
}

export interface Profile {
  firstName: string;
  lastName: string | null;
  gender: (typeof genders)[number];
  // YYYY-MM-DD.
  birthday: string | null;
}

export interface AddressFields {
  location: Point;
  label: (typeof addressLabels)[number];
  customLabel: string | null;
  street: string;
  floor: string | null;
  landmark: string;
  // E.164; null is the account's own number.
  contactPhone: string | null;
  recipientName: string | null;
  directions: string | null;
}

export interface Address extends AddressFields {
  id: string;
  cityId: string;
  isDefault: boolean;
  // «الحي»: the name of the active zone the pin is in; null when no active
  // zone covers it any more, «خارج منطقة التوصيل حالياً» (Q6).
  neighbourhood: string | null;
}

// CU §7.4: an unsaved address, the fields of a saved one without its label.
export type UnsavedAddressFields = Omit<AddressFields, 'label' | 'customLabel'>;

// The address an order keeps (Q6): «الحي» is the zone at placing, and another
// contact number stays encrypted with identity's key.
export interface OrderAddress {
  // The saved address it was copied from; null for an unsaved one.
  addressId: string | null;
  cityId: string;
  location: Point;
  zone: { id: string; name: string };
  label: AddressFields['label'] | null;
  customLabel: string | null;
  street: string;
  floor: string | null;
  landmark: string;
  // null is the account's own number.
  contactPhoneEncrypted: string | null;
  recipientName: string | null;
  directions: string | null;
}

// CU §7.1: where a point stands. served has restaurants that cover it;
// no_restaurants is «لا توجد مطاعم توصل إلى موقعك حالياً»; outside_zones is
// «قريباً في منطقتك» with the vote (§7.2).
export interface Location {
  state: 'served' | 'no_restaurants' | 'outside_zones';
  cityId: string | null;
  zone: { id: string; name: string } | null;
}

// A customer belongs to no city; V1 serves Syria only, so «a past date»
// is on Syria's clock.
const PROFILE_TIME_ZONE = 'Asia/Damascus';

// CU §7.3: up to 10 saved addresses (fixed).
export const MAX_ADDRESSES = 10;

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// The customers' profiles and saved addresses (architecture §4.2; CU §5.3,
// §7). Other modules read them through CustomersService only.
@Injectable()
export class CustomersService {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly geo: GeoService,
    private readonly merchants: MerchantsService,
    private readonly phones: PhoneCipher,
  ) {}

  // CU §7.1: the zone check of a point, and whether any restaurant covers it.
  async location(point: Point): Promise<Location> {
    const place = await this.geo.locate(point);
    if (place === null || place.zone === null) {
      return { state: 'outside_zones', cityId: place?.cityId ?? null, zone: null };
    }
    const covering = await this.merchants.coveringRestaurants(place.cityId, point);
    return {
      state: covering.length > 0 ? 'served' : 'no_restaurants',
      cityId: place.cityId,
      zone: place.zone,
    };
  }

  // The details of CU §5.3; null until the customer completes them.
  async profile(accountId: string): Promise<Profile | null> {
    const [row] = await this.database.db
      .select({
        firstName: profiles.firstName,
        lastName: profiles.lastName,
        gender: profiles.gender,
        birthday: profiles.birthday,
      })
      .from(profiles)
      .where(eq(profiles.accountId, accountId));
    return row ?? null;
  }

  // The completed customers' first names by account, in one read: all a
  // restaurant sees of its customer with «الحي» (RA §8.4, principle 6).
  async firstNames(accountIds: string[]): Promise<Map<string, string>> {
    if (accountIds.length === 0) return new Map();
    const rows = await this.database.db
      .select({ accountId: profiles.accountId, firstName: profiles.firstName })
      .from(profiles)
      .where(inArray(profiles.accountId, accountIds));
    return new Map(rows.map((row) => [row.accountId, row.firstName]));
  }

  // «أكمل بياناتك» (CU §5.3), and later edits in «حسابي» (§13). The terms
  // are accepted once, when the details are first completed.
  async saveProfile(
    accountId: string,
    profile: Profile,
    { acceptTerms, now }: { acceptTerms: boolean; now: Date },
  ): Promise<Profile> {
    if (profile.birthday !== null && profile.birthday >= dateIn(PROFILE_TIME_ZONE, now)) {
      throw new CustomersRefusedError('invalid_birthday', 'the birthday is a past date');
    }
    const updated = await this.database.db
      .update(profiles)
      .set({ ...profile, updatedAt: now })
      .where(eq(profiles.accountId, accountId))
      .returning({ accountId: profiles.accountId });
    if (updated.length === 0) {
      if (!acceptTerms) {
        throw new CustomersRefusedError('terms_required', 'the terms are accepted first');
      }
      await this.database.db
        .insert(profiles)
        .values({ accountId, ...profile, termsAcceptedAt: now, createdAt: now, updatedAt: now })
        .onConflictDoUpdate({ target: profiles.accountId, set: { ...profile, updatedAt: now } });
    }
    return profile;
  }

  // CU §7.3–7.4, Q6: the address an order keeps, copied from a saved address
  // or from the fields of an unsaved one, with «الحي» from the active zone at
  // the pin now. Refused outside every active zone.
  async orderAddress(
    accountId: string,
    choice: { addressId: string } | { fields: UnsavedAddressFields },
  ): Promise<OrderAddress> {
    let source: {
      addressId: string | null;
      label: Address['label'] | null;
      customLabel: string | null;
      fields: UnsavedAddressFields;
      contactPhoneEncrypted: string | null;
    };
    if ('addressId' in choice) {
      const [row] = await this.database.db
        .select(addressColumns)
        .from(addresses)
        .where(mine(accountId, choice.addressId));
      if (!row) throw new CustomersRefusedError('unknown_address', 'no such address');
      source = {
        addressId: row.id,
        label: row.label,
        customLabel: row.customLabel,
        fields: {
          location: { latitude: row.latitude, longitude: row.longitude },
          street: row.street,
          floor: row.floor,
          landmark: row.landmark,
          contactPhone: null,
          recipientName: row.recipientName,
          directions: row.directions,
        },
        contactPhoneEncrypted: row.contactPhoneEncrypted,
      };
    } else {
      const { fields } = choice;
      source = {
        addressId: null,
        label: null,
        customLabel: null,
        fields,
        contactPhoneEncrypted:
          fields.contactPhone === null ? null : this.phones.encrypt(fields.contactPhone),
      };
    }
    const place = await this.geo.locate(source.fields.location);
    if (place === null || place.zone === null) throw outsideZones();
    const { fields } = source;
    return {
      addressId: source.addressId,
      cityId: place.cityId,
      location: fields.location,
      zone: place.zone,
      label: source.label,
      customLabel: source.customLabel,
      street: fields.street,
      floor: fields.floor,
      landmark: fields.landmark,
      contactPhoneEncrypted: source.contactPhoneEncrypted,
      recipientName: source.contactPhoneEncrypted === null ? null : fields.recipientName,
      directions: fields.directions,
    };
  }

  // The saved addresses, the default first, then the newest.
  async addresses(accountId: string): Promise<Address[]> {
    const rows = await this.database.db
      .select(addressColumns)
      .from(addresses)
      .where(and(eq(addresses.accountId, accountId), isNull(addresses.deletedAt)))
      .orderBy(desc(addresses.isDefault), desc(addresses.id));
    return Promise.all(rows.map((row) => this.addressOf(row)));
  }

  // CU §7.3: a new address, its pin inside an active zone. The first is the
  // default; isDefault makes a later one the default.
  async addAddress(
    accountId: string,
    fields: AddressFields & { isDefault: boolean },
    now: Date,
  ): Promise<Address> {
    const cityId = await this.zoneCity(fields.location);
    const id = await this.database.db.transaction(async (tx) => {
      await lockAddresses(tx, accountId);
      const [{ count }] = (await tx
        .select({ count: sql<number>`count(*)::int` })
        .from(addresses)
        .where(and(eq(addresses.accountId, accountId), isNull(addresses.deletedAt)))) as [
        { count: number },
      ];
      if (count >= MAX_ADDRESSES) {
        throw new CustomersRefusedError('address_limit', `up to ${MAX_ADDRESSES} addresses`);
      }
      const isDefault = count === 0 || fields.isDefault;
      if (isDefault) await clearDefault(tx, accountId, now);
      const [row] = (await tx
        .insert(addresses)
        .values({
          accountId,
          cityId,
          ...this.columns(fields),
          isDefault,
          createdAt: now,
          updatedAt: now,
        })
        .returning({ id: addresses.id })) as [{ id: string }];
      return row.id;
    });
    return (await this.address(accountId, id))!;
  }

  // CU §7.3 (U5): every field may change, the pin only inside active zones.
  async updateAddress(
    accountId: string,
    id: string,
    fields: AddressFields,
    now: Date,
  ): Promise<Address> {
    const cityId = await this.zoneCity(fields.location);
    const updated = await this.database.db
      .update(addresses)
      .set({ cityId, ...this.columns(fields), updatedAt: now })
      .where(mine(accountId, id))
      .returning({ id: addresses.id });
    if (updated.length === 0) throw unknownAddress();
    return (await this.address(accountId, id))!;
  }

  // The default address (CU §7.3); one outside every active zone cannot be
  // chosen (Q6, 409 outside_zones).
  async setDefaultAddress(accountId: string, id: string, now: Date): Promise<Address> {
    const address = await this.address(accountId, id);
    if (address === null) throw unknownAddress();
    if (address.neighbourhood === null) throw outsideZones();
    await this.database.db.transaction(async (tx) => {
      await lockAddresses(tx, accountId);
      if (!(await exists(tx, accountId, id))) throw unknownAddress();
      await clearDefault(tx, accountId, now);
      await tx
        .update(addresses)
        .set({ isDefault: true, updatedAt: now })
        .where(mine(accountId, id));
    });
    return { ...address, isDefault: true };
  }

  // Deleting hides the address; no order changes (Q6). When it was the
  // default, the newest remaining address inside an active zone becomes the
  // default, or else the newest remaining one.
  async deleteAddress(accountId: string, id: string, now: Date): Promise<void> {
    // The zones are read before the transaction, which holds a connection;
    // the others come newest first.
    const others = (await this.addresses(accountId)).filter((address) => address.id !== id);
    const heirs = [
      ...others.filter((address) => address.neighbourhood !== null),
      ...others.filter((address) => address.neighbourhood === null),
    ].map((address) => address.id);
    await this.database.db.transaction(async (tx) => {
      await lockAddresses(tx, accountId);
      const [row] = await tx
        .select({ isDefault: addresses.isDefault })
        .from(addresses)
        .where(mine(accountId, id));
      if (!row) throw unknownAddress();
      await tx
        .update(addresses)
        .set({ deletedAt: now, isDefault: false, updatedAt: now })
        .where(eq(addresses.id, id));
      if (!row.isDefault) return;
      for (const heir of heirs) {
        const moved = await tx
          .update(addresses)
          .set({ isDefault: true, updatedAt: now })
          .where(mine(accountId, heir))
          .returning({ id: addresses.id });
        if (moved.length === 1) return;
      }
    });
  }

  private async address(accountId: string, id: string): Promise<Address | null> {
    const [row] = await this.database.db
      .select(addressColumns)
      .from(addresses)
      .where(mine(accountId, id));
    return row ? this.addressOf(row) : null;
  }

  private async addressOf(row: AddressRow): Promise<Address> {
    const location = { latitude: row.latitude, longitude: row.longitude };
    const zone = await this.geo.zoneAt(row.cityId, location);
    return {
      id: row.id,
      cityId: row.cityId,
      location,
      label: row.label,
      customLabel: row.customLabel,
      street: row.street,
      floor: row.floor,
      landmark: row.landmark,
      contactPhone:
        row.contactPhoneEncrypted === null ? null : this.phones.decrypt(row.contactPhoneEncrypted),
      recipientName: row.recipientName,
      directions: row.directions,
      isDefault: row.isDefault,
      neighbourhood: zone?.name ?? null,
    };
  }

  private async zoneCity(point: Point): Promise<string> {
    const place = await this.geo.locate(point);
    if (place === null || place.zone === null) throw outsideZones();
    return place.cityId;
  }

  private columns(fields: AddressFields) {
    const { latitude, longitude } = fields.location;
    return {
      location: sql`ST_SetSRID(ST_MakePoint(${longitude}, ${latitude}), 4326)`,
      label: fields.label,
      customLabel: fields.label === 'other' ? fields.customLabel : null,
      street: fields.street,
      floor: fields.floor,
      landmark: fields.landmark,
      contactPhoneEncrypted:
        fields.contactPhone === null ? null : this.phones.encrypt(fields.contactPhone),
      recipientName: fields.contactPhone === null ? null : fields.recipientName,
      directions: fields.directions,
    };
  }
}

const addressColumns = {
  id: addresses.id,
  cityId: addresses.cityId,
  latitude: sql<number>`ST_Y(${addresses.location})`.mapWith(Number),
  longitude: sql<number>`ST_X(${addresses.location})`.mapWith(Number),
  label: addresses.label,
  customLabel: addresses.customLabel,
  street: addresses.street,
  floor: addresses.floor,
  landmark: addresses.landmark,
  contactPhoneEncrypted: addresses.contactPhoneEncrypted,
  recipientName: addresses.recipientName,
  directions: addresses.directions,
  isDefault: addresses.isDefault,
};

interface AddressRow {
  id: string;
  cityId: string;
  latitude: number;
  longitude: number;
  label: AddressFields['label'];
  customLabel: string | null;
  street: string;
  floor: string | null;
  landmark: string;
  contactPhoneEncrypted: string | null;
  recipientName: string | null;
  directions: string | null;
  isDefault: boolean;
}

function mine(accountId: string, id: string) {
  return and(eq(addresses.id, id), eq(addresses.accountId, accountId), isNull(addresses.deletedAt));
}

async function exists(tx: Tx, accountId: string, id: string): Promise<boolean> {
  const rows = await tx.select({ id: addresses.id }).from(addresses).where(mine(accountId, id));
  return rows.length === 1;
}

async function clearDefault(tx: Tx, accountId: string, now: Date): Promise<void> {
  await tx
    .update(addresses)
    .set({ isDefault: false, updatedAt: now })
    .where(and(eq(addresses.accountId, accountId), eq(addresses.isDefault, true)));
}

// A customer's address changes take turns, so the limit and the one default
// hold under concurrent requests.
async function lockAddresses(tx: Tx, accountId: string): Promise<void> {
  await tx.execute(
    sql`SELECT pg_advisory_xact_lock(hashtextextended(${`addresses:${accountId}`}, 0))`,
  );
}

function outsideZones(): CustomersRefusedError {
  return new CustomersRefusedError('outside_zones', 'the pin is outside every active zone');
}

function unknownAddress(): CustomersRefusedError {
  return new CustomersRefusedError('unknown_address', 'no such address');
}

// The date at a moment on a time zone's clock, as YYYY-MM-DD.
function dateIn(timeZone: string, at: Date): string {
  return new Intl.DateTimeFormat('en-CA', { timeZone }).format(at);
}
