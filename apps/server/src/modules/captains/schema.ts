import { sql } from 'drizzle-orm';
import {
  bigint,
  boolean,
  check,
  customType,
  date,
  doublePrecision,
  index,
  integer,
  jsonb,
  pgSchema,
  primaryKey,
  real,
  text,
  timestamp,
  uniqueIndex,
  uuid,
} from 'drizzle-orm/pg-core';
import { vehicles } from '../settings/index.js';
import { captainStatuses, lastOrderBy } from './availability.js';

// Architecture §4.2–4.3: the captains module owns the captain record, its
// availability and the pay table. Cities belong to geo, the captain's sign-in
// to identity and the money to the ledger: their ids are plain columns here.
export const captains = pgSchema('captains');

// A PostGIS point in WGS 84, written and read through SQL only.
const point = customType<{ data: string; driverData: string }>({
  dataType: () => 'geometry(Point,4326)',
});

const createdAt = () => timestamp('created_at', { withTimezone: true }).notNull().defaultNow();
const vehicleValues = sql.raw(vehicles.map((vehicle) => `'${vehicle}'`).join(', '));

// Why an online period ended (CA §7.5–7.6).
// offers_expired: C3, after unanswered offers (AP §9.7.6).
// handed_over: K17, the captain handed their order to another (slice 2.12b).
// last_order: the captain's last-order mode, after the order (CA §7.3).
// forced: operations' «فصل من الاتصال», at once or after the order (CA §7.6).
// cannot_complete: K17, the order left the captain while their «لا أستطيع
// إكمال الطلب» was open (slice 2.13b).
// emergency: K17, the order left the captain while their «طوارئ» was open
// (slice 2.13c).
export const onlineEndReasons = [
  'captain',
  'suspended',
  'terminated',
  'offers_expired',
  'handed_over',
  'last_order',
  'forced',
  'cannot_complete',
  'emergency',
] as const;
const endReasonValues = sql.raw(onlineEndReasons.map((reason) => `'${reason}'`).join(', '));
const lastOrderValues = sql.raw(lastOrderBy.map((by) => `'${by}'`).join(', '));

// AP §9.7.1, §9.7.5, D10: an activated captain with its vehicle and cash
// limit.
export const captainRecords = captains.table(
  'captains',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    // The full three-part name (AP §9.7.1).
    name: text('name').notNull(),
    vehicle: text('vehicle', { enum: vehicles }).notNull(),
    // Motor vehicles only.
    plateNumber: text('plate_number'),
    status: text('status', { enum: captainStatuses }).notNull().default('active'),
    // The latest suspension's reason, shown in the app, and its end; no end
    // means until further notice (AP §9.7.5).
    suspensionReason: text('suspension_reason'),
    suspendedUntil: timestamp('suspended_until', { withTimezone: true }),
    // D10, AP §8.5.3: in the city's base currency, required before
    // activation.
    custodyLimit: bigint('custody_limit', { mode: 'bigint' }).notNull(),
    custodyLimitCurrency: text('custody_limit_currency').notNull(),
    // CA §10.5 «العملات التي أحملها»: the city's currencies the captain
    // carries, the base among them when switched on. Null until the captain
    // sets them: the base only, its default.
    carriedCurrencies: text('carried_currencies').array(),
    // CA §10.5, C4, K2 «أقصى مبلغ أحمله»: the most the captain pays a
    // restaurant at pickup, in the city's base currency; null is no limit,
    // its default. max_pickup_set_at is when the captain last answered,
    // a limit or none, so the app asks once (K2).
    maxPickupAmount: bigint('max_pickup_amount', { mode: 'bigint' }),
    maxPickupCurrency: text('max_pickup_currency'),
    maxPickupSetAt: timestamp('max_pickup_set_at', { withTimezone: true }),
    createdAt: createdAt(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull().defaultNow(),
  },
  (table) => [
    index('captains_city').on(table.cityId),
    check('captains_vehicle_values', sql`${table.vehicle} IN (${vehicleValues})`),
    check('captains_status_values', sql`${table.status} IN ('active', 'suspended', 'terminated')`),
    check(
      'captains_plate_number',
      sql`${table.vehicle} NOT IN ('motorbike', 'car') OR ${table.plateNumber} IS NOT NULL`,
    ),
    check(
      'captains_suspension',
      sql`(${table.status} = 'suspended') = (${table.suspensionReason} IS NOT NULL)
          AND (${table.suspendedUntil} IS NULL OR ${table.status} = 'suspended')`,
    ),
    check('captains_custody_limit', sql`${table.custodyLimit} > 0`),
    check(
      'captains_max_pickup',
      sql`(${table.maxPickupAmount} IS NULL) = (${table.maxPickupCurrency} IS NULL)
          AND (${table.maxPickupAmount} IS NULL OR ${table.maxPickupAmount} > 0)
          AND (${table.maxPickupAmount} IS NULL OR ${table.maxPickupSetAt} IS NOT NULL)`,
    ),
  ],
);

