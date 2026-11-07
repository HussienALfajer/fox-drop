import 'package:core_api/core_api.dart';
import 'package:core_l10n/core_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../cart/cart.dart';
import '../cart/item_choice.dart';
import '../cart/item_sheet.dart';
import '../device.dart';
import 'browsing.dart';

/// A restaurant's page (CU §9.1–9.3, §9.5's badge): the header, the state,
/// «أوقات العمل», and the menu with «ابحث في القائمة». Unstyled until the
/// design; the category bar that follows the scroll waits for it.
class RestaurantScreen extends ConsumerStatefulWidget {
  const RestaurantScreen({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  ConsumerState<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends ConsumerState<RestaurantScreen> {
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final page = ref.watch(restaurantPageProvider(widget.restaurantId));
    final cart = ref.watch(cartProvider).value?.cart;
    return Scaffold(
      appBar: AppBar(
        title: Text(page.value?.nameAr ?? ''),
        actions: [
          if (cart != null)
            TextButton(
              key: const Key('open-cart'),
              onPressed: () => context.push('/cart'),
              child: Text(l10n.customerCartCount(cart.lines.length)),
            ),
        ],
      ),
      body: switch (page) {
        AsyncData(value: final restaurant?) => _page(context, restaurant),
        AsyncData() => Center(child: Text(l10n.notFound)),
        AsyncError() => Center(
          child: TextButton(
            onPressed: () =>
                ref.invalidate(restaurantPageProvider(widget.restaurantId)),
            child: Text(l10n.customerTryAgain),
          ),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _page(BuildContext context, CustomerRestaurantPageDtoOutput r) {
    final l10n = AppLocalizations.of(context);
    final now = ref.watch(clockProvider)();
    final state = RestaurantState(
      state: r.state.state.name,
      busyMode: r.state.busyMode,
      until: r.state.until,
      opensAt: r.state.opensAt,
      message: r.state.message,
    );
    final stateText = restaurantStateText(l10n, state, now);
    // A restaurant that cannot take orders, or does not deliver here, keeps
    // its menu browsable with the add buttons off (CU §9.2).
    final blocked = !state.takesOrders
        ? stateText
        : !r.deliversHere
        ? l10n.customerNotCovered
        : null;
    final fee = r.deliveryFee;
    final free = r.freeDeliveryFrom;
    final search = _search.trim();
    return ListView(
      children: [
        ListTile(
          title: Text(r.nameAr),
          subtitle: Text(
            [
              ?r.category,
              r.rating == null
                  ? l10n.customerNew
                  : l10n.customerRating(
                      r.rating!.toStringAsFixed(1),
                      r.ratingCount ?? 0,
                    ),
              l10n.customerEstimate(r.estimate.fromMin, r.estimate.toMin),
              if (fee != null)
                fee.free
                    ? l10n.customerFreeDelivery
                    : l10n.customerDeliveryFeeValue(
                        l10n.formatMoney(fee.fee.amount, fee.fee.currency),
                      ),
            ].join(' · '),
          ),
        ),
        if (r.description case final description?)
          ListTile(title: Text(description)),
        if (r.minimumOrder case final minimum?)
          ListTile(
            title: Text(
              l10n.customerMinimumOrder(
                l10n.formatMoney(minimum.amount, minimum.currency),
              ),
            ),
          ),
        if (free != null)
          ListTile(
            title: Text(
              l10n.customerFreeDeliveryFrom(
                l10n.formatMoney(free.amount, free.currency),
              ),
            ),
          ),
        if (stateText != null) ListTile(title: Text(stateText)),
        if (state.takesOrders && !r.deliversHere)
          ListTile(title: Text(l10n.customerNotCovered)),
        Wrap(
          children: [
            TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  content: Text(l10n.customerSamePricesExplained),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(l10n.customerOk),
                    ),
                  ],
                ),
              ),
              child: Text(l10n.customerSamePrices),
            ),
            TextButton(
              onPressed: () => _showHours(context, r),
              child: Text(l10n.customerOpeningHours),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          child: TextField(
            key: const Key('menu-search'),
            decoration: InputDecoration(labelText: l10n.customerMenuSearch),
            onChanged: (value) => setState(() => _search = value),
          ),
        ),
        for (final category in r.menu)
          if (category.items.any((item) => _matches(item, search))) ...[
            ListTile(title: Text(category.name)),
            for (final item in category.items)
              if (_matches(item, search))
                _itemTile(context, r, category, item, blocked),
          ],
      ],
    );
  }

  bool _matches(MenuItem item, String search) =>
      search.isEmpty ||
      item.name.contains(search) ||
      (item.description?.contains(search) ?? false);

  Widget _itemTile(
    BuildContext context,
    CustomerRestaurantPageDtoOutput r,
    CustomerRestaurantPageDtoOutputMenuInner category,
    MenuItem item,
    String? blocked,
  ) {
    final l10n = AppLocalizations.of(context);
    final price = item.fromPrice == null
        ? l10n.formatMoney(item.price!.amount, item.price!.currency)
        : l10n.customerFromPrice(
            l10n.formatMoney(item.fromPrice!.amount, item.fromPrice!.currency),
          );
    final window = category.window;
    final unavailable = item.available
        ? null
        : switch (item.unavailableReason?.name) {
            'tomorrow' => l10n.customerAvailableTomorrow,
            'window' when window != null => l10n.customerAvailableFrom(
              l10n.formatMinuteOfDay(window.startsAt),
            ),
            _ => l10n.customerUnavailable,
          };
    return ListTile(
      key: Key('item-${item.id}'),
      title: Text(item.name),
      subtitle: Text([?item.description, price, ?unavailable].join('\n')),
      enabled: item.available,
      onTap: item.available
          ? () => showItemSheet(
              context,
              restaurantId: r.id,
              restaurantName: r.nameAr,
              item: item,
              blocked: blocked,
            )
          : null,
    );
  }

  void _showHours(BuildContext context, CustomerRestaurantPageDtoOutput r) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: Text(l10n.customerOpeningHours)),
          for (final period in r.schedule)
            ListTile(
              title: Text(l10n.weekdayName(period.weekday)),
              subtitle: Text(
                l10n.customerHoursRange(
                  l10n.formatMinuteOfDay(period.opensAt),
                  l10n.formatMinuteOfDay(period.closesAt),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
