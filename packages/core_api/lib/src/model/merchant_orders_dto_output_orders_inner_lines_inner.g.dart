// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputOrdersInnerLinesInner
    extends MerchantOrdersDtoOutputOrdersInnerLinesInner {
  @override
  final String itemId;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final BuiltList<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>
  options;
  @override
  final String? note;
  @override
  final String lineTotal;

  factory _$MerchantOrdersDtoOutputOrdersInnerLinesInner([
    void Function(MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder)? updates,
  ]) => (MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder()..update(updates))
      ._build();

  _$MerchantOrdersDtoOutputOrdersInnerLinesInner._({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.options,
    this.note,
    required this.lineTotal,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerLinesInner rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerLinesInner &&
        itemId == other.itemId &&
        name == other.name &&
        quantity == other.quantity &&
        options == other.options &&
        note == other.note &&
        lineTotal == other.lineTotal;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, lineTotal.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerLinesInner',
          )
          ..add('itemId', itemId)
          ..add('name', name)
          ..add('quantity', quantity)
          ..add('options', options)
          ..add('note', note)
          ..add('lineTotal', lineTotal))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerLinesInner,
          MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerLinesInner? _$v;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>?
  _options;
  ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>
  get options => _$this._options ??=
      ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>();
  set options(
    ListBuilder<MerchantOrdersDtoOutputOrdersInnerLinesInnerOptionsInner>?
    options,
  ) => _$this._options = options;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _lineTotal;
  String? get lineTotal => _$this._lineTotal;
  set lineTotal(String? lineTotal) => _$this._lineTotal = lineTotal;

  MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder() {
    MerchantOrdersDtoOutputOrdersInnerLinesInner._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _name = $v.name;
      _quantity = $v.quantity;
      _options = $v.options.toBuilder();
      _note = $v.note;
      _lineTotal = $v.lineTotal;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerLinesInner other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerLinesInner;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerLinesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerLinesInner build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerLinesInner _build() {
    _$MerchantOrdersDtoOutputOrdersInnerLinesInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrdersDtoOutputOrdersInnerLinesInner._(
            itemId: BuiltValueNullFieldError.checkNotNull(
              itemId,
              r'MerchantOrdersDtoOutputOrdersInnerLinesInner',
              'itemId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantOrdersDtoOutputOrdersInnerLinesInner',
              'name',
            ),
            quantity: BuiltValueNullFieldError.checkNotNull(
              quantity,
              r'MerchantOrdersDtoOutputOrdersInnerLinesInner',
              'quantity',
            ),
            options: options.build(),
            note: note,
            lineTotal: BuiltValueNullFieldError.checkNotNull(
              lineTotal,
              r'MerchantOrdersDtoOutputOrdersInnerLinesInner',
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
          r'MerchantOrdersDtoOutputOrdersInnerLinesInner',
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
