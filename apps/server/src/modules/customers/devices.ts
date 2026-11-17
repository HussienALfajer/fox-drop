// The device block (docs/domain/08, owner decisions 2026-11-10 and
// 2026-11-18; slice 2.25d): a block or unpaid dues follow the phone itself,
// so every account signed in on a device another blocked account used is
// stopped too.

// One account's sign-ins on one device (identity's customer sessions), the
// device being the app's `deviceId`, which survives a reinstall.
export interface DeviceSighting {
  deviceId: string;
  accountId: string;
  firstSignedInAt: Date;
  lastSignedInAt: Date;
  // The latest refresh or end of its sessions: when the device was last seen.
  lastSeenAt: Date;
  // The IP address and user agent of the latest sign-in: a signal only,
  // never the block (a VPN changes the address and many share one).
  ipAddress: string | null;
  userAgent: string | null;
}

// The accounts linked to the line through a device, with the devices they
// share, in the sightings' order: every account outside the line signed in
// on a device the line used. Only sign-ins after the device's latest
// «فك حظر الجهاز» count, on both sides, so a phone sold on starts clean and
// a blocked account signing in on it again links it again.
export function deviceLinks(
  line: readonly string[],
  sightings: readonly DeviceSighting[],
  lifts: ReadonlyMap<string, Date>,
): Map<string, string[]> {
  const inLine = new Set(line);
  const current = sightings.filter((sighting) => {
    const lift = lifts.get(sighting.deviceId);
    return lift === undefined || sighting.lastSignedInAt.getTime() > lift.getTime();
  });
  const lineDevices = new Set(
    current.filter((sighting) => inLine.has(sighting.accountId)).map((s) => s.deviceId),
  );
  const links = new Map<string, string[]>();
  for (const sighting of current) {
    if (inLine.has(sighting.accountId) || !lineDevices.has(sighting.deviceId)) continue;
    const devices = links.get(sighting.accountId) ?? [];
    if (!devices.includes(sighting.deviceId)) devices.push(sighting.deviceId);
    links.set(sighting.accountId, devices);
  }
  return links;
}
