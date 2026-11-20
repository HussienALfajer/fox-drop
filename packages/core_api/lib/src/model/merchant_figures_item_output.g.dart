// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_item_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresItemOutput extends MerchantFiguresItemOutput {
  @override
  final String itemId;
  @override
  final String name;
  @override
  final int quantity;
  @override
  final String sales;

  factory _$MerchantFiguresItemOutput([
    void Function(MerchantFiguresItemOutputBuilder)? updates,
  ]) => (MerchantFiguresItemOutputBuilder()..update(updates))._build();

  _$MerchantFiguresItemOutput._({
    required this.itemId,
    required this.name,
    required this.quantity,
    required this.sales,
  }) : super._();
  @override
  MerchantFiguresItemOutput rebuild(
    void Function(MerchantFiguresItemOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresItemOutputBuilder toBuilder() =>
      MerchantFiguresItemOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresItemOutput &&
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
    return (newBuiltValueToStringHelper(r'MerchantFiguresItemOutput')
          ..add('itemId', itemId)
          ..add('name', name)
          ..add('quantity', quantity)
          ..add('sales', sales))
        .toString();
  }
}

class MerchantFiguresItemOutputBuilder
    implements
        Builder<MerchantFiguresItemOutput, MerchantFiguresItemOutputBuilder> {
  _$MerchantFiguresItemOutput? _$v;

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

  MerchantFiguresItemOutputBuilder() {
    MerchantFiguresItemOutput._defaults(this);
  }

  MerchantFiguresItemOutputBuilder get _$this {
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
  void replace(MerchantFiguresItemOutput other) {
    _$v = other as _$MerchantFiguresItemOutput;
  }

  @override
  void update(void Function(MerchantFiguresItemOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresItemOutput build() => _build();

  _$MerchantFiguresItemOutput _build() {
    final _$result =
        _$v ??
        _$MerchantFiguresItemOutput._(
          itemId: BuiltValueNullFieldError.checkNotNull(
            itemId,
            r'MerchantFiguresItemOutput',
            'itemId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'MerchantFiguresItemOutput',
            'name',
          ),
          quantity: BuiltValueNullFieldError.checkNotNull(
            quantity,
            r'MerchantFiguresItemOutput',
            'quantity',
          ),
          sales: BuiltValueNullFieldError.checkNotNull(
            sales,
            r'MerchantFiguresItemOutput',
            'sales',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
