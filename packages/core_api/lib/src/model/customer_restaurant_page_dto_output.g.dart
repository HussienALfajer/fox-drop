// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_page_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRestaurantPageDtoOutput
    extends CustomerRestaurantPageDtoOutput {
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
  final CustomerRestaurantPageDtoOutputDeliveryFee? deliveryFee;
  @override
  final CustomerRestaurantListDtoOutputRestaurantsInnerState state;
  @override
  final String? description;
  @override
  final CaptainWentOfflineDtoOutputHandIn? minimumOrder;
  @override
  final CaptainWentOfflineDtoOutputHandIn? freeDeliveryFrom;
  @override
  final BuiltList<CustomerRestaurantPageDtoOutputScheduleInner> schedule;
  @override
  final bool deliversHere;
  @override
  final BuiltList<CustomerRestaurantPageDtoOutputMenuInner> menu;

  factory _$CustomerRestaurantPageDtoOutput([
    void Function(CustomerRestaurantPageDtoOutputBuilder)? updates,
  ]) => (CustomerRestaurantPageDtoOutputBuilder()..update(updates))._build();

  _$CustomerRestaurantPageDtoOutput._({
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
    this.description,
    this.minimumOrder,
    this.freeDeliveryFrom,
    required this.schedule,
    required this.deliversHere,
    required this.menu,
  }) : super._();
  @override
  CustomerRestaurantPageDtoOutput rebuild(
    void Function(CustomerRestaurantPageDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantPageDtoOutputBuilder toBuilder() =>
      CustomerRestaurantPageDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantPageDtoOutput &&
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
        state == other.state &&
        description == other.description &&
        minimumOrder == other.minimumOrder &&
        freeDeliveryFrom == other.freeDeliveryFrom &&
        schedule == other.schedule &&
        deliversHere == other.deliversHere &&
        menu == other.menu;
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
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, minimumOrder.hashCode);
    _$hash = $jc(_$hash, freeDeliveryFrom.hashCode);
    _$hash = $jc(_$hash, schedule.hashCode);
    _$hash = $jc(_$hash, deliversHere.hashCode);
    _$hash = $jc(_$hash, menu.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerRestaurantPageDtoOutput')
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
          ..add('state', state)
          ..add('description', description)
          ..add('minimumOrder', minimumOrder)
          ..add('freeDeliveryFrom', freeDeliveryFrom)
          ..add('schedule', schedule)
          ..add('deliversHere', deliversHere)
          ..add('menu', menu))
        .toString();
  }
}

class CustomerRestaurantPageDtoOutputBuilder
    implements
        Builder<
          CustomerRestaurantPageDtoOutput,
          CustomerRestaurantPageDtoOutputBuilder
        > {
  _$CustomerRestaurantPageDtoOutput? _$v;

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

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  CaptainWentOfflineDtoOutputHandInBuilder? _minimumOrder;
  CaptainWentOfflineDtoOutputHandInBuilder get minimumOrder =>
      _$this._minimumOrder ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set minimumOrder(CaptainWentOfflineDtoOutputHandInBuilder? minimumOrder) =>
      _$this._minimumOrder = minimumOrder;

  CaptainWentOfflineDtoOutputHandInBuilder? _freeDeliveryFrom;
  CaptainWentOfflineDtoOutputHandInBuilder get freeDeliveryFrom =>
      _$this._freeDeliveryFrom ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set freeDeliveryFrom(
    CaptainWentOfflineDtoOutputHandInBuilder? freeDeliveryFrom,
  ) => _$this._freeDeliveryFrom = freeDeliveryFrom;

  ListBuilder<CustomerRestaurantPageDtoOutputScheduleInner>? _schedule;
  ListBuilder<CustomerRestaurantPageDtoOutputScheduleInner> get schedule =>
      _$this._schedule ??=
          ListBuilder<CustomerRestaurantPageDtoOutputScheduleInner>();
  set schedule(
    ListBuilder<CustomerRestaurantPageDtoOutputScheduleInner>? schedule,
  ) => _$this._schedule = schedule;

  bool? _deliversHere;
  bool? get deliversHere => _$this._deliversHere;
  set deliversHere(bool? deliversHere) => _$this._deliversHere = deliversHere;

  ListBuilder<CustomerRestaurantPageDtoOutputMenuInner>? _menu;
  ListBuilder<CustomerRestaurantPageDtoOutputMenuInner> get menu =>
      _$this._menu ??= ListBuilder<CustomerRestaurantPageDtoOutputMenuInner>();
  set menu(ListBuilder<CustomerRestaurantPageDtoOutputMenuInner>? menu) =>
      _$this._menu = menu;

  CustomerRestaurantPageDtoOutputBuilder() {
    CustomerRestaurantPageDtoOutput._defaults(this);
  }

  CustomerRestaurantPageDtoOutputBuilder get _$this {
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
      _description = $v.description;
      _minimumOrder = $v.minimumOrder?.toBuilder();
      _freeDeliveryFrom = $v.freeDeliveryFrom?.toBuilder();
      _schedule = $v.schedule.toBuilder();
      _deliversHere = $v.deliversHere;
      _menu = $v.menu.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRestaurantPageDtoOutput other) {
    _$v = other as _$CustomerRestaurantPageDtoOutput;
  }

  @override
  void update(void Function(CustomerRestaurantPageDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantPageDtoOutput build() => _build();

  _$CustomerRestaurantPageDtoOutput _build() {
    _$CustomerRestaurantPageDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRestaurantPageDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerRestaurantPageDtoOutput',
              'id',
            ),
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'CustomerRestaurantPageDtoOutput',
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
            description: description,
            minimumOrder: _minimumOrder?.build(),
            freeDeliveryFrom: _freeDeliveryFrom?.build(),
            schedule: schedule.build(),
            deliversHere: BuiltValueNullFieldError.checkNotNull(
              deliversHere,
              r'CustomerRestaurantPageDtoOutput',
              'deliversHere',
            ),
            menu: menu.build(),
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

        _$failedField = 'minimumOrder';
        _minimumOrder?.build();
        _$failedField = 'freeDeliveryFrom';
        _freeDeliveryFrom?.build();
        _$failedField = 'schedule';
        schedule.build();

        _$failedField = 'menu';
        menu.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRestaurantPageDtoOutput',
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
