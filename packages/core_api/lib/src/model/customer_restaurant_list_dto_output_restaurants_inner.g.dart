// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_list_dto_output_restaurants_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRestaurantListDtoOutputRestaurantsInner
    extends CustomerRestaurantListDtoOutputRestaurantsInner {
  @override
  final String id;
  @override
  final String nameAr;
  @override
  final String? nameEn;
  @override
  final String? category;
  @override
  final String? logoKey;
  @override
  final String? coverKey;
  @override
  final num? rating;
  @override
  final int? ratingCount;
  @override
  final CustomerRestaurantListDtoOutputRestaurantsInnerEstimate estimate;
  @override
  final CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFee? deliveryFee;
  @override
  final CustomerRestaurantListDtoOutputRestaurantsInnerState state;

  factory _$CustomerRestaurantListDtoOutputRestaurantsInner([
    void Function(CustomerRestaurantListDtoOutputRestaurantsInnerBuilder)?
    updates,
  ]) =>
      (CustomerRestaurantListDtoOutputRestaurantsInnerBuilder()
            ..update(updates))
          ._build();

  _$CustomerRestaurantListDtoOutputRestaurantsInner._({
    required this.id,
    required this.nameAr,
    this.nameEn,
    this.category,
    this.logoKey,
    this.coverKey,
    this.rating,
    this.ratingCount,
    required this.estimate,
    this.deliveryFee,
    required this.state,
  }) : super._();
  @override
  CustomerRestaurantListDtoOutputRestaurantsInner rebuild(
    void Function(CustomerRestaurantListDtoOutputRestaurantsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantListDtoOutputRestaurantsInnerBuilder toBuilder() =>
      CustomerRestaurantListDtoOutputRestaurantsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantListDtoOutputRestaurantsInner &&
        id == other.id &&
        nameAr == other.nameAr &&
        nameEn == other.nameEn &&
        category == other.category &&
        logoKey == other.logoKey &&
        coverKey == other.coverKey &&
        rating == other.rating &&
        ratingCount == other.ratingCount &&
        estimate == other.estimate &&
        deliveryFee == other.deliveryFee &&
        state == other.state;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, nameEn.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, logoKey.hashCode);
    _$hash = $jc(_$hash, coverKey.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, ratingCount.hashCode);
    _$hash = $jc(_$hash, estimate.hashCode);
    _$hash = $jc(_$hash, deliveryFee.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerRestaurantListDtoOutputRestaurantsInner',
          )
          ..add('id', id)
          ..add('nameAr', nameAr)
          ..add('nameEn', nameEn)
          ..add('category', category)
          ..add('logoKey', logoKey)
          ..add('coverKey', coverKey)
          ..add('rating', rating)
          ..add('ratingCount', ratingCount)
          ..add('estimate', estimate)
          ..add('deliveryFee', deliveryFee)
          ..add('state', state))
        .toString();
  }
}

class CustomerRestaurantListDtoOutputRestaurantsInnerBuilder
    implements
        Builder<
          CustomerRestaurantListDtoOutputRestaurantsInner,
          CustomerRestaurantListDtoOutputRestaurantsInnerBuilder
        > {
  _$CustomerRestaurantListDtoOutputRestaurantsInner? _$v;

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

  CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder? _estimate;
  CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder get estimate =>
      _$this._estimate ??=
          CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder();
  set estimate(
    CustomerRestaurantListDtoOutputRestaurantsInnerEstimateBuilder? estimate,
  ) => _$this._estimate = estimate;

  CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder?
  _deliveryFee;
  CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder
  get deliveryFee => _$this._deliveryFee ??=
      CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder();
  set deliveryFee(
    CustomerRestaurantListDtoOutputRestaurantsInnerDeliveryFeeBuilder?
    deliveryFee,
  ) => _$this._deliveryFee = deliveryFee;

  CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder? _state;
  CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder get state =>
      _$this._state ??=
          CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder();
  set state(
    CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder? state,
  ) => _$this._state = state;

  CustomerRestaurantListDtoOutputRestaurantsInnerBuilder() {
    CustomerRestaurantListDtoOutputRestaurantsInner._defaults(this);
  }

  CustomerRestaurantListDtoOutputRestaurantsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nameAr = $v.nameAr;
      _nameEn = $v.nameEn;
      _category = $v.category;
      _logoKey = $v.logoKey;
      _coverKey = $v.coverKey;
      _rating = $v.rating;
      _ratingCount = $v.ratingCount;
      _estimate = $v.estimate.toBuilder();
      _deliveryFee = $v.deliveryFee?.toBuilder();
      _state = $v.state.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRestaurantListDtoOutputRestaurantsInner other) {
    _$v = other as _$CustomerRestaurantListDtoOutputRestaurantsInner;
  }

  @override
  void update(
    void Function(CustomerRestaurantListDtoOutputRestaurantsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantListDtoOutputRestaurantsInner build() => _build();

  _$CustomerRestaurantListDtoOutputRestaurantsInner _build() {
    _$CustomerRestaurantListDtoOutputRestaurantsInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRestaurantListDtoOutputRestaurantsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerRestaurantListDtoOutputRestaurantsInner',
              'id',
            ),
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'CustomerRestaurantListDtoOutputRestaurantsInner',
              'nameAr',
            ),
            nameEn: nameEn,
            category: category,
            logoKey: logoKey,
            coverKey: coverKey,
            rating: rating,
            ratingCount: ratingCount,
            estimate: estimate.build(),
            deliveryFee: _deliveryFee?.build(),
            state: state.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'estimate';
        estimate.build();
        _$failedField = 'deliveryFee';
        _deliveryFee?.build();
        _$failedField = 'state';
        state.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRestaurantListDtoOutputRestaurantsInner',
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
