import 'dart:async';

import 'package:built_collection/built_collection.dart';
import 'package:core_api/core_api.dart';
import 'package:core_auth/core_auth.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:core_realtime/core_realtime.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../device.dart';
import '../support/report_photo.dart';

typedef Menu = MerchantMenuDtoOutput;
typedef MenuCategory = MerchantMenuDtoOutputCategoriesInner;
typedef MenuItem = MerchantMenuDtoOutputCategoriesInnerItemsInner;
typedef MenuOption =
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner;
typedef PriceLogEntry = MerchantPriceLogDtoOutputEntriesInner;
typedef BulkPreview = MerchantMenuBulkPreviewDtoOutput;
typedef PreviewCategory = MerchantMenuPreviewCategoryOutput;
typedef Pending = MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner;
typedef PendingField =
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum;
typedef MenuGroup = MerchantMenuDtoOutputOptionGroupsInner;
typedef GroupOption = MerchantMenuDtoOutputOptionGroupsInnerOptionsInner;

/// What a row is, for the availability switch (RA §9.3).
enum RowType { category, item, option }

/// «حتى الغد» (the default) or «حتى أعيده» (RA §9.3).
enum OffFor { tomorrow, untilBack }

/// The kinds of `restaurant.state_changed` after which the menu is read
/// again (RA §18 «menu changed», slices 2.32a and 2.32b): the restaurant's
/// own change on another device, an admin's price change and a review's
/// decision.
const menuKinds = {
  'menu_changed',
  'price_change',
  'price_change_bulk',
  'menu_change_approved',
  'menu_change_rejected',
};

/// RA §9.5: a row waiting for review as a new one (its request `created`):
/// customers do not see it, and only its request can change it.
bool isNew(Iterable<Pending> pending) =>
    pending.any((each) => each.field == PendingField.created);

/// A new row's id (RA §9.2): the app names it, so sending a request again
/// changes that row and never adds a second one. Tests give their own.
final newMenuIdProvider = Provider<String Function()>((ref) => uuidV4);

/// The menu's currency, from its prices (the base): null for a menu without
/// a price yet, which onboarding never leaves past activation.
String? menuCurrency(Menu menu) =>
    menu.categories
        .expand((c) => c.items)
        .map((i) => i.price.currency)
        .firstOrNull ??
    menu.optionGroups
        .expand((g) => g.options)
        .map((o) => o.priceDelta.currency)
        .firstOrNull;

/// The published rows' ids in order, which the reorder names (RA §9.2: a new
/// row takes the end once approved).
List<String> publishedIds(Iterable<({String id, bool isNew})> rows) => [
  for (final row in rows)
    if (!row.isNew) row.id,
];

bool changesMenu(Map<String, Object?> publication) =>
    publication['type'] == 'restaurant.state_changed' &&
    menuKinds.contains(publication['kind']);

/// The menu of the «القائمة» tab (RA §9.1): read on opening, after each
/// command's answer (every command answers the menu), after a subscription
/// that did not recover and on every menu change of the restaurant's channel,
/// so every device shows what the last one published.
class MenuNotifier extends AsyncNotifier<Menu> {
  @override
  Future<Menu> build() async {
    final restaurantId = ref.watch(
      merchantSessionProvider.select((s) => s.value?.restaurantId),
    );
    if (restaurantId != null) {
      final signals = ref
          .watch(realtimeTransportProvider)
          .channel('merchant:$restaurantId')
          .listen((signal) {
            final again = switch (signal) {
              RealtimeUp(:final recovered) => !recovered,
              RealtimePublication(:final data) => changesMenu(data),
              RealtimeDown() => false,
            };
            if (again) unawaited(reread());
          });
      ref.onDispose(signals.cancel);
    }
    return _read();
  }

  Future<Menu> _read() async =>
      (await ref.read(coreApiProvider).getMerchantApi().merchantMenuMenu())
          .data!;

  /// Reads again, keeping the menu shown until the answer.
  Future<void> reread() async {
    try {
      final menu = await _read();
      if (ref.mounted) state = AsyncData(menu);
    } on Object {
      // The menu shown stays; the next event or opening reads again.
    }
  }

  /// A command answered the menu: shown at once.
  void answered(Menu menu) {
    if (ref.mounted) state = AsyncData(menu);
  }
}

