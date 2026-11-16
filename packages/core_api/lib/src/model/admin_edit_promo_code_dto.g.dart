// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_edit_promo_code_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminEditPromoCodeDtoKindEnum _$adminEditPromoCodeDtoKindEnum_percentage =
    const AdminEditPromoCodeDtoKindEnum._('percentage');
const AdminEditPromoCodeDtoKindEnum
_$adminEditPromoCodeDtoKindEnum_fixedAmount =
    const AdminEditPromoCodeDtoKindEnum._('fixedAmount');
const AdminEditPromoCodeDtoKindEnum
_$adminEditPromoCodeDtoKindEnum_freeDelivery =
    const AdminEditPromoCodeDtoKindEnum._('freeDelivery');

AdminEditPromoCodeDtoKindEnum _$adminEditPromoCodeDtoKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'percentage':
      return _$adminEditPromoCodeDtoKindEnum_percentage;
    case 'fixedAmount':
      return _$adminEditPromoCodeDtoKindEnum_fixedAmount;
    case 'freeDelivery':
      return _$adminEditPromoCodeDtoKindEnum_freeDelivery;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminEditPromoCodeDtoKindEnum>
_$adminEditPromoCodeDtoKindEnumValues = BuiltSet<AdminEditPromoCodeDtoKindEnum>(
  const <AdminEditPromoCodeDtoKindEnum>[
    _$adminEditPromoCodeDtoKindEnum_percentage,
    _$adminEditPromoCodeDtoKindEnum_fixedAmount,
    _$adminEditPromoCodeDtoKindEnum_freeDelivery,
  ],
);

const AdminEditPromoCodeDtoAudienceEnum
_$adminEditPromoCodeDtoAudienceEnum_everyone =
    const AdminEditPromoCodeDtoAudienceEnum._('everyone');
const AdminEditPromoCodeDtoAudienceEnum
_$adminEditPromoCodeDtoAudienceEnum_newUsers =
    const AdminEditPromoCodeDtoAudienceEnum._('newUsers');

