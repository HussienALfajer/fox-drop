import 'package:core_api/core_api.dart';
import 'package:core_storage/core_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api.dart';
import '../auth.dart';
import '../cart/cart.dart';
import '../device.dart';
import '../location/delivery_point.dart';

typedef Quote = CustomerQuoteDtoOutput;
typedef QuoteProblem = CustomerQuoteDtoOutputProblemsInner;
typedef ProblemCode = CustomerQuoteDtoOutputProblemsInnerCodeEnum;

const _payInKey = 'checkout.pay_in';

/// «سأدفع بـ» (CU §10.5): a currency code, or null for «لم أحدد», the
/// default. The app remembers the last choice on the device.
class PayInController extends AsyncNotifier<String?> {
  DeviceStore get _store => ref.read(deviceStoreProvider);

  @override
  Future<String?> build() async {
    try {
      return await _store.read(_payInKey);
    } on Object {
      return null;
    }
  }

  Future<void> choose(String? currency) async {
    state = AsyncData(currency);
    try {
      if (currency == null) {
        await _store.delete(_payInKey);
      } else {
        await _store.write(_payInKey, currency);
      }
    } on Object {
      // Remembered for this run only.
    }
  }
}

final payInProvider = AsyncNotifierProvider<PayInController, String?>(
  PayInController.new,
);

/// The cart lines as the quote and the order command take them.
List<CustomerQuoteRequestDtoLinesInner> requestLines(Cart cart) => [
  for (final line in cart.lines)
    CustomerQuoteRequestDtoLinesInner(
      (b) => b
        ..itemId = line.itemId
        ..optionIds.replace(line.optionIds)
        ..quantity = line.quantity
        ..note = line.note
        ..knownUnitPrice = line.unitPrice,
    ),
];

/// Whether the next quote is the one asked on opening checkout: a
/// signed-in customer who opens checkout during an emergency stop counts
/// once per stop as an attempt (CU §4.7, AP §9.1.6). Marked by checkout as
/// it opens, taken by the next quote that sends a request. A plain holder, not state:
/// marking it rebuilds nothing.
class CheckoutOpening {
  bool _pending = false;

  void mark() => _pending = true;

  /// Checkout closed before any quote was sent: a later one is not it.
  void clear() => _pending = false;

  bool take() {
    final pending = _pending;
    _pending = false;
    return pending;
  }
}

final checkoutOpeningProvider = Provider<CheckoutOpening>(
  (ref) => CheckoutOpening(),
);

/// The quote of the cart at the delivery point (CU §10.6): asked again
/// whenever the cart, the point or «سأدفع بـ» changes, and on opening the
/// cart or checkout, and after sign-in, so a signed-in customer's quote
/// checks their active orders (CU §5.1). Null while the cart is empty or no
/// point is checked.
final quoteProvider = FutureProvider.autoDispose<Quote?>((ref) async {
  await ref.watch(customerAuth.session.future);
  final cart = (await ref.watch(cartProvider.future)).cart;
  final point = ref.watch(deliveryPointProvider);
  final payIn = await ref.watch(payInProvider.future);
  if (cart == null || point is! PointChecked) return null;
  // Taken right before the request, so a run that returns early or is
  // superseded during its waits leaves it to the next one.
  final openedCheckout = ref.read(checkoutOpeningProvider).take();
  final response = await ref
      .watch(coreApiProvider)
      .getCustomerApi()
      .customerQuoteQuote(
        customerQuoteRequestDto: CustomerQuoteRequestDto(
          (b) => b
            ..restaurantId = cart.restaurantId
            ..location.latitude = point.point.latitude
            ..location.longitude = point.point.longitude
            ..lines.replace(requestLines(cart))
            ..payIn = payIn
            ..appVersion = appVersion
            ..openedCheckout = openedCheckout,
        ),
      );
  return response.data!;
});
