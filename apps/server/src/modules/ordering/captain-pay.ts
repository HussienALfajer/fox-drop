import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { CaptainsService } from '../captains/index.js';
import { waitingMinutes } from './door-payment.js';
import { orderKey } from './order-views.js';
import { orders } from './schema.js';
import { acceptedPrepMin } from './time-changes.js';

type Executor = Pick<NodePgDatabase, 'select'>;

// CA §9.8, AP §8.5.2: the captain's pay for a picked-up order, by the pay
// table the order kept, the captain's vehicle, the trip and the paid waiting
// (docs/domain/04), shared by the delivery and «تحديد النتيجة» (AP §8.9 rule
// 4). `pay` is null when the table has no rate for the vehicle. Read before
// the order's transaction: the pay table and the captain are slow reads.
export async function captainPay(
  executor: Executor,
  captains: Pick<CaptainsService, 'captain' | 'payParts'>,
  order: { id: string; placedAt: Date },
  captainId: string,
  now: Date,
) {
  const [money] = await executor
    .select({
      payTableId: orders.payTableId,
      tripMetres: orders.tripMetres,
      commissionBp: orders.commissionBp,
      acceptedAt: orders.acceptedAt,
      prepMin: orders.prepMin,
      arrivedAtMerchantAt: orders.arrivedAtMerchantAt,
      captainWaitingAlertAt: orders.captainWaitingAlertAt,
      pickedUpAt: orders.pickedUpAt,
      testOrder: orders.testOrder,
    })
    .from(orders)
    .where(orderKey(order.id, order.placedAt));
  const captain = await captains.captain(captainId, now);
  if (!money?.acceptedAt || money.prepMin === null || !money.pickedUpAt) {
    throw new Error(`order ${order.id} was not picked up`);
  }
  if (!captain) throw new Error(`captain ${captainId} not found`);
  // Placing needs a pay table in force (captain_pay_unset); only an order
  // placed before slice 1.13 can lack one.
  if (money.payTableId === null) throw new Error(`order ${order.id} kept no pay table`);
  const waiting = waitingMinutes({
    acceptedAt: money.acceptedAt,
    // docs/domain/04 (slice 2.9, to confirm with the owner): «تعديل الوقت»
    // never shortens the captain's paid waiting; it counts from the prep
    // time chosen at acceptance.
    prepMin: (await acceptedPrepMin(executor, order)) ?? money.prepMin,
    arrivedAtMerchantAt: money.arrivedAtMerchantAt,
    captainWaitingAlertAt: money.captainWaitingAlertAt,
    pickedUpAt: money.pickedUpAt,
  });
  const pay = await captains.payParts(
    money.payTableId,
    captain.vehicle,
    money.tripMetres ?? 0,
    waiting,
  );
  return {
    pay,
    waiting,
    // AP §9.6.3: a test order, flagged at placing, posts no commission.
    commissionBp: money.testOrder ? null : money.commissionBp,
  };
}
