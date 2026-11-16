// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_generate_promo_codes_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminGeneratePromoCodesDtoKindEnum
_$adminGeneratePromoCodesDtoKindEnum_percentage =
    const AdminGeneratePromoCodesDtoKindEnum._('percentage');
const AdminGeneratePromoCodesDtoKindEnum
_$adminGeneratePromoCodesDtoKindEnum_fixedAmount =
    const AdminGeneratePromoCodesDtoKindEnum._('fixedAmount');
const AdminGeneratePromoCodesDtoKindEnum
_$adminGeneratePromoCodesDtoKindEnum_freeDelivery =
    const AdminGeneratePromoCodesDtoKindEnum._('freeDelivery');

AdminGeneratePromoCodesDtoKindEnum _$adminGeneratePromoCodesDtoKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'percentage':
      return _$adminGeneratePromoCodesDtoKindEnum_percentage;
    case 'fixedAmount':
      return _$adminGeneratePromoCodesDtoKindEnum_fixedAmount;
    case 'freeDelivery':
      return _$adminGeneratePromoCodesDtoKindEnum_freeDelivery;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminGeneratePromoCodesDtoKindEnum>
_$adminGeneratePromoCodesDtoKindEnumValues =
    BuiltSet<AdminGeneratePromoCodesDtoKindEnum>(
      const <AdminGeneratePromoCodesDtoKindEnum>[
        _$adminGeneratePromoCodesDtoKindEnum_percentage,
        _$adminGeneratePromoCodesDtoKindEnum_fixedAmount,
        _$adminGeneratePromoCodesDtoKindEnum_freeDelivery,
      ],
    );

const AdminGeneratePromoCodesDtoAudienceEnum
_$adminGeneratePromoCodesDtoAudienceEnum_everyone =
    const AdminGeneratePromoCodesDtoAudienceEnum._('everyone');
const AdminGeneratePromoCodesDtoAudienceEnum
_$adminGeneratePromoCodesDtoAudienceEnum_newUsers =
    const AdminGeneratePromoCodesDtoAudienceEnum._('newUsers');