final menuProvider = AsyncNotifierProvider.autoDispose<MenuNotifier, Menu>(
  MenuNotifier.new,
);

/// Why the server refused a menu command, for the screen's message.
enum MenuRefusal {
  invalid,
  ownerOnly,
  terminated,
  gone,
  priceReachesZero,
  notPending,
  photo,
  other,
}

MenuRefusal refusalOf(DioException error) {
  final body = error.response?.data;
  final code = body is Map ? body['error'] : null;
  return switch (code) {
    'invalid_menu' => MenuRefusal.invalid,
    'owner_only' => MenuRefusal.ownerOnly,
    'restaurant_terminated' => MenuRefusal.terminated,
    'unknown_menu_row' || 'unknown_change_request' => MenuRefusal.gone,
    'price_reaches_zero' => MenuRefusal.priceReachesZero,
    // RA §9.5: decided by operations, or withdrawn, meanwhile.
    'request_not_pending' => MenuRefusal.notPending,
    String() when code.startsWith('upload_') => MenuRefusal.photo,
    _ => MenuRefusal.other,
  };
}

/// One row of «تعديل سريع» (RA §9.6): an item or one of its options.
class QuickRow {
  const QuickRow.item(this.category, this.item) : option = null;
  const QuickRow.option(this.category, this.item, MenuOption this.option);

  final MenuCategory category;
  final MenuItem item;
  final MenuOption? option;

  String get name => option?.name ?? item.name;
  String get id => option?.id ?? item.id;
}

/// «تعديل سريع»: every item and option of the menu, by name and category
/// (RA §9.6). An option shared by several items shows once, under the first.
List<QuickRow> quickRows(Menu menu, {String query = '', String? categoryId}) {
  final wanted = query.trim().toLowerCase();
  final seen = <String>{};
  bool matches(String name) =>
      wanted.isEmpty || name.toLowerCase().contains(wanted);
  return [
    for (final category in menu.categories)
      if (categoryId == null || category.id == categoryId)
        for (final item in category.items.where((i) => !isNew(i.pending))) ...[
          if (matches(item.name)) QuickRow.item(category, item),
          for (final group in item.optionGroups)
            for (final option in group.options)
              if (seen.add(option.id) && matches(option.name))
                QuickRow.option(category, item, option),
        ],
  ];
}

/// The ids in the new order after moving one up (-1) or down (+1); null when
/// it cannot move (RA §9.2, up and down until the design's drag).
List<String>? moved(List<String> ids, String id, int by) {
  final from = ids.indexOf(id);
  final to = from + by;
  if (from < 0 || to < 0 || to >= ids.length) return null;
  final next = [...ids]..removeAt(from);
  return next..insert(to, id);
}

/// A minor amount as typed in a field («12.50», «12» for a whole amount).
String typedOf(String minor, String currency, AppLocalizations l10n) {
  final shown = l10n.formatMoney(minor, currency);
  final symbol = l10n.currencySymbol(currency);
  return shown.replaceAll(symbol, '').replaceAll(',', '').trim();
}

/// A typed delta in minor units: 0 or more (RA §9.4); null when unreadable.
String? deltaOfTyped(String typed, String currency) {
  final text = typed.trim();
  if (RegExp(r'^0+(\.0+)?$').hasMatch(text)) return '0';
  return minorOfTyped(text, currency);
}

/// The owners' and cashiers' commands of the «القائمة» tab (RA §9.2, §18).
/// Each sets a value and answers the menu, so a repeat is harmless; the bulk
/// change is relative, so its key belongs to its body until the server
/// answers.
class MenuCommands {
  MenuCommands(this._api, this._ref);

  final MerchantApi _api;
  final Ref _ref;
  final _bulkKeys = <String, String>{};

