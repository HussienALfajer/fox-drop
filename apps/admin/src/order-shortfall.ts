import type { components } from '@fox-drop/api-schema';
import { keepPreviousData, queryOptions, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRef } from 'react';
import { api } from './api.js';
import { OPERATIONS_MANAGE } from './assign-captain.js';
import type { OrderDetail } from './order-detail.js';
import { journalLines, type OutcomeLine } from './order-outcome.js';
import { type AdminSession, can } from './session.js';

type ResolveBody = components['schemas']['AdminResolveShortfallDto'];
export type ShortfallParty = ResolveBody['responsible'];
export type ShortfallPreview = components['schemas']['AdminShortfallPreviewAnswerDto_Output'];

// AP §8.6: who may bear a collection shortfall, in AP Appendix C's order;
// never the restaurant, which was paid in full at the pickup.
export const SHORTFALL_PARTIES = [
  'captain',
  'customer',
  'platform',
] as const satisfies readonly ShortfallParty[];

type Delivery = NonNullable<OrderDetail['delivery']>;
type OpenShortfall = Delivery & {
  shortfall: NonNullable<Delivery['shortfall']> & { resolution: null };
};

// AP §8.6 «حلّ النقص» (slice 2.20b): OWN and OPS, while the order's
// collection shortfall is open.
export function canResolveShortfall(
  session: AdminSession | null | undefined,
  order: Pick<OrderDetail, 'delivery'>,
): order is { delivery: OpenShortfall } {
  return (
    can(session, OPERATIONS_MANAGE) &&
    order.delivery?.shortfall !== null &&
    order.delivery?.shortfall !== undefined &&
    order.delivery.shortfall.resolution === null
  );
}

// The body once a party is chosen and the note written, else null.
export function resolveBody(
  responsible: ShortfallParty | null,
  reason: string,
): ResolveBody | null {
  const note = reason.trim();
  return responsible === null || note === '' ? null : { responsible, reason: note };
}

// The preview's sentences, those of the outcome dialog («يُخصم من مستحقات
// الكابتن … : نقص في التحصيل.», «سيُحظر الزبون … حتى دفع …», «تتحمّل
// المنصة …»); anything else (the restaurant never bears a shortfall) is
// `unknown`, which blocks the confirm.
export function shortfallLines(preview: ShortfallPreview): OutcomeLine[] {
  return journalLines(preview.entries).map((line) =>
    SHORTFALL_LINES.includes(line.key) ? line : { key: 'unknown' as const },
  );
}

const SHORTFALL_LINES: readonly OutcomeLine['key'][] = ['captainCharge', 'dues', 'platformCost'];

// The one refusal the panel explains: no shortfall open any more (resolved
// meanwhile, from another screen).
export type ShortfallRefusal = 'order_state_changed';

function refusalOf(status: number, error: unknown): ShortfallRefusal | null {
  const refusal = (error as { error?: unknown } | undefined)?.error;
  return status === 409 && refusal === 'order_state_changed' ? refusal : null;
}

export type ShortfallPreviewResult =
  | { status: 'preview'; preview: ShortfallPreview }
  | { status: 'refused'; refusal: ShortfallRefusal };

// Asked on each party chosen and on each new version of the order, keeping
// the previous answer with the confirm off while the next one loads.
export function shortfallPreviewQuery(
  orderId: string,
  version: number,
  responsible: ShortfallParty | null,
) {
  return queryOptions({
    queryKey: ['shortfall-preview', orderId, version, responsible],
    enabled: responsible !== null,
    placeholderData: keepPreviousData,
    queryFn: async (): Promise<ShortfallPreviewResult> => {
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/shortfall-preview',
        { params: { path: { orderId } }, body: { responsible: responsible! } },
      );
      if (data) return { status: 'preview', preview: data };
      const refusal = refusalOf(response.status, error);
      if (refusal) return { status: 'refused', refusal };
      throw new Error(`The preview failed with ${response.status}.`);
    },
  });
}

export type ResolveResult = { status: 'done' } | { status: 'refused'; refusal: ShortfallRefusal };

// One Idempotency-Key per choice until an answer arrives (architecture §5.3).
export function useResolveShortfall(orderId: string) {
  const queryClient = useQueryClient();
  const keys = useRef(new Map<string, string>());
  return useMutation({
    mutationFn: async (body: ResolveBody): Promise<ResolveResult> => {
      const id = JSON.stringify(body);
      let key = keys.current.get(id);
      if (key === undefined) {
        key = crypto.randomUUID();
        keys.current.set(id, key);
      }
      const { data, error, response } = await api.POST(
        '/v1/admin/orders/{orderId}/resolve-shortfall',
        { params: { path: { orderId }, header: { 'Idempotency-Key': key } }, body },
      );
      if (data) {
        keys.current.delete(id);
        return { status: 'done' };
      }
      const refusal = refusalOf(response.status, error);
      if (refusal) {
        keys.current.delete(id);
        return { status: 'refused', refusal };
      }
      throw new Error(`Resolving the shortfall failed with ${response.status}.`);
    },
    onSettled: () =>
      Promise.all([
        queryClient.invalidateQueries({ queryKey: ['order', orderId] }),
        queryClient.invalidateQueries({ queryKey: ['orders-board'] }),
        queryClient.invalidateQueries({ queryKey: ['alerts'] }),
        queryClient.invalidateQueries({ queryKey: ['shortfall-preview', orderId] }),
      ]),
  });
}
