import 'package:core_api/core_api.dart';

import 'cart.dart';

typedef MenuItem = CustomerRestaurantPageDtoOutputMenuInnerItemsInner;
typedef OptionGroup =
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner;

/// An item note is up to 100 characters (CU §9.4, fixed).
const maxItemNote = 100;

/// A run of 7 or more digits reads as a phone number, which a note cannot
/// carry (Q25); Arabic-Indic digits count too.
final _phoneRun = RegExp(r'[0-9٠-٩۰-۹]{7,}');

bool hasPhoneNumber(String text) => _phoneRun.hasMatch(text);

/// What the item sheet has chosen (CU §9.4).
class ItemChoice {
  ItemChoice(
    this.item, {
    Map<String, Set<String>>? chosen,
    this.quantity = 1,
    this.note = '',
  }) : chosen = chosen ?? {for (final group in item.optionGroups) group.id: {}};

  /// The sheet reopened from a cart line («تعديل»).
  factory ItemChoice.ofLine(MenuItem item, CartLine line) => ItemChoice(
    item,
    chosen: {
      for (final group in item.optionGroups)
        group.id: {
          for (final option in group.options)
            if (line.optionIds.contains(option.id)) option.id,
        },
    },
    quantity: line.quantity,
    note: line.note ?? '',
  );

  final MenuItem item;
  final Map<String, Set<String>> chosen;
  int quantity;
  String note;

  /// A tap on an option: a group of one choice swaps it; another adds or
  /// removes it, up to the group's maximum. Unavailable options cannot be
  /// picked (CU §9.3).
  void toggle(OptionGroup group, String optionId) {
    final option = group.options.firstWhere((o) => o.id == optionId);
    final picked = chosen[group.id]!;
    if (picked.contains(optionId)) {
      picked.remove(optionId);
    } else if (!option.available) {
      return;
    } else if (group.maxChoices == 1) {
      picked
        ..clear()
        ..add(optionId);
    } else if (picked.length < group.maxChoices) {
      picked.add(optionId);
    }
  }

  /// The groups whose minimum is not reached yet.
  List<OptionGroup> get incompleteGroups => [
    for (final group in item.optionGroups)
      if (chosen[group.id]!.length < group.minChoices) group,
  ];

  String? get trimmedNote {
    final value = note.trim();
    return value.isEmpty ? null : value;
  }

  bool get noteTooLong => note.trim().length > maxItemNote;

  bool get noteHasPhone => hasPhoneNumber(note);

  /// The item's price with the chosen options' deltas, in minor units. Every
  /// delta is in the item's currency (the server's `fromPrice` is null
  /// otherwise, and the quote refuses such a price).
  String get unitPrice {
    var total = BigInt.parse(item.price!.amount);
    for (final group in item.optionGroups) {
      for (final option in group.options) {
        if (chosen[group.id]!.contains(option.id)) {
          total += BigInt.parse(option.priceDelta!.amount);
        }
      }
    }
    return total.toString();
  }

  String get linePrice =>
      (BigInt.parse(unitPrice) * BigInt.from(quantity)).toString();

  /// The cart line, in the menu's option order.
  CartLine toLine() {
    final ids = <String>[];
    final names = <String>[];
    for (final group in item.optionGroups) {
      for (final option in group.options) {
        if (chosen[group.id]!.contains(option.id)) {
          ids.add(option.id);
          names.add(option.name);
        }
      }
    }
    return CartLine(
      itemId: item.id,
      name: item.name,
      optionIds: ids,
      optionNames: names,
      quantity: quantity,
      note: trimmedNote,
      unitPrice: unitPrice,
      currency: item.price!.currency,
    );
  }
}
