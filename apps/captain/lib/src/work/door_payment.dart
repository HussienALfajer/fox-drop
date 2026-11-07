/// An amount in a currency's minor units, as the API sends it (AP §8.6).
class Money {
  const Money(this.amount, this.currency);

  /// Integer minor units, as a string.
  final String amount;
  final String currency;

  BigInt get minor => BigInt.parse(amount);

  @override
  bool operator ==(Object other) =>
      other is Money && other.amount == amount && other.currency == currency;

  @override
  int get hashCode => Object.hash(amount, currency);

  @override
  String toString() => '$amount $currency';
}

/// A reason from CA Appendix C, with the text of «أخرى».
class Reason {
  const Reason(this.reason, [this.note]);

  /// The reason's code in its Content list, such as `pin_inaccurate`.
  final String reason;
  final String? note;

  String get key => '$reason:${note ?? ''}';
}

/// Minor-unit digits of the currencies the server seeds (`core_l10n`'s
/// table): all three have 2.
const _decimals = 2;

/// An amount typed by the captain («410» or «10.5») in minor units, or null
/// when it is not a positive amount with at most the currency's digits.
String? minorOf(String typed) {
  final text = typed.trim();
  final match = RegExp(r'^(\d{1,13})(?:[.,](\d{1,2}))?$').firstMatch(text);
  if (match == null) return null;
  final fraction = (match[2] ?? '').padRight(_decimals, '0');
  final minor = BigInt.parse('${match[1]}$fraction');
  return minor > BigInt.zero ? minor.toString() : null;
}

/// A minor amount as the captain types it again («41000» is «410»).
String majorOf(String minor) {
  final digits = minor.padLeft(_decimals + 1, '0');
  final whole = digits.substring(0, digits.length - _decimals);
  final fraction = digits.substring(digits.length - _decimals);
  final trimmed = fraction.replaceFirst(RegExp(r'0+$'), '');
  return trimmed.isEmpty ? whole : '$whole.$trimmed';
}

/// The amount due in each accepted currency (CA §9.7 item 1): the order's
/// total, then its equivalents, the customer's pay-in currency first (CU
/// U10), for the buttons that fill the exact amount.
List<Money> dueIn(Money total, List<Money> equivalents, String? payIn) {
  final all = [
    total,
    ...equivalents.where((e) => e.currency != total.currency),
  ];
  if (payIn == null) return all;
  return [
    ...all.where((m) => m.currency == payIn),
    ...all.where((m) => m.currency != payIn),
  ];
}

/// The change the customer is due in the base currency (CA §9.7 item 3),
/// when everything was received in it: the received amount less the amount
/// due. Null for money in another currency, which the app cannot convert
/// without the order's rates: the captain records the change and the server
/// checks it.
Money? changeDue(List<Money> received, Money amountDue) {
  if (received.isEmpty) return null;
  if (received.any((line) => line.currency != amountDue.currency)) {
    return null;
  }
  final paid = received.fold(BigInt.zero, (sum, line) => sum + line.minor);
  return Money((paid - amountDue.minor).toString(), amountDue.currency);
}

/// The door payment the captain records (CA §9.7).
class DoorPayment {
  const DoorPayment({
    required this.received,
    required this.change,
    required this.amountDue,
    this.shortfall,
  });

  final List<Money> received;
  final List<Money> change;

  /// The amount due the screen showed (the order's total).
  final Money amountDue;
  final Reason? shortfall;

  /// The command's body for its idempotency key.
  String get key =>
      '${received.join(',')}|${change.join(',')}|$amountDue|${shortfall?.key}';
}
