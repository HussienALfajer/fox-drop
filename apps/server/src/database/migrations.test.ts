import { randomUUID } from 'node:crypto';
import { PgBoss } from 'pg-boss';
import { afterAll, beforeAll, describe, expect, it } from 'vitest';
import { createJobQueue, QUEUES } from '../jobs/job-queue.js';
import { createDatabase, type Database } from './database.js';
import { runMigrations } from './migrate.js';
import { startTestDatabase, type TestDatabase } from './test-database.js';

let database: TestDatabase;
let app: Database;

beforeAll(async () => {
  database = await startTestDatabase();
  app = createDatabase(database.appUrl);
}, 300_000);

afterAll(async () => {
  await app?.pool.end();
  await database?.stop();
});

async function appQuery(text: string) {
  return app.pool.query(text);
}

describe('migrations on a fresh database', () => {
  it('seed Azaz with a UUIDv7 key', async () => {
    const { rows } = await appQuery('SELECT id, code, name, time_zone, status FROM geo.cities');

    expect(rows).toEqual([
      {
        id: expect.stringMatching(/^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab]/),
        code: 'AZ',
        name: 'أعزاز',
        time_zone: 'Asia/Damascus',
        status: 'active',
      },
    ]);
  });

  it('apply nothing on a second run, even two at once', async () => {
    await Promise.all([runMigrations(database.migratorUrl), runMigrations(database.migratorUrl)]);

    const { rows } = await appQuery('SELECT count(*)::int AS count FROM geo.cities');
    expect(rows[0].count).toBe(1);
  });

  it('have only the extensions production has', async () => {
    const { rows } = await appQuery('SELECT extname FROM pg_extension ORDER BY extname');
    expect(rows.map((row) => row.extname)).toEqual(['plpgsql', 'postgis']);
  });

  it('give the application role PostGIS', async () => {
    const { rows } = await appQuery(
      'SELECT ST_Contains(ST_MakeEnvelope(0, 0, 2, 2, 4326), ST_SetSRID(ST_MakePoint(1, 1), 4326)) AS inside',
    );
    expect(rows[0].inside).toBe(true);
  });
});

describe('the application role', () => {
  it('adds and changes rows', async () => {
    await appQuery("INSERT INTO geo.cities (code, name) VALUES ('TS', 'test city')");
    await appQuery("UPDATE geo.cities SET status = 'inactive' WHERE code = 'TS'");

    const { rows } = await appQuery("SELECT status FROM geo.cities WHERE code = 'TS'");
    expect(rows[0].status).toBe('inactive');
  });

  it.each([
    ['delete a row', "DELETE FROM geo.cities WHERE code = 'TS'", /permission denied/],
    ['create a table', 'CREATE TABLE geo.extra (id int)', /permission denied/],
    ['alter a table', 'ALTER TABLE geo.cities ADD COLUMN extra int', /must be owner/],
    ['drop a table', 'DROP TABLE geo.cities', /must be owner/],
    ['create a schema', 'CREATE SCHEMA extra', /permission denied/],
    ['create a table in public', 'CREATE TABLE public.extra (id int)', /permission denied/],
    [
      'read the migration journal',
      'SELECT * FROM drizzle.__drizzle_migrations',
      /permission denied/,
    ],
  ])('cannot %s', async (_, statement, error) => {
    await expect(appQuery(statement)).rejects.toThrow(error);
  });
});

