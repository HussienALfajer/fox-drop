// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_dto_output_current_top_by_quantity_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresDtoOutputCurrentTopByQuantityInner
    extends MerchantFiguresDtoOutputCurrentTopByQuantityInner {
  @override
  final String itemId;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final String sales;

  factory _$MerchantFiguresDtoOutputCurrentTopByQuantityInner([
    void Function(MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder)?
    updates,
  ]) =>
      (MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantFiguresDtoOutputCurrentTopByQuantityInner._({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.sales,
  }) : super._();
  @override
  MerchantFiguresDtoOutputCurrentTopByQuantityInner rebuild(
    void Function(MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder toBuilder() =>
      MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresDtoOutputCurrentTopByQuantityInner &&
        itemId == other.itemId &&
        name == other.name &&
        quantity == other.quantity &&
        sales == other.sales;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, sales.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantFiguresDtoOutputCurrentTopByQuantityInner',
          )
          ..add('itemId', itemId)
          ..add('name', name)
          ..add('quantity', quantity)
          ..add('sales', sales))
        .toString();
  }
}

class MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder
    implements
        Builder<
          MerchantFiguresDtoOutputCurrentTopByQuantityInner,
          MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder
        > {
  _$MerchantFiguresDtoOutputCurrentTopByQuantityInner? _$v;

  String? _itemId;
  String? get itemId => _$this._itemId;
  set itemId(String? itemId) => _$this._itemId = itemId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  String? _sales;
  String? get sales => _$this._sales;
  set sales(String? sales) => _$this._sales = sales;

  MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder() {
    MerchantFiguresDtoOutputCurrentTopByQuantityInner._defaults(this);
  }

  MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemId = $v.itemId;
      _name = $v.name;
      _quantity = $v.quantity;
      _sales = $v.sales;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantFiguresDtoOutputCurrentTopByQuantityInner other) {
    _$v = other as _$MerchantFiguresDtoOutputCurrentTopByQuantityInner;
  }

  @override
  void update(
    void Function(MerchantFiguresDtoOutputCurrentTopByQuantityInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresDtoOutputCurrentTopByQuantityInner build() => _build();

  _$MerchantFiguresDtoOutputCurrentTopByQuantityInner _build() {
    final _$result =
        _$v ??
        _$MerchantFiguresDtoOutputCurrentTopByQuantityInner._(
          itemId: BuiltValueNullFieldError.checkNotNull(
            itemId,
            r'MerchantFiguresDtoOutputCurrentTopByQuantityInner',
            'itemId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantFiguresDtoOutputCurrentTopByQuantityInner',
            'name',
          ),
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'MerchantFiguresDtoOutputCurrentTopByQuantityInner',
            'quantity',
          ),
          sales: BuiltValueNullFieldError.checkNotNull(
            sales,
            r'MerchantFiguresDtoOutputCurrentTopByQuantityInner',
            'sales',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
