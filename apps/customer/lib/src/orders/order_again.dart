import 'package:core_api/core_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../cart/cart.dart';
import '../cart/item_choice.dart';
import 'order_live.dart';

typedef RestaurantCard = CustomerRestaurantListDtoOutputRestaurantsInner;

/// The restaurant of a rejected or unanswered order and the order's pin.
typedef SimilarTo = ({String restaurantId, double latitude, double longitude});

/// CU §11.9: up to 5 similar restaurants under a rejected or unanswered
/// order, at its pin: open, of the same category, delivering there. The
/// server picks them (`similarTo` on the restaurant list).
final similarRestaurantsProvider = FutureProvider.autoDispose
    .family<List<RestaurantCard>, SimilarTo>((ref, to) async {
      final response = await ref
          .watch(coreApiProvider)
          .getCustomerApi()
          .customerBrowsingList(
            latitude: '${to.latitude}',
            longitude: '${to.longitude}',
            similarTo: to.restaurantId,
          );
      return response.data!.restaurants.toList();
    });

/// Similar restaurants follow a rejection and an unanswered order only.
SimilarTo? similarToOf(CustomerOrder order) => switch (titleOf(order)) {
  Rejected() || NoRestaurantResponse() => (
    restaurantId: order.restaurant.id,
    latitude: order.address.location.latitude.toDouble(),
    longitude: order.address.location.longitude.toDouble(),
  ),
  _ => null,
};

/// A line of the order to put back in the cart.
typedef OrderedLine = ({
  String itemId,
  String name,
  int quantity,
  String? note,
  List<String> optionIds,
});

/// The cart rebuilt from the restaurant's current menu (CU §12.3).
class Rebuilt {
  const Rebuilt(this.lines, this.skipped);

  /// At current prices, the notes copied.
  final List<CartLine> lines;

  /// The names of the lines whose item or options are no longer available:
  /// «لم نضف: {الأصناف} لأنها غير متوفرة».
  final List<String> skipped;
}

/// CU §11.9, §12.3 (Q22): the order's lines without the items in [without],
/// priced from [menu] now. A line whose item is gone or unavailable, or one
/// of whose options is, or whose groups no longer fit its options, is
/// skipped and named.
Rebuilt rebuildLines(
  Iterable<OrderedLine> ordered,
  Iterable<CustomerRestaurantPageDtoOutputMenuInner> menu,
  Set<String> without,
) {
  final items = {
    for (final category in menu)
      for (final item in category.items) item.id: item,
  };
  final lines = <CartLine>[];
  final skipped = <String>[];
  for (final line in ordered) {
    if (without.contains(line.itemId)) continue;
    final item = items[line.itemId];
    final choice = item == null || !item.available ? null : _choice(item, line);
    if (choice == null) {
      if (!skipped.contains(line.name)) skipped.add(line.name);
    } else {
      lines.add(choice.toLine());
    }
  }
  return Rebuilt(lines, skipped);
}

ItemChoice? _choice(MenuItem item, OrderedLine line) {
  final chosen = <String, Set<String>>{};
  var found = 0;
  for (final group in item.optionGroups) {
    chosen[group.id] = {};
    for (final option in group.options) {
      if (!line.optionIds.contains(option.id)) continue;
      if (!option.available) return null;
      chosen[group.id]!.add(option.id);
      found++;
    }
    if (chosen[group.id]!.length > group.maxChoices) return null;
  }
  if (found != line.optionIds.toSet().length) return null;
  final choice = ItemChoice(
    item,
    chosen: chosen,
    quantity: line.quantity > maxQuantity ? maxQuantity : line.quantity,
    note: line.note ?? '',
  );
  return choice.incompleteGroups.isEmpty ? choice : null;
}

/// The order's lines as [rebuildLines] takes them.
List<OrderedLine> orderedLines(CustomerOrder order) => [
  for (final line in order.lines)
    (
      itemId: line.itemId,
      name: line.name,
      quantity: line.quantity,
      note: line.note,
      optionIds: [for (final option in line.options) option.id],
    ),
];

/// CU §11.9 (Q22): the order's lines without [without], from the
/// restaurant's menu at the order's pin now; null when customers no longer
/// see the restaurant.
Future<Rebuilt?> rebuildFromOrder(
  CustomerApi api,
  CustomerOrder order,
  Set<String> without,
) async {
  final response = await api.customerBrowsingPage(
    restaurantId: order.restaurant.id,
    latitude: '${order.address.location.latitude}',
    longitude: '${order.address.location.longitude}',
  );
  final page = response.data;
  if (page == null) return null;
  return rebuildLines(orderedLines(order), page.menu, without);
}