describe('the audit log (AP §9.16)', () => {
  const currentPartition = `audit.events_${new Date().toISOString().slice(0, 7).replace('-', '_')}`;

  it('has a partition for this month and the next', async () => {
    const { rows } = await appQuery(
      "SELECT inhrelid::regclass::text AS name FROM pg_inherits WHERE inhparent = 'audit.events'::regclass ORDER BY 1",
    );
    expect(rows).toHaveLength(2);
    expect(rows[0].name).toBe(currentPartition);
  });

  it('takes an event from the application role and reads it back', async () => {
    await appQuery(
      "INSERT INTO audit.events (actor_type, kind, action, target_type, target_id) VALUES ('system', 'write', 'test.write', 'city', 'AZ')",
    );

    const { rows } = await appQuery(
      `SELECT id, action FROM ${currentPartition} WHERE action = 'test.write'`,
    );
    expect(rows).toEqual([
      { id: expect.stringMatching(/^[0-9a-f]{8}-[0-9a-f]{4}-7/), action: 'test.write' },
    ]);
  });

  it('lets the application role create the coming partitions again', async () => {
    await appQuery('SELECT audit.create_month_partitions()');
  });

  it.each([
    ['an admin without an id', "'admin', NULL, 'write', NULL"],
    ['the system with an id', "'system', '0190f3a0-0000-7000-8000-000000000001', 'write', NULL"],
    ['a view with changes', "'system', NULL, 'view', '{}'"],
  ])('refuses %s', async (_, values) => {
    await expect(
      appQuery(
        `INSERT INTO audit.events (actor_type, actor_id, kind, changes, action, target_type, target_id) VALUES (${values}, 'test.refused', 'city', 'AZ')`,
      ),
    ).rejects.toThrow(/violates check constraint/);
  });

  it.each([
    ['change an event', "UPDATE audit.events SET reason = 'x'"],
    ['change an event in its partition', `UPDATE ${currentPartition} SET reason = 'x'`],
    ['delete an event', 'DELETE FROM audit.events'],
    ['delete an event from its partition', `DELETE FROM ${currentPartition}`],
    ['empty the log', 'TRUNCATE audit.events'],
    ['empty a partition', `TRUNCATE ${currentPartition}`],
    [
      'create a partition',
      "CREATE TABLE audit.events_2099_01 PARTITION OF audit.events FOR VALUES FROM ('2099-01-01') TO ('2099-02-01')",
    ],
  ])('refuses the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied|must be owner/);
  });
});

