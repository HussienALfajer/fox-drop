import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// The parts the owners' settings screens share (RA §14). Unstyled until the
// design.

/// «آخر نشاط: …» on the city's clock, or «لم يسجّل الدخول بعد».
String lastActiveText(AppLocalizations l10n, DateTime? at) => at == null
    ? l10n.merchantNeverActive
    : l10n.merchantLastActive(l10n.formatDate(at), l10n.formatTime(at));

/// A device's platform in words.
String platformText(
  AppLocalizations l10n,
  MerchantDevicesDtoOutputDevicesInnerPlatformEnum platform,
) => switch (platform) {
  MerchantDevicesDtoOutputDevicesInnerPlatformEnum.ios =>
    l10n.merchantPlatformIos,
  MerchantDevicesDtoOutputDevicesInnerPlatformEnum.windows =>
    l10n.merchantPlatformWindows,
  _ => l10n.merchantPlatformAndroid,
};

/// Asks before a command that cannot be undone; true once confirmed.
Future<bool> confirm(BuildContext context, String question, String yes) async {
  final l10n = AppLocalizations.of(context);
  final answer = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(question),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.merchantMenuCancel),
        ),
        TextButton(
          key: const Key('confirm'),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(yes),
        ),
      ],
    ),
  );
  return answer ?? false;
}

/// A refused read: a `403` (a cashier, a terminated restaurant) would fail
/// again, any other failure offers a retry.
class Failure extends StatelessWidget {
  const Failure({super.key, required this.error, required this.retry});

  final Object error;
  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (error is DioException &&
        (error as DioException).response?.statusCode == 403) {
      return Center(child: Text(l10n.merchantSettingsNotAllowed));
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(l10n.merchantSettingsFailed),
          TextButton(onPressed: retry, child: Text(l10n.merchantRetry)),
        ],
      ),
    );
  }
}