// CA §7: a stretch of time online. The open one (no end) is the captain
// online now; one at most per captain.
export const onlinePeriods = captains.table(
  'online_periods',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    captainId: uuid('captain_id')
      .notNull()
      .references(() => captainRecords.id),
    startedAt: timestamp('started_at', { withTimezone: true }).notNull(),
    appVersion: text('app_version'),
    endedAt: timestamp('ended_at', { withTimezone: true }),
    endReason: text('end_reason', { enum: onlineEndReasons }),
    // CA §7.3, §7.6, K18: last-order mode, since when and who asked; a force
    // offline keeps operations' reason, shown to the captain.
    lastOrderBy: text('last_order_by', { enum: lastOrderBy }),
    lastOrderAt: timestamp('last_order_at', { withTimezone: true }),
    lastOrderReason: text('last_order_reason'),
  },
  (table) => [
    uniqueIndex('online_periods_one_open')
      .on(table.captainId)
      .where(sql`${table.endedAt} IS NULL`),
    index('online_periods_captain').on(table.captainId, table.startedAt.desc()),
    check(
      'online_periods_end',
      sql`(${table.endedAt} IS NULL) = (${table.endReason} IS NULL)
          AND (${table.endedAt} IS NULL OR ${table.endedAt} >= ${table.startedAt})`,
    ),
    check('online_periods_end_reason_values', sql`${table.endReason} IN (${endReasonValues})`),
    check(
      'online_periods_last_order',
      sql`(${table.lastOrderBy} IS NULL) = (${table.lastOrderAt} IS NULL)
          AND (coalesce(${table.lastOrderBy}, '') = 'forced') = (${table.lastOrderReason} IS NOT NULL)
          AND (${table.lastOrderBy} IS NULL OR ${table.lastOrderBy} IN (${lastOrderValues}))`,
    ),
  ],
);

// AP §9.12.5: a version of a city's pay table, never changed, in effect from
// its start; the latest start reached is in force.
export const payTables = captains.table(
  'pay_tables',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    // The city's base currency when the table was set (AP §8.6).
    currency: text('currency').notNull(),
    effectiveFrom: timestamp('effective_from', { withTimezone: true }).notNull(),
    editorType: text('editor_type', { enum: ['admin', 'system'] }).notNull(),
    editorId: uuid('editor_id'),
    reason: text('reason'),
    createdAt: createdAt(),
  },
  (table) => [
    index('pay_tables_current').on(table.cityId, table.effectiveFrom.desc(), table.id.desc()),
    check('pay_tables_editor_type_values', sql`${table.editorType} IN ('admin', 'system')`),
    check('pay_tables_editor', sql`(${table.editorType} = 'system') = (${table.editorId} IS NULL)`),
  ],
);

