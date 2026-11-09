// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_dto_output_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteDtoOutputLinesInner
    extends CustomerQuoteDtoOutputLinesInner {
  @override
  final String itemId;
  @override
  final String? name;
  @override
  final int quantity;
  @override
  final String? note;
  @override
  final BuiltList<CustomerQuoteDtoOutputLinesInnerOptionsInner> options;
  @override
  final String? unitPrice;
  @override
  final String? lineTotal;

  factory _$CustomerQuoteDtoOutputLinesInner([
    void Function(CustomerQuoteDtoOutputLinesInnerBuilder)? updates,
  ]) => (CustomerQuoteDtoOutputLinesInnerBuilder()..update(updates))._build();

  _$CustomerQuoteDtoOutputLinesInner._({
    required this.itemId,
    this.name,
    required this.quantity,
    this.note,
    required this.options,
    this.unitPrice,
    this.lineTotal,
  }) : super._();
  @override
  CustomerQuoteDtoOutputLinesInner rebuild(
    void Function(CustomerQuoteDtoOutputLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteDtoOutputLinesInnerBuilder toBuilder() =>
      CustomerQuoteDtoOutputLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteDtoOutputLinesInner &&
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
    return (newBuiltValueToStringHelper(r'CustomerQuoteDtoOutputLinesInner')
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

class CustomerQuoteDtoOutputLinesInnerBuilder
    implements
        Builder<
          CustomerQuoteDtoOutputLinesInner,
          CustomerQuoteDtoOutputLinesInnerBuilder
        > {
  _$CustomerQuoteDtoOutputLinesInner? _$v;

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

  CustomerQuoteDtoOutputLinesInnerBuilder() {
    CustomerQuoteDtoOutputLinesInner._defaults(this);
  }

  CustomerQuoteDtoOutputLinesInnerBuilder get _$this {
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
  void replace(CustomerQuoteDtoOutputLinesInner other) {
    _$v = other as _$CustomerQuoteDtoOutputLinesInner;
  }

  @override
  void update(void Function(CustomerQuoteDtoOutputLinesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteDtoOutputLinesInner build() => _build();

  _$CustomerQuoteDtoOutputLinesInner _build() {
    _$CustomerQuoteDtoOutputLinesInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerQuoteDtoOutputLinesInner._(
            itemId: BuiltValueNullFieldError.checkNotNull(
              itemId,
              r'CustomerQuoteDtoOutputLinesInner',
              'itemId',
            ),
            name: name,
            quantity: BuiltValueNullFieldError.checkNotNull(
              quantity,
              r'CustomerQuoteDtoOutputLinesInner',
              'quantity',
            ),
            note: note,
            options: options.build(),
            unitPrice: unitPrice,
            lineTotal: lineTotal,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerQuoteDtoOutputLinesInner',
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
