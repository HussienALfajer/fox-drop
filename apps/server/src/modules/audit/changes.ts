import { isDeepStrictEqual } from 'node:util';

export type Changes = Record<string, { before: unknown; after: unknown }>;

type Values = Readonly<Record<string, unknown>>;

// The before and after values of a write as a diff (AP §9.16): the changed
// fields only. A created target has no before; a field that disappears has no
// after. Missing values are null, so the diff survives JSON.
export function changedFields(before: Values | null, after: Values | null): Changes {
  const changes: Changes = {};
  for (const field of new Set([...Object.keys(before ?? {}), ...Object.keys(after ?? {})])) {
    const was = before?.[field] ?? null;
    const is = after?.[field] ?? null;
    if (!isDeepStrictEqual(was, is)) changes[field] = { before: was, after: is };
  }
  return changes;
}