// One vehicle's row of a pay table version (pay.ts); every vehicle has one.
export const payRates = captains.table(
  'pay_rates',
  {
    tableId: uuid('table_id')
      .notNull()
      .references(() => payTables.id),
    vehicle: text('vehicle', { enum: vehicles }).notNull(),
    basePay: bigint('base_pay', { mode: 'bigint' }).notNull(),
    includedMetres: integer('included_metres').notNull(),
    perExtraKm: bigint('per_extra_km', { mode: 'bigint' }).notNull(),
    waitingPerMinute: bigint('waiting_per_minute', { mode: 'bigint' }).notNull(),
    minimumPay: bigint('minimum_pay', { mode: 'bigint' }).notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.tableId, table.vehicle] }),
    check('pay_rates_vehicle_values', sql`${table.vehicle} IN (${vehicleValues})`),
    check(
      'pay_rates_amounts',
      sql`${table.basePay} >= 0 AND ${table.perExtraKm} >= 0 AND ${table.waitingPerMinute} >= 0
          AND ${table.minimumPay} >= 0 AND ${table.includedMetres} >= 0`,
    ),
  ],
);

// AP §9.12.5 «مكافأة ساعة الذروة» (D15): a version of a city's peak bonus,
// never changed, in force from its start unless a newer one was saved before
// that start (peak-bonus.ts). Off until the owner turns it on.
export const peakBonusVersions = captains.table(
  'peak_bonus_versions',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    enabled: boolean('enabled').notNull(),
    // The city's base currency when the version was saved (AP §8.6).
    currency: text('currency').notNull(),
    effectiveFrom: timestamp('effective_from', { withTimezone: true }).notNull(),
    editorType: text('editor_type', { enum: ['admin', 'system'] }).notNull(),
    editorId: uuid('editor_id'),
    createdAt: timestamp('created_at', { withTimezone: true }).notNull(),
  },
  (table) => [
    index('peak_bonus_versions_city').on(table.cityId, table.createdAt, table.id),
    check(
      'peak_bonus_versions_editor_type_values',
      sql`${table.editorType} IN ('admin', 'system')`,
    ),
    check(
      'peak_bonus_versions_editor',
      sql`(${table.editorType} = 'system') = (${table.editorId} IS NULL)`,
    ),
    check('peak_bonus_versions_start', sql`${table.effectiveFrom} >= ${table.createdAt}`),
  ],
);

// One window of a peak bonus version: its ISO days, its hours in minutes of
// the city's day (an end before the start runs past midnight), the amount
// per delivered order and the zones it is limited to (none: every zone).
export const peakBonusWindows = captains.table(
  'peak_bonus_windows',
  {
    versionId: uuid('version_id')
      .notNull()
      .references(() => peakBonusVersions.id),
    position: integer('position').notNull(),
    days: integer('days').array().notNull(),
    startMinute: integer('start_minute').notNull(),
    endMinute: integer('end_minute').notNull(),
    amount: bigint('amount', { mode: 'bigint' }).notNull(),
    // Geo's zone ids, plain values (architecture §4.3).
    zoneIds: uuid('zone_ids').array().notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.versionId, table.position] }),
    check(
      'peak_bonus_windows_values',
      sql`cardinality(${table.days}) > 0 AND ${table.days} <@ ARRAY[1, 2, 3, 4, 5, 6, 7]
          AND ${table.startMinute} BETWEEN 0 AND 1439 AND ${table.endMinute} BETWEEN 0 AND 1439
          AND ${table.startMinute} <> ${table.endMinute} AND ${table.amount} > 0`,
    ),
  ],
);

// CA §4.3, architecture §7.3: the points a captain's app sent while online,
// for routes and disputes; the live position is in Valkey. Partitioned by
// the month the point was recorded, append-only. A point sent again (a retry)
// is the same row.
export const locations = captains.table(
  'locations',
  {
    captainId: uuid('captain_id').notNull(),
    cityId: uuid('city_id').notNull(),
    // On the phone, which queues the points recorded without a signal.
    recordedAt: timestamp('recorded_at', { withTimezone: true }).notNull(),
    receivedAt: timestamp('received_at', { withTimezone: true }).notNull(),
    location: point('location').notNull(),
    accuracyMetres: real('accuracy_metres').notNull(),
    // A mock-location app on Android or isSimulatedBySoftware on iOS (CA §4.3).
    simulated: boolean('simulated').notNull(),
  },
  (table) => [
    primaryKey({ columns: [table.captainId, table.recordedAt] }),
    check('locations_accuracy', sql`${table.accuracyMetres} >= 0`),
  ],
);