AdminEditPromoCodeDtoAudienceEnum _$adminEditPromoCodeDtoAudienceEnumValueOf(
  String name,
) {
  switch (name) {
    case 'everyone':
      return _$adminEditPromoCodeDtoAudienceEnum_everyone;
    case 'newUsers':
      return _$adminEditPromoCodeDtoAudienceEnum_newUsers;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminEditPromoCodeDtoAudienceEnum>
_$adminEditPromoCodeDtoAudienceEnumValues =
    BuiltSet<AdminEditPromoCodeDtoAudienceEnum>(
      const <AdminEditPromoCodeDtoAudienceEnum>[
        _$adminEditPromoCodeDtoAudienceEnum_everyone,
        _$adminEditPromoCodeDtoAudienceEnum_newUsers,
      ],
    );

const AdminEditPromoCodeDtoFundingEnum
_$adminEditPromoCodeDtoFundingEnum_platform =
    const AdminEditPromoCodeDtoFundingEnum._('platform');
const AdminEditPromoCodeDtoFundingEnum
_$adminEditPromoCodeDtoFundingEnum_restaurant =
    const AdminEditPromoCodeDtoFundingEnum._('restaurant');
const AdminEditPromoCodeDtoFundingEnum
_$adminEditPromoCodeDtoFundingEnum_shared =
    const AdminEditPromoCodeDtoFundingEnum._('shared');

AdminEditPromoCodeDtoFundingEnum _$adminEditPromoCodeDtoFundingEnumValueOf(
  String name,
) {
  switch (name) {
    case 'platform':
      return _$adminEditPromoCodeDtoFundingEnum_platform;
    case 'restaurant':
      return _$adminEditPromoCodeDtoFundingEnum_restaurant;
    case 'shared':
      return _$adminEditPromoCodeDtoFundingEnum_shared;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminEditPromoCodeDtoFundingEnum>
_$adminEditPromoCodeDtoFundingEnumValues =
    BuiltSet<AdminEditPromoCodeDtoFundingEnum>(
      const <AdminEditPromoCodeDtoFundingEnum>[
        _$adminEditPromoCodeDtoFundingEnum_platform,
        _$adminEditPromoCodeDtoFundingEnum_restaurant,
        _$adminEditPromoCodeDtoFundingEnum_shared,
      ],
    );

const AdminEditPromoCodeDtoVisibilityEnum
_$adminEditPromoCodeDtoVisibilityEnum_visible =
    const AdminEditPromoCodeDtoVisibilityEnum._('visible');
const AdminEditPromoCodeDtoVisibilityEnum
_$adminEditPromoCodeDtoVisibilityEnum_secret =
    const AdminEditPromoCodeDtoVisibilityEnum._('secret');

AdminEditPromoCodeDtoVisibilityEnum
_$adminEditPromoCodeDtoVisibilityEnumValueOf(String name) {
  switch (name) {
    case 'visible':
      return _$adminEditPromoCodeDtoVisibilityEnum_visible;
    case 'secret':
      return _$adminEditPromoCodeDtoVisibilityEnum_secret;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminEditPromoCodeDtoVisibilityEnum>
_$adminEditPromoCodeDtoVisibilityEnumValues =
    BuiltSet<AdminEditPromoCodeDtoVisibilityEnum>(
      const <AdminEditPromoCodeDtoVisibilityEnum>[
        _$adminEditPromoCodeDtoVisibilityEnum_visible,
        _$adminEditPromoCodeDtoVisibilityEnum_secret,
      ],
    );

Serializer<AdminEditPromoCodeDtoKindEnum>
_$adminEditPromoCodeDtoKindEnumSerializer =
    _$AdminEditPromoCodeDtoKindEnumSerializer();
Serializer<AdminEditPromoCodeDtoAudienceEnum>
_$adminEditPromoCodeDtoAudienceEnumSerializer =
    _$AdminEditPromoCodeDtoAudienceEnumSerializer();
Serializer<AdminEditPromoCodeDtoFundingEnum>
_$adminEditPromoCodeDtoFundingEnumSerializer =
    _$AdminEditPromoCodeDtoFundingEnumSerializer();
Serializer<AdminEditPromoCodeDtoVisibilityEnum>
_$adminEditPromoCodeDtoVisibilityEnumSerializer =
    _$AdminEditPromoCodeDtoVisibilityEnumSerializer();

class _$AdminEditPromoCodeDtoKindEnumSerializer
    implements PrimitiveSerializer<AdminEditPromoCodeDtoKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'percentage': 'percentage',
    'fixedAmount': 'fixed_amount',
    'freeDelivery': 'free_delivery',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'percentage': 'percentage',
    'fixed_amount': 'fixedAmount',
    'free_delivery': 'freeDelivery',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminEditPromoCodeDtoKindEnum];
  @override
  final String wireName = 'AdminEditPromoCodeDtoKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminEditPromoCodeDtoKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminEditPromoCodeDtoKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminEditPromoCodeDtoKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminEditPromoCodeDtoAudienceEnumSerializer
    implements PrimitiveSerializer<AdminEditPromoCodeDtoAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'everyone': 'everyone',
    'newUsers': 'new_users',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'everyone': 'everyone',
    'new_users': 'newUsers',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminEditPromoCodeDtoAudienceEnum];
  @override
  final String wireName = 'AdminEditPromoCodeDtoAudienceEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminEditPromoCodeDtoAudienceEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminEditPromoCodeDtoAudienceEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminEditPromoCodeDtoAudienceEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminEditPromoCodeDtoFundingEnumSerializer
    implements PrimitiveSerializer<AdminEditPromoCodeDtoFundingEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'platform': 'platform',
    'restaurant': 'restaurant',
    'shared': 'shared',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'platform': 'platform',
    'restaurant': 'restaurant',
    'shared': 'shared',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminEditPromoCodeDtoFundingEnum];
  @override
  final String wireName = 'AdminEditPromoCodeDtoFundingEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminEditPromoCodeDtoFundingEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminEditPromoCodeDtoFundingEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminEditPromoCodeDtoFundingEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminEditPromoCodeDtoVisibilityEnumSerializer
    implements PrimitiveSerializer<AdminEditPromoCodeDtoVisibilityEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'visible': 'visible',
    'secret': 'secret',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'visible': 'visible',
    'secret': 'secret',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminEditPromoCodeDtoVisibilityEnum,
  ];
  @override
  final String wireName = 'AdminEditPromoCodeDtoVisibilityEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminEditPromoCodeDtoVisibilityEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminEditPromoCodeDtoVisibilityEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminEditPromoCodeDtoVisibilityEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminEditPromoCodeDto extends AdminEditPromoCodeDto {
  @override
  final String cityId;
  @override
  final AdminEditPromoCodeDtoKindEnum kind;
  @override
  final int? percentBp;
  @override
  final String? amount;
  @override
  final String? maxDiscount;
  @override
  final String? minOrder;
  @override
  final DateTime validFrom;
  @override
  final DateTime validTo;
  @override
  final int? startMinute;
  @override
  final int? endMinute;
  @override
  final int? totalLimit;
  @override
  final int? perCustomerLimit;
  @override
  final AdminEditPromoCodeDtoAudienceEnum audience;
  @override
  final BuiltList<String> restaurantIds;
  @override
  final BuiltList<String> zoneIds;
  @override
  final AdminEditPromoCodeDtoFundingEnum funding;
  @override
  final int? sharedMerchantBp;
  @override
  final String? dailyBudget;
  @override
  final AdminEditPromoCodeDtoVisibilityEnum visibility;

  factory _$AdminEditPromoCodeDto([
    void Function(AdminEditPromoCodeDtoBuilder)? updates,
  ]) => (AdminEditPromoCodeDtoBuilder()..update(updates))._build();

  _$AdminEditPromoCodeDto._({
    required this.cityId,
    required this.kind,
    this.percentBp,
    this.amount,
    this.maxDiscount,
    this.minOrder,
    required this.validFrom,
    required this.validTo,
    this.startMinute,
    this.endMinute,
    this.totalLimit,
    this.perCustomerLimit,
    required this.audience,
    required this.restaurantIds,
    required this.zoneIds,
    required this.funding,
    this.sharedMerchantBp,
    this.dailyBudget,
    required this.visibility,
  }) : super._();
  @override
  AdminEditPromoCodeDto rebuild(
    void Function(AdminEditPromoCodeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEditPromoCodeDtoBuilder toBuilder() =>
      AdminEditPromoCodeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEditPromoCodeDto &&
        cityId == other.cityId &&
        kind == other.kind &&
        percentBp == other.percentBp &&
        amount == other.amount &&
        maxDiscount == other.maxDiscount &&
        minOrder == other.minOrder &&
        validFrom == other.validFrom &&
        validTo == other.validTo &&
        startMinute == other.startMinute &&
        endMinute == other.endMinute &&
        totalLimit == other.totalLimit &&
        perCustomerLimit == other.perCustomerLimit &&
        audience == other.audience &&
        restaurantIds == other.restaurantIds &&
        zoneIds == other.zoneIds &&
        funding == other.funding &&
        sharedMerchantBp == other.sharedMerchantBp &&
        dailyBudget == other.dailyBudget &&
        visibility == other.visibility;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, percentBp.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, maxDiscount.hashCode);
    _$hash = $jc(_$hash, minOrder.hashCode);
    _$hash = $jc(_$hash, validFrom.hashCode);
    _$hash = $jc(_$hash, validTo.hashCode);
    _$hash = $jc(_$hash, startMinute.hashCode);
    _$hash = $jc(_$hash, endMinute.hashCode);
    _$hash = $jc(_$hash, totalLimit.hashCode);
    _$hash = $jc(_$hash, perCustomerLimit.hashCode);
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, restaurantIds.hashCode);
    _$hash = $jc(_$hash, zoneIds.hashCode);
    _$hash = $jc(_$hash, funding.hashCode);
    _$hash = $jc(_$hash, sharedMerchantBp.hashCode);
    _$hash = $jc(_$hash, dailyBudget.hashCode);
    _$hash = $jc(_$hash, visibility.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminEditPromoCodeDto')
          ..add('cityId', cityId)
          ..add('kind', kind)
          ..add('percentBp', percentBp)
          ..add('amount', amount)
          ..add('maxDiscount', maxDiscount)
          ..add('minOrder', minOrder)
          ..add('validFrom', validFrom)
          ..add('validTo', validTo)
          ..add('startMinute', startMinute)
          ..add('endMinute', endMinute)
          ..add('totalLimit', totalLimit)
          ..add('perCustomerLimit', perCustomerLimit)
          ..add('audience', audience)
          ..add('restaurantIds', restaurantIds)
          ..add('zoneIds', zoneIds)
          ..add('funding', funding)
          ..add('sharedMerchantBp', sharedMerchantBp)
          ..add('dailyBudget', dailyBudget)
          ..add('visibility', visibility))
        .toString();
  }
}

