// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_create_promo_code_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCreatePromoCodeDtoKindEnum
_$adminCreatePromoCodeDtoKindEnum_percentage =
    const AdminCreatePromoCodeDtoKindEnum._('percentage');
const AdminCreatePromoCodeDtoKindEnum
_$adminCreatePromoCodeDtoKindEnum_fixedAmount =
    const AdminCreatePromoCodeDtoKindEnum._('fixedAmount');
const AdminCreatePromoCodeDtoKindEnum
_$adminCreatePromoCodeDtoKindEnum_freeDelivery =
    const AdminCreatePromoCodeDtoKindEnum._('freeDelivery');

AdminCreatePromoCodeDtoKindEnum _$adminCreatePromoCodeDtoKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'percentage':
      return _$adminCreatePromoCodeDtoKindEnum_percentage;
    case 'fixedAmount':
      return _$adminCreatePromoCodeDtoKindEnum_fixedAmount;
    case 'freeDelivery':
      return _$adminCreatePromoCodeDtoKindEnum_freeDelivery;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCreatePromoCodeDtoKindEnum>
_$adminCreatePromoCodeDtoKindEnumValues =
    BuiltSet<AdminCreatePromoCodeDtoKindEnum>(
      const <AdminCreatePromoCodeDtoKindEnum>[
        _$adminCreatePromoCodeDtoKindEnum_percentage,
        _$adminCreatePromoCodeDtoKindEnum_fixedAmount,
        _$adminCreatePromoCodeDtoKindEnum_freeDelivery,
      ],
    );

const AdminCreatePromoCodeDtoAudienceEnum
_$adminCreatePromoCodeDtoAudienceEnum_everyone =
    const AdminCreatePromoCodeDtoAudienceEnum._('everyone');
const AdminCreatePromoCodeDtoAudienceEnum
_$adminCreatePromoCodeDtoAudienceEnum_newUsers =
    const AdminCreatePromoCodeDtoAudienceEnum._('newUsers');

