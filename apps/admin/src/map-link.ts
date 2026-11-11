// «فتح الخريطة» (AP §9.1.3, CA §9.11; slice 2.13c, owner decision
// 2026-11-11): until the panel has its live map, Google Maps at the point,
// opened in a new tab.
export function mapLink(point: { latitude: number; longitude: number }): string {
  const query = `${point.latitude},${point.longitude}`;
  return `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(query)}`;
}