describe('the ledger (architecture §5.6)', () => {
  const currentPartition = `ledger.entries_${new Date().toISOString().slice(0, 7).replace('-', '_')}`;
  const city = "'0190f3a0-0000-7000-8000-0000000000c1'";

  it('has an entries partition for this month and the next', async () => {
    const { rows } = await appQuery(
      "SELECT inhrelid::regclass::text AS name FROM pg_inherits WHERE inhparent = 'ledger.entries'::regclass ORDER BY 1",
    );
    expect(rows).toHaveLength(2);
    expect(rows[0].name).toBe(currentPartition);
  });

  // A journal and its entries, posted in one transaction as LedgerService posts them.
  const delivery = `(SELECT id FROM ledger.accounts WHERE city_id = ${city} AND purpose = 'platform.revenue_delivery')`;
  const clearing = `(SELECT id FROM ledger.accounts WHERE city_id = ${city} AND purpose = 'platform.order_clearing')`;
  const journal = (id: string) =>
    `INSERT INTO ledger.journals (id, city_id, type, source_kind, source_id, actor_type)
       VALUES ('${id}', ${city}, 'platform.revenue_delivery', 'order', uuidv7(), 'system')`;
  const entry = (journalId: string, account: string, amount: number, currency = 'TRY') =>
    `INSERT INTO ledger.entries (journal_id, city_id, account_id, currency, amount)
       VALUES ('${journalId}', ${city}, ${account}, '${currency}', ${amount})`;

  async function inTransaction(...statements: string[]): Promise<void> {
    const client = await app.pool.connect();
    try {
      await client.query('BEGIN');
      for (const statement of statements) await client.query(statement);
      await client.query('COMMIT');
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  }

  it('takes an account, a journal and its entries from the application role', async () => {
    await appQuery(
      `INSERT INTO ledger.accounts (city_id, purpose, currency)
         VALUES (${city}, 'platform.revenue_delivery', 'TRY'), (${city}, 'platform.order_clearing', 'TRY')`,
    );
    const id = randomUUID();
    await inTransaction(journal(id), entry(id, delivery, -40), entry(id, clearing, 40));

    const { rows } = await appQuery(
      `SELECT sum(amount)::int AS total, count(*)::int AS lines FROM ${currentPartition} WHERE journal_id = '${id}'`,
    );
    expect(rows[0]).toEqual({ total: 0, lines: 2 });
  });

  it('refuses at commit a journal that does not balance to zero', async () => {
    const id = randomUUID();
    await expect(
      inTransaction(journal(id), entry(id, delivery, -40), entry(id, clearing, 30)),
    ).rejects.toThrow(/does not balance to zero/);
  });

  it('refuses at commit a journal without two entries', async () => {
    await expect(inTransaction(journal(randomUUID()))).rejects.toThrow(/fewer than two entries/);
  });

  it('refuses an entry on a journal posted in an earlier transaction', async () => {
    const id = randomUUID();
    await inTransaction(journal(id), entry(id, delivery, -40), entry(id, clearing, 40));

    await expect(inTransaction(entry(id, delivery, -5), entry(id, clearing, 5))).rejects.toThrow(
      /joins only a journal posted in its transaction/,
    );
  });

  it('refuses an entry in another currency than its account', async () => {
    const id = randomUUID();
    await expect(
      inTransaction(journal(id), entry(id, delivery, -40, 'USD'), entry(id, clearing, 40, 'USD')),
    ).rejects.toThrow(/entries_account/);
  });

  it('lets the application role create the coming partitions again', async () => {
    await appQuery('SELECT ledger.create_month_partitions()');
  });

  it.each([
    [
      'an unknown account purpose',
      "INSERT INTO ledger.accounts (city_id, purpose, currency) VALUES (CITY, 'platform.wallet', 'TRY')",
    ],
    [
      'a captain account without its captain',
      "INSERT INTO ledger.accounts (city_id, purpose, currency) VALUES (CITY, 'captain.custody', 'TRY')",
    ],
    [
      'a currency that is not a code',
      "INSERT INTO ledger.accounts (city_id, purpose, currency) VALUES (CITY, 'platform.test_cost', 'lira')",
    ],
    [
      'an unknown journal type',
      "INSERT INTO ledger.journals (city_id, type, actor_type) VALUES (CITY, 'custody.gift', 'system')",
    ],
    [
      'a manual correction without a reason',
      "INSERT INTO ledger.journals (city_id, type, actor_type, actor_id) VALUES (CITY, 'earn.adjustment', 'admin', uuidv7())",
    ],
    [
      'a manual bonus without a reason',
      "INSERT INTO ledger.journals (city_id, type, actor_type, actor_id) VALUES (CITY, 'earn.bonus', 'admin', uuidv7())",
    ],
    [
      'a source without its id',
      "INSERT INTO ledger.journals (city_id, type, source_kind, actor_type) VALUES (CITY, 'earn.order_pay', 'order', 'system')",
    ],
  ])('refuses %s', async (_, statement) => {
    await expect(appQuery(statement.replace('CITY', city))).rejects.toThrow(
      /violates check constraint/,
    );
  });

  it.each([
    ['change an account', "UPDATE ledger.accounts SET currency = 'USD'"],
    ['delete an account', 'DELETE FROM ledger.accounts'],
    ['change a journal', "UPDATE ledger.journals SET reason = 'x'"],
    ['delete a journal', 'DELETE FROM ledger.journals'],
    ['change an entry', 'UPDATE ledger.entries SET amount = 1'],
    ['change an entry in its partition', `UPDATE ${currentPartition} SET amount = 1`],
    ['delete an entry', 'DELETE FROM ledger.entries'],
    ['delete an entry from its partition', `DELETE FROM ${currentPartition}`],
    ['empty the entries', 'TRUNCATE ledger.entries'],
    ['empty a partition', `TRUNCATE ${currentPartition}`],
    [
      'create a partition',
      "CREATE TABLE ledger.entries_2099_01 PARTITION OF ledger.entries FOR VALUES FROM ('2099-01-01') TO ('2099-02-01')",
    ],
  ])('refuses the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied|must be owner/);
  });
});

