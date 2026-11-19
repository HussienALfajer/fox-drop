import { Inject, Injectable } from '@nestjs/common';
import { and, eq } from 'drizzle-orm';
import type { Database } from '../../database/database.js';
import { DATABASE } from '../../database/database.module.js';
import { phoneOf } from '../../http/phone-search.js';
import { maskedPhone } from '../customers/index.js';
import type { AdminPermission } from '../identity/index.js';
import { SupportService } from '../support/index.js';
import { orders } from './schema.js';

// What a searched text can be (AP §7.2): a number (an order's or a ticket's,
// `#10001` or `T-5521`), a phone (a captain's or a customer's), or a part of
// a name (a restaurant's or a captain's). A phone is never a number.
export interface SearchTerms {
  text: string;
  phone: string | null;
  number: bigint | null;
}

// The shortest part of a name searched, as the customers' search.
const NAME_MIN = 2;

export function searchTerms(q: string): SearchTerms {
  const text = q.trim();
  const phone = phoneOf(text);
  const digits = /^(?:#|t-?)?(\d{1,12})$/i.exec(text.replace(/\s/g, ''));
  return { text, phone, number: phone === null && digits ? BigInt(digits[1]!) : null };
}

export interface SearchResults {
  orders: { id: string; number: string; status: string }[];
  restaurants: { id: string; name: string }[];
  captains: { id: string; name: string }[];
  tickets: { id: string; number: string; status: string }[];
  customers: { id: string; name: string; maskedPhone: string }[];
}

// AP §7.2 the top bar's global search, each kind for whoever reads its
// module (AP §6.2), and a customer by the phone for OWN, OPS and SUP only
// (`customers.reveal_phone`, the rule of AP §9.5), answered masked.
@Injectable()
export class AdminSearch {
  constructor(
    @Inject(DATABASE) private readonly database: Database,
    private readonly support: SupportService,
  ) {}

  async search(
    cityId: string,
    q: string,
    permissions: readonly AdminPermission[],
    now: Date,
  ): Promise<SearchResults> {
    const may = (permission: AdminPermission) => permissions.includes(permission);
    const terms = searchTerms(q);
    const byName = terms.phone === null && terms.number === null && terms.text.length >= NAME_MIN;
    const query = { text: terms.text, phone: terms.phone };
    const none = Promise.resolve([]);
    const [foundOrders, restaurants, captains, tickets, customers] = await Promise.all([
      may('operations.read') && terms.number !== null
        ? this.database.db
            .select({ id: orders.id, number: orders.number, status: orders.status })
            .from(orders)
            .where(and(eq(orders.cityId, cityId), eq(orders.number, terms.number)))
        : none,
      may('restaurants.read') && byName
        ? this.support.findParties(cityId, 'restaurant', query, now)
        : none,
      may('captains.read') && (byName || terms.phone !== null)
        ? this.support.findParties(cityId, 'captain', query, now)
        : none,
      may('support.read') && terms.number !== null
        ? this.support.ticketsByNumber(cityId, terms.number)
        : none,
      may('customers.read') && may('customers.reveal_phone') && terms.phone !== null
        ? this.support.findParties(cityId, 'customer', query, now)
        : none,
    ]);
    return {
      orders: foundOrders.map((row) => ({ ...row, number: row.number.toString() })),
      restaurants,
      captains,
      tickets: tickets.map((row) => ({ ...row, number: row.number.toString() })),
      customers: customers.map((row) => ({ ...row, maskedPhone: maskedPhone(terms.phone!) })),
    };
  }
}
