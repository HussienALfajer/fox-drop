// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_promo_codes_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPromoCodesDtoOutput extends AdminPromoCodesDtoOutput {
  @override
  final BuiltList<AdminPromoCodesDtoOutputCodesInner> codes;
  @override
  final BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  restaurants;
  @override
  final BuiltList<AdminPeakBonusDtoOutputZonesInner> zones;
  @override
  final String? baseCurrency;
  @override
  final bool canManage;

  factory _$AdminPromoCodesDtoOutput([
    void Function(AdminPromoCodesDtoOutputBuilder)? updates,
  ]) => (AdminPromoCodesDtoOutputBuilder()..update(updates))._build();

  _$AdminPromoCodesDtoOutput._({
    required this.codes,
    required this.restaurants,
    required this.zones,
    this.baseCurrency,
    required this.canManage,
  }) : super._();
  @override
  AdminPromoCodesDtoOutput rebuild(
    void Function(AdminPromoCodesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPromoCodesDtoOutputBuilder toBuilder() =>
      AdminPromoCodesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPromoCodesDtoOutput &&
        codes == other.codes &&
        restaurants == other.restaurants &&
        zones == other.zones &&
        baseCurrency == other.baseCurrency &&
        canManage == other.canManage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, codes.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, zones.hashCode);
    _$hash = $jc(_$hash, baseCurrency.hashCode);
    _$hash = $jc(_$hash, canManage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminPromoCodesDtoOutput')
          ..add('codes', codes)
          ..add('restaurants', restaurants)
          ..add('zones', zones)
          ..add('baseCurrency', baseCurrency)
          ..add('canManage', canManage))
        .toString();
  }
}

class AdminPromoCodesDtoOutputBuilder
    implements
        Builder<AdminPromoCodesDtoOutput, AdminPromoCodesDtoOutputBuilder> {
  _$AdminPromoCodesDtoOutput? _$v;

  ListBuilder<AdminPromoCodesDtoOutputCodesInner>? _codes;
  ListBuilder<AdminPromoCodesDtoOutputCodesInner> get codes =>
      _$this._codes ??= ListBuilder<AdminPromoCodesDtoOutputCodesInner>();
  set codes(ListBuilder<AdminPromoCodesDtoOutputCodesInner>? codes) =>
      _$this._codes = codes;

  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>?
  _restaurants;
  ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  get restaurants => _$this._restaurants ??=
      ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>();
  set restaurants(
    ListBuilder<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>?
    restaurants,
  ) => _$this._restaurants = restaurants;

  ListBuilder<AdminPeakBonusDtoOutputZonesInner>? _zones;
  ListBuilder<AdminPeakBonusDtoOutputZonesInner> get zones =>
      _$this._zones ??= ListBuilder<AdminPeakBonusDtoOutputZonesInner>();
  set zones(ListBuilder<AdminPeakBonusDtoOutputZonesInner>? zones) =>
      _$this._zones = zones;

  String? _baseCurrency;
  String? get baseCurrency => _$this._baseCurrency;
  set baseCurrency(String? baseCurrency) => _$this._baseCurrency = baseCurrency;

  bool? _canManage;
  bool? get canManage => _$this._canManage;
  set canManage(bool? canManage) => _$this._canManage = canManage;

  AdminPromoCodesDtoOutputBuilder() {
    AdminPromoCodesDtoOutput._defaults(this);
  }

  AdminPromoCodesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _codes = $v.codes.toBuilder();
      _restaurants = $v.restaurants.toBuilder();
      _zones = $v.zones.toBuilder();
      _baseCurrency = $v.baseCurrency;
      _canManage = $v.canManage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPromoCodesDtoOutput other) {
    _$v = other as _$AdminPromoCodesDtoOutput;
  }

  @override
  void update(void Function(AdminPromoCodesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminPromoCodesDtoOutput build() => _build();

  _$AdminPromoCodesDtoOutput _build() {
    _$AdminPromoCodesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminPromoCodesDtoOutput._(
            codes: codes.build(),
            restaurants: restaurants.build(),
            zones: zones.build(),
            baseCurrency: baseCurrency,
            canManage: BuiltValueNullFieldError.checkNotNull(
              canManage,
              r'AdminPromoCodesDtoOutput',
              'canManage',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'codes';
        codes.build();
        _$failedField = 'restaurants';
        restaurants.build();
        _$failedField = 'zones';
        zones.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminPromoCodesDtoOutput',
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