describe('the settings tables (AP §4.4)', () => {
  const editor = "'0190f3a0-0000-7000-8000-000000000001', '{OWN}'";

  it('keep one stored value per key and scope, global included', async () => {
    await appQuery("INSERT INTO settings.values (key, value) VALUES ('test.global', '1')");

    await expect(
      appQuery("INSERT INTO settings.values (key, value) VALUES ('test.global', '2')"),
    ).rejects.toThrow(/values_key_city/);
  });

  it('let the application role change a stored value', async () => {
    await appQuery("UPDATE settings.values SET value = '3' WHERE key = 'test.global'");
  });

  it('refuse a value on a row reset to the default', async () => {
    await expect(
      appQuery(
        "INSERT INTO settings.values (key, value, is_default) VALUES ('test.reset', '1', true)",
      ),
    ).rejects.toThrow(/values_default_has_no_value/);
  });

  it('take a change from the application role', async () => {
    await appQuery(
      `INSERT INTO settings.changes (key, action, before, after, editor_id, editor_roles) VALUES ('test.global', 'update', '1', '3', ${editor})`,
    );
  });

  it.each([
    ['change a change', "UPDATE settings.changes SET reason = 'x'"],
    ['delete a change', 'DELETE FROM settings.changes'],
    ['delete a stored value', 'DELETE FROM settings.values'],
  ])('refuse the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied/);
  });
});

describe('the zones and fee tables (AP §9.12.2–9.12.3)', () => {
  const azaz = "(SELECT id FROM geo.cities WHERE code = 'AZ')";

  it('take a zone polygon and refuse one that crosses itself', async () => {
    await appQuery(
      `INSERT INTO geo.zones (city_id, name, area, active) VALUES (${azaz}, 'test square', ST_GeomFromText('POLYGON((37 36, 37.01 36, 37.01 36.01, 37 36.01, 37 36))', 4326), true)`,
    );
    await expect(
      appQuery(
        `INSERT INTO geo.zones (city_id, name, area, active) VALUES (${azaz}, 'test bow tie', ST_GeomFromText('POLYGON((37 36, 37.01 36.01, 37.01 36, 37 36.01, 37 36))', 4326), true)`,
      ),
    ).rejects.toThrow(/zones_area_valid/);
  });

  it('take a fee rule with its bands and refuse a flat rule without its fee', async () => {
    const { rows } = await appQuery(
      `INSERT INTO geo.fee_rules (city_id, kind, currency) VALUES (${azaz}, 'distance_bands', 'TRY') RETURNING id`,
    );
    await appQuery(
      `INSERT INTO geo.fee_bands (rule_id, position, up_to_metres, fee) VALUES ('${rows[0].id}', 0, NULL, 4000)`,
    );
    await expect(
      appQuery(
        `INSERT INTO geo.fee_rules (city_id, kind, currency) VALUES (${azaz}, 'flat', 'TRY')`,
      ),
    ).rejects.toThrow(/fee_rules_flat_fee/);
  });

  it.each([
    ['change a fee rule', "UPDATE geo.fee_rules SET reason = 'x'"],
    ['change a fee band', 'UPDATE geo.fee_bands SET fee = 1'],
    ['delete a zone', 'DELETE FROM geo.zones'],
  ])('refuse the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied/);
  });
});

