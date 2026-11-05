// A version of a restaurant's commission, in basis points of the items value
// (1500 is 15%), in effect from its start for new orders (AP §9.6.5, D16).
export interface CommissionVersion {
  id: string;
  rateBp: number;
  effectiveFrom: Date;
}

// The version in effect at a moment: the latest start already reached, and
// of two with the same start the later one; null before the first.
export function commissionAt<Version extends CommissionVersion>(
  versions: readonly Version[],
  at: Date,
): Version | null {
  let current: Version | null = null;
  for (const version of versions) {
    if (version.effectiveFrom.getTime() > at.getTime()) continue;
    if (
      current === null ||
      version.effectiveFrom.getTime() > current.effectiveFrom.getTime() ||
      (version.effectiveFrom.getTime() === current.effectiveFrom.getTime() &&
        version.id > current.id)
    ) {
      current = version;
    }
  }
  return current;
}
