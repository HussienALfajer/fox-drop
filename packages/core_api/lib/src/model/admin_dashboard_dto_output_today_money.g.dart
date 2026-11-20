// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_dashboard_dto_output_today_money.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDashboardDtoOutputTodayMoney
    extends AdminDashboardDtoOutputTodayMoney {
  @override
  final String currency;
  @override
  final String gmv;
  @override
  final String itemsValue;
  @override
  final String deliveryFees;
  @override
  final String commission;
  @override
  final String margin;

  factory _$AdminDashboardDtoOutputTodayMoney([
    void Function(AdminDashboardDtoOutputTodayMoneyBuilder)? updates,
  ]) => (AdminDashboardDtoOutputTodayMoneyBuilder()..update(updates))._build();

  _$AdminDashboardDtoOutputTodayMoney._({
    required this.currency,
    required this.gmv,
    required this.itemsValue,
    required this.deliveryFees,
    required this.commission,
    required this.margin,
  }) : super._();
  @override
  AdminDashboardDtoOutputTodayMoney rebuild(
    void Function(AdminDashboardDtoOutputTodayMoneyBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDashboardDtoOutputTodayMoneyBuilder toBuilder() =>
      AdminDashboardDtoOutputTodayMoneyBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDashboardDtoOutputTodayMoney &&
        currency == other.currency &&
        gmv == other.gmv &&
        itemsValue == other.itemsValue &&
        deliveryFees == other.deliveryFees &&
        commission == other.commission &&
        margin == other.margin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, gmv.hashCode);
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jc(_$hash, deliveryFees.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, margin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDashboardDtoOutputTodayMoney')
          ..add('currency', currency)
          ..add('gmv', gmv)
          ..add('itemsValue', itemsValue)
          ..add('deliveryFees', deliveryFees)
          ..add('commission', commission)
          ..add('margin', margin))
        .toString();
  }
}

class AdminDashboardDtoOutputTodayMoneyBuilder
    implements
        Builder<
          AdminDashboardDtoOutputTodayMoney,
          AdminDashboardDtoOutputTodayMoneyBuilder
        > {
  _$AdminDashboardDtoOutputTodayMoney? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _gmv;
  String? get gmv => _$this._gmv;
  set gmv(String? gmv) => _$this._gmv = gmv;

  String? _itemsValue;
  String? get itemsValue => _$this._itemsValue;
  set itemsValue(String? itemsValue) => _$this._itemsValue = itemsValue;

  String? _deliveryFees;
  String? get deliveryFees => _$this._deliveryFees;
  set deliveryFees(String? deliveryFees) => _$this._deliveryFees = deliveryFees;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  String? _margin;
  String? get margin => _$this._margin;
  set margin(String? margin) => _$this._margin = margin;

  AdminDashboardDtoOutputTodayMoneyBuilder() {
    AdminDashboardDtoOutputTodayMoney._defaults(this);
  }

  AdminDashboardDtoOutputTodayMoneyBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _gmv = $v.gmv;
      _itemsValue = $v.itemsValue;
      _deliveryFees = $v.deliveryFees;
      _commission = $v.commission;
      _margin = $v.margin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDashboardDtoOutputTodayMoney other) {
    _$v = other as _$AdminDashboardDtoOutputTodayMoney;
  }

  @override
  void update(
    void Function(AdminDashboardDtoOutputTodayMoneyBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDashboardDtoOutputTodayMoney build() => _build();

  _$AdminDashboardDtoOutputTodayMoney _build() {
    final _$result =
        _$v ??
        _$AdminDashboardDtoOutputTodayMoney._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminDashboardDtoOutputTodayMoney',
            'currency',
          ),
          gmv: BuiltValueNullFieldError.checkNotNull(
            gmv,
            r'AdminDashboardDtoOutputTodayMoney',
            'gmv',
          ),
          itemsValue: BuiltValueNullFieldError.checkNotNull(
            itemsValue,
            r'AdminDashboardDtoOutputTodayMoney',
            'itemsValue',
          ),
          deliveryFees: BuiltValueNullFieldError.checkNotNull(
            deliveryFees,
            r'AdminDashboardDtoOutputTodayMoney',
            'deliveryFees',
          ),
          commission: BuiltValueNullFieldError.checkNotNull(
            commission,
            r'AdminDashboardDtoOutputTodayMoney',
            'commission',
          ),
          margin: BuiltValueNullFieldError.checkNotNull(
            margin,
            r'AdminDashboardDtoOutputTodayMoney',
            'margin',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