class AdminEditPromoCodeDtoBuilder
    implements Builder<AdminEditPromoCodeDto, AdminEditPromoCodeDtoBuilder> {
  _$AdminEditPromoCodeDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminEditPromoCodeDtoKindEnum? _kind;
  AdminEditPromoCodeDtoKindEnum? get kind => _$this._kind;
  set kind(AdminEditPromoCodeDtoKindEnum? kind) => _$this._kind = kind;

  int? _percentBp;
  int? get percentBp => _$this._percentBp;
  set percentBp(int? percentBp) => _$this._percentBp = percentBp;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _maxDiscount;
  String? get maxDiscount => _$this._maxDiscount;
  set maxDiscount(String? maxDiscount) => _$this._maxDiscount = maxDiscount;

  String? _minOrder;
  String? get minOrder => _$this._minOrder;
  set minOrder(String? minOrder) => _$this._minOrder = minOrder;

  DateTime? _validFrom;
  DateTime? get validFrom => _$this._validFrom;
  set validFrom(DateTime? validFrom) => _$this._validFrom = validFrom;

  DateTime? _validTo;
  DateTime? get validTo => _$this._validTo;
  set validTo(DateTime? validTo) => _$this._validTo = validTo;

  int? _startMinute;
  int? get startMinute => _$this._startMinute;
  set startMinute(int? startMinute) => _$this._startMinute = startMinute;

  int? _endMinute;
  int? get endMinute => _$this._endMinute;
  set endMinute(int? endMinute) => _$this._endMinute = endMinute;

  int? _totalLimit;
  int? get totalLimit => _$this._totalLimit;
  set totalLimit(int? totalLimit) => _$this._totalLimit = totalLimit;

  int? _perCustomerLimit;
  int? get perCustomerLimit => _$this._perCustomerLimit;
  set perCustomerLimit(int? perCustomerLimit) =>
      _$this._perCustomerLimit = perCustomerLimit;

  AdminEditPromoCodeDtoAudienceEnum? _audience;
  AdminEditPromoCodeDtoAudienceEnum? get audience => _$this._audience;
  set audience(AdminEditPromoCodeDtoAudienceEnum? audience) =>
      _$this._audience = audience;

  ListBuilder<String>? _restaurantIds;
  ListBuilder<String> get restaurantIds =>
      _$this._restaurantIds ??= ListBuilder<String>();
  set restaurantIds(ListBuilder<String>? restaurantIds) =>
      _$this._restaurantIds = restaurantIds;

  ListBuilder<String>? _zoneIds;
  ListBuilder<String> get zoneIds => _$this._zoneIds ??= ListBuilder<String>();
  set zoneIds(ListBuilder<String>? zoneIds) => _$this._zoneIds = zoneIds;

  AdminEditPromoCodeDtoFundingEnum? _funding;
  AdminEditPromoCodeDtoFundingEnum? get funding => _$this._funding;
  set funding(AdminEditPromoCodeDtoFundingEnum? funding) =>
      _$this._funding = funding;

  int? _sharedMerchantBp;
  int? get sharedMerchantBp => _$this._sharedMerchantBp;
  set sharedMerchantBp(int? sharedMerchantBp) =>
      _$this._sharedMerchantBp = sharedMerchantBp;

  String? _dailyBudget;
  String? get dailyBudget => _$this._dailyBudget;
  set dailyBudget(String? dailyBudget) => _$this._dailyBudget = dailyBudget;

  AdminEditPromoCodeDtoVisibilityEnum? _visibility;
  AdminEditPromoCodeDtoVisibilityEnum? get visibility => _$this._visibility;
  set visibility(AdminEditPromoCodeDtoVisibilityEnum? visibility) =>
      _$this._visibility = visibility;

  AdminEditPromoCodeDtoBuilder() {
    AdminEditPromoCodeDto._defaults(this);
  }

  AdminEditPromoCodeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _kind = $v.kind;
      _percentBp = $v.percentBp;
      _amount = $v.amount;
      _maxDiscount = $v.maxDiscount;
      _minOrder = $v.minOrder;
      _validFrom = $v.validFrom;
      _validTo = $v.validTo;
      _startMinute = $v.startMinute;
      _endMinute = $v.endMinute;
      _totalLimit = $v.totalLimit;
      _perCustomerLimit = $v.perCustomerLimit;
      _audience = $v.audience;
      _restaurantIds = $v.restaurantIds.toBuilder();
      _zoneIds = $v.zoneIds.toBuilder();
      _funding = $v.funding;
      _sharedMerchantBp = $v.sharedMerchantBp;
      _dailyBudget = $v.dailyBudget;
      _visibility = $v.visibility;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEditPromoCodeDto other) {
    _$v = other as _$AdminEditPromoCodeDto;
  }

  @override
  void update(void Function(AdminEditPromoCodeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminEditPromoCodeDto build() => _build();

  _$AdminEditPromoCodeDto _build() {
    _$AdminEditPromoCodeDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminEditPromoCodeDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminEditPromoCodeDto',
              'cityId',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminEditPromoCodeDto',
              'kind',
            ),
            percentBp: percentBp,
            amount: amount,
            maxDiscount: maxDiscount,
            minOrder: minOrder,
            validFrom: BuiltValueNullFieldError.checkNotNull(
              validFrom,
              r'AdminEditPromoCodeDto',
              'validFrom',
            ),
            validTo: BuiltValueNullFieldError.checkNotNull(
              validTo,
              r'AdminEditPromoCodeDto',
              'validTo',
            ),
            startMinute: startMinute,
            endMinute: endMinute,
            totalLimit: totalLimit,
            perCustomerLimit: perCustomerLimit,
            audience: BuiltValueNullFieldError.checkNotNull(
              audience,
              r'AdminEditPromoCodeDto',
              'audience',
            ),
            restaurantIds: restaurantIds.build(),
            zoneIds: zoneIds.build(),
            funding: BuiltValueNullFieldError.checkNotNull(
              funding,
              r'AdminEditPromoCodeDto',
              'funding',
            ),
            sharedMerchantBp: sharedMerchantBp,
            dailyBudget: dailyBudget,
            visibility: BuiltValueNullFieldError.checkNotNull(
              visibility,
              r'AdminEditPromoCodeDto',
              'visibility',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurantIds';
        restaurantIds.build();
        _$failedField = 'zoneIds';
        zoneIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminEditPromoCodeDto',
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
