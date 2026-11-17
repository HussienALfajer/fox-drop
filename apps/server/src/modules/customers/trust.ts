// AP §9.8 «توثيق» and «إزالة الثقة» (slice 2.25b): the latest mark an admin
// gave the account.
export interface TrustMark {
  trusted: boolean;
  at: Date;
}

// D23 with the marks (owner decisions 2026-11-17): the normal deliveries
// that count toward the trust are those after `since`, the latest of the
// latest fake outcome (`lastFakeAt`, its order's first outcome, which
// «تغيير النتيجة» does not move) and the latest mark; `marked` is true while
// a «توثيق» is newer than every fake outcome in force, by when each was set
// (`fakeSetAt`, so a change to fake after the mark removes the trust), which
// trusts the account whatever the count. «إزالة الثقة» acts as a fake
// outcome: the count restarts.
export function trustBasis(
  lastFakeAt: Date | null,
  mark: TrustMark | null,
  fakeSetAt: Date | null = lastFakeAt,
): { since: Date | null; marked: boolean } {
  if (mark === null || (lastFakeAt !== null && lastFakeAt >= mark.at)) {
    return { since: lastFakeAt, marked: false };
  }
  return {
    since: mark.at,
    marked: mark.trusted && (fakeSetAt === null || fakeSetAt < mark.at),
  };
}

// docs/domain/08 (owner decision 2026-11-17): clearing the strikes restarts
// the count and deletes nothing, so the strikes that count are those within
// the window and after the latest clear.
export function strikesSince(windowStart: Date, clearedAt: Date | null): Date {
  return clearedAt !== null && clearedAt > windowStart ? clearedAt : windowStart;
}
