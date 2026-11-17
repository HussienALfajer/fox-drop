// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cost_report_dto_output_restaurants_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCostReportDtoOutputRestaurantsInner
    extends AdminCostReportDtoOutputRestaurantsInner {
  @override
  final String? restaurantId;
  @override
  final String? name;
  @override
  final String discounts;
  @override
  final String compensation;
  @override
  final String operating;
  @override
  final String total;

  factory _$AdminCostReportDtoOutputRestaurantsInner([
    void Function(AdminCostReportDtoOutputRestaurantsInnerBuilder)? updates,
  ]) => (AdminCostReportDtoOutputRestaurantsInnerBuilder()..update(updates))
      ._build();

  _$AdminCostReportDtoOutputRestaurantsInner._({
    this.restaurantId,
    this.name,
    required this.discounts,
    required this.compensation,
    required this.operating,
    required this.total,
  }) : super._();
  @override
  AdminCostReportDtoOutputRestaurantsInner rebuild(
    void Function(AdminCostReportDtoOutputRestaurantsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCostReportDtoOutputRestaurantsInnerBuilder toBuilder() =>
      AdminCostReportDtoOutputRestaurantsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCostReportDtoOutputRestaurantsInner &&
        restaurantId == other.restaurantId &&
        name == other.name &&
        discounts == other.discounts &&
        compensation == other.compensation &&
        operating == other.operating &&
        total == other.total;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, discounts.hashCode);
    _$hash = $jc(_$hash, compensation.hashCode);
    _$hash = $jc(_$hash, operating.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCostReportDtoOutputRestaurantsInner',
          )
          ..add('restaurantId', restaurantId)
          ..add('name', name)
          ..add('discounts', discounts)
          ..add('compensation', compensation)
          ..add('operating', operating)
          ..add('total', total))
        .toString();
  }
}

class AdminCostReportDtoOutputRestaurantsInnerBuilder
    implements
        Builder<
          AdminCostReportDtoOutputRestaurantsInner,
          AdminCostReportDtoOutputRestaurantsInnerBuilder
        > {
  _$AdminCostReportDtoOutputRestaurantsInner? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _discounts;
  String? get discounts => _$this._discounts;
  set discounts(String? discounts) => _$this._discounts = discounts;

  String? _compensation;
  String? get compensation => _$this._compensation;
  set compensation(String? compensation) => _$this._compensation = compensation;

  String? _operating;
  String? get operating => _$this._operating;
  set operating(String? operating) => _$this._operating = operating;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  AdminCostReportDtoOutputRestaurantsInnerBuilder() {
    AdminCostReportDtoOutputRestaurantsInner._defaults(this);
  }

  AdminCostReportDtoOutputRestaurantsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _name = $v.name;
      _discounts = $v.discounts;
      _compensation = $v.compensation;
      _operating = $v.operating;
      _total = $v.total;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCostReportDtoOutputRestaurantsInner other) {
    _$v = other as _$AdminCostReportDtoOutputRestaurantsInner;
  }

  @override
  void update(
    void Function(AdminCostReportDtoOutputRestaurantsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCostReportDtoOutputRestaurantsInner build() => _build();

  _$AdminCostReportDtoOutputRestaurantsInner _build() {
    final _$result =
        _$v ??
        _$AdminCostReportDtoOutputRestaurantsInner._(
          restaurantId: restaurantId,
          name: name,
          discounts: BuiltValueNullFieldError.checkNotNull(
            discounts,
            r'AdminCostReportDtoOutputRestaurantsInner',
            'discounts',
          ),
          compensation: BuiltValueNullFieldError.checkNotNull(
            compensation,
            r'AdminCostReportDtoOutputRestaurantsInner',
            'compensation',
          ),
          operating: BuiltValueNullFieldError.checkNotNull(
            operating,
            r'AdminCostReportDtoOutputRestaurantsInner',
            'operating',
          ),
          total: BuiltValueNullFieldError.checkNotNull(
            total,
            r'AdminCostReportDtoOutputRestaurantsInner',
            'total',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
