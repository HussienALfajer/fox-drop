// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_account_dto_output_pickups_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantAccountDtoOutputPickupsInner
    extends MerchantAccountDtoOutputPickupsInner {
  @override
  final String orderId;
  @override
  final String orderNumber;
  @override
  final DateTime at;
  @override
  final String? captainName;
  @override
  final String amount;
  @override
  final BuiltList<MerchantAccountDtoOutputPickupsInnerLinesInner> lines;

  factory _$MerchantAccountDtoOutputPickupsInner([
    void Function(MerchantAccountDtoOutputPickupsInnerBuilder)? updates,
  ]) =>
      (MerchantAccountDtoOutputPickupsInnerBuilder()..update(updates))._build();

  _$MerchantAccountDtoOutputPickupsInner._({
    required this.orderId,
    required this.orderNumber,
    required this.at,
    this.captainName,
    required this.amount,
    required this.lines,
  }) : super._();
  @override
  MerchantAccountDtoOutputPickupsInner rebuild(
    void Function(MerchantAccountDtoOutputPickupsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantAccountDtoOutputPickupsInnerBuilder toBuilder() =>
      MerchantAccountDtoOutputPickupsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantAccountDtoOutputPickupsInner &&
        orderId == other.orderId &&
        orderNumber == other.orderNumber &&
        at == other.at &&
        captainName == other.captainName &&
        amount == other.amount &&
        lines == other.lines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, captainName.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantAccountDtoOutputPickupsInner')
          ..add('orderId', orderId)
          ..add('orderNumber', orderNumber)
          ..add('at', at)
          ..add('captainName', captainName)
          ..add('amount', amount)
          ..add('lines', lines))
        .toString();
  }
}

class MerchantAccountDtoOutputPickupsInnerBuilder
    implements
        Builder<
          MerchantAccountDtoOutputPickupsInner,
          MerchantAccountDtoOutputPickupsInnerBuilder
        > {
  _$MerchantAccountDtoOutputPickupsInner? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _captainName;
  String? get captainName => _$this._captainName;
  set captainName(String? captainName) => _$this._captainName = captainName;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  ListBuilder<MerchantAccountDtoOutputPickupsInnerLinesInner>? _lines;
  ListBuilder<MerchantAccountDtoOutputPickupsInnerLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<MerchantAccountDtoOutputPickupsInnerLinesInner>();
  set lines(
    ListBuilder<MerchantAccountDtoOutputPickupsInnerLinesInner>? lines,
  ) => _$this._lines = lines;

  MerchantAccountDtoOutputPickupsInnerBuilder() {
    MerchantAccountDtoOutputPickupsInner._defaults(this);
  }

  MerchantAccountDtoOutputPickupsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _orderNumber = $v.orderNumber;
      _at = $v.at;
      _captainName = $v.captainName;
      _amount = $v.amount;
      _lines = $v.lines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantAccountDtoOutputPickupsInner other) {
    _$v = other as _$MerchantAccountDtoOutputPickupsInner;
  }

  @override
  void update(
    void Function(MerchantAccountDtoOutputPickupsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantAccountDtoOutputPickupsInner build() => _build();

  _$MerchantAccountDtoOutputPickupsInner _build() {
    _$MerchantAccountDtoOutputPickupsInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantAccountDtoOutputPickupsInner._(
            orderId: BuiltValueNullFieldError.checkNotNull(
              orderId,
              r'MerchantAccountDtoOutputPickupsInner',
              'orderId',
            ),
            orderNumber: BuiltValueNullFieldError.checkNotNull(
              orderNumber,
              r'MerchantAccountDtoOutputPickupsInner',
              'orderNumber',
            ),
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'MerchantAccountDtoOutputPickupsInner',
              'at',
            ),
            captainName: captainName,
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'MerchantAccountDtoOutputPickupsInner',
              'amount',
            ),
            lines: lines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantAccountDtoOutputPickupsInner',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
