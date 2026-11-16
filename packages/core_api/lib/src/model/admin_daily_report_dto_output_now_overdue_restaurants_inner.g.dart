// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_daily_report_dto_output_now_overdue_restaurants_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDailyReportDtoOutputNowOverdueRestaurantsInner
    extends AdminDailyReportDtoOutputNowOverdueRestaurantsInner {
  @override
  final String restaurantId;
  @override
  final String name;
  @override
  final String balance;
  @override
  final DateTime overdueSince;

  factory _$AdminDailyReportDtoOutputNowOverdueRestaurantsInner([
    void Function(AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder)?
    updates,
  ]) =>
      (AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminDailyReportDtoOutputNowOverdueRestaurantsInner._({
    required this.restaurantId,
    required this.name,
    required this.balance,
    required this.overdueSince,
  }) : super._();
  @override
  AdminDailyReportDtoOutputNowOverdueRestaurantsInner rebuild(
    void Function(AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder toBuilder() =>
      AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDailyReportDtoOutputNowOverdueRestaurantsInner &&
        restaurantId == other.restaurantId &&
        name == other.name &&
        balance == other.balance &&
        overdueSince == other.overdueSince;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, balance.hashCode);
    _$hash = $jc(_$hash, overdueSince.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDailyReportDtoOutputNowOverdueRestaurantsInner',
          )
          ..add('restaurantId', restaurantId)
          ..add('name', name)
          ..add('balance', balance)
          ..add('overdueSince', overdueSince))
        .toString();
  }
}

class AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder
    implements
        Builder<
          AdminDailyReportDtoOutputNowOverdueRestaurantsInner,
          AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder
        > {
  _$AdminDailyReportDtoOutputNowOverdueRestaurantsInner? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _balance;
  String? get balance => _$this._balance;
  set balance(String? balance) => _$this._balance = balance;

  DateTime? _overdueSince;
  DateTime? get overdueSince => _$this._overdueSince;
  set overdueSince(DateTime? overdueSince) =>
      _$this._overdueSince = overdueSince;

  AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder() {
    AdminDailyReportDtoOutputNowOverdueRestaurantsInner._defaults(this);
  }

  AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _name = $v.name;
      _balance = $v.balance;
      _overdueSince = $v.overdueSince;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDailyReportDtoOutputNowOverdueRestaurantsInner other) {
    _$v = other as _$AdminDailyReportDtoOutputNowOverdueRestaurantsInner;
  }

  @override
  void update(
    void Function(AdminDailyReportDtoOutputNowOverdueRestaurantsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDailyReportDtoOutputNowOverdueRestaurantsInner build() => _build();

  _$AdminDailyReportDtoOutputNowOverdueRestaurantsInner _build() {
    final _$result =
        _$v ??
        _$AdminDailyReportDtoOutputNowOverdueRestaurantsInner._(
          restaurantId: BuiltValueNullFieldError.checkNotNull(
            restaurantId,
            r'AdminDailyReportDtoOutputNowOverdueRestaurantsInner',
            'restaurantId',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminDailyReportDtoOutputNowOverdueRestaurantsInner',
            'name',
          ),
          balance: BuiltValueNullFieldError.checkNotNull(
            balance,
            r'AdminDailyReportDtoOutputNowOverdueRestaurantsInner',
            'balance',
          ),
          overdueSince: BuiltValueNullFieldError.checkNotNull(
            overdueSince,
            r'AdminDailyReportDtoOutputNowOverdueRestaurantsInner',
            'overdueSince',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
