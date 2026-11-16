// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_daily_report_dto_output_restaurants.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDailyReportDtoOutputRestaurants
    extends AdminDailyReportDtoOutputRestaurants {
  @override
  final String commission;
  @override
  final String discountShare;
  @override
  final String owedByRestaurants;
  @override
  final String owedToRestaurants;

  factory _$AdminDailyReportDtoOutputRestaurants([
    void Function(AdminDailyReportDtoOutputRestaurantsBuilder)? updates,
  ]) =>
      (AdminDailyReportDtoOutputRestaurantsBuilder()..update(updates))._build();

  _$AdminDailyReportDtoOutputRestaurants._({
    required this.commission,
    required this.discountShare,
    required this.owedByRestaurants,
    required this.owedToRestaurants,
  }) : super._();
  @override
  AdminDailyReportDtoOutputRestaurants rebuild(
    void Function(AdminDailyReportDtoOutputRestaurantsBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDailyReportDtoOutputRestaurantsBuilder toBuilder() =>
      AdminDailyReportDtoOutputRestaurantsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDailyReportDtoOutputRestaurants &&
        commission == other.commission &&
        discountShare == other.discountShare &&
        owedByRestaurants == other.owedByRestaurants &&
        owedToRestaurants == other.owedToRestaurants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, discountShare.hashCode);
    _$hash = $jc(_$hash, owedByRestaurants.hashCode);
    _$hash = $jc(_$hash, owedToRestaurants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDailyReportDtoOutputRestaurants')
          ..add('commission', commission)
          ..add('discountShare', discountShare)
          ..add('owedByRestaurants', owedByRestaurants)
          ..add('owedToRestaurants', owedToRestaurants))
        .toString();
  }
}

class AdminDailyReportDtoOutputRestaurantsBuilder
    implements
        Builder<
          AdminDailyReportDtoOutputRestaurants,
          AdminDailyReportDtoOutputRestaurantsBuilder
        > {
  _$AdminDailyReportDtoOutputRestaurants? _$v;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  String? _discountShare;
  String? get discountShare => _$this._discountShare;
  set discountShare(String? discountShare) =>
      _$this._discountShare = discountShare;

  String? _owedByRestaurants;
  String? get owedByRestaurants => _$this._owedByRestaurants;
  set owedByRestaurants(String? owedByRestaurants) =>
      _$this._owedByRestaurants = owedByRestaurants;

  String? _owedToRestaurants;
  String? get owedToRestaurants => _$this._owedToRestaurants;
  set owedToRestaurants(String? owedToRestaurants) =>
      _$this._owedToRestaurants = owedToRestaurants;

  AdminDailyReportDtoOutputRestaurantsBuilder() {
    AdminDailyReportDtoOutputRestaurants._defaults(this);
  }

  AdminDailyReportDtoOutputRestaurantsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _commission = $v.commission;
      _discountShare = $v.discountShare;
      _owedByRestaurants = $v.owedByRestaurants;
      _owedToRestaurants = $v.owedToRestaurants;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDailyReportDtoOutputRestaurants other) {
    _$v = other as _$AdminDailyReportDtoOutputRestaurants;
  }

  @override
  void update(
    void Function(AdminDailyReportDtoOutputRestaurantsBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDailyReportDtoOutputRestaurants build() => _build();

  _$AdminDailyReportDtoOutputRestaurants _build() {
    final _$result =
        _$v ??
        _$AdminDailyReportDtoOutputRestaurants._(
          commission: BuiltValueNullFieldError.checkNotNull(
            commission,
            r'AdminDailyReportDtoOutputRestaurants',
            'commission',
          ),
          discountShare: BuiltValueNullFieldError.checkNotNull(
            discountShare,
            r'AdminDailyReportDtoOutputRestaurants',
            'discountShare',
          ),
          owedByRestaurants: BuiltValueNullFieldError.checkNotNull(
            owedByRestaurants,
            r'AdminDailyReportDtoOutputRestaurants',
            'owedByRestaurants',
          ),
          owedToRestaurants: BuiltValueNullFieldError.checkNotNull(
            owedToRestaurants,
            r'AdminDailyReportDtoOutputRestaurants',
            'owedToRestaurants',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
