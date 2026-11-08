// The apps whose version and maintenance Appendix A sets (`app.<app>.*`).
export const platformApps = ['customer', 'merchant', 'captain'] as const;
export type PlatformApp = (typeof platformApps)[number];

// An app version: major.minor.patch, as the apps send it.
export const APP_VERSION = /^\d+\.\d+\.\d+$/;

// AP §9.14: whether an app version such as 1.9.0 is below a minimum such as
// 1.10.0, part by part. A version not in that form is below any minimum.
export function versionBelow(version: string, minimum: string): boolean {
  if (!APP_VERSION.test(version)) return true;
  const parts = version.split('.').map(Number);
  const least = minimum.split('.').map(Number);
  for (let index = 0; index < least.length; index += 1) {
    const difference = (parts[index] ?? 0) - least[index]!;
    if (difference !== 0) return difference < 0;
  }
  return false;
}

// CU §4.2, RA §4.2, CA §4.2: below the minimum the app blocks with its update
// screen, below the latest it offers a dismissible banner.
export type UpdateNeed = 'required' | 'suggested' | 'none';

export function updateNeed(
  version: string,
  versions: { minVersion: string | null; latestVersion: string | null },
): UpdateNeed {
  if (versions.minVersion !== null && versionBelow(version, versions.minVersion)) return 'required';
  if (versions.latestVersion !== null && versionBelow(version, versions.latestVersion)) {
    return 'suggested';
  }
  return 'none';
}
