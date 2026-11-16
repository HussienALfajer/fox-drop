// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_daily_report_dto_output_discounts.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDailyReportDtoOutputDiscounts
    extends AdminDailyReportDtoOutputDiscounts {
  @override
  final String platform;
  @override
  final String restaurant;

  factory _$AdminDailyReportDtoOutputDiscounts([
    void Function(AdminDailyReportDtoOutputDiscountsBuilder)? updates,
  ]) => (AdminDailyReportDtoOutputDiscountsBuilder()..update(updates))._build();

  _$AdminDailyReportDtoOutputDiscounts._({
    required this.platform,
    required this.restaurant,
  }) : super._();
  @override
  AdminDailyReportDtoOutputDiscounts rebuild(
    void Function(AdminDailyReportDtoOutputDiscountsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDailyReportDtoOutputDiscountsBuilder toBuilder() =>
      AdminDailyReportDtoOutputDiscountsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDailyReportDtoOutputDiscounts &&
        platform == other.platform &&
        restaurant == other.restaurant;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, platform.hashCode);
    _$hash = $jc(_$hash, restaurant.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDailyReportDtoOutputDiscounts')
          ..add('platform', platform)
          ..add('restaurant', restaurant))
        .toString();
  }
}

class AdminDailyReportDtoOutputDiscountsBuilder
    implements
        Builder<
          AdminDailyReportDtoOutputDiscounts,
          AdminDailyReportDtoOutputDiscountsBuilder
        > {
  _$AdminDailyReportDtoOutputDiscounts? _$v;

  String? _platform;
  String? get platform => _$this._platform;
  set platform(String? platform) => _$this._platform = platform;

  String? _restaurant;
  String? get restaurant => _$this._restaurant;
  set restaurant(String? restaurant) => _$this._restaurant = restaurant;

  AdminDailyReportDtoOutputDiscountsBuilder() {
    AdminDailyReportDtoOutputDiscounts._defaults(this);
  }

  AdminDailyReportDtoOutputDiscountsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _platform = $v.platform;
      _restaurant = $v.restaurant;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDailyReportDtoOutputDiscounts other) {
    _$v = other as _$AdminDailyReportDtoOutputDiscounts;
  }

  @override
  void update(
    void Function(AdminDailyReportDtoOutputDiscountsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDailyReportDtoOutputDiscounts build() => _build();

  _$AdminDailyReportDtoOutputDiscounts _build() {
    final _$result =
        _$v ??
        _$AdminDailyReportDtoOutputDiscounts._(
          platform: BuiltValueNullFieldError.checkNotNull(
            platform,
            r'AdminDailyReportDtoOutputDiscounts',
            'platform',
          ),
          restaurant: BuiltValueNullFieldError.checkNotNull(
            restaurant,
            r'AdminDailyReportDtoOutputDiscounts',
            'restaurant',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