  /// RA §9.3: switching off takes «حتى الغد» or «حتى أعيده».
  Future<MenuRefusal?> setAvailability(
    RowType type,
    String id, {
    required bool available,
    OffFor offFor = OffFor.tomorrow,
  }) => _run(() async {
    await _api.merchantMenuSetAvailability(
      merchantAvailabilityDto: MerchantAvailabilityDto(
        (b) => b
          ..type = switch (type) {
            RowType.category => MerchantAvailabilityDtoTypeEnum.category,
            RowType.item => MerchantAvailabilityDtoTypeEnum.item,
            RowType.option => MerchantAvailabilityDtoTypeEnum.option,
          }
          ..id = id
          ..available = available
          ..until = available
              ? null
              : offFor == OffFor.tomorrow
              ? MerchantAvailabilityDtoUntilEnum.tomorrow
              : MerchantAvailabilityDtoUntilEnum.turnedBackOn,
      ),
    );
    // The switch answers only the switch: the menu is read again.
    await _ref.read(menuProvider.notifier).reread();
  });

  Future<MenuRefusal?> setItemPrice(
    String itemId,
    String minor,
    String currency,
  ) => _menu(
    () => _api.merchantMenuItemPrice(
      itemId: itemId,
      merchantMenuItemPriceDto: MerchantMenuItemPriceDto(
        (b) => b.price
          ..amount = minor
          ..currency = currency,
      ),
    ),
  );

  Future<MenuRefusal?> setOptionDelta(
    String optionId,
    String minor,
    String currency,
  ) => _menu(
    () => _api.merchantMenuOptionPrice(
      optionId: optionId,
      merchantMenuOptionPriceDto: MerchantMenuOptionPriceDto(
        (b) => b.priceDelta
          ..amount = minor
          ..currency = currency,
      ),
    ),
  );

  Future<MenuRefusal?> setHidden(RowType type, String id, bool hidden) =>
      _menu(() {
        final body = MerchantMenuHiddenDto((b) => b.hidden = hidden);
        return type == RowType.category
            ? _api.merchantMenuCategoryHidden(
                categoryId: id,
                merchantMenuHiddenDto: body,
              )
            : _api.merchantMenuItemHidden(
                itemId: id,
                merchantMenuHiddenDto: body,
              );
      });

  /// Minutes after midnight on the city's clock; null for all day.
  Future<MenuRefusal?> setWindow(
    String categoryId,
    ({int startsAt, int endsAt})? window,
  ) => _menu(
    () => _api.merchantMenuCategoryWindow(
      categoryId: categoryId,
      merchantMenuWindowDto: MerchantMenuWindowDto(
        (b) => window == null
            ? b.window = null
            : (b.window
                ..startsAt = window.startsAt
                ..endsAt = window.endsAt),
      ),
    ),
  );

  Future<MenuRefusal?> orderCategories(List<String> ids) => _menu(
    () => _api.merchantMenuCategoryOrder(
      merchantMenuCategoryOrderDto: MerchantMenuCategoryOrderDto(
        (b) => b.categoryIds = ListBuilder(ids),
      ),
    ),
  );

  Future<MenuRefusal?> orderItems(String categoryId, List<String> ids) => _menu(
    () => _api.merchantMenuItemOrder(
      categoryId: categoryId,
      merchantMenuItemOrderDto: MerchantMenuItemOrderDto(
        (b) => b.itemIds = ListBuilder(ids),
      ),
    ),
  );

  /// RA §9.2 «After admin review» (slice 2.32b): a new category (a new id)
  /// or a category's name, as a request «بانتظار المراجعة».
  Future<MenuRefusal?> requestCategory(String categoryId, String name) => _menu(
    () => _api.merchantMenuRequestCategory(
      categoryId: categoryId,
      merchantCategoryRequestDto: MerchantCategoryRequestDto(
        (b) => b.name = name,
      ),
    ),
  );

  /// A new item (a new id) with its price and photo, or the one waiting for
  /// review edited; the photo is uploaded first, once.
  Future<MenuRefusal?> requestNewItem(String itemId, NewItem item) =>
      _run(() async {
        final uploadId = item.photo == null
            ? null
            : await uploadItemPhoto(_ref, item.photo!);
        final answer = await _api.merchantMenuRequestNewItem(
          itemId: itemId,
          merchantNewItemRequestDto: MerchantNewItemRequestDto(
            (b) => b
              ..categoryId = item.categoryId
              ..name = item.name
              ..description = item.description
              ..price.amount = item.price
              ..price.currency = item.currency
              ..uploadId = uploadId,
          ),
        );
        _ref.read(menuProvider.notifier).answered(answer.data!);
      });