describe('the merchants tables (AP §9.6, RA §9–10)', () => {
  const azaz = "(SELECT id FROM geo.cities WHERE code = 'AZ')";
  const restaurant = (coverage: string) =>
    `INSERT INTO merchants.restaurants (city_id, name_ar, location, coverage_kind, coverage_radius_metres, minimum_order, minimum_order_currency, default_prep_min) VALUES (${azaz}, 'test', ST_SetSRID(ST_MakePoint(37.05, 36.59), 4326), ${coverage}, 10000, 'TRY', 20) RETURNING id`;

  it('take a restaurant with its commission and refuse a radius coverage without its radius', async () => {
    const { rows } = await appQuery(restaurant("'radius', 3000"));
    await appQuery(
      `INSERT INTO merchants.commission_rates (restaurant_id, rate_bp, effective_from, changed_by_type) VALUES ('${rows[0].id}', 1500, now(), 'system')`,
    );
    await expect(appQuery(restaurant("'radius', NULL"))).rejects.toThrow(
      /restaurants_coverage_radius/,
    );
    await expect(appQuery(restaurant("'zones', 3000"))).rejects.toThrow(
      /restaurants_coverage_radius/,
    );
  });

  it('refuse a restaurant pause without an end', async () => {
    const { rows } = await appQuery(restaurant("'radius', 3000"));
    await expect(
      appQuery(
        `INSERT INTO merchants.pauses (restaurant_id, source, starts_at) VALUES ('${rows[0].id}', 'restaurant', now())`,
      ),
    ).rejects.toThrow(/pauses_restaurant_ends/);
    await appQuery(
      `INSERT INTO merchants.pauses (restaurant_id, source, starts_at) VALUES ('${rows[0].id}', 'ops', now())`,
    );
  });

  it('refuse a second pending change request for the same field', async () => {
    const { rows } = await appQuery(restaurant("'radius', 3000"));
    const request = `INSERT INTO merchants.change_requests (restaurant_id, target_type, target_id, field, pending_value, requested_by_id) VALUES ('${rows[0].id}', 'item', '0190f3a0-0000-7000-8000-0000000000b1', 'name', '"x"', '0190f3a0-0000-7000-8000-0000000000b2')`;
    await appQuery(request);
    await expect(appQuery(request)).rejects.toThrow(/change_requests_one_pending/);
  });

  it.each([
    ['change a commission version', 'UPDATE merchants.commission_rates SET rate_bp = 1'],
    ['change a schedule version', 'UPDATE merchants.weekly_schedules SET changed_by_id = NULL'],
    ['change an opening period', 'UPDATE merchants.opening_periods SET opens_at = 0'],
    ['change the price log', 'UPDATE merchants.price_changes SET new_price = 1'],
    ['delete a restaurant', 'DELETE FROM merchants.restaurants'],
  ])('refuse the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied/);
  });
});

describe('the captains tables (AP §9.7, §9.12.5; CA §7)', () => {
  const azaz = "(SELECT id FROM geo.cities WHERE code = 'AZ')";
  const captain = (vehicle: string, plate: string) =>
    `INSERT INTO captains.captains (city_id, name, vehicle, plate_number, custody_limit, custody_limit_currency) VALUES (${azaz}, 'كابتن اختبار', '${vehicle}', ${plate}, 300000, 'TRY') RETURNING id`;

  it('take a captain and refuse a motor vehicle without its plate', async () => {
    await appQuery(captain('motorbike', "'12345'"));
    await appQuery(captain('walking', 'NULL'));
    await expect(appQuery(captain('car', 'NULL'))).rejects.toThrow(/captains_plate_number/);
  });

  it('refuse a suspension without its reason', async () => {
    const { rows } = await appQuery(captain('walking', 'NULL'));
    await expect(
      appQuery(`UPDATE captains.captains SET status = 'suspended' WHERE id = '${rows[0].id}'`),
    ).rejects.toThrow(/captains_suspension/);
  });

  it('keep one open online period per captain', async () => {
    const { rows } = await appQuery(captain('walking', 'NULL'));
    const open = `INSERT INTO captains.online_periods (captain_id, started_at) VALUES ('${rows[0].id}', now())`;
    await appQuery(open);
    await expect(appQuery(open)).rejects.toThrow(/online_periods_one_open/);
  });

  const thisMonth = `captains.locations_${new Date().toISOString().slice(0, 7).replace('-', '_')}`;

  it('have a locations partition for last month, this month and the next', async () => {
    const { rows } = await appQuery(
      "SELECT count(*)::int AS n FROM pg_inherits WHERE inhparent = 'captains.locations'::regclass",
    );
    expect(rows).toEqual([{ n: 3 }]);
  });

  it('keep one row per captain and recorded time', async () => {
    const point = `INSERT INTO captains.locations (captain_id, city_id, recorded_at, received_at, location, accuracy_metres, simulated) VALUES ('0190f3a0-0000-7000-8000-0000000000c1', ${azaz}, date_trunc('hour', now()), now(), ST_SetSRID(ST_MakePoint(37.05, 36.59), 4326), 8, false)`;
    await appQuery(point);
    await expect(appQuery(point)).rejects.toThrow(/duplicate key/);
  });

  it.each([
    ['change a location', 'UPDATE captains.locations SET simulated = true'],
    ['change a location partition', `UPDATE ${thisMonth} SET simulated = true`],
    ['delete a location', 'DELETE FROM captains.locations'],
    ['change a pay table version', "UPDATE captains.pay_tables SET reason = 'x'"],
    ['change a pay rate', 'UPDATE captains.pay_rates SET base_pay = 1'],
    ['delete a captain', 'DELETE FROM captains.captains'],
  ])('refuse the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied/);
  });
});

