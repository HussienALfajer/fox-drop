// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_request_dto_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteRequestDtoLinesInner
    extends CustomerQuoteRequestDtoLinesInner {
  @override
  final String itemId;
  @override
  final BuiltList<String> optionIds;
  @override
  final int quantity;
  @override
  final String? note;
  @override
  final String knownUnitPrice;

  factory _$CustomerQuoteRequestDtoLinesInner([
    void Function(CustomerQuoteRequestDtoLinesInnerBuilder)? updates,
  ]) => (CustomerQuoteRequestDtoLinesInnerBuilder()..update(updates))._build();

  _$CustomerQuoteRequestDtoLinesInner._({
    required this.itemId,
    required this.optionIds,
    required this.quantity,
    this.note,
    required this.knownUnitPrice,
  }) : super._();
  @override
  CustomerQuoteRequestDtoLinesInner rebuild(
    void Function(CustomerQuoteRequestDtoLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteRequestDtoLinesInnerBuilder toBuilder() =>
      CustomerQuoteRequestDtoLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteRequestDtoLinesInner &&
        itemId == other.itemId &&
        optionIds == other.optionIds &&
        quantity == other.quantity &&
        note == other.note &&
        knownUnitPrice == other.knownUnitPrice;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, optionIds.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, knownUnitPrice.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerQuoteRequestDtoLinesInner')
          ..add('itemId', itemId)
          ..add('optionIds', optionIds)
          ..add('quantity', quantity)
          ..add('note', note)
          ..add('knownUnitPrice', knownUnitPrice))
        .toString();
  }
}

class CustomerQuoteRequestDtoLinesInnerBuilder
    implements
        Builder<
          CustomerQuoteRequestDtoLinesInner,
          CustomerQuoteRequestDtoLinesInnerBuilder
        > {
  _$CustomerQuoteRequestDtoLinesInner? _$v;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  ListBuilder<String>? _optionIds;
  ListBuilder<String> get optionIds =>
      _$this._optionIds ??= ListBuilder<String>();
  set optionIds(ListBuilder<String>? optionIds) =>
      _$this._optionIds = optionIds;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _knownUnitPrice;
  String? get knownUnitPrice => _$this._knownUnitPrice;
  set knownUnitPrice(String? knownUnitPrice) =>
      _$this._knownUnitPrice = knownUnitPrice;

  CustomerQuoteRequestDtoLinesInnerBuilder() {
    CustomerQuoteRequestDtoLinesInner._defaults(this);
  }

  CustomerQuoteRequestDtoLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _optionIds = $v.optionIds.toBuilder();
      _quantity = $v.quantity;
      _note = $v.note;
      _knownUnitPrice = $v.knownUnitPrice;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteRequestDtoLinesInner other) {
    _$v = other as _$CustomerQuoteRequestDtoLinesInner;
  }

  @override
  void update(
    void Function(CustomerQuoteRequestDtoLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteRequestDtoLinesInner build() => _build();

  _$CustomerQuoteRequestDtoLinesInner _build() {
    _$CustomerQuoteRequestDtoLinesInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerQuoteRequestDtoLinesInner._(
            itemId: BuiltValueNullFieldError.checkNotNull(
              itemId,
              r'CustomerQuoteRequestDtoLinesInner',
              'itemId',
            ),
            optionIds: optionIds.build(),
            quantity: BuiltValueNullFieldError.checkNotNull(
              quantity,
              r'CustomerQuoteRequestDtoLinesInner',
              'quantity',
            ),
            note: note,
            knownUnitPrice: BuiltValueNullFieldError.checkNotNull(
              knownUnitPrice,
              r'CustomerQuoteRequestDtoLinesInner',
              'knownUnitPrice',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'optionIds';
        optionIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerQuoteRequestDtoLinesInner',
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