  /// A published item's name and description (RA §9.5: one request per
  /// field; the published value withdraws its request).
  Future<MenuRefusal?> requestItemText(
    String itemId,
    String name,
    String? description,
  ) => _menu(
    () => _api.merchantMenuRequestItemText(
      itemId: itemId,
      merchantItemTextRequestDto: MerchantItemTextRequestDto(
        (b) => b
          ..name = name
          ..description = description,
      ),
    ),
  );

  /// RA §9.2: a new or replaced photo; the old one stays until approval.
  Future<MenuRefusal?> requestItemPhoto(String itemId, ItemPhoto photo) =>
      _run(() async {
        final uploadId = await uploadItemPhoto(_ref, photo);
        final answer = await _api.merchantMenuRequestItemPhoto(
          itemId: itemId,
          merchantItemPhotoRequestDto: MerchantItemPhotoRequestDto(
            (b) => b.uploadId = uploadId,
          ),
        );
        _ref.read(menuProvider.notifier).answered(answer.data!);
      });

  /// A new option group (a new id) or a group's name, choices, items, new
  /// options and options' names.
  Future<MenuRefusal?> requestOptionGroup(String groupId, GroupRequest group) =>
      _menu(
        () => _api.merchantMenuRequestOptionGroup(
          groupId: groupId,
          merchantOptionGroupRequestDto: MerchantOptionGroupRequestDto(
            (b) => b
              ..name = group.name
              ..minChoices = group.minChoices
              ..maxChoices = group.maxChoices
              ..itemIds = ListBuilder(group.itemIds)
              ..options = ListBuilder([
                for (final option in group.options)
                  MerchantRequestOption(
                    (o) => o
                      ..id = option.id
                      ..name = option.name
                      ..priceDelta.amount = option.delta
                      ..priceDelta.currency = option.currency,
                  ),
              ]),
          ),
        ),
      );

  /// RA §9.5: the owner withdraws a pending request.
  Future<MenuRefusal?> withdraw(String requestId) =>
      _menu(() => _api.merchantMenuWithdraw(requestId: requestId));

  /// The before and after of the bulk change (AP §9.6.6); a read.
  Future<(BulkPreview?, MenuRefusal?)> previewBulk(BulkChange change) async {
    try {
      final answer = await _api.merchantMenuBulkPricePreview(
        merchantMenuBulkPriceDto: change.body,
      );
      return (answer.data, null);
    } on DioException catch (error) {
      return (null, refusalOf(error));
    }
  }

  /// The server's count of the prices it changed, recomputed under the
  /// restaurant's lock, so it may differ from the preview's.
  int? lastBulkChanged;

  Future<MenuRefusal?> applyBulk(BulkChange change) => _run(() async {
    final body = change.body;
    final key = _bulkKeys.putIfAbsent(body.toString(), uuidV4);
    try {
      final answer = await _api.merchantMenuBulkPrice(
        idempotencyKey: key,
        merchantMenuBulkPriceDto: body,
      );
      lastBulkChanged = answer.data!.changed;
      _bulkKeys.remove(body.toString());
    } on DioException catch (error) {
      // An answer ends the key; a lost one sends it again with the same key.
      if (error.response != null) _bulkKeys.remove(body.toString());
      rethrow;
    }
    await _ref.read(menuProvider.notifier).reread();
  });

  Future<MenuRefusal?> _menu(Future<Response<Menu>> Function() call) =>
      _run(() async {
        final answer = await call();
        _ref.read(menuProvider.notifier).answered(answer.data!);
      });

  Future<MenuRefusal?> _run(Future<void> Function() call) async {
    try {
      await call();
      return null;
    } on DioException catch (error) {
      unawaited(_ref.read(menuProvider.notifier).reread());
      return refusalOf(error);
    }
  }
}

final menuCommandsProvider = Provider<MenuCommands>(
  (ref) => MenuCommands(ref.watch(coreApiProvider).getMerchantApi(), ref),
);

/// A bulk change (RA §9.4): by a percentage or a fixed amount, up or down,
/// for one category or the whole menu.
class BulkChange {
  const BulkChange({
    required this.categoryId,
    required this.percent,
    required this.up,
    required this.value,
  });

  final String? categoryId;
  final bool percent;
  final bool up;

