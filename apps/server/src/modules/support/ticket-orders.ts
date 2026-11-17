import type { NodePgDatabase } from 'drizzle-orm/node-postgres';
import type { LedgerActor } from '../ledger/index.js';
import type { CorrectionEntry, MoneyLine } from './pickup-disputes.js';
import type { ResponsibleParty } from './tickets.js';

type Tx = Parameters<Parameters<NodePgDatabase['transaction']>[0]>[0];

// An affected line as chosen: the order's line by its position, and how many.
export interface AffectedLine {
  position: number;
  quantity: number;
}

// What a ticket on an order reads of it (AP §9.9.3, §8.10; slice 2.23c):
// its parties, money and current lines, whether it was delivered normally
// (a problem after delivery has money only then), and what the captain
// recorded at the door (CU Q23).
export interface TicketOrderFacts {
  orderId: string;
  cityId: string;
  number: bigint;
  customerAccountId: string;
  restaurantId: string;
  captainId: string | null;
  currency: string;
  total: bigint;
  itemsValue: bigint;
  deliveredNormally: boolean;
  lines: {
    position: number;
    name: string;
    quantity: number;
    unitPrice: bigint;
    lineTotal: bigint;
  }[];
  received: MoneyLine[];
  change: MoneyLine[];
  // What the captain recorded as received, in the order's currency by its
  // snapshot: the most the customer can have been short (M).
  receivedTotal: bigint;
  // AP §9.6.3: a test order's problem posts no entries.
  testOrder: boolean;
}

// The money a resolution asks (docs/domain/10): the responsible party, the
// affected lines (V) and the wrong change M with whether it goes back as a
// code.
export interface TicketMoneyInput {
  responsible: ResponsibleParty;
  affected: AffectedLine[];
  wrongChange: { amount: bigint; code: boolean } | null;
  // «إعادة توصيل مجانية» (slice 2.23d): no entries now; the re-delivery's
  // own come with its delivery.
  redelivery: boolean;
}

export interface TicketMoneyPreview {
  currency: string;
  affectedValue: bigint;
  // What the restaurant ends up owing (V less the commission reversed) and
  // what the captain is charged.
  merchantDebit: bigint;
  captainCharge: bigint;
  entries: CorrectionEntry[];
  // A free re-delivery (slice 2.23d): what its pickup will pay the
  // restaurant, the commission on it and the merchant net its responsible
  // party bears at its delivery.
  redelivery: { pickupPayment: bigint; commission: bigint; merchantNet: bigint } | null;
}

// The affected lines as kept on the ticket, with their value.
export interface StoredAffectedLine extends AffectedLine {
  name: string;
  value: bigint;
}

// A free re-delivery an order has for a ticket (slice 2.23d).
export interface TicketRedelivery {
  orderId: string;
  number: bigint;
  status: string;
}

// A problem after delivery's side that only ordering can read and post (it
// owns the order, its lines and its commission): ordering registers it with
// SupportService.useTicketOrders at start. Refusals are TicketRefusedError:
// invalid_affected.
export interface TicketOrders {
  // null for an order ordering does not know.
  facts(orderId: string): Promise<TicketOrderFacts | null>;
  preview(orderId: string, input: TicketMoneyInput): Promise<TicketMoneyPreview>;
  // In the resolution's transaction: the journals with the order as their
  // source, and the pushes of the restaurant's debit and the captain's
  // charge (AP §10); answers the journals' ids and the affected lines.
  post(
    tx: Tx,
    input: {
      orderId: string;
      ticketId: string;
      ticketNumber: bigint;
      money: TicketMoneyInput;
      actor: LedgerActor;
      now: Date;
    },
  ): Promise<{ journalIds: string[]; affected: StoredAffectedLine[]; affectedValue: bigint }>;
  // «إعادة توصيل مجانية» (AP §9.9.3, slice 2.23d): what the re-delivery
  // reads before the resolution's transaction, then the order placed in it
  // (its money is posted at its delivery, so the affected items' entries of
  // `post` are not); answers the new order and the affected lines.
  prepareRedelivery(orderId: string, now: Date): Promise<object>;
  redeliver(
    tx: Tx,
    input: {
      orderId: string;
      ticketId: string;
      money: TicketMoneyInput;
      chargePay: boolean;
      prepared: object;
      adminId: string;
      now: Date;
    },
  ): Promise<{
    redelivery: { orderId: string; number: bigint };
    affected: StoredAffectedLine[];
    affectedValue: bigint;
  }>;
  // The re-deliveries placed for a ticket, newest first.
  redeliveries(ticketId: string): Promise<TicketRedelivery[]>;
}
