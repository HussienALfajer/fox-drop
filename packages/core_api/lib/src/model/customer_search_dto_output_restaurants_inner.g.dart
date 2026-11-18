// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_search_dto_output_restaurants_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerSearchDtoOutputRestaurantsInner
    extends CustomerSearchDtoOutputRestaurantsInner {
  @override
  final String id;
  @override
  final String nameAr;
  @override
  final String? nameEn;
  @override
  final String? category;
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> categories;
  @override
  final String? logoKey;
  @override
  final String? coverKey;
  @override
  final num? rating;
  @override
  final int? ratingCount;
  @override
  final bool testMode;
  @override
  final CustomerRestaurantListDtoOutputRestaurantsInnerEstimate estimate;
  @override
  final CustomerRestaurantPageDtoOutputDeliveryFee? deliveryFee;
  @override
  final CustomerRestaurantListDtoOutputRestaurantsInnerState state;
  @override
  final bool favourite;

  factory _$CustomerSearchDtoOutputRestaurantsInner([
    void Function(CustomerSearchDtoOutputRestaurantsInnerBuilder)? updates,
  ]) => (CustomerSearchDtoOutputRestaurantsInnerBuilder()..update(updates))
      ._build();

  _$CustomerSearchDtoOutputRestaurantsInner._({
    required this.id,
    required this.nameAr,
    this.nameEn,
    this.category,
    required this.categories,
    this.logoKey,
    this.coverKey,
    this.rating,
    this.ratingCount,
    required this.testMode,
    required this.estimate,
    this.deliveryFee,
    required this.state,
    required this.favourite,
  }) : super._();
  @override
  CustomerSearchDtoOutputRestaurantsInner rebuild(
    void Function(CustomerSearchDtoOutputRestaurantsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSearchDtoOutputRestaurantsInnerBuilder toBuilder() =>
      CustomerSearchDtoOutputRestaurantsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSearchDtoOutputRestaurantsInner &&
        id == other.id &&
        nameAr == other.nameAr &&
        nameEn == other.nameEn &&
        category == other.category &&
        categories == other.categories &&
        logoKey == other.logoKey &&
        coverKey == other.coverKey &&
        rating == other.rating &&
        ratingCount == other.ratingCount &&
        testMode == other.testMode &&
        estimate == other.estimate &&
        deliveryFee == other.deliveryFee &&
        state == other.state &&
        favourite == other.favourite;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, nameEn.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, logoKey.hashCode);
    _$hash = $jc(_$hash, coverKey.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, ratingCount.hashCode);
    _$hash = $jc(_$hash, testMode.hashCode);
    _$hash = $jc(_$hash, estimate.hashCode);
    _$hash = $jc(_$hash, deliveryFee.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, favourite.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerSearchDtoOutputRestaurantsInner',
          )
          ..add('id', id)
          ..add('nameAr', nameAr)
          ..add('nameEn', nameEn)
          ..add('category', category)
          ..add('categories', categories)
          ..add('logoKey', logoKey)
          ..add('coverKey', coverKey)
          ..add('rating', rating)
          ..add('ratingCount', ratingCount)
          ..add('testMode', testMode)
          ..add('estimate', estimate)
          ..add('deliveryFee', deliveryFee)
          ..add('state', state)
          ..add('favourite', favourite))
        .toString();
  }
}

