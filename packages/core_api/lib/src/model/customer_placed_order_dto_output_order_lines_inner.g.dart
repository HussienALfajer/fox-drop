// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_placed_order_dto_output_order_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerPlacedOrderDtoOutputOrderLinesInner
    extends CustomerPlacedOrderDtoOutputOrderLinesInner {
  @override
  final String itemId;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final String? note;
  @override
  final BuiltList<CustomerQuoteDtoOutputLinesInnerOptionsInner> options;
  @override
  final String unitPrice;
  @override
  final String lineTotal;

  factory _$CustomerPlacedOrderDtoOutputOrderLinesInner([
    void Function(CustomerPlacedOrderDtoOutputOrderLinesInnerBuilder)? updates,
  ]) => (CustomerPlacedOrderDtoOutputOrderLinesInnerBuilder()..update(updates))
      ._build();

  _$CustomerPlacedOrderDtoOutputOrderLinesInner._({
    required this.itemId,
    required this.name,
    required this.quantity,
    this.note,
    required this.options,
    required this.unitPrice,
    required this.lineTotal,
  }) : super._();
  @override
  CustomerPlacedOrderDtoOutputOrderLinesInner rebuild(
    void Function(CustomerPlacedOrderDtoOutputOrderLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerPlacedOrderDtoOutputOrderLinesInnerBuilder toBuilder() =>
      CustomerPlacedOrderDtoOutputOrderLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerPlacedOrderDtoOutputOrderLinesInner &&
        itemId == other.itemId &&
        name == other.name &&
        quantity == other.quantity &&
        note == other.note &&
        options == other.options &&
        unitPrice == other.unitPrice &&
        lineTotal == other.lineTotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, unitPrice.hashCode);
    _$hash = $jc(_$hash, lineTotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerPlacedOrderDtoOutputOrderLinesInner',
          )
          ..add('itemId', itemId)
          ..add('name', name)
          ..add('quantity', quantity)
          ..add('note', note)
          ..add('options', options)
          ..add('unitPrice', unitPrice)
          ..add('lineTotal', lineTotal))
        .toString();
  }
}

class CustomerPlacedOrderDtoOutputOrderLinesInnerBuilder
    implements
        Builder<
          CustomerPlacedOrderDtoOutputOrderLinesInner,
          CustomerPlacedOrderDtoOutputOrderLinesInnerBuilder
        > {
  _$CustomerPlacedOrderDtoOutputOrderLinesInner? _$v;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  ListBuilder<CustomerQuoteDtoOutputLinesInnerOptionsInner>? _options;
  ListBuilder<CustomerQuoteDtoOutputLinesInnerOptionsInner> get options =>
      _$this._options ??=
          ListBuilder<CustomerQuoteDtoOutputLinesInnerOptionsInner>();
  set options(
    ListBuilder<CustomerQuoteDtoOutputLinesInnerOptionsInner>? options,
  ) => _$this._options = options;

  String? _unitPrice;
  String? get unitPrice => _$this._unitPrice;
  set unitPrice(String? unitPrice) => _$this._unitPrice = unitPrice;

  String? _lineTotal;
  String? get lineTotal => _$this._lineTotal;
  set lineTotal(String? lineTotal) => _$this._lineTotal = lineTotal;

  CustomerPlacedOrderDtoOutputOrderLinesInnerBuilder() {
    CustomerPlacedOrderDtoOutputOrderLinesInner._defaults(this);
  }

  CustomerPlacedOrderDtoOutputOrderLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _name = $v.name;
      _quantity = $v.quantity;
      _note = $v.note;
      _options = $v.options.toBuilder();
      _unitPrice = $v.unitPrice;
      _lineTotal = $v.lineTotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerPlacedOrderDtoOutputOrderLinesInner other) {
    _$v = other as _$CustomerPlacedOrderDtoOutputOrderLinesInner;
  }

  @override
  void update(
    void Function(CustomerPlacedOrderDtoOutputOrderLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerPlacedOrderDtoOutputOrderLinesInner build() => _build();

  _$CustomerPlacedOrderDtoOutputOrderLinesInner _build() {
    _$CustomerPlacedOrderDtoOutputOrderLinesInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerPlacedOrderDtoOutputOrderLinesInner._(
            itemId: BuiltValueNullFieldError.checkNotNull(
              itemId,
              r'CustomerPlacedOrderDtoOutputOrderLinesInner',
              'itemId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CustomerPlacedOrderDtoOutputOrderLinesInner',
              'name',
            ),
            quantity: BuiltValueNullFieldError.checkNotNull(
              quantity,
              r'CustomerPlacedOrderDtoOutputOrderLinesInner',
              'quantity',
            ),
            note: note,
            options: options.build(),
            unitPrice: BuiltValueNullFieldError.checkNotNull(
              unitPrice,
              r'CustomerPlacedOrderDtoOutputOrderLinesInner',
              'unitPrice',
            ),
            lineTotal: BuiltValueNullFieldError.checkNotNull(
              lineTotal,
              r'CustomerPlacedOrderDtoOutputOrderLinesInner',
              'lineTotal',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerPlacedOrderDtoOutputOrderLinesInner',
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
