import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';

import 'menu.dart';

/// A row's own switch (RA §9.3): on, off «حتى الغد» or off «حتى أعيده».
String switchText(
  AppLocalizations l10n,
  MerchantMenuDtoOutputCategoriesInnerSwitchedOff? off,
) => off == null
    ? l10n.merchantMenuAvailable
    : off.until == null
    ? l10n.merchantMenuOffUntilBack
    : l10n.merchantMenuOffTomorrow;

/// A category's daily window, or «متوفر طوال اليوم» (RA §9.1).
String windowText(AppLocalizations l10n, MenuCategory category) {
  final window = category.window;
  if (window == null) return l10n.merchantMenuWindowAllDay;
  return l10n.merchantMenuWindowShown(
    l10n.formatMinuteOfDay(window.startsAt),
    l10n.formatMinuteOfDay(window.endsAt % 1440),
  );
}

String refusalText(
  AppLocalizations l10n,
  MenuRefusal refusal, {
  bool request = false,
}) => switch (refusal) {
  MenuRefusal.invalid when request => l10n.merchantMenuRequestInvalid,
  MenuRefusal.invalid => l10n.merchantMenuInvalidPrice,
  MenuRefusal.terminated => l10n.merchantMenuTerminated,
  MenuRefusal.priceReachesZero => l10n.merchantMenuBulkRefused,
  MenuRefusal.notPending => l10n.merchantMenuRequestGone,
  MenuRefusal.photo => l10n.merchantMenuPhotoFailed,
  _ => l10n.merchantSaveFailed,
};

/// RA §9.5: what a pending request asks, beside its row; `itemName` names a
/// group's items.
String pendingText(
  AppLocalizations l10n,
  Pending pending,
  String Function(String id) itemName,
) => switch (pending.field) {
  PendingField.created => l10n.merchantMenuPendingNew,
  PendingField.rename => l10n.merchantMenuPendingName(pending.name ?? ''),
  PendingField.description =>
    pending.description == null
        ? l10n.merchantMenuPendingNoDescription
        : l10n.merchantMenuPendingDescription(pending.description!),
  PendingField.photo => l10n.merchantMenuPendingPhoto,
  PendingField.choices => l10n.merchantMenuPendingChoices(
    '${pending.minChoices}',
    '${pending.maxChoices}',
  ),
  PendingField.items =>
    pending.itemIds == null || pending.itemIds!.isEmpty
        ? l10n.merchantMenuPendingNoItems
        : l10n.merchantMenuPendingItems(
            pending.itemIds!.map(itemName).join('، '),
          ),
  _ => l10n.merchantMenuPendingReview,
};

/// Who changed a price (RA §9.4): the restaurant user, or «FOX DROP».
String changedByText(AppLocalizations l10n, PriceLogEntry entry) =>
    entry.byType == MerchantPriceLogDtoOutputEntriesInnerByTypeEnum.merchant
    ? (entry.byName ?? l10n.merchantMenuUnknownUser)
    : l10n.merchantMenuFoxDrop;

/// An item's line in the customer preview (CU §9.3).
String? previewReasonText(
  AppLocalizations l10n,
  AdminMenuPreviewDtoOutputMenuInnerItemsInner item,
  PreviewCategory category,
) {
  if (item.available) return null;
  return switch (item.unavailableReason?.name) {
    'tomorrow' => l10n.merchantMenuPreviewTomorrow,
    'window' when category.window != null => l10n.merchantMenuPreviewFrom(
      l10n.formatMinuteOfDay(category.window!.startsAt),
    ),
    _ => l10n.merchantMenuPreviewUnavailable,
  };
}