// AP §8.5.4 «Hand-in grace» (slice 2.17b): a grace for one captain (OWN or
// FIN) or, with no captain, for every captain of the city for one business
// day (OWN, from the cash desk), with its reason. It lifts the closed_due
// block until `until`, the next cutoff when granted; the custody stays due.
// Never changed: the application role may only insert.
export const handInGraces = captains.table(
  'hand_in_graces',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    // Null for the bulk grace of the whole city.
    captainId: uuid('captain_id').references(() => captainRecords.id),
    until: timestamp('until', { withTimezone: true }).notNull(),
    reason: text('reason').notNull(),
    grantedBy: uuid('granted_by').notNull(),
    grantedAt: timestamp('granted_at', { withTimezone: true }).notNull(),
  },
  (table) => [
    index('hand_in_graces_city_until').on(table.cityId, table.until),
    index('hand_in_graces_captain_until').on(table.captainId, table.until),
    check('hand_in_graces_reason', sql`length(btrim(${table.reason})) > 0`),
    check('hand_in_graces_until', sql`${table.until} > ${table.grantedAt}`),
  ],
);

// CA §10.4, AP §8.5.3 (slice 2.17d): each time usage rose past
// captain.custody_warn_pct, the warning pushed once; cleared when usage fell
// below it again, so the next rise warns again. One open row per captain.
export const custodyWarnings = captains.table(
  'custody_warnings',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    cityId: uuid('city_id').notNull(),
    captainId: uuid('captain_id')
      .notNull()
      .references(() => captainRecords.id),
    warnedAt: timestamp('warned_at', { withTimezone: true }).notNull(),
    clearedAt: timestamp('cleared_at', { withTimezone: true }),
  },
  (table) => [
    index('custody_warnings_captain').on(table.captainId, table.warnedAt),
    uniqueIndex('custody_warnings_one_open')
      .on(table.captainId)
      .where(sql`${table.clearedAt} IS NULL`),
    check(
      'custody_warnings_cleared',
      sql`${table.clearedAt} IS NULL OR ${table.clearedAt} >= ${table.warnedAt}`,
    ),
  ],
);

// CA §5.4, AP §9.7.1 (slice 2.34a): an application's stage. `draft` is the
// form before «إرسال الطلب» (CA §5.1: saved after every step); the others are
// the panel's stages and its two side stages.
export const applicationStages = [
  'draft',
  'new',
  'under_review',
  'interview',
  'awaiting_kit',
  'active',
  'waitlist',
  'rejected',
] as const;
const stageValues = sql.raw(applicationStages.map((stage) => `'${stage}'`).join(', '));

