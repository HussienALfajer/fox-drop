// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInner
    extends CustomerActiveOrdersDtoOutputOrdersInnerLinesInner {
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
  @override
  final bool added;
  @override
  final int? quantityBefore;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInner([
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder)?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInner._({
    required this.itemId,
    required this.name,
    required this.quantity,
    this.note,
    required this.options,
    required this.unitPrice,
    required this.lineTotal,
    required this.added,
    this.quantityBefore,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLinesInner rebuild(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerLinesInner &&
        itemId == other.itemId &&
        name == other.name &&
        quantity == other.quantity &&
        note == other.note &&
        options == other.options &&
        unitPrice == other.unitPrice &&
        lineTotal == other.lineTotal &&
        added == other.added &&
        quantityBefore == other.quantityBefore;
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
    _$hash = $jc(_$hash, added.hashCode);
    _$hash = $jc(_$hash, quantityBefore.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerLinesInner',
          )
          ..add('itemId', itemId)
          ..add('name', name)
          ..add('quantity', quantity)
          ..add('note', note)
          ..add('options', options)
          ..add('unitPrice', unitPrice)
          ..add('lineTotal', lineTotal)
          ..add('added', added)
          ..add('quantityBefore', quantityBefore))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerLinesInner,
          CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInner? _$v;

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

  bool? _added;
  bool? get added => _$this._added;
  set added(bool? added) => _$this._added = added;

  int? _quantityBefore;
  int? get quantityBefore => _$this._quantityBefore;
  set quantityBefore(int? quantityBefore) =>
      _$this._quantityBefore = quantityBefore;

  CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerLinesInner._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _name = $v.name;
      _quantity = $v.quantity;
      _note = $v.note;
      _options = $v.options.toBuilder();
      _unitPrice = $v.unitPrice;
      _lineTotal = $v.lineTotal;
      _added = $v.added;
      _quantityBefore = $v.quantityBefore;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerActiveOrdersDtoOutputOrdersInnerLinesInner other) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInner;
  }

  @override
  void update(
    void Function(CustomerActiveOrdersDtoOutputOrdersInnerLinesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLinesInner build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInner _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInnerLinesInner._(
            itemId: BuiltValueNullFieldError.checkNotNull(
              itemId,
              r'CustomerActiveOrdersDtoOutputOrdersInnerLinesInner',
              'itemId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CustomerActiveOrdersDtoOutputOrdersInnerLinesInner',
              'name',
            ),
            quantity: BuiltValueNullFieldError.checkNotNull(
              quantity,
              r'CustomerActiveOrdersDtoOutputOrdersInnerLinesInner',
              'quantity',
            ),
            note: note,
            options: options.build(),
            unitPrice: BuiltValueNullFieldError.checkNotNull(
              unitPrice,
              r'CustomerActiveOrdersDtoOutputOrdersInnerLinesInner',
              'unitPrice',
            ),
            lineTotal: BuiltValueNullFieldError.checkNotNull(
              lineTotal,
              r'CustomerActiveOrdersDtoOutputOrdersInnerLinesInner',
              'lineTotal',
            ),
            added: BuiltValueNullFieldError.checkNotNull(
              added,
              r'CustomerActiveOrdersDtoOutputOrdersInnerLinesInner',
              'added',
            ),
            quantityBefore: quantityBefore,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerActiveOrdersDtoOutputOrdersInnerLinesInner',
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
