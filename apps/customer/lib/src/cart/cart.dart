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

  /// Lines with this key are one line: the same item, options and note.
  String get key => jsonEncode([
    itemId,
    [...optionIds]..sort(),
    note,
  ]);

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
    this.code,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
    restaurantId: json['restaurantId'] as String,
    restaurantName: json['restaurantName'] as String,
    lines: [
      for (final line in json['lines'] as List)
        CartLine.fromJson(line as Map<String, dynamic>),
    ],
    changedAt: DateTime.parse(json['changedAt'] as String),
    code: json['code'] as String?,
  );

  final String restaurantId;
  final String restaurantName;
  final List<CartLine> lines;
  final DateTime changedAt;

  /// The order's code (CU §10.4), as the customer typed it, sent with every
  /// quote and the order command; null without one. One code per order.
  final String? code;

  Map<String, dynamic> toJson() => {
    'restaurantId': restaurantId,
    'restaurantName': restaurantName,
    'lines': [for (final line in lines) line.toJson()],
    'changedAt': changedAt.toUtc().toIso8601String(),
    'code': code,
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
    await _save(restaurantId, restaurantName, lines, code: current?.code);
    return CartAdd.added;
  }

  /// «سلة جديدة»: empties the cart and starts it with [line].
  Future<void> startNew(
    String restaurantId,
    String restaurantName,
    CartLine line,
  ) => _save(restaurantId, restaurantName, [line]);

  /// The cart rebuilt from an order (CU §11.9, §12.3), replacing whatever
  /// it held: the screen asks first when it is not empty.
  Future<void> replaceWith(
    String restaurantId,
    String restaurantName,
    List<CartLine> lines,
  ) => _save(restaurantId, restaurantName, lines);

  /// «−» and «+»; 0 removes the line.
  Future<void> setQuantity(int index, int quantity) => _change((lines) {
    if (index >= lines.length) return;
    if (quantity <= 0) {
      lines.removeAt(index);
    } else {
      lines[index] = lines[index].copyWith(
        quantity: quantity > maxQuantity ? maxQuantity : quantity,
      );
    }
  });

  Future<void> remove(int index) => _change((lines) {
    if (index < lines.length) lines.removeAt(index);
  });

  /// «تعديل»: the item sheet's new choice for the line. A choice that
  /// matches another line joins it (CU §9.4).
  Future<void> replace(int index, CartLine line) => _change((lines) {
    if (index >= lines.length) return;
    final other = lines.indexWhere((l) => l.key == line.key);
    if (other == -1 || other == index) {
      lines[index] = line;
      return;
    }
    final quantity = lines[other].quantity + line.quantity;
    lines[other] = lines[other].copyWith(
      quantity: quantity > maxQuantity ? maxQuantity : quantity,
    );
    lines.removeAt(index);
  });

  /// «حذف» on a problem: the line with [key], if it is still in the cart.
  Future<void> removeKey(String key) =>
      _change((lines) => lines.removeWhere((l) => l.key == key));

  /// «موافق» on «تغيّر سعر…» (CU Appendix C): the customer saw the new price
  /// of the line with [key], if it is still in the cart.
  Future<void> acceptPrice(String key, String unitPrice) => _change((lines) {
    final index = lines.indexWhere((l) => l.key == key);
    if (index != -1) {
      lines[index] = lines[index].copyWith(unitPrice: unitPrice);
    }
  });

  /// «تطبيق» (CU §10.4): the code for the order, trimmed and with Western
  /// digits (AP §4.7); the server checks it with every quote. Null is
  /// «إزالة».
  Future<void> setCode(String? code) async {
    final cart = await _fresh();
    if (cart == null) return;
    final trimmed = code == null ? null : _westernDigits(code).trim();
    await _save(
      cart.restaurantId,
      cart.restaurantName,
      cart.lines,
      code: trimmed == null || trimmed.isEmpty ? null : trimmed,
    );
  }

  /// After the order is placed (CU §10.7).
  Future<void> clear() async {
    await _store.delete(_cartKey);
    state = const AsyncData(CartState(null));
  }

  /// The cart, emptied first when it is older than [cartLifetime] (CU
  /// §10.1): checkout and the order command read it through this.
  Future<Cart?> current() => _fresh();

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
    await _save(cart.restaurantId, cart.restaurantName, lines, code: cart.code);
  }

  /// A new cart ([startNew], [replaceWith]) starts without a code.
  Future<void> _save(
    String restaurantId,
    String restaurantName,
    List<CartLine> lines, {
    String? code,
  }) async {
    if (lines.isEmpty) return clear();
    final cart = Cart(
      restaurantId: restaurantId,
      restaurantName: restaurantName,
      lines: List.unmodifiable(lines),
      changedAt: _now(),
      code: code,
    );
    state = AsyncData(CartState(cart));
    await _store.write(_cartKey, jsonEncode(cart.toJson()));
  }
}

/// [text] with Arabic-Indic and Persian digits as Western ones (AP §4.7),
/// every other character kept.
String _westernDigits(String text) => String.fromCharCodes(
  text.runes.map(
    (c) => c >= 0x0660 && c <= 0x0669
        ? c - 0x0660 + 0x30
        : c >= 0x06F0 && c <= 0x06F9
        ? c - 0x06F0 + 0x30
        : c,
  ),
);

/// The longest code the quote takes (the server's `promoCodeInput`).
const maxCodeLength = 40;

/// A line's quantity is 1 to 20 (CU §9.4, fixed).
const maxQuantity = 20;

final cartProvider = AsyncNotifierProvider<CartController, CartState>(
  CartController.new,
);