describe('the customers tables and the zone votes (CU §5.3, §7.2–7.3)', () => {
  const azaz = "(SELECT id FROM geo.cities WHERE code = 'AZ')";
  const address = (accountId: string, extra: string) =>
    `INSERT INTO customers.addresses (account_id, city_id, location, label, custom_label, street, landmark, contact_phone_encrypted, recipient_name, is_default) VALUES ('${accountId}', ${azaz}, ST_SetSRID(ST_MakePoint(37.05, 36.59), 4326), ${extra})`;

  it('take a profile and refuse another gender value', async () => {
    const profile = (gender: string) =>
      `INSERT INTO customers.profiles (account_id, first_name, gender, terms_accepted_at) VALUES ('${randomUUID()}', 'أحمد', '${gender}', now())`;
    await appQuery(profile('male'));
    await expect(appQuery(profile('other'))).rejects.toThrow(/profiles_gender_values/);
  });

  it('keep one default address per account, a custom name with «آخر» and a recipient with another number', async () => {
    const accountId = randomUUID();
    await appQuery(address(accountId, "'home', NULL, 'شارع', 'جامع', NULL, NULL, true"));
    await expect(
      appQuery(address(accountId, "'work', NULL, 'شارع', 'جامع', NULL, NULL, true")),
    ).rejects.toThrow(/addresses_one_default/);
    await expect(
      appQuery(address(accountId, "'other', NULL, 'شارع', 'جامع', NULL, NULL, false")),
    ).rejects.toThrow(/addresses_custom_label/);
    await expect(
      appQuery(address(accountId, "'home', NULL, 'شارع', 'جامع', 'v1.x', NULL, false")),
    ).rejects.toThrow(/addresses_recipient/);
  });

  it('take a vote with or without a city', async () => {
    const vote = (city: string) =>
      `INSERT INTO geo.zone_votes (city_id, device_id, location) VALUES (${city}, '${randomUUID()}', ST_SetSRID(ST_MakePoint(37.1, 36.6), 4326))`;
    await appQuery(vote(azaz));
    await appQuery(vote('NULL'));
  });

  it.each([
    ['delete an address', 'DELETE FROM customers.addresses'],
    ['delete a profile', 'DELETE FROM customers.profiles'],
    ['delete a vote', 'DELETE FROM geo.zone_votes'],
  ])('refuse the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied/);
  });
});