AdminCreatePromoCodeDtoAudienceEnum
_$adminCreatePromoCodeDtoAudienceEnumValueOf(String name) {
  switch (name) {
    case 'everyone':
      return _$adminCreatePromoCodeDtoAudienceEnum_everyone;
    case 'newUsers':
      return _$adminCreatePromoCodeDtoAudienceEnum_newUsers;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCreatePromoCodeDtoAudienceEnum>
_$adminCreatePromoCodeDtoAudienceEnumValues =
    BuiltSet<AdminCreatePromoCodeDtoAudienceEnum>(
      const <AdminCreatePromoCodeDtoAudienceEnum>[
        _$adminCreatePromoCodeDtoAudienceEnum_everyone,
        _$adminCreatePromoCodeDtoAudienceEnum_newUsers,
      ],
    );

const AdminCreatePromoCodeDtoFundingEnum
_$adminCreatePromoCodeDtoFundingEnum_platform =
    const AdminCreatePromoCodeDtoFundingEnum._('platform');
const AdminCreatePromoCodeDtoFundingEnum
_$adminCreatePromoCodeDtoFundingEnum_restaurant =
    const AdminCreatePromoCodeDtoFundingEnum._('restaurant');
const AdminCreatePromoCodeDtoFundingEnum
_$adminCreatePromoCodeDtoFundingEnum_shared =
    const AdminCreatePromoCodeDtoFundingEnum._('shared');

AdminCreatePromoCodeDtoFundingEnum _$adminCreatePromoCodeDtoFundingEnumValueOf(
  String name,
) {
  switch (name) {
    case 'platform':
      return _$adminCreatePromoCodeDtoFundingEnum_platform;
    case 'restaurant':
      return _$adminCreatePromoCodeDtoFundingEnum_restaurant;
    case 'shared':
      return _$adminCreatePromoCodeDtoFundingEnum_shared;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCreatePromoCodeDtoFundingEnum>
_$adminCreatePromoCodeDtoFundingEnumValues =
    BuiltSet<AdminCreatePromoCodeDtoFundingEnum>(
      const <AdminCreatePromoCodeDtoFundingEnum>[
        _$adminCreatePromoCodeDtoFundingEnum_platform,
        _$adminCreatePromoCodeDtoFundingEnum_restaurant,
        _$adminCreatePromoCodeDtoFundingEnum_shared,
      ],
    );

const AdminCreatePromoCodeDtoVisibilityEnum
_$adminCreatePromoCodeDtoVisibilityEnum_visible =
    const AdminCreatePromoCodeDtoVisibilityEnum._('visible');
const AdminCreatePromoCodeDtoVisibilityEnum
_$adminCreatePromoCodeDtoVisibilityEnum_secret =
    const AdminCreatePromoCodeDtoVisibilityEnum._('secret');

AdminCreatePromoCodeDtoVisibilityEnum
_$adminCreatePromoCodeDtoVisibilityEnumValueOf(String name) {
  switch (name) {
    case 'visible':
      return _$adminCreatePromoCodeDtoVisibilityEnum_visible;
    case 'secret':
      return _$adminCreatePromoCodeDtoVisibilityEnum_secret;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCreatePromoCodeDtoVisibilityEnum>
_$adminCreatePromoCodeDtoVisibilityEnumValues =
    BuiltSet<AdminCreatePromoCodeDtoVisibilityEnum>(
      const <AdminCreatePromoCodeDtoVisibilityEnum>[
        _$adminCreatePromoCodeDtoVisibilityEnum_visible,
        _$adminCreatePromoCodeDtoVisibilityEnum_secret,
      ],
    );

Serializer<AdminCreatePromoCodeDtoKindEnum>
_$adminCreatePromoCodeDtoKindEnumSerializer =
    _$AdminCreatePromoCodeDtoKindEnumSerializer();
Serializer<AdminCreatePromoCodeDtoAudienceEnum>
_$adminCreatePromoCodeDtoAudienceEnumSerializer =
    _$AdminCreatePromoCodeDtoAudienceEnumSerializer();
Serializer<AdminCreatePromoCodeDtoFundingEnum>
_$adminCreatePromoCodeDtoFundingEnumSerializer =
    _$AdminCreatePromoCodeDtoFundingEnumSerializer();
Serializer<AdminCreatePromoCodeDtoVisibilityEnum>
_$adminCreatePromoCodeDtoVisibilityEnumSerializer =
    _$AdminCreatePromoCodeDtoVisibilityEnumSerializer();

class _$AdminCreatePromoCodeDtoKindEnumSerializer
    implements PrimitiveSerializer<AdminCreatePromoCodeDtoKindEnum> {
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
  final Iterable<Type> types = const <Type>[AdminCreatePromoCodeDtoKindEnum];
  @override
  final String wireName = 'AdminCreatePromoCodeDtoKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCreatePromoCodeDtoKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCreatePromoCodeDtoKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCreatePromoCodeDtoKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCreatePromoCodeDtoAudienceEnumSerializer
    implements PrimitiveSerializer<AdminCreatePromoCodeDtoAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'everyone': 'everyone',
    'newUsers': 'new_users',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'everyone': 'everyone',
    'new_users': 'newUsers',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCreatePromoCodeDtoAudienceEnum,
  ];
  @override
  final String wireName = 'AdminCreatePromoCodeDtoAudienceEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCreatePromoCodeDtoAudienceEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCreatePromoCodeDtoAudienceEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCreatePromoCodeDtoAudienceEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCreatePromoCodeDtoFundingEnumSerializer
    implements PrimitiveSerializer<AdminCreatePromoCodeDtoFundingEnum> {
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
  final Iterable<Type> types = const <Type>[AdminCreatePromoCodeDtoFundingEnum];
  @override
  final String wireName = 'AdminCreatePromoCodeDtoFundingEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCreatePromoCodeDtoFundingEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCreatePromoCodeDtoFundingEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCreatePromoCodeDtoFundingEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCreatePromoCodeDtoVisibilityEnumSerializer
    implements PrimitiveSerializer<AdminCreatePromoCodeDtoVisibilityEnum> {
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
    AdminCreatePromoCodeDtoVisibilityEnum,
  ];
  @override
  final String wireName = 'AdminCreatePromoCodeDtoVisibilityEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCreatePromoCodeDtoVisibilityEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCreatePromoCodeDtoVisibilityEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCreatePromoCodeDtoVisibilityEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCreatePromoCodeDto extends AdminCreatePromoCodeDto {
  @override
  final String cityId;
  @override
  final String code;
  @override
  final AdminCreatePromoCodeDtoKindEnum kind;
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
  final AdminCreatePromoCodeDtoAudienceEnum audience;
  @override
  final BuiltList<String> restaurantIds;
  @override
  final BuiltList<String> zoneIds;
  @override
  final AdminCreatePromoCodeDtoFundingEnum funding;
  @override
  final int? sharedMerchantBp;
  @override
  final String? dailyBudget;
  @override
  final AdminCreatePromoCodeDtoVisibilityEnum visibility;

  factory _$AdminCreatePromoCodeDto([
    void Function(AdminCreatePromoCodeDtoBuilder)? updates,
  ]) => (AdminCreatePromoCodeDtoBuilder()..update(updates))._build();

  _$AdminCreatePromoCodeDto._({
    required this.cityId,
    required this.code,
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
  AdminCreatePromoCodeDto rebuild(
    void Function(AdminCreatePromoCodeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCreatePromoCodeDtoBuilder toBuilder() =>
      AdminCreatePromoCodeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCreatePromoCodeDto &&
        cityId == other.cityId &&
        code == other.code &&
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
    _$hash = $jc(_$hash, code.hashCode);
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
    return (newBuiltValueToStringHelper(r'AdminCreatePromoCodeDto')
          ..add('cityId', cityId)
          ..add('code', code)
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

class AdminCreatePromoCodeDtoBuilder
    implements
        Builder<AdminCreatePromoCodeDto, AdminCreatePromoCodeDtoBuilder> {
  _$AdminCreatePromoCodeDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  AdminCreatePromoCodeDtoKindEnum? _kind;
  AdminCreatePromoCodeDtoKindEnum? get kind => _$this._kind;
  set kind(AdminCreatePromoCodeDtoKindEnum? kind) => _$this._kind = kind;

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

  AdminCreatePromoCodeDtoAudienceEnum? _audience;
  AdminCreatePromoCodeDtoAudienceEnum? get audience => _$this._audience;
  set audience(AdminCreatePromoCodeDtoAudienceEnum? audience) =>
      _$this._audience = audience;

  ListBuilder<String>? _restaurantIds;
  ListBuilder<String> get restaurantIds =>
      _$this._restaurantIds ??= ListBuilder<String>();
  set restaurantIds(ListBuilder<String>? restaurantIds) =>
      _$this._restaurantIds = restaurantIds;

  ListBuilder<String>? _zoneIds;
  ListBuilder<String> get zoneIds => _$this._zoneIds ??= ListBuilder<String>();
  set zoneIds(ListBuilder<String>? zoneIds) => _$this._zoneIds = zoneIds;

  AdminCreatePromoCodeDtoFundingEnum? _funding;
  AdminCreatePromoCodeDtoFundingEnum? get funding => _$this._funding;
  set funding(AdminCreatePromoCodeDtoFundingEnum? funding) =>
      _$this._funding = funding;

  int? _sharedMerchantBp;
  int? get sharedMerchantBp => _$this._sharedMerchantBp;
  set sharedMerchantBp(int? sharedMerchantBp) =>
      _$this._sharedMerchantBp = sharedMerchantBp;

  String? _dailyBudget;
  String? get dailyBudget => _$this._dailyBudget;
  set dailyBudget(String? dailyBudget) => _$this._dailyBudget = dailyBudget;

  AdminCreatePromoCodeDtoVisibilityEnum? _visibility;
  AdminCreatePromoCodeDtoVisibilityEnum? get visibility => _$this._visibility;
  set visibility(AdminCreatePromoCodeDtoVisibilityEnum? visibility) =>
      _$this._visibility = visibility;

  AdminCreatePromoCodeDtoBuilder() {
    AdminCreatePromoCodeDto._defaults(this);
  }

  AdminCreatePromoCodeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _code = $v.code;
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
  void replace(AdminCreatePromoCodeDto other) {
    _$v = other as _$AdminCreatePromoCodeDto;
  }

  @override
  void update(void Function(AdminCreatePromoCodeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCreatePromoCodeDto build() => _build();

  _$AdminCreatePromoCodeDto _build() {
    _$AdminCreatePromoCodeDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminCreatePromoCodeDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminCreatePromoCodeDto',
              'cityId',
            ),
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'AdminCreatePromoCodeDto',
              'code',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminCreatePromoCodeDto',
              'kind',
            ),
            percentBp: percentBp,
            amount: amount,
            maxDiscount: maxDiscount,
            minOrder: minOrder,
            validFrom: BuiltValueNullFieldError.checkNotNull(
              validFrom,
              r'AdminCreatePromoCodeDto',
              'validFrom',
            ),
            validTo: BuiltValueNullFieldError.checkNotNull(
              validTo,
              r'AdminCreatePromoCodeDto',
              'validTo',
            ),
            startMinute: startMinute,
            endMinute: endMinute,
            totalLimit: totalLimit,
            perCustomerLimit: perCustomerLimit,
            audience: BuiltValueNullFieldError.checkNotNull(
              audience,
              r'AdminCreatePromoCodeDto',
              'audience',
            ),
            restaurantIds: restaurantIds.build(),
            zoneIds: zoneIds.build(),
            funding: BuiltValueNullFieldError.checkNotNull(
              funding,
              r'AdminCreatePromoCodeDto',
              'funding',
            ),
            sharedMerchantBp: sharedMerchantBp,
            dailyBudget: dailyBudget,
            visibility: BuiltValueNullFieldError.checkNotNull(
              visibility,
              r'AdminCreatePromoCodeDto',
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
          r'AdminCreatePromoCodeDto',
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
