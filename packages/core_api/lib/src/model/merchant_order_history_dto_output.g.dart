// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_order_history_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrderHistoryDtoOutput extends MerchantOrderHistoryDtoOutput {
  @override
  final bool owner;
  @override
  final Date fromDay;
  @override
  final Date toDay;
  @override
  final BuiltList<MerchantOrderHistoryDtoOutputOrdersInner> orders;
  @override
  final String? next;

  factory _$MerchantOrderHistoryDtoOutput([
    void Function(MerchantOrderHistoryDtoOutputBuilder)? updates,
  ]) => (MerchantOrderHistoryDtoOutputBuilder()..update(updates))._build();

  _$MerchantOrderHistoryDtoOutput._({
    required this.owner,
    required this.fromDay,
    required this.toDay,
    required this.orders,
    this.next,
  }) : super._();
  @override
  MerchantOrderHistoryDtoOutput rebuild(
    void Function(MerchantOrderHistoryDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrderHistoryDtoOutputBuilder toBuilder() =>
      MerchantOrderHistoryDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrderHistoryDtoOutput &&
        owner == other.owner &&
        fromDay == other.fromDay &&
        toDay == other.toDay &&
        orders == other.orders &&
        next == other.next;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, owner.hashCode);
    _$hash = $jc(_$hash, fromDay.hashCode);
    _$hash = $jc(_$hash, toDay.hashCode);
    _$hash = $jc(_$hash, orders.hashCode);
    _$hash = $jc(_$hash, next.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantOrderHistoryDtoOutput')
          ..add('owner', owner)
          ..add('fromDay', fromDay)
          ..add('toDay', toDay)
          ..add('orders', orders)
          ..add('next', next))
        .toString();
  }
}

class MerchantOrderHistoryDtoOutputBuilder
    implements
        Builder<
          MerchantOrderHistoryDtoOutput,
          MerchantOrderHistoryDtoOutputBuilder
        > {
  _$MerchantOrderHistoryDtoOutput? _$v;

  bool? _owner;
  bool? get owner => _$this._owner;
  set owner(bool? owner) => _$this._owner = owner;

  Date? _fromDay;
  Date? get fromDay => _$this._fromDay;
  set fromDay(Date? fromDay) => _$this._fromDay = fromDay;

  Date? _toDay;
  Date? get toDay => _$this._toDay;
  set toDay(Date? toDay) => _$this._toDay = toDay;

  ListBuilder<MerchantOrderHistoryDtoOutputOrdersInner>? _orders;
  ListBuilder<MerchantOrderHistoryDtoOutputOrdersInner> get orders =>
      _$this._orders ??=
          ListBuilder<MerchantOrderHistoryDtoOutputOrdersInner>();
  set orders(ListBuilder<MerchantOrderHistoryDtoOutputOrdersInner>? orders) =>
      _$this._orders = orders;

  String? _next;
  String? get next => _$this._next;
  set next(String? next) => _$this._next = next;

  MerchantOrderHistoryDtoOutputBuilder() {
    MerchantOrderHistoryDtoOutput._defaults(this);
  }

  MerchantOrderHistoryDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _owner = $v.owner;
      _fromDay = $v.fromDay;
      _toDay = $v.toDay;
      _orders = $v.orders.toBuilder();
      _next = $v.next;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrderHistoryDtoOutput other) {
    _$v = other as _$MerchantOrderHistoryDtoOutput;
  }

  @override
  void update(void Function(MerchantOrderHistoryDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrderHistoryDtoOutput build() => _build();

  _$MerchantOrderHistoryDtoOutput _build() {
    _$MerchantOrderHistoryDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrderHistoryDtoOutput._(
            owner: BuiltValueNullFieldError.checkNotNull(
              owner,
              r'MerchantOrderHistoryDtoOutput',
              'owner',
            ),
            fromDay: BuiltValueNullFieldError.checkNotNull(
              fromDay,
              r'MerchantOrderHistoryDtoOutput',
              'fromDay',
            ),
            toDay: BuiltValueNullFieldError.checkNotNull(
              toDay,
              r'MerchantOrderHistoryDtoOutput',
              'toDay',
            ),
            orders: orders.build(),
            next: next,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrderHistoryDtoOutput',
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
