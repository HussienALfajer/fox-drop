// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_order_dto_output_order_delivery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerOrderDtoOutputOrderDelivery
    extends CustomerOrderDtoOutputOrderDelivery {
  @override
  final DateTime at;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> received;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> change;

  factory _$CustomerOrderDtoOutputOrderDelivery([
    void Function(CustomerOrderDtoOutputOrderDeliveryBuilder)? updates,
  ]) =>
      (CustomerOrderDtoOutputOrderDeliveryBuilder()..update(updates))._build();

  _$CustomerOrderDtoOutputOrderDelivery._({
    required this.at,
    required this.received,
    required this.change,
  }) : super._();
  @override
  CustomerOrderDtoOutputOrderDelivery rebuild(
    void Function(CustomerOrderDtoOutputOrderDeliveryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerOrderDtoOutputOrderDeliveryBuilder toBuilder() =>
      CustomerOrderDtoOutputOrderDeliveryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerOrderDtoOutputOrderDelivery &&
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
    return (newBuiltValueToStringHelper(r'CustomerOrderDtoOutputOrderDelivery')
          ..add('at', at)
          ..add('received', received)
          ..add('change', change))
        .toString();
  }
}

class CustomerOrderDtoOutputOrderDeliveryBuilder
    implements
        Builder<
          CustomerOrderDtoOutputOrderDelivery,
          CustomerOrderDtoOutputOrderDeliveryBuilder
        > {
  _$CustomerOrderDtoOutputOrderDelivery? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? _received;
  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit> get received =>
      _$this._received ??=
          ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>();
  set received(
    ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? received,
  ) => _$this._received = received;

  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? _change;
  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit> get change =>
      _$this._change ??=
          ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>();
  set change(ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? change) =>
      _$this._change = change;

  CustomerOrderDtoOutputOrderDeliveryBuilder() {
    CustomerOrderDtoOutputOrderDelivery._defaults(this);
  }

  CustomerOrderDtoOutputOrderDeliveryBuilder get _$this {
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
  void replace(CustomerOrderDtoOutputOrderDelivery other) {
    _$v = other as _$CustomerOrderDtoOutputOrderDelivery;
  }

  @override
  void update(
    void Function(CustomerOrderDtoOutputOrderDeliveryBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerOrderDtoOutputOrderDelivery build() => _build();

  _$CustomerOrderDtoOutputOrderDelivery _build() {
    _$CustomerOrderDtoOutputOrderDelivery _$result;
    try {
      _$result =
          _$v ??
          _$CustomerOrderDtoOutputOrderDelivery._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'CustomerOrderDtoOutputOrderDelivery',
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
          r'CustomerOrderDtoOutputOrderDelivery',
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
