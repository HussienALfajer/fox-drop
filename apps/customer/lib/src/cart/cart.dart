import 'dart:async';
import 'dart:convert';

import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../device.dart';

/// The cart is kept on the device this long after its last change (CU
/// §10.1, fixed).
const cartLifetime = Duration(hours: 24);

const _cartKey = 'cart';

/// A line of the cart: an item with its chosen options, quantity and note.
/// The same item with other options or another note is another line (CU
/// §9.4).
class CartLine {
  const CartLine({
    required this.itemId,
    required this.name,
    required this.optionIds,
    required this.optionNames,
    required this.quantity,
    required this.note,
    required this.unitPrice,
    required this.currency,
  });

  factory CartLine.fromJson(Map<String, dynamic> json) => CartLine(
    itemId: json['itemId'] as String,
    name: json['name'] as String,
    optionIds: (json['optionIds'] as List).cast<String>(),
    optionNames: (json['optionNames'] as List).cast<String>(),
    quantity: json['quantity'] as int,
    note: json['note'] as String?,
    unitPrice: json['unitPrice'] as String,
    currency: json['currency'] as String,
  );

  final String itemId;
  final String name;
  final List<String> optionIds;
  final List<String> optionNames;
  final int quantity;
  final String? note;

  /// The unit price the customer last saw, in minor units: the quote's
  /// `knownUnitPrice` (CU §10.1).
  final String unitPrice;
  final String currency;

  /// Lines with this key are one line.
  String get key => '$itemId|${([...optionIds]..sort()).join(',')}|$note';

  String get lineTotal =>
      (BigInt.parse(unitPrice) * BigInt.from(quantity)).toString();

  CartLine copyWith({int? quantity, String? unitPrice}) => CartLine(
    itemId: itemId,
    name: name,
    optionIds: optionIds,
    optionNames: optionNames,
    quantity: quantity ?? this.quantity,
    note: note,
    unitPrice: unitPrice ?? this.unitPrice,
    currency: currency,
  );

  Map<String, dynamic> toJson() => {
    'itemId': itemId,
    'name': name,
    'optionIds': optionIds,
    'optionNames': optionNames,
    'quantity': quantity,
    'note': note,
    'unitPrice': unitPrice,
    'currency': currency,
  };
}

/// One restaurant's cart (CU §10.1).
class Cart {
  const Cart({
    required this.restaurantId,
    required this.restaurantName,
    required this.lines,
    required this.changedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    restaurantId: json['restaurantId'] as String,
    restaurantName: json['restaurantName'] as String,
    lines: [
      for (final line in json['lines'] as List)
        CartLine.fromJson(line as Map<String, dynamic>),
    ],
    changedAt: DateTime.parse(json['changedAt'] as String),
  );

  final String restaurantId;
  final String restaurantName;
  final List<CartLine> lines;
  final DateTime changedAt;

  Map<String, dynamic> toJson() => {
    'restaurantId': restaurantId,
    'restaurantName': restaurantName,
    'lines': [for (final line in lines) line.toJson()],
    'changedAt': changedAt.toUtc().toIso8601String(),
  };
}

class CartState {
  const CartState(this.cart, {this.expired = false});

  /// Null while empty.
  final Cart? cart;

  /// «انتهت صلاحية سلتك»: the stored cart was older than [cartLifetime].
  /// It stays until the next item is added.
  final bool expired;

  bool get isEmpty => cart == null;
}

/// What [CartController.add] did.
enum CartAdd { added, otherRestaurant }

/// The cart, kept on the device (owner decision 2026-11-07).
class CartController extends AsyncNotifier<CartState> {
  DeviceStore get _store => ref.read(deviceStoreProvider);

  DateTime _now() => ref.read(clockProvider)();

  @override
  Future<CartState> build() async {
    try {
      final stored = await _store.read(_cartKey);
      if (stored == null) return const CartState(null);
      final cart = Cart.fromJson(jsonDecode(stored) as Map<String, dynamic>);
      if (_now().difference(cart.changedAt) > cartLifetime) {
        await _store.delete(_cartKey);
        return const CartState(null, expired: true);
      }
      return CartState(cart);
    } on Object {
      // An unreadable value starts an empty cart.
      unawaited(_store.delete(_cartKey).catchError((Object _) {}));
      return const CartState(null);
    }
  }

  /// Adds [line] from the restaurant; a line with the same item, options and
  /// note gains its quantity, up to [maxQuantity]. A cart of another
  /// restaurant is left as it is: the screen asks first (CU §10.1), then
  /// calls [startNew].
  Future<CartAdd> add(
    String restaurantId,
    String restaurantName,
    CartLine line,
  ) async {
    final current = await _fresh();
    if (current != null && current.restaurantId != restaurantId) {
      return CartAdd.otherRestaurant;
    }
    final lines = [...?current?.lines];
    final index = lines.indexWhere((l) => l.key == line.key);
    if (index == -1) {
      lines.add(line);
    } else {
      final quantity = lines[index].quantity + line.quantity;
      lines[index] = line.copyWith(
        quantity: quantity > maxQuantity ? maxQuantity : quantity,
      );
    }
    await _save(restaurantId, restaurantName, lines);
    return CartAdd.added;
  }

  /// «سلة جديدة»: empties the cart and starts it with [line].
  Future<void> startNew(
    String restaurantId,
    String restaurantName,
    CartLine line,
  ) => _save(restaurantId, restaurantName, [line]);

  /// «−» and «+»; 0 removes the line.
  Future<void> setQuantity(int index, int quantity) => _change((lines) {
    if (quantity <= 0) {
      lines.removeAt(index);
    } else {
      lines[index] = lines[index].copyWith(
        quantity: quantity > maxQuantity ? maxQuantity : quantity,
      );
    }
  });

  Future<void> remove(int index) => _change((lines) => lines.removeAt(index));

  /// «تعديل»: the item sheet's new choice for the line.
  Future<void> replace(int index, CartLine line) =>
      _change((lines) => lines[index] = line);

  /// «موافق» on «تغيّر سعر…» (CU Appendix C): the customer saw the new price.
  Future<void> acceptPrice(int index, String unitPrice) => _change(
    (lines) => lines[index] = lines[index].copyWith(unitPrice: unitPrice),
  );

  /// After the order is placed (CU §10.7).
  Future<void> clear() async {
    await _store.delete(_cartKey);
    state = const AsyncData(CartState(null));
  }

  Future<Cart?> _fresh() async {
    final cart = (await future).cart;
    if (cart != null && _now().difference(cart.changedAt) > cartLifetime) {
      await _store.delete(_cartKey);
      state = const AsyncData(CartState(null, expired: true));
      return null;
    }
    return cart;
  }

  Future<void> _change(void Function(List<CartLine> lines) change) async {
    final cart = await _fresh();
    if (cart == null) return;
    final lines = [...cart.lines];
    change(lines);
    await _save(cart.restaurantId, cart.restaurantName, lines);
  }

  Future<void> _save(
    String restaurantId,
    String restaurantName,
    List<CartLine> lines,
  ) async {
    if (lines.isEmpty) return clear();
    final cart = Cart(
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      lines: List.unmodifiable(lines),
      changedAt: _now(),
    );
    state = AsyncData(CartState(cart));
    await _store.write(_cartKey, jsonEncode(cart.toJson()));
  }
}

/// A line's quantity is 1 to 20 (CU §9.4, fixed).
const maxQuantity = 20;

final cartProvider = AsyncNotifierProvider<CartController, CartState>(
  CartController.new,
);