describe('the ordering tables (AP §8.1, §4.8; architecture §5.5)', () => {
  const azaz = "(SELECT id FROM geo.cities WHERE code = 'AZ')";
  const suffix = new Date().toISOString().slice(0, 7).replace('-', '_');
  const order = (id: string, extra: { total?: string; note?: string; phone?: string } = {}) =>
    `INSERT INTO ordering.orders (id, placed_at, city_id, number, customer_account_id, restaurant_id, status, version, currency, items_value, delivery_fee, discount, rounding, total, delivery_free, fee_rule_id, commission_bp, rate_snapshot, note, estimate_from_min, estimate_to_min, location, zone_id, neighbourhood, street, landmark, contact_phone_encrypted, recipient_name) VALUES ('${id}', now(), ${azaz}, 10001, '${randomUUID()}', '${randomUUID()}', 'placed', 1, 'TRY', 20000, 4000, 0, 0, ${extra.total ?? '24000'}, false, '${randomUUID()}', 1500, '{}', ${extra.note ?? 'NULL'}, 30, 40, ST_SetSRID(ST_MakePoint(37.05, 36.59), 4326), '${randomUUID()}', 'أعزاز', 'شارع', 'جامع', ${extra.phone ?? 'NULL'}, NULL)`;
  const placedAt = (id: string) => `(SELECT placed_at FROM ordering.orders WHERE id = '${id}')`;

  it('have a partition of the orders, lines and events for this month and the next', async () => {
    const { rows } = await appQuery(
      "SELECT inhparent::regclass::text AS parent, count(*)::int AS n FROM pg_inherits WHERE inhparent IN ('ordering.orders'::regclass, 'ordering.order_lines'::regclass, 'ordering.order_events'::regclass) GROUP BY 1 ORDER BY 1",
    );
    expect(rows).toEqual([
      { parent: 'ordering.order_events', n: 2 },
      { parent: 'ordering.order_lines', n: 2 },
      { parent: 'ordering.orders', n: 2 },
    ]);
  });

  it('take an order with its line and event, and refuse money that does not add up', async () => {
    const id = randomUUID();
    await appQuery(order(id));
    await appQuery(
      `INSERT INTO ordering.order_lines (order_id, order_placed_at, position, city_id, item_id, item_name, quantity, options, unit_price, line_total) VALUES ('${id}', ${placedAt(id)}, 0, ${azaz}, '${randomUUID()}', 'شاورما', 2, '[]', 10000, 20000)`,
    );
    await appQuery(
      `INSERT INTO ordering.order_events (order_id, order_placed_at, version, city_id, at, to_status, actor_type) VALUES ('${id}', ${placedAt(id)}, 1, ${azaz}, now(), 'placed', 'customer')`,
    );
    await appQuery(
      `UPDATE ordering.orders SET status = 'cancelled', version = 2, cancelled_at = now(), cancel_reason = 'customer', food_prepared = false WHERE id = '${id}'`,
    );
    await expect(appQuery(order(randomUUID(), { total: '25000' }))).rejects.toThrow(/orders_money/);
    await expect(
      appQuery(
        `INSERT INTO ordering.order_lines (order_id, order_placed_at, position, city_id, item_id, item_name, quantity, options, unit_price, line_total) VALUES ('${id}', ${placedAt(id)}, 1, ${azaz}, '${randomUUID()}', 'شاورما', 2, '[]', 10000, 10000)`,
      ),
    ).rejects.toThrow(/order_lines_money/);
  });

  it('refuse a note over 200 characters and another number without its recipient', async () => {
    await expect(appQuery(order(randomUUID(), { note: `'${'م'.repeat(201)}'` }))).rejects.toThrow(
      /orders_note/,
    );
    await expect(appQuery(order(randomUUID(), { phone: "'v1.x'" }))).rejects.toThrow(
      /orders_recipient/,
    );
  });

  it('let the application role create the coming partitions again', async () => {
    await appQuery('SELECT ordering.create_month_partitions()');
  });

  it('let the application role mark an outbox row published and change nothing else', async () => {
    const { rows } = await appQuery(
      `INSERT INTO ordering.outbox (created_at, city_id, type, order_id, order_version, payload) VALUES (now(), ${azaz}, 'order.placed', '${randomUUID()}', 1, '{}') RETURNING id`,
    );
    await appQuery(`UPDATE ordering.outbox SET published_at = now() WHERE id = ${rows[0].id}`);
    await expect(
      appQuery(`UPDATE ordering.outbox SET type = 'x' WHERE id = ${rows[0].id}`),
    ).rejects.toThrow(/permission denied/);
  });

  it("install pg-boss as the migration role, with the application role's rows only", async () => {
    const { rows } = await appQuery("SELECT name FROM pgboss.queue WHERE name LIKE 'ordering-%'");
    expect(rows).toEqual([{ name: 'ordering-merchant-auto-cancel' }]);
    await expect(appQuery('CREATE TABLE pgboss.extra (id int)')).rejects.toThrow(
      /permission denied/,
    );
    await expect(appQuery('UPDATE pgboss.version SET version = 0')).rejects.toThrow(
      /permission denied/,
    );
  });

  it('let the application role send, work and maintain jobs', async () => {
    const boss: PgBoss = createJobQueue(database.appUrl, false);
    boss.on('error', () => undefined);
    await boss.start();
    try {
      const id = await boss.send(QUEUES.merchantAutoCancel, { test: true });
      const [job] = await boss.fetch(QUEUES.merchantAutoCancel);
      expect(job?.id).toBe(id);
      await boss.complete(QUEUES.merchantAutoCancel, id!);
      // A whole maintenance pass, as the worker runs it.
      await boss.supervise();
    } finally {
      await boss.stop({ graceful: false });
    }
  });

  it.each([
    ['change an order event', "UPDATE ordering.order_events SET reason = 'x'"],
    ['change an order event partition', `UPDATE ordering.order_events_${suffix} SET reason = 'x'`],
    ['delete an order', 'DELETE FROM ordering.orders'],
    ['delete an order line', 'DELETE FROM ordering.order_lines'],
    ['delete an idempotency key', 'DELETE FROM ordering.idempotency_keys'],
  ])('refuse the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied/);
  });
});