// CA §5.1–5.2 (slice 2.34a): one applicant's application, by their sign-in
// account (identity's id, a plain column). An account has one application
// not rejected; a rejected one stays as the history and a new one follows
// after 30 days (K11, slice 2.34b). The city is the chosen zone's.
export const applications = captains.table(
  'applications',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    accountId: uuid('account_id').notNull(),
    cityId: uuid('city_id').notNull(),
    stage: text('stage', { enum: applicationStages }).notNull(),
    // Step 1: the full three-part name, the date of birth, the
    // neighbourhood (one of the city's active zones, owner decision
    // 2026-11-19; geo's id).
    fullName: text('full_name').notNull(),
    birthDate: date('birth_date', { mode: 'string' }).notNull(),
    zoneId: uuid('zone_id').notNull(),
    // Step 2: null until chosen; the plate for a motorbike or a car only.
    vehicle: text('vehicle', { enum: vehicles }),
    plate: text('plate'),
    submittedAt: timestamp('submitted_at', { withTimezone: true }),
    // «تحديد مقابلة» (AP §9.7.1, slice 2.34b): the time, and the place typed
    // with each interview with its point (owner decision 2026-11-19).
    interviewAt: timestamp('interview_at', { withTimezone: true }),
    interviewPlace: text('interview_place'),
    interviewLatitude: doublePrecision('interview_latitude'),
    interviewLongitude: doublePrecision('interview_longitude'),
    // «رفض» (slice 2.34b): its reason, sent to the applicant; a new
    // application follows 30 days after it (K11).
    rejectedAt: timestamp('rejected_at', { withTimezone: true }),
    rejectionReason: text('rejection_reason'),
    // The activation's records at «بانتظار العدة» (AP §9.7.1, slice 2.35a).
    // «تسليم العدة»: the items from the list `kit_item`, with their labels as
    // issued and the size typed (owner decision 2026-11-19).
    kitItems: jsonb('kit_items').$type<KitItem[]>(),
    kitIssuedAt: timestamp('kit_issued_at', { withTimezone: true }),
    // The cash limit (D10), in the city's base currency.
    custodyLimit: bigint('custody_limit', { mode: 'bigint' }),
    custodyLimitCurrency: text('custody_limit_currency'),
    // «تسجيل العقد» (AP §9.7.2, D24): the signing and start dates, the
    // probation and commitment lengths of the settings when it was recorded,
    // and the probation's end they compute. The scan is the document
    // `signed_contract`.
    contractSignedOn: date('contract_signed_on', { mode: 'string' }),
    contractStartsOn: date('contract_starts_on', { mode: 'string' }),
    probationDays: integer('probation_days'),
    commitmentMonths: integer('commitment_months'),
    probationEndsOn: date('probation_ends_on', { mode: 'string' }),
    // The deposit (AP §9.7.1, §8.5; owner decision 2026-11-19): its amount
    // in the city's base and the instalment deducted each Thursday from the
    // earnings until it is paid (null: no instalments). What is paid is the
    // captain.deposit account; the desk records it with its receipt.
    depositAmount: bigint('deposit_amount', { mode: 'bigint' }),
    depositInstalment: bigint('deposit_instalment', { mode: 'bigint' }),
    depositCurrency: text('deposit_currency'),
    // «تفعيل»: the captain made from it, whose id is the application's for a
    // new captain (so the deposit paid before is already its account).
    captainId: uuid('captain_id'),
    activatedAt: timestamp('activated_at', { withTimezone: true }),
    createdAt: createdAt(),
    updatedAt: timestamp('updated_at', { withTimezone: true }).notNull(),
  },
  (table) => [
    check(
      'applications_interview',
      sql`(${table.interviewAt} IS NULL) = (${table.interviewPlace} IS NULL) AND (${table.interviewAt} IS NULL) = (${table.interviewLatitude} IS NULL) AND (${table.interviewLatitude} IS NULL) = (${table.interviewLongitude} IS NULL)`,
    ),
    check(
      'applications_rejected',
      sql`(${table.stage} = 'rejected') = (${table.rejectedAt} IS NOT NULL) AND (${table.rejectedAt} IS NULL) = (${table.rejectionReason} IS NULL)`,
    ),
    // The panel's list by stage, oldest sent first.
    index('applications_stage').on(table.cityId, table.stage, table.submittedAt),
    // The duplicate check by the plate, without spaces in lower case.
    index('applications_plate_key')
      .on(sql`lower(replace(${table.plate}, ' ', ''))`)
      .where(sql`${table.plate} IS NOT NULL`),
    check('applications_stage_values', sql`${table.stage} IN (${stageValues})`),
    check('applications_vehicle_values', sql`${table.vehicle} IN (${vehicleValues})`),
    check(
      'applications_plate',
      sql`(${table.plate} IS NOT NULL) = (${table.vehicle} IN ('motorbike', 'car'))`,
    ),
    check(
      'applications_submitted',
      sql`(${table.stage} = 'draft') = (${table.submittedAt} IS NULL) AND (${table.stage} = 'draft' OR ${table.vehicle} IS NOT NULL)`,
    ),
    uniqueIndex('applications_open_account')
      .on(table.accountId)
      .where(sql`${table.stage} <> 'rejected'`),
    check('applications_kit', sql`(${table.kitItems} IS NULL) = (${table.kitIssuedAt} IS NULL)`),
    check(
      'applications_custody_limit',
      sql`(${table.custodyLimit} IS NULL) = (${table.custodyLimitCurrency} IS NULL) AND (${table.custodyLimit} IS NULL OR ${table.custodyLimit} > 0)`,
    ),
    check(
      'applications_contract',
      sql`(${table.contractSignedOn} IS NULL) = (${table.contractStartsOn} IS NULL) AND (${table.contractSignedOn} IS NULL) = (${table.probationDays} IS NULL) AND (${table.contractSignedOn} IS NULL) = (${table.commitmentMonths} IS NULL) AND (${table.contractSignedOn} IS NULL) = (${table.probationEndsOn} IS NULL) AND (${table.contractStartsOn} IS NULL OR ${table.contractStartsOn} >= ${table.contractSignedOn})`,
    ),
    check(
      'applications_deposit',
      sql`(${table.depositAmount} IS NULL) = (${table.depositCurrency} IS NULL) AND (${table.depositAmount} IS NULL OR ${table.depositAmount} >= 0) AND (${table.depositInstalment} IS NULL OR (${table.depositAmount} IS NOT NULL AND ${table.depositInstalment} > 0))`,
    ),
    check(
      'applications_activated',
      sql`(${table.stage} = 'active') = (${table.activatedAt} IS NOT NULL) AND (${table.activatedAt} IS NULL) = (${table.captainId} IS NULL)`,
    ),
    uniqueIndex('applications_captain').on(table.captainId),
  ],
);

