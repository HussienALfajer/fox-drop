// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_report_order_dto_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerReportOrderDtoItemsInner
    extends CustomerReportOrderDtoItemsInner {
  @override
  final int position;
  @override
  final int quantity;

  factory _$CustomerReportOrderDtoItemsInner([
    void Function(CustomerReportOrderDtoItemsInnerBuilder)? updates,
  ]) => (CustomerReportOrderDtoItemsInnerBuilder()..update(updates))._build();

  _$CustomerReportOrderDtoItemsInner._({
    required this.position,
    required this.quantity,
  }) : super._();
  @override
  CustomerReportOrderDtoItemsInner rebuild(
    void Function(CustomerReportOrderDtoItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerReportOrderDtoItemsInnerBuilder toBuilder() =>
      CustomerReportOrderDtoItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerReportOrderDtoItemsInner &&
        position == other.position &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, position.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerReportOrderDtoItemsInner')
          ..add('position', position)
          ..add('quantity', quantity))
        .toString();
  }
}

class CustomerReportOrderDtoItemsInnerBuilder
    implements
        Builder<
          CustomerReportOrderDtoItemsInner,
          CustomerReportOrderDtoItemsInnerBuilder
        > {
  _$CustomerReportOrderDtoItemsInner? _$v;

  int? _position;
  int? get position => _$this._position;
  set position(int? position) => _$this._position = position;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  CustomerReportOrderDtoItemsInnerBuilder() {
    CustomerReportOrderDtoItemsInner._defaults(this);
  }

  CustomerReportOrderDtoItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _position = $v.position;
      _quantity = $v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerReportOrderDtoItemsInner other) {
    _$v = other as _$CustomerReportOrderDtoItemsInner;
  }

  @override
  void update(void Function(CustomerReportOrderDtoItemsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerReportOrderDtoItemsInner build() => _build();

  _$CustomerReportOrderDtoItemsInner _build() {
    final _$result =
        _$v ??
        _$CustomerReportOrderDtoItemsInner._(
          position: BuiltValueNullFieldError.checkNotNull(
            position,
            r'CustomerReportOrderDtoItemsInner',
            'position',
          ),
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'CustomerReportOrderDtoItemsInner',
            'quantity',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