describe('the identity tables (AP §5.1–5.2)', () => {
  it('refuse an admin account without an email or a phone', async () => {
    await expect(
      appQuery("INSERT INTO identity.admin_accounts (roles) VALUES ('{OWN}')"),
    ).rejects.toThrow(/admin_accounts_has_sign_in_name/);
  });

  it('refuse an active admin account without a password and a TOTP secret', async () => {
    await expect(
      appQuery(
        "INSERT INTO identity.admin_accounts (email, roles, status) VALUES ('a@example.test', '{OWN}', 'active')",
      ),
    ).rejects.toThrow(/admin_accounts_active_is_set_up/);
  });

  it('keep one account per email', async () => {
    await appQuery(
      "INSERT INTO identity.admin_accounts (email, roles) VALUES ('owner@example.test', '{OWN}')",
    );
    await expect(
      appQuery(
        "INSERT INTO identity.admin_accounts (email, roles) VALUES ('owner@example.test', '{OPS}')",
      ),
    ).rejects.toThrow(/admin_accounts_email_unique/);
  });

  it('let the application role end a session', async () => {
    await appQuery(
      "INSERT INTO identity.admin_sessions (account_id, token_hash) SELECT id, 'h1' FROM identity.admin_accounts WHERE email = 'owner@example.test'",
    );
    await appQuery(
      "UPDATE identity.admin_sessions SET ended_at = now(), end_reason = 'sign_out' WHERE token_hash = 'h1'",
    );
  });

  it.each([
    ['delete an account', 'DELETE FROM identity.admin_accounts'],
    ['delete a session', 'DELETE FROM identity.admin_sessions'],
    ['delete a backup code', 'DELETE FROM identity.admin_backup_codes'],
    ['delete a setup link', 'DELETE FROM identity.admin_setup_links'],
    ['delete a sign-in code', 'DELETE FROM identity.app_sign_in_codes'],
    ['delete a customer account', 'DELETE FROM identity.customer_accounts'],
    ['delete an app session', 'DELETE FROM identity.app_sessions'],
    ['delete a refresh token', 'DELETE FROM identity.app_refresh_tokens'],
    ['delete a signing key', 'DELETE FROM identity.app_signing_keys'],
    ['delete a restaurant user', 'DELETE FROM identity.merchant_accounts'],
    ['delete a restaurant device', 'DELETE FROM merchants.devices'],
  ])('refuse the application role to %s', async (_, statement) => {
    await expect(appQuery(statement)).rejects.toThrow(/permission denied/);
  });
});

describe('the app sign-in tables (architecture §8.3.2, §15.1)', () => {
  const code = (phoneHash: string) =>
    `INSERT INTO identity.app_sign_in_codes (party, phone_hash, device_id, code_hash, expires_at) VALUES ('customer', '${phoneHash}', 'd1', 'c1', now())`;

  it('keep one open code per number', async () => {
    await appQuery(code('p1'));
    await expect(appQuery(code('p1'))).rejects.toThrow(/app_sign_in_codes_open_per_number/);
    await appQuery(
      "UPDATE identity.app_sign_in_codes SET ended_at = now(), end_reason = 'replaced' WHERE phone_hash = 'p1'",
    );
    await appQuery(code('p1'));
  });

  it('keep one active customer account per number', async () => {
    const account =
      "INSERT INTO identity.customer_accounts (phone_encrypted, phone_hash) VALUES ('e', 'p2')";
    await appQuery(account);
    await expect(appQuery(account)).rejects.toThrow(/customer_accounts_active_phone/);
  });

  it('refuse a party no app signs in with yet', async () => {
    await expect(appQuery(code('p3').replace("'customer'", "'courier'"))).rejects.toThrow(
      /app_sign_in_codes_party_values/,
    );
  });
});