// An item of «تسليم العدة» (owner decision 2026-11-19): its code and label
// in the list `kit_item` when issued, the size typed, how many.
export interface KitItem {
  code: string;
  label: string;
  size: string | null;
  quantity: number;
}

// CA §5.3, AP §9.7.1, D24: the documents an applicant uploads. The signed
// contract is the office's (2.35).
export const applicationDocumentKinds = [
  'national_id',
  'personal_photo',
  'civil_registry',
  'criminal_record',
  'vehicle_papers',
  'driving_licence',
  // «العقد الموقّع» (D24, slice 2.35a): the office's only, with «تسجيل العقد».
  'signed_contract',
] as const;
const documentKindValues = sql.raw(applicationDocumentKinds.map((kind) => `'${kind}'`).join(', '));

export const documentStatuses = ['pending', 'accepted', 'rejected'] as const;

// One upload of a document: its files in private-docs (1 or 2: the ID's
// front and back), its number (the ID's) and issue date (the criminal
// record's, which sets its expiry, C18). A new upload of the same kind
// replaces the row in force (`replaced_at`), which stays as the history.
// The review's columns are the panel's (slice 2.34b).
export const applicationDocuments = captains.table(
  'application_documents',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    applicationId: uuid('application_id')
      .notNull()
      .references(() => applications.id),
    kind: text('kind', { enum: applicationDocumentKinds }).notNull(),
    fileKeys: text('file_keys').array().notNull(),
    number: text('number'),
    issueDate: date('issue_date', { mode: 'string' }),
    expiresOn: date('expires_on', { mode: 'string' }),
    status: text('status', { enum: documentStatuses }).notNull(),
    reason: text('reason'),
    reviewedBy: uuid('reviewed_by'),
    reviewedAt: timestamp('reviewed_at', { withTimezone: true }),
    // The account that uploaded it: the applicant's, or an admin's (the
    // office's scans, slice 2.34b).
    uploadedBy: uuid('uploaded_by').notNull(),
    createdAt: createdAt(),
    replacedAt: timestamp('replaced_at', { withTimezone: true }),
  },
  (table) => [
    check('application_documents_kind_values', sql`${table.kind} IN (${documentKindValues})`),
    check(
      'application_documents_status_values',
      sql`${table.status} IN ('pending', 'accepted', 'rejected')`,
    ),
    check(
      'application_documents_files',
      sql`cardinality(${table.fileKeys}) BETWEEN 1 AND (CASE WHEN ${table.kind} = 'signed_contract' THEN 6 ELSE 2 END)`,
    ),
    uniqueIndex('application_documents_in_force')
      .on(table.applicationId, table.kind)
      .where(sql`${table.replacedAt} IS NULL`),
    // Every upload of an application, the history included (slice 2.34b's
    // review reads it).
    index('application_documents_application').on(table.applicationId, table.createdAt),
    // The duplicate check by the ID's number (AP §9.7.1, slice 2.34b).
    index('application_documents_number')
      .on(table.number)
      .where(sql`${table.number} IS NOT NULL`),
  ],
);

