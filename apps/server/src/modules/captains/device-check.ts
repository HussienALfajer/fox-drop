// CA §4.5 (slice 2.43): the device check's items, as the captain app reports
// the failed ones. On Android: 1 notifications, 2 location always and
// precise, 3 battery optimisation off and the brand's auto-start, 4 full
// screen, 5 the alarm volume and Do Not Disturb, 6 the test offer, 7 the
// server connection and the GPS accuracy, 8 the call permission.
export const captainDeviceCheckCodes = [
  'notifications',
  'location',
  'battery',
  'autostart',
  'full_screen',
  'alarm_volume',
  'do_not_disturb',
  'test_offer',
  'connection',
  'gps_accuracy',
  'call',
] as const;
export type CaptainDeviceCheckCode = (typeof captainDeviceCheckCodes)[number];

// The last check of a captain's phone: passed with no failed item.
export interface CaptainDeviceCheck {
  at: Date;
  // The app installation that ran it (the session's device).
  deviceId: string;
  passed: boolean;
  failed: CaptainDeviceCheckCode[];
}