AdminGeneratePromoCodesDtoAudienceEnum
_$adminGeneratePromoCodesDtoAudienceEnumValueOf(String name) {
  switch (name) {
    case 'everyone':
      return _$adminGeneratePromoCodesDtoAudienceEnum_everyone;
    case 'newUsers':
      return _$adminGeneratePromoCodesDtoAudienceEnum_newUsers;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminGeneratePromoCodesDtoAudienceEnum>
_$adminGeneratePromoCodesDtoAudienceEnumValues =
    BuiltSet<AdminGeneratePromoCodesDtoAudienceEnum>(
      const <AdminGeneratePromoCodesDtoAudienceEnum>[
        _$adminGeneratePromoCodesDtoAudienceEnum_everyone,
        _$adminGeneratePromoCodesDtoAudienceEnum_newUsers,
      ],
    );

const AdminGeneratePromoCodesDtoFundingEnum
_$adminGeneratePromoCodesDtoFundingEnum_platform =
    const AdminGeneratePromoCodesDtoFundingEnum._('platform');
const AdminGeneratePromoCodesDtoFundingEnum
_$adminGeneratePromoCodesDtoFundingEnum_restaurant =
    const AdminGeneratePromoCodesDtoFundingEnum._('restaurant');
const AdminGeneratePromoCodesDtoFundingEnum
_$adminGeneratePromoCodesDtoFundingEnum_shared =
    const AdminGeneratePromoCodesDtoFundingEnum._('shared');

AdminGeneratePromoCodesDtoFundingEnum
_$adminGeneratePromoCodesDtoFundingEnumValueOf(String name) {
  switch (name) {
    case 'platform':
      return _$adminGeneratePromoCodesDtoFundingEnum_platform;
    case 'restaurant':
      return _$adminGeneratePromoCodesDtoFundingEnum_restaurant;
    case 'shared':
      return _$adminGeneratePromoCodesDtoFundingEnum_shared;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminGeneratePromoCodesDtoFundingEnum>
_$adminGeneratePromoCodesDtoFundingEnumValues =
    BuiltSet<AdminGeneratePromoCodesDtoFundingEnum>(
      const <AdminGeneratePromoCodesDtoFundingEnum>[
        _$adminGeneratePromoCodesDtoFundingEnum_platform,
        _$adminGeneratePromoCodesDtoFundingEnum_restaurant,
        _$adminGeneratePromoCodesDtoFundingEnum_shared,
      ],
    );

const AdminGeneratePromoCodesDtoVisibilityEnum
_$adminGeneratePromoCodesDtoVisibilityEnum_visible =
    const AdminGeneratePromoCodesDtoVisibilityEnum._('visible');
const AdminGeneratePromoCodesDtoVisibilityEnum
_$adminGeneratePromoCodesDtoVisibilityEnum_secret =
    const AdminGeneratePromoCodesDtoVisibilityEnum._('secret');

AdminGeneratePromoCodesDtoVisibilityEnum
_$adminGeneratePromoCodesDtoVisibilityEnumValueOf(String name) {
  switch (name) {
    case 'visible':
      return _$adminGeneratePromoCodesDtoVisibilityEnum_visible;
    case 'secret':
      return _$adminGeneratePromoCodesDtoVisibilityEnum_secret;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminGeneratePromoCodesDtoVisibilityEnum>
_$adminGeneratePromoCodesDtoVisibilityEnumValues =
    BuiltSet<AdminGeneratePromoCodesDtoVisibilityEnum>(
      const <AdminGeneratePromoCodesDtoVisibilityEnum>[
        _$adminGeneratePromoCodesDtoVisibilityEnum_visible,
        _$adminGeneratePromoCodesDtoVisibilityEnum_secret,
      ],
    );

Serializer<AdminGeneratePromoCodesDtoKindEnum>
_$adminGeneratePromoCodesDtoKindEnumSerializer =
    _$AdminGeneratePromoCodesDtoKindEnumSerializer();
Serializer<AdminGeneratePromoCodesDtoAudienceEnum>
_$adminGeneratePromoCodesDtoAudienceEnumSerializer =
    _$AdminGeneratePromoCodesDtoAudienceEnumSerializer();
Serializer<AdminGeneratePromoCodesDtoFundingEnum>
_$adminGeneratePromoCodesDtoFundingEnumSerializer =
    _$AdminGeneratePromoCodesDtoFundingEnumSerializer();
Serializer<AdminGeneratePromoCodesDtoVisibilityEnum>
_$adminGeneratePromoCodesDtoVisibilityEnumSerializer =
    _$AdminGeneratePromoCodesDtoVisibilityEnumSerializer();

class _$AdminGeneratePromoCodesDtoKindEnumSerializer
    implements PrimitiveSerializer<AdminGeneratePromoCodesDtoKindEnum> {
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
  final Iterable<Type> types = const <Type>[AdminGeneratePromoCodesDtoKindEnum];
  @override
  final String wireName = 'AdminGeneratePromoCodesDtoKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminGeneratePromoCodesDtoKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminGeneratePromoCodesDtoKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminGeneratePromoCodesDtoKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminGeneratePromoCodesDtoAudienceEnumSerializer
    implements PrimitiveSerializer<AdminGeneratePromoCodesDtoAudienceEnum> {
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
    AdminGeneratePromoCodesDtoAudienceEnum,
  ];
  @override
  final String wireName = 'AdminGeneratePromoCodesDtoAudienceEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminGeneratePromoCodesDtoAudienceEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminGeneratePromoCodesDtoAudienceEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminGeneratePromoCodesDtoAudienceEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminGeneratePromoCodesDtoFundingEnumSerializer
    implements PrimitiveSerializer<AdminGeneratePromoCodesDtoFundingEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminGeneratePromoCodesDtoFundingEnum,
  ];
  @override
  final String wireName = 'AdminGeneratePromoCodesDtoFundingEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminGeneratePromoCodesDtoFundingEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminGeneratePromoCodesDtoFundingEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminGeneratePromoCodesDtoFundingEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminGeneratePromoCodesDtoVisibilityEnumSerializer
    implements PrimitiveSerializer<AdminGeneratePromoCodesDtoVisibilityEnum> {
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
    AdminGeneratePromoCodesDtoVisibilityEnum,
  ];
  @override
  final String wireName = 'AdminGeneratePromoCodesDtoVisibilityEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminGeneratePromoCodesDtoVisibilityEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminGeneratePromoCodesDtoVisibilityEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminGeneratePromoCodesDtoVisibilityEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminGeneratePromoCodesDto extends AdminGeneratePromoCodesDto {
  @override
  final String cityId;
  @override
  final int count;
  @override
  final String prefix;
  @override
  final AdminGeneratePromoCodesDtoKindEnum kind;
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
  final AdminGeneratePromoCodesDtoAudienceEnum audience;
  @override
  final BuiltList<String> restaurantIds;
  @override
  final BuiltList<String> zoneIds;
  @override
  final AdminGeneratePromoCodesDtoFundingEnum funding;
  @override
  final int? sharedMerchantBp;
  @override
  final String? dailyBudget;
  @override
  final AdminGeneratePromoCodesDtoVisibilityEnum visibility;

  factory _$AdminGeneratePromoCodesDto([
    void Function(AdminGeneratePromoCodesDtoBuilder)? updates,
  ]) => (AdminGeneratePromoCodesDtoBuilder()..update(updates))._build();

  _$AdminGeneratePromoCodesDto._({
    required this.cityId,
    required this.count,
    required this.prefix,
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
  AdminGeneratePromoCodesDto rebuild(
    void Function(AdminGeneratePromoCodesDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminGeneratePromoCodesDtoBuilder toBuilder() =>
      AdminGeneratePromoCodesDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminGeneratePromoCodesDto &&
        cityId == other.cityId &&
        count == other.count &&
        prefix == other.prefix &&
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
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, prefix.hashCode);
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
    return (newBuiltValueToStringHelper(r'AdminGeneratePromoCodesDto')
          ..add('cityId', cityId)
          ..add('count', count)
          ..add('prefix', prefix)
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

class AdminGeneratePromoCodesDtoBuilder
    implements
        Builder<AdminGeneratePromoCodesDto, AdminGeneratePromoCodesDtoBuilder> {
  _$AdminGeneratePromoCodesDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  String? _prefix;
  String? get prefix => _$this._prefix;
  set prefix(String? prefix) => _$this._prefix = prefix;

  AdminGeneratePromoCodesDtoKindEnum? _kind;
  AdminGeneratePromoCodesDtoKindEnum? get kind => _$this._kind;
  set kind(AdminGeneratePromoCodesDtoKindEnum? kind) => _$this._kind = kind;

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

  AdminGeneratePromoCodesDtoAudienceEnum? _audience;
  AdminGeneratePromoCodesDtoAudienceEnum? get audience => _$this._audience;
  set audience(AdminGeneratePromoCodesDtoAudienceEnum? audience) =>
      _$this._audience = audience;

  ListBuilder<String>? _restaurantIds;
  ListBuilder<String> get restaurantIds =>
      _$this._restaurantIds ??= ListBuilder<String>();
  set restaurantIds(ListBuilder<String>? restaurantIds) =>
      _$this._restaurantIds = restaurantIds;

  ListBuilder<String>? _zoneIds;
  ListBuilder<String> get zoneIds => _$this._zoneIds ??= ListBuilder<String>();
  set zoneIds(ListBuilder<String>? zoneIds) => _$this._zoneIds = zoneIds;

  AdminGeneratePromoCodesDtoFundingEnum? _funding;
  AdminGeneratePromoCodesDtoFundingEnum? get funding => _$this._funding;
  set funding(AdminGeneratePromoCodesDtoFundingEnum? funding) =>
      _$this._funding = funding;

  int? _sharedMerchantBp;
  int? get sharedMerchantBp => _$this._sharedMerchantBp;
  set sharedMerchantBp(int? sharedMerchantBp) =>
      _$this._sharedMerchantBp = sharedMerchantBp;

  String? _dailyBudget;
  String? get dailyBudget => _$this._dailyBudget;
  set dailyBudget(String? dailyBudget) => _$this._dailyBudget = dailyBudget;

  AdminGeneratePromoCodesDtoVisibilityEnum? _visibility;
  AdminGeneratePromoCodesDtoVisibilityEnum? get visibility =>
      _$this._visibility;
  set visibility(AdminGeneratePromoCodesDtoVisibilityEnum? visibility) =>
      _$this._visibility = visibility;

  AdminGeneratePromoCodesDtoBuilder() {
    AdminGeneratePromoCodesDto._defaults(this);
  }

  AdminGeneratePromoCodesDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _count = $v.count;
      _prefix = $v.prefix;
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
  void replace(AdminGeneratePromoCodesDto other) {
    _$v = other as _$AdminGeneratePromoCodesDto;
  }

  @override
  void update(void Function(AdminGeneratePromoCodesDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminGeneratePromoCodesDto build() => _build();

  _$AdminGeneratePromoCodesDto _build() {
    _$AdminGeneratePromoCodesDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminGeneratePromoCodesDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminGeneratePromoCodesDto',
              'cityId',
            ),
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'AdminGeneratePromoCodesDto',
              'count',
            ),
            prefix: BuiltValueNullFieldError.checkNotNull(
              prefix,
              r'AdminGeneratePromoCodesDto',
              'prefix',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminGeneratePromoCodesDto',
              'kind',
            ),
            percentBp: percentBp,
            amount: amount,
            maxDiscount: maxDiscount,
            minOrder: minOrder,
            validFrom: BuiltValueNullFieldError.checkNotNull(
              validFrom,
              r'AdminGeneratePromoCodesDto',
              'validFrom',
            ),
            validTo: BuiltValueNullFieldError.checkNotNull(
              validTo,
              r'AdminGeneratePromoCodesDto',
              'validTo',
            ),
            startMinute: startMinute,
            endMinute: endMinute,
            totalLimit: totalLimit,
            perCustomerLimit: perCustomerLimit,
            audience: BuiltValueNullFieldError.checkNotNull(
              audience,
              r'AdminGeneratePromoCodesDto',
              'audience',
            ),
            restaurantIds: restaurantIds.build(),
            zoneIds: zoneIds.build(),
            funding: BuiltValueNullFieldError.checkNotNull(
              funding,
              r'AdminGeneratePromoCodesDto',
              'funding',
            ),
            sharedMerchantBp: sharedMerchantBp,
            dailyBudget: dailyBudget,
            visibility: BuiltValueNullFieldError.checkNotNull(
              visibility,
              r'AdminGeneratePromoCodesDto',
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
          r'AdminGeneratePromoCodesDto',
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