  /// Basis points for a percentage, minor units for an amount.
  final String value;

  MerchantMenuBulkPriceDto get body => MerchantMenuBulkPriceDto(
    (b) => b
      ..categoryId = categoryId
      ..kind = percent
          ? MerchantMenuBulkPriceDtoKindEnum.percent
          : MerchantMenuBulkPriceDtoKindEnum.amount
      ..direction = up
          ? MerchantMenuBulkPriceDtoDirectionEnum.up
          : MerchantMenuBulkPriceDtoDirectionEnum.down
      ..value = value,
  );
}

/// A typed percentage («10», «12.5») in basis points; null unless 0.01 to
/// 1000 (the server's cap).
String? basisPointsOf(String typed) {
  final match = RegExp(r'^(\d{1,4})(?:\.(\d{1,2}))?$').firstMatch(typed.trim());
  if (match == null) return null;
  final bp =
      int.parse(match.group(1)!) * 100 +
      int.parse((match.group(2) ?? '').padRight(2, '0'));
  return bp < 1 || bp > 100000 ? null : bp.toString();
}

/// «سجل الأسعار» (RA §9.4), the owners'; read while its screen shows.
final priceLogProvider = FutureProvider.autoDispose<BuiltList<PriceLogEntry>>((
  ref,
) async {
  return (await ref
          .watch(coreApiProvider)
          .getMerchantApi()
          .merchantPriceLogPriceLog())
      .data!
      .entries;
});

/// «معاينة كما يراها الزبون» (RA §9.7), the owners'.
final customerPreviewProvider =
    FutureProvider.autoDispose<BuiltList<PreviewCategory>>((ref) async {
      return (await ref
              .watch(coreApiProvider)
              .getMerchantApi()
              .merchantMenuPreviewPreview())
          .data!
          .menu;
    });

/// RA §5.5: a terminated restaurant's menu is refused.
bool isTerminated(Object error) =>
    error is DioException && refusalOf(error) == MenuRefusal.terminated;

/// A read refused to a cashier (RA §6: the owners' screens).
bool isOwnerOnly(Object error) =>
    error is DioException && refusalOf(error) == MenuRefusal.ownerOnly;

/// A new item as the owner asks it (RA §9.2: its price is part of the
/// request).
class NewItem {
  const NewItem({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    this.photo,
  });

  final String categoryId;
  final String name;
  final String? description;

  /// Minor units.
  final String price;
  final String currency;

  /// A new photo; null keeps the one asked.
  final ItemPhoto? photo;
}

/// An option group as the owner asks it.
class GroupRequest {
  const GroupRequest({
    required this.name,
    required this.minChoices,
    required this.maxChoices,
    required this.itemIds,
    required this.options,
  });

  final String name;
  final int minChoices;
  final int maxChoices;
  final List<String> itemIds;
  final List<({String id, String name, String delta, String currency})> options;
}

/// A photo on its way into a request: uploaded once, then sent by its
/// upload id however often the request is sent again.
class ItemPhoto {
  ItemPhoto(this.photo);

  final PickedPhoto photo;
  String? uploadId;
}

/// Uploads the photo unless it was: `POST /v1/merchant/uploads/item-photo`
/// for a signed PUT into public-media, then the PUT. Answers its upload id.
Future<String> uploadItemPhoto(Ref ref, ItemPhoto photo) async {
  final known = photo.uploadId;
  if (known != null) return known;
  final answer = await ref
      .read(coreApiProvider)
      .getMerchantApi()
      .merchantMenuItemPhotoUpload(
        merchantNewUploadDto: MerchantNewUploadDto(
          (b) => b
            ..contentType = _uploadTypes[photo.photo.contentType]
            ..sizeBytes = photo.photo.bytes.length,
        ),
      );
  final upload = answer.data!;
  await ref.read(photoPutProvider)(upload.url, photo.photo);
  return photo.uploadId = upload.uploadId;
}

const _uploadTypes = {
  'image/jpeg': MerchantNewUploadDtoContentTypeEnum.imageSlashJpeg,
  'image/png': MerchantNewUploadDtoContentTypeEnum.imageSlashPng,
  'image/webp': MerchantNewUploadDtoContentTypeEnum.imageSlashWebp,
};
