/// A moment the status fixtures count from.
final now = DateTime.utc(2026, 11, 9, 9);

/// `GET /v1/merchant/restaurant/status` as the server answers it.
Map<String, Object?> statusJson({
  String state = 'open',
  String? pauseSource,
  DateTime? stateUntil,
  DateTime? closesAt,
  DateTime? opensAt,
  int? busyMode,
  int? activeOrders,
  int? maxActiveOrders,
}) => {
  'state': state,
  'pauseSource': pauseSource,
  'stateUntil': stateUntil?.toIso8601String(),
  'closesAt': closesAt?.toIso8601String(),
  'opensAt': opensAt?.toIso8601String(),
  'busyMode': busyMode == null
      ? null
      : {
          'extraMin': busyMode,
          'until': now.add(const Duration(hours: 5)).toIso8601String(),
        },
  'activeOrders': activeOrders,
  'maxActiveOrders': maxActiveOrders,
  'holiday': null,
  'pauseChoicesMin': [15, 30, 60],
  'busyExtraOptionsMin': [10, 20],
  'busyReminderMin': 60,
};
