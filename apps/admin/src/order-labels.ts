import type { components } from '@fox-drop/api-schema';
import type { AlertCode } from './alerts.js';
import type { OrderCard, OrderStatus } from './orders-board.js';

type Vehicle = components['schemas']['AdminPickerDto_Output']['captains'][number]['vehicle'];

// The translation keys of the codes the operations pages show (AP Appendix
// C, docs/domain/02, AP §9.1.3, CA §5).
export const statusKeys = {
  placed: 'order.status.placed',
  accepted: 'order.status.accepted',
  ready: 'order.status.ready',
  picked_up: 'order.status.pickedUp',
  arrived: 'order.status.arrived',
  delivered: 'order.status.delivered',
  rejected: 'order.status.rejected',
  cancelled: 'order.status.cancelled',
  failed: 'order.status.failed',
} as const satisfies Record<OrderStatus, string>;

export const trackKeys = {
  searching: 'order.track.searching',
  offered: 'order.track.offered',
  assigned: 'order.track.assigned',
  at_merchant: 'order.track.atMerchant',
  pickup_pending: 'order.track.pickupPending',
  picked_up: 'order.track.pickedUp',
  at_customer: 'order.track.atCustomer',
  done: 'order.track.done',
} as const satisfies Record<NonNullable<OrderCard['captainTrack']>, string>;

export const alertKeys = {
  restaurant_not_accepted: 'order.alert.restaurantNotAccepted',
  prep_late: 'order.alert.prepLate',
  no_captain: 'order.alert.noCaptain',
  no_captain_after_ready: 'order.alert.noCaptainAfterReady',
  captain_waiting: 'order.alert.captainWaiting',
  pickup_disputed: 'order.alert.pickupDisputed',
  away_from_address: 'order.alert.awayFromAddress',
  captain_gps_lost: 'order.alert.captainGpsLost',
  delivery_late: 'order.alert.deliveryLate',
  collection_shortfall: 'order.alert.collectionShortfall',
  captain_cash_limit: 'order.alert.captainCashLimit',
  codes_cannot_send: 'order.alert.codesCannotSend',
  code_number_stopped: 'order.alert.codeNumberStopped',
  restaurant_auto_paused: 'order.alert.restaurantAutoPaused',
  item_unavailable: 'order.alert.itemUnavailable',
} as const satisfies Record<AlertCode, string>;

export const badgeKeys = {
  needsAssignment: 'order.badge.needsAssignment',
  note: 'order.badge.note',
  newCustomer: 'order.badge.newCustomer',
  pickupPending: 'order.badge.pickupPending',
  itemReport: 'order.badge.itemReport',
} as const satisfies Record<keyof OrderCard['badges'], string>;

export const vehicleKeys = {
  walking: 'order.vehicle.walking',
  bicycle: 'order.vehicle.bicycle',
  motorbike: 'order.vehicle.motorbike',
  car: 'order.vehicle.car',
} as const satisfies Record<Vehicle, string>;

export function vehicleKey(vehicle: string) {
  return vehicle in vehicleKeys ? vehicleKeys[vehicle as Vehicle] : 'order.vehicle.other';
}

export const slaKeys = {
  green: 'board.sla.green',
  amber: 'board.sla.amber',
  red: 'board.sla.red',
} as const;
