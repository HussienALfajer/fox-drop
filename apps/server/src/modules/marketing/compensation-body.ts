import { z } from 'zod';
import type { Compensation, CompensationValue } from './compensations.service.js';
import { compensationStatuses } from './schema.js';

const minor = z.string().regex(/^\d{1,18}$/);

// AP §6.4: an amount, or a percentage with its maximum amount, in minor
// units of the city's base currency. One flat object (the generated Dart
// client takes no oneOf); `compensationValue` checks which fields go with the
// kind.
export const compensationValueBody = z.object({
  kind: z.enum(['fixed_amount', 'percentage']),
  amount: minor.nullable().describe('A fixed amount; null for a percentage.'),
  percentBp: z
    .number()
    .int()
    .min(1)
    .max(10000)
    .nullable()
    .describe('A percentage: 2000 is 20%; null for an amount.'),
  maxDiscount: minor
    .nullable()
    .describe("A percentage's maximum, what counts against the cap; null for an amount."),
});

// The value, or null when its fields do not fit its kind (400 invalid_value).
export function compensationValue(
  body: z.infer<typeof compensationValueBody>,
): CompensationValue | null {
  if (body.kind === 'fixed_amount') {
    if (body.amount === null || body.percentBp !== null || body.maxDiscount !== null) return null;
    const amount = BigInt(body.amount);
    return amount > 0n ? { kind: 'fixed_amount', amount } : null;
  }
  if (body.amount !== null || body.percentBp === null || body.maxDiscount === null) return null;
  const maxDiscount = BigInt(body.maxDiscount);
  return maxDiscount > 0n ? { kind: 'percentage', percentBp: body.percentBp, maxDiscount } : null;
}

export const compensationBody = z.object({
  id: z.uuid(),
  orderId: z.uuid(),
  orderNumber: z.string(),
  kind: z.enum(['fixed_amount', 'percentage']),
  amount: minor.nullable(),
  percentBp: z.number().int().nullable(),
  maxDiscount: minor.nullable(),
  currency: z.string().length(3),
  reason: z.object({ code: z.string(), label: z.string() }),
  note: z.string().nullable(),
  status: z
    .enum(compensationStatuses)
    .describe('issued: the customer has the code; waiting: in «طلبات الموافقة»; rejected by OWN.'),
  requestedBy: z.string().nullable().describe("The admin's name, null when they have none."),
  requestedAt: z.iso.datetime(),
  decidedBy: z.string().nullable(),
  decidedAt: z.iso.datetime().nullable(),
  code: z.string().nullable().describe('The personal code once issued.'),
  codeValidTo: z.iso.datetime().nullable(),
});

export function compensationOut(
  row: Compensation,
  names: ReadonlyMap<string, string>,
): z.infer<typeof compensationBody> {
  return {
    id: row.id,
    orderId: row.orderId,
    orderNumber: row.orderNumber.toString(),
    kind: row.kind,
    amount: row.amount?.toString() ?? null,
    percentBp: row.percentBp,
    maxDiscount: row.maxDiscount?.toString() ?? null,
    currency: row.currency,
    reason: { code: row.reasonCode, label: row.reasonLabel },
    note: row.note,
    status: row.status,
    requestedBy: names.get(row.requestedBy) ?? null,
    requestedAt: row.requestedAt.toISOString(),
    decidedBy: row.decidedBy === null ? null : (names.get(row.decidedBy) ?? null),
    decidedAt: row.decidedAt?.toISOString() ?? null,
    code: row.code,
    codeValidTo: row.codeValidTo?.toISOString() ?? null,
  };
}

// Every admin a list of compensations names.
export function compensationAdmins(rows: readonly Compensation[]): string[] {
  return rows.flatMap((row) =>
    row.decidedBy ? [row.requestedBy, row.decidedBy] : [row.requestedBy],
  );
}
