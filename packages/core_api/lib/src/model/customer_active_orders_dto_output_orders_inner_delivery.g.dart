// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_delivery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerDelivery
    extends CustomerActiveOrdersDtoOutputOrdersInnerDelivery {
  @override
  final DateTime at;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> received;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> change;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerDelivery([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerDelivery._({
    required this.at,
    required this.received,
    required this.change,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerDelivery rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerDelivery &&
        at == other.at &&
        received == other.received &&
        change == other.change;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jc(_$hash, change.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerDelivery',
          )
          ..add('at', at)
          ..add('received', received)
          ..add('change', change))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerDelivery,
          CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerDelivery? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _received;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get received =>
      _$this._received ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set received(ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? received) =>
      _$this._received = received;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _change;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get change =>
      _$this._change ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set change(ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? change) =>
      _$this._change = change;

  CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerDelivery._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _received = $v.received.toBuilder();
      _change = $v.change.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerDelivery other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerDelivery;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerDeliveryBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerDelivery build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerDelivery _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInnerDelivery _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInnerDelivery._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CustomerActiveOrdersDtoOutputOrdersInnerDelivery',
              'at',
            ),
            received: received.build(),
            change: change.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'received';
        received.build();
        _$failedField = 'change';
        change.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerActiveOrdersDtoOutputOrdersInnerDelivery',
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
