// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_choices_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftChoicesDtoOutput
    extends AdminRestaurantDraftChoicesDtoOutput {
  @override
  final BuiltList<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>
  categories;
  @override
  final int categoriesMax;
  @override
  final BuiltList<AdminRestaurantDraftChoicesDtoOutputCategoriesInner> zones;
  @override
  final String? baseCurrency;
  @override
  final AdminRestaurantDraftChoicesDtoOutputCentre? centre;
  @override
  final int prepFloorMin;
  @override
  final int prepCeilingMin;
  @override
  final int defaultPrepMin;
  @override
  final AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrder?
  defaultMinimumOrder;
  @override
  final int defaultCommissionBp;
  @override
  final int nameMax;
  @override
  final int descriptionMax;
  @override
  final int addressMax;

  factory _$AdminRestaurantDraftChoicesDtoOutput([
    void Function(AdminRestaurantDraftChoicesDtoOutputBuilder)? updates,
  ]) =>
      (AdminRestaurantDraftChoicesDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantDraftChoicesDtoOutput._({
    required this.categories,
    required this.categoriesMax,
    required this.zones,
    this.baseCurrency,
    this.centre,
    required this.prepFloorMin,
    required this.prepCeilingMin,
    required this.defaultPrepMin,
    this.defaultMinimumOrder,
    required this.defaultCommissionBp,
    required this.nameMax,
    required this.descriptionMax,
    required this.addressMax,
  }) : super._();
  @override
  AdminRestaurantDraftChoicesDtoOutput rebuild(
    void Function(AdminRestaurantDraftChoicesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftChoicesDtoOutputBuilder toBuilder() =>
      AdminRestaurantDraftChoicesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftChoicesDtoOutput &&
        categories == other.categories &&
        categoriesMax == other.categoriesMax &&
        zones == other.zones &&
        baseCurrency == other.baseCurrency &&
        centre == other.centre &&
        prepFloorMin == other.prepFloorMin &&
        prepCeilingMin == other.prepCeilingMin &&
        defaultPrepMin == other.defaultPrepMin &&
        defaultMinimumOrder == other.defaultMinimumOrder &&
        defaultCommissionBp == other.defaultCommissionBp &&
        nameMax == other.nameMax &&
        descriptionMax == other.descriptionMax &&
        addressMax == other.addressMax;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, categoriesMax.hashCode);
    _$hash = $jc(_$hash, zones.hashCode);
    _$hash = $jc(_$hash, baseCurrency.hashCode);
    _$hash = $jc(_$hash, centre.hashCode);
    _$hash = $jc(_$hash, prepFloorMin.hashCode);
    _$hash = $jc(_$hash, prepCeilingMin.hashCode);
    _$hash = $jc(_$hash, defaultPrepMin.hashCode);
    _$hash = $jc(_$hash, defaultMinimumOrder.hashCode);
    _$hash = $jc(_$hash, defaultCommissionBp.hashCode);
    _$hash = $jc(_$hash, nameMax.hashCode);
    _$hash = $jc(_$hash, descriptionMax.hashCode);
    _$hash = $jc(_$hash, addressMax.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantDraftChoicesDtoOutput')
          ..add('categories', categories)
          ..add('categoriesMax', categoriesMax)
          ..add('zones', zones)
          ..add('baseCurrency', baseCurrency)
          ..add('centre', centre)
          ..add('prepFloorMin', prepFloorMin)
          ..add('prepCeilingMin', prepCeilingMin)
          ..add('defaultPrepMin', defaultPrepMin)
          ..add('defaultMinimumOrder', defaultMinimumOrder)
          ..add('defaultCommissionBp', defaultCommissionBp)
          ..add('nameMax', nameMax)
          ..add('descriptionMax', descriptionMax)
          ..add('addressMax', addressMax))
        .toString();
  }
}

class AdminRestaurantDraftChoicesDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantDraftChoicesDtoOutput,
          AdminRestaurantDraftChoicesDtoOutputBuilder
        > {
  _$AdminRestaurantDraftChoicesDtoOutput? _$v;

  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>? _categories;
  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>
  get categories => _$this._categories ??=
      ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>();
  set categories(
    ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>?
    categories,
  ) => _$this._categories = categories;

  int? _categoriesMax;
  int? get categoriesMax => _$this._categoriesMax;
  set categoriesMax(int? categoriesMax) =>
      _$this._categoriesMax = categoriesMax;

  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>? _zones;
  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner> get zones =>
      _$this._zones ??=
          ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>();
  set zones(
    ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>? zones,
  ) => _$this._zones = zones;

  String? _baseCurrency;
  String? get baseCurrency => _$this._baseCurrency;
  set baseCurrency(String? baseCurrency) => _$this._baseCurrency = baseCurrency;

  AdminRestaurantDraftChoicesDtoOutputCentreBuilder? _centre;
  AdminRestaurantDraftChoicesDtoOutputCentreBuilder get centre =>
      _$this._centre ??= AdminRestaurantDraftChoicesDtoOutputCentreBuilder();
  set centre(AdminRestaurantDraftChoicesDtoOutputCentreBuilder? centre) =>
      _$this._centre = centre;

  int? _prepFloorMin;
  int? get prepFloorMin => _$this._prepFloorMin;
  set prepFloorMin(int? prepFloorMin) => _$this._prepFloorMin = prepFloorMin;

  int? _prepCeilingMin;
  int? get prepCeilingMin => _$this._prepCeilingMin;
  set prepCeilingMin(int? prepCeilingMin) =>
      _$this._prepCeilingMin = prepCeilingMin;

  int? _defaultPrepMin;
  int? get defaultPrepMin => _$this._defaultPrepMin;
  set defaultPrepMin(int? defaultPrepMin) =>
      _$this._defaultPrepMin = defaultPrepMin;

  AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder?
  _defaultMinimumOrder;
  AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder
  get defaultMinimumOrder => _$this._defaultMinimumOrder ??=
      AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder();
  set defaultMinimumOrder(
    AdminRestaurantDraftChoicesDtoOutputDefaultMinimumOrderBuilder?
    defaultMinimumOrder,
  ) => _$this._defaultMinimumOrder = defaultMinimumOrder;

  int? _defaultCommissionBp;
  int? get defaultCommissionBp => _$this._defaultCommissionBp;
  set defaultCommissionBp(int? defaultCommissionBp) =>
      _$this._defaultCommissionBp = defaultCommissionBp;

  int? _nameMax;
  int? get nameMax => _$this._nameMax;
  set nameMax(int? nameMax) => _$this._nameMax = nameMax;

  int? _descriptionMax;
  int? get descriptionMax => _$this._descriptionMax;
  set descriptionMax(int? descriptionMax) =>
      _$this._descriptionMax = descriptionMax;

  int? _addressMax;
  int? get addressMax => _$this._addressMax;
  set addressMax(int? addressMax) => _$this._addressMax = addressMax;

  AdminRestaurantDraftChoicesDtoOutputBuilder() {
    AdminRestaurantDraftChoicesDtoOutput._defaults(this);
  }

  AdminRestaurantDraftChoicesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categories = $v.categories.toBuilder();
      _categoriesMax = $v.categoriesMax;
      _zones = $v.zones.toBuilder();
      _baseCurrency = $v.baseCurrency;
      _centre = $v.centre?.toBuilder();
      _prepFloorMin = $v.prepFloorMin;
      _prepCeilingMin = $v.prepCeilingMin;
      _defaultPrepMin = $v.defaultPrepMin;
      _defaultMinimumOrder = $v.defaultMinimumOrder?.toBuilder();
      _defaultCommissionBp = $v.defaultCommissionBp;
      _nameMax = $v.nameMax;
      _descriptionMax = $v.descriptionMax;
      _addressMax = $v.addressMax;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftChoicesDtoOutput other) {
    _$v = other as _$AdminRestaurantDraftChoicesDtoOutput;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftChoicesDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftChoicesDtoOutput build() => _build();

  _$AdminRestaurantDraftChoicesDtoOutput _build() {
    _$AdminRestaurantDraftChoicesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantDraftChoicesDtoOutput._(
            categories: categories.build(),
            categoriesMax: BuiltValueNullFieldError.checkNotNull(
              categoriesMax,
              r'AdminRestaurantDraftChoicesDtoOutput',
              'categoriesMax',
            ),
            zones: zones.build(),
            baseCurrency: baseCurrency,
            centre: _centre?.build(),
            prepFloorMin: BuiltValueNullFieldError.checkNotNull(
              prepFloorMin,
              r'AdminRestaurantDraftChoicesDtoOutput',
              'prepFloorMin',
            ),
            prepCeilingMin: BuiltValueNullFieldError.checkNotNull(
              prepCeilingMin,
              r'AdminRestaurantDraftChoicesDtoOutput',
              'prepCeilingMin',
            ),
            defaultPrepMin: BuiltValueNullFieldError.checkNotNull(
              defaultPrepMin,
              r'AdminRestaurantDraftChoicesDtoOutput',
              'defaultPrepMin',
            ),
            defaultMinimumOrder: _defaultMinimumOrder?.build(),
            defaultCommissionBp: BuiltValueNullFieldError.checkNotNull(
              defaultCommissionBp,
              r'AdminRestaurantDraftChoicesDtoOutput',
              'defaultCommissionBp',
            ),
            nameMax: BuiltValueNullFieldError.checkNotNull(
              nameMax,
              r'AdminRestaurantDraftChoicesDtoOutput',
              'nameMax',
            ),
            descriptionMax: BuiltValueNullFieldError.checkNotNull(
              descriptionMax,
              r'AdminRestaurantDraftChoicesDtoOutput',
              'descriptionMax',
            ),
            addressMax: BuiltValueNullFieldError.checkNotNull(
              addressMax,
              r'AdminRestaurantDraftChoicesDtoOutput',
              'addressMax',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();

        _$failedField = 'zones';
        zones.build();

        _$failedField = 'centre';
        _centre?.build();

        _$failedField = 'defaultMinimumOrder';
        _defaultMinimumOrder?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantDraftChoicesDtoOutput',
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
