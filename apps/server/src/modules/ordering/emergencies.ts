import { and, eq, inArray, isNull, sql } from 'drizzle-orm';
import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import { emergencies, type emergencyHows } from './schema.js';

type Executor = Pick<NodePgDatabase, 'select'>;
type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// How an open «طوارئ» closed (CA §9.11, slice 2.13c).
export type EmergencyHow = (typeof emergencyHows)[number];

// The fix the app sent with «طوارئ», as recorded.
export interface EmergencyLocation {
  latitude: number;
  longitude: number;
  accuracyMetres: number;
  recordedAt: Date;
  simulated: boolean;
}

// An open emergency as the reads give it: its captain, their fix (null
// without one) and when.
export interface OpenEmergency {
  orderId: string;
  captainId: string;
  location: EmergencyLocation | null;
  at: Date;
}

// The open emergencies of these orders (at most one each).
export async function openEmergencies(
  executor: Executor,
  keys: { id: string; placedAt: Date }[],
): Promise<Map<string, OpenEmergency>> {
  if (keys.length === 0) return new Map();
  const rows = await executor
    .select({
      orderId: emergencies.orderId,
      captainId: emergencies.captainId,
      latitude: sql<number | null>`ST_Y(${emergencies.location})`,
      longitude: sql<number | null>`ST_X(${emergencies.location})`,
      accuracyMetres: emergencies.accuracyMetres,
      locatedAt: emergencies.locatedAt,
      simulated: emergencies.simulated,
      at: emergencies.raisedAt,
    })
    .from(emergencies)
    .where(
      and(
        inArray(
          emergencies.orderId,
          keys.map((key) => key.id),
        ),
        inArray(
          emergencies.orderPlacedAt,
          keys.map((key) => key.placedAt),
        ),
        isNull(emergencies.closedAt),
      ),
    );
  return new Map(
    rows.map((row) => [
      row.orderId,
      {
        orderId: row.orderId,
        captainId: row.captainId,
        location:
          row.latitude === null ||
          row.longitude === null ||
          row.accuracyMetres === null ||
          row.locatedAt === null ||
          row.simulated === null
            ? null
            : {
                latitude: Number(row.latitude),
                longitude: Number(row.longitude),
                accuracyMetres: row.accuracyMetres,
                recordedAt: row.locatedAt,
                simulated: row.simulated,
              },
        at: row.at,
      },
    ]),
  );
}

export async function openEmergency(
  executor: Executor,
  key: { id: string; placedAt: Date },
): Promise<OpenEmergency | null> {
  return (await openEmergencies(executor, [key])).get(key.id) ?? null;
}

// Records the captain's emergency on the order, with their fix.
export async function raiseEmergency(
  tx: Tx,
  order: { id: string; placedAt: Date; cityId: string },
  captainId: string,
  location: EmergencyLocation | null,
  now: Date,
): Promise<void> {
  await tx.insert(emergencies).values({
    orderId: order.id,
    orderPlacedAt: order.placedAt,
    cityId: order.cityId,
    captainId,
    location:
      location && sql`ST_SetSRID(ST_MakePoint(${location.longitude}, ${location.latitude}), 4326)`,
    accuracyMetres: location?.accuracyMetres ?? null,
    locatedAt: location?.recordedAt ?? null,
    simulated: location?.simulated ?? null,
    raisedAt: now,
  });
}

// Closes the order's open emergency, if any, and answers it.
export async function closeEmergency(
  tx: Tx,
  key: { id: string; placedAt: Date },
  how: EmergencyHow,
  now: Date,
): Promise<OpenEmergency | null> {
  const open = await openEmergency(tx, key);
  if (open === null) return null;
  await tx
    .update(emergencies)
    .set({ closedAt: now, closedHow: how })
    .where(
      and(
        eq(emergencies.orderId, key.id),
        eq(emergencies.orderPlacedAt, key.placedAt),
        isNull(emergencies.closedAt),
      ),
    );
  return open;
}
