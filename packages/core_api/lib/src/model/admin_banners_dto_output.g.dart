// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_banners_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBannersDtoOutput extends AdminBannersDtoOutput {
  @override
  final BuiltList<AdminBannersDtoOutputBannersInner> banners;
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?> restaurants;
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?> categories;
  @override
  final BuiltList<AdminBannersDtoOutputCodesInner> codes;
  @override
  final BuiltList<AdminPeakBonusDtoOutputZonesInner> zones;
  @override
  final bool canManage;

  factory _$AdminBannersDtoOutput([
    void Function(AdminBannersDtoOutputBuilder)? updates,
  ]) => (AdminBannersDtoOutputBuilder()..update(updates))._build();

  _$AdminBannersDtoOutput._({
    required this.banners,
    required this.restaurants,
    required this.categories,
    required this.codes,
    required this.zones,
    required this.canManage,
  }) : super._();
  @override
  AdminBannersDtoOutput rebuild(
    void Function(AdminBannersDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBannersDtoOutputBuilder toBuilder() =>
      AdminBannersDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBannersDtoOutput &&
        banners == other.banners &&
        restaurants == other.restaurants &&
        categories == other.categories &&
        codes == other.codes &&
        zones == other.zones &&
        canManage == other.canManage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, banners.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, codes.hashCode);
    _$hash = $jc(_$hash, zones.hashCode);
    _$hash = $jc(_$hash, canManage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBannersDtoOutput')
          ..add('banners', banners)
          ..add('restaurants', restaurants)
          ..add('categories', categories)
          ..add('codes', codes)
          ..add('zones', zones)
          ..add('canManage', canManage))
        .toString();
  }
}

class AdminBannersDtoOutputBuilder
    implements Builder<AdminBannersDtoOutput, AdminBannersDtoOutputBuilder> {
  _$AdminBannersDtoOutput? _$v;

  ListBuilder<AdminBannersDtoOutputBannersInner>? _banners;
  ListBuilder<AdminBannersDtoOutputBannersInner> get banners =>
      _$this._banners ??= ListBuilder<AdminBannersDtoOutputBannersInner>();
  set banners(ListBuilder<AdminBannersDtoOutputBannersInner>? banners) =>
      _$this._banners = banners;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>? _restaurants;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>
  get restaurants => _$this._restaurants ??=
      ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>();
  set restaurants(
    ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>? restaurants,
  ) => _$this._restaurants = restaurants;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>? _categories;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>
  get categories => _$this._categories ??=
      ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>();
  set categories(
    ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>? categories,
  ) => _$this._categories = categories;

  ListBuilder<AdminBannersDtoOutputCodesInner>? _codes;
  ListBuilder<AdminBannersDtoOutputCodesInner> get codes =>
      _$this._codes ??= ListBuilder<AdminBannersDtoOutputCodesInner>();
  set codes(ListBuilder<AdminBannersDtoOutputCodesInner>? codes) =>
      _$this._codes = codes;

  ListBuilder<AdminPeakBonusDtoOutputZonesInner>? _zones;
  ListBuilder<AdminPeakBonusDtoOutputZonesInner> get zones =>
      _$this._zones ??= ListBuilder<AdminPeakBonusDtoOutputZonesInner>();
  set zones(ListBuilder<AdminPeakBonusDtoOutputZonesInner>? zones) =>
      _$this._zones = zones;

  bool? _canManage;
  bool? get canManage => _$this._canManage;
  set canManage(bool? canManage) => _$this._canManage = canManage;

  AdminBannersDtoOutputBuilder() {
    AdminBannersDtoOutput._defaults(this);
  }

  AdminBannersDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _banners = $v.banners.toBuilder();
      _restaurants = $v.restaurants.toBuilder();
      _categories = $v.categories.toBuilder();
      _codes = $v.codes.toBuilder();
      _zones = $v.zones.toBuilder();
      _canManage = $v.canManage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBannersDtoOutput other) {
    _$v = other as _$AdminBannersDtoOutput;
  }

  @override
  void update(void Function(AdminBannersDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBannersDtoOutput build() => _build();

  _$AdminBannersDtoOutput _build() {
    _$AdminBannersDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminBannersDtoOutput._(
            banners: banners.build(),
            restaurants: restaurants.build(),
            categories: categories.build(),
            codes: codes.build(),
            zones: zones.build(),
            canManage: BuiltValueNullFieldError.checkNotNull(
              canManage,
              r'AdminBannersDtoOutput',
              'canManage',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'banners';
        banners.build();
        _$failedField = 'restaurants';
        restaurants.build();
        _$failedField = 'categories';
        categories.build();
        _$failedField = 'codes';
        codes.build();
        _$failedField = 'zones';
        zones.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminBannersDtoOutput',
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
