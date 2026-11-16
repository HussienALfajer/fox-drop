// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_daily_report_dto_output_orders.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDailyReportDtoOutputOrders
    extends AdminDailyReportDtoOutputOrders {
  @override
  final int count;
  @override
  final String gmv;
  @override
  final String itemsValue;

  factory _$AdminDailyReportDtoOutputOrders([
    void Function(AdminDailyReportDtoOutputOrdersBuilder)? updates,
  ]) => (AdminDailyReportDtoOutputOrdersBuilder()..update(updates))._build();

  _$AdminDailyReportDtoOutputOrders._({
    required this.count,
    required this.gmv,
    required this.itemsValue,
  }) : super._();
  @override
  AdminDailyReportDtoOutputOrders rebuild(
    void Function(AdminDailyReportDtoOutputOrdersBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDailyReportDtoOutputOrdersBuilder toBuilder() =>
      AdminDailyReportDtoOutputOrdersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDailyReportDtoOutputOrders &&
        count == other.count &&
        gmv == other.gmv &&
        itemsValue == other.itemsValue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, gmv.hashCode);
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDailyReportDtoOutputOrders')
          ..add('count', count)
          ..add('gmv', gmv)
          ..add('itemsValue', itemsValue))
        .toString();
  }
}

class AdminDailyReportDtoOutputOrdersBuilder
    implements
        Builder<
          AdminDailyReportDtoOutputOrders,
          AdminDailyReportDtoOutputOrdersBuilder
        > {
  _$AdminDailyReportDtoOutputOrders? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _gmv;
  String? get gmv => _$this._gmv;
  set gmv(String? gmv) => _$this._gmv = gmv;

  String? _itemsValue;
  String? get itemsValue => _$this._itemsValue;
  set itemsValue(String? itemsValue) => _$this._itemsValue = itemsValue;

  AdminDailyReportDtoOutputOrdersBuilder() {
    AdminDailyReportDtoOutputOrders._defaults(this);
  }

  AdminDailyReportDtoOutputOrdersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _gmv = $v.gmv;
      _itemsValue = $v.itemsValue;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDailyReportDtoOutputOrders other) {
    _$v = other as _$AdminDailyReportDtoOutputOrders;
  }

  @override
  void update(void Function(AdminDailyReportDtoOutputOrdersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDailyReportDtoOutputOrders build() => _build();

  _$AdminDailyReportDtoOutputOrders _build() {
    final _$result =
        _$v ??
        _$AdminDailyReportDtoOutputOrders._(
          count: BuiltValueNullFieldError.checkNotNull(
            count,
            r'AdminDailyReportDtoOutputOrders',
            'count',
          ),
          gmv: BuiltValueNullFieldError.checkNotNull(
            gmv,
            r'AdminDailyReportDtoOutputOrders',
            'gmv',
          ),
          itemsValue: BuiltValueNullFieldError.checkNotNull(
            itemsValue,
            r'AdminDailyReportDtoOutputOrders',
            'itemsValue',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
