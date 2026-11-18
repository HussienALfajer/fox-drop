// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_mass_pushes_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMassPushesDtoOutput extends AdminMassPushesDtoOutput {
  @override
  final BuiltList<AdminMassPushesDtoOutputPushesInner> pushes;
  @override
  final BuiltList<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>
  restaurants;
  @override
  final BuiltList<AdminBannersDtoOutputCodesInner> codes;
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?> zones;
  @override
  final bool canManage;

  factory _$AdminMassPushesDtoOutput([
    void Function(AdminMassPushesDtoOutputBuilder)? updates,
  ]) => (AdminMassPushesDtoOutputBuilder()..update(updates))._build();

  _$AdminMassPushesDtoOutput._({
    required this.pushes,
    required this.restaurants,
    required this.codes,
    required this.zones,
    required this.canManage,
  }) : super._();
  @override
  AdminMassPushesDtoOutput rebuild(
    void Function(AdminMassPushesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMassPushesDtoOutputBuilder toBuilder() =>
      AdminMassPushesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMassPushesDtoOutput &&
        pushes == other.pushes &&
        restaurants == other.restaurants &&
        codes == other.codes &&
        zones == other.zones &&
        canManage == other.canManage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pushes.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, codes.hashCode);
    _$hash = $jc(_$hash, zones.hashCode);
    _$hash = $jc(_$hash, canManage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMassPushesDtoOutput')
          ..add('pushes', pushes)
          ..add('restaurants', restaurants)
          ..add('codes', codes)
          ..add('zones', zones)
          ..add('canManage', canManage))
        .toString();
  }
}

class AdminMassPushesDtoOutputBuilder
    implements
        Builder<AdminMassPushesDtoOutput, AdminMassPushesDtoOutputBuilder> {
  _$AdminMassPushesDtoOutput? _$v;

  ListBuilder<AdminMassPushesDtoOutputPushesInner>? _pushes;
  ListBuilder<AdminMassPushesDtoOutputPushesInner> get pushes =>
      _$this._pushes ??= ListBuilder<AdminMassPushesDtoOutputPushesInner>();
  set pushes(ListBuilder<AdminMassPushesDtoOutputPushesInner>? pushes) =>
      _$this._pushes = pushes;

  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>?
  _restaurants;
  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>
  get restaurants => _$this._restaurants ??=
      ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>();
  set restaurants(
    ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>?
    restaurants,
  ) => _$this._restaurants = restaurants;

  ListBuilder<AdminBannersDtoOutputCodesInner>? _codes;
  ListBuilder<AdminBannersDtoOutputCodesInner> get codes =>
      _$this._codes ??= ListBuilder<AdminBannersDtoOutputCodesInner>();
  set codes(ListBuilder<AdminBannersDtoOutputCodesInner>? codes) =>
      _$this._codes = codes;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>? _zones;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?> get zones =>
      _$this._zones ??=
          ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>();
  set zones(
    ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>? zones,
  ) => _$this._zones = zones;

  bool? _canManage;
  bool? get canManage => _$this._canManage;
  set canManage(bool? canManage) => _$this._canManage = canManage;

  AdminMassPushesDtoOutputBuilder() {
    AdminMassPushesDtoOutput._defaults(this);
  }

  AdminMassPushesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pushes = $v.pushes.toBuilder();
      _restaurants = $v.restaurants.toBuilder();
      _codes = $v.codes.toBuilder();
      _zones = $v.zones.toBuilder();
      _canManage = $v.canManage;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMassPushesDtoOutput other) {
    _$v = other as _$AdminMassPushesDtoOutput;
  }

  @override
  void update(void Function(AdminMassPushesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMassPushesDtoOutput build() => _build();

  _$AdminMassPushesDtoOutput _build() {
    _$AdminMassPushesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminMassPushesDtoOutput._(
            pushes: pushes.build(),
            restaurants: restaurants.build(),
            codes: codes.build(),
            zones: zones.build(),
            canManage: BuiltValueNullFieldError.checkNotNull(
              canManage,
              r'AdminMassPushesDtoOutput',
              'canManage',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'pushes';
        pushes.build();
        _$failedField = 'restaurants';
        restaurants.build();
        _$failedField = 'codes';
        codes.build();
        _$failedField = 'zones';
        zones.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMassPushesDtoOutput',
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