class CustomerSearchDtoOutputRestaurantsInnerBuilder
    implements
        Builder<
          CustomerSearchDtoOutputRestaurantsInner,
          CustomerSearchDtoOutputRestaurantsInnerBuilder
        > {
  _$CustomerSearchDtoOutputRestaurantsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  String? _nameEn;
  String? get nameEn => _$this._nameEn;
  set nameEn(String? nameEn) => _$this._nameEn = nameEn;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? _categories;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get categories =>
      _$this._categories ??=
          ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>();
  set categories(
    ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? categories,
  ) => _$this._categories = categories;

  String? _logoKey;
  String? get logoKey => _$this._logoKey;
  set logoKey(String? logoKey) => _$this._logoKey = logoKey;

  String? _coverKey;
  String? get coverKey => _$this._coverKey;
  set coverKey(String? coverKey) => _$this._coverKey = coverKey;

  num? _rating;
  num? get rating => _$this._rating;
  set rating(num? rating) => _$this._rating = rating;

  int? _ratingCount;
  int? get ratingCount => _$this._ratingCount;
  set ratingCount(int? ratingCount) => _$this._ratingCount = ratingCount;

  bool? _testMode;
  bool? get testMode => _$this._testMode;
  set testMode(bool? testMode) => _$this._testMode = testMode;

  CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder? _estimate;
  CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder get estimate =>
      _$this._estimate ??=
          CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder();
  set estimate(
    CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder? estimate,
  ) => _$this._estimate = estimate;

  CustomerRestaurantPageDtoOutputDeliveryFeeBuilder? _deliveryFee;
  CustomerRestaurantPageDtoOutputDeliveryFeeBuilder get deliveryFee =>
      _$this._deliveryFee ??=
          CustomerRestaurantPageDtoOutputDeliveryFeeBuilder();
  set deliveryFee(
    CustomerRestaurantPageDtoOutputDeliveryFeeBuilder? deliveryFee,
  ) => _$this._deliveryFee = deliveryFee;

  CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder? _state;
  CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder get state =>
      _$this._state ??=
          CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder();
  set state(
    CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder? state,
  ) => _$this._state = state;

  bool? _favourite;
  bool? get favourite => _$this._favourite;
  set favourite(bool? favourite) => _$this._favourite = favourite;

  CustomerSearchDtoOutputRestaurantsInnerBuilder() {
    CustomerSearchDtoOutputRestaurantsInner._defaults(this);
  }

  CustomerSearchDtoOutputRestaurantsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nameAr = $v.nameAr;
      _nameEn = $v.nameEn;
      _category = $v.category;
      _categories = $v.categories.toBuilder();
      _logoKey = $v.logoKey;
      _coverKey = $v.coverKey;
      _rating = $v.rating;
      _ratingCount = $v.ratingCount;
      _testMode = $v.testMode;
      _estimate = $v.estimate.toBuilder();
      _deliveryFee = $v.deliveryFee?.toBuilder();
      _state = $v.state.toBuilder();
      _favourite = $v.favourite;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSearchDtoOutputRestaurantsInner other) {
    _$v = other as _$CustomerSearchDtoOutputRestaurantsInner;
  }

  @override
  void update(
    void Function(CustomerSearchDtoOutputRestaurantsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSearchDtoOutputRestaurantsInner build() => _build();

  _$CustomerSearchDtoOutputRestaurantsInner _build() {
    _$CustomerSearchDtoOutputRestaurantsInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerSearchDtoOutputRestaurantsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerSearchDtoOutputRestaurantsInner',
              'id',
            ),
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'CustomerSearchDtoOutputRestaurantsInner',
              'nameAr',
            ),
            nameEn: nameEn,
            category: category,
            categories: categories.build(),
            logoKey: logoKey,
            coverKey: coverKey,
            rating: rating,
            ratingCount: ratingCount,
            testMode: BuiltValueNullFieldError.checkNotNull(
              testMode,
              r'CustomerSearchDtoOutputRestaurantsInner',
              'testMode',
            ),
            estimate: estimate.build(),
            deliveryFee: _deliveryFee?.build(),
            state: state.build(),
            favourite: BuiltValueNullFieldError.checkNotNull(
              favourite,
              r'CustomerSearchDtoOutputRestaurantsInner',
              'favourite',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();

        _$failedField = 'estimate';
        estimate.build();
        _$failedField = 'deliveryFee';
        _deliveryFee?.build();
        _$failedField = 'state';
        state.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerSearchDtoOutputRestaurantsInner',
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