// AP §9.7.1 «طلب مستند» (slice 2.34b): a document or a correction the panel
// asked for, open until the applicant uploads that kind again
// (`fulfilled_at`).
export const applicationDocumentRequests = captains.table(
  'application_document_requests',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    applicationId: uuid('application_id')
      .notNull()
      .references(() => applications.id),
    kind: text('kind', { enum: applicationDocumentKinds }).notNull(),
    reason: text('reason').notNull(),
    requestedBy: uuid('requested_by').notNull(),
    requestedAt: timestamp('requested_at', { withTimezone: true }).notNull(),
    fulfilledAt: timestamp('fulfilled_at', { withTimezone: true }),
  },
  (table) => [
    check(
      'application_document_requests_kind_values',
      sql`${table.kind} IN (${documentKindValues})`,
    ),
    uniqueIndex('application_document_requests_open')
      .on(table.applicationId, table.kind)
      .where(sql`${table.fulfilledAt} IS NULL`),
    index('application_document_requests_application').on(table.applicationId),
  ],
);

// AP §9.7.1 (slice 2.34b): the application's history and the reviewers'
// notes, never changed (the application role may only insert). The actor is
// an admin's account, or null for the applicant; `stage` is the stage after
// the event.
export const applicationEventKinds = [
  'submitted',
  'stage',
  'note',
  'document_review',
  'document_request',
  'document_upload',
  'interview',
  // The activation's records (slice 2.35a).
  'kit',
  'cash_limit',
  'contract',
  'deposit',
] as const;
const eventKindValues = sql.raw(applicationEventKinds.map((kind) => `'${kind}'`).join(', '));

export const applicationEvents = captains.table(
  'application_events',
  {
    id: uuid('id')
      .primaryKey()
      .default(sql`uuidv7()`),
    applicationId: uuid('application_id')
      .notNull()
      .references(() => applications.id),
    at: timestamp('at', { withTimezone: true }).notNull(),
    actorId: uuid('actor_id'),
    kind: text('kind', { enum: applicationEventKinds }).notNull(),
    stage: text('stage', { enum: applicationStages }).notNull(),
    documentKind: text('document_kind', { enum: applicationDocumentKinds }),
    documentStatus: text('document_status', { enum: documentStatuses }),
    // The note, the reason of a rejection or a request.
    note: text('note'),
    // A note's Idempotency-Key (apps/server/CLAUDE.md), so a repeat answers
    // the note made.
    idempotencyKey: text('idempotency_key'),
  },
  (table) => [
    check('application_events_kind_values', sql`${table.kind} IN (${eventKindValues})`),
    uniqueIndex('application_events_key')
      .on(table.applicationId, table.actorId, table.idempotencyKey)
      .where(sql`${table.idempotencyKey} IS NOT NULL`),
    check('application_events_stage_values', sql`${table.stage} IN (${stageValues})`),
    check(
      'application_events_document_kind_values',
      sql`${table.documentKind} IN (${documentKindValues})`,
    ),
    check(
      'application_events_document_status_values',
      sql`${table.documentStatus} IN ('pending', 'accepted', 'rejected')`,
    ),
    index('application_events_application').on(table.applicationId, table.at),
  ],
);
