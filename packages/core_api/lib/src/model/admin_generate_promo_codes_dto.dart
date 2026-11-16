//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_generate_promo_codes_dto.g.dart';

/// AdminGeneratePromoCodesDto
///
/// Properties:
/// * [cityId]
/// * [count]
/// * [prefix] - Before 8 random characters; may be empty.
/// * [kind]
/// * [percentBp] - A percentage code: 2000 is 20%.
/// * [amount] - A fixed-amount code: minor units of the base currency.
/// * [maxDiscount] - A percentage code's cap, or null for none.
/// * [minOrder] - On the items value before discounts; null for none.
/// * [validFrom]
/// * [validTo]
/// * [startMinute] - Optional hours: minutes from midnight on the city clock, 20:00 is 1200.
/// * [endMinute] - At or before the start, the hours run past midnight.
/// * [totalLimit] - Null: no limit.
/// * [perCustomerLimit] - Null: no limit.
/// * [audience]
/// * [restaurantIds] - None: every restaurant.
/// * [zoneIds] - None: every zone.
/// * [funding]
/// * [sharedMerchantBp] - A shared code: the restaurant's share, 4000 is 40%; null otherwise.
/// * [dailyBudget] - Pauses the code for the business day; null for none.
/// * [visibility]
@BuiltValue()
abstract class AdminGeneratePromoCodesDto
    implements
        Built<AdminGeneratePromoCodesDto, AdminGeneratePromoCodesDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'count')
  int get count;

  /// Before 8 random characters; may be empty.
  @BuiltValueField(wireName: r'prefix')
  String get prefix;

  @BuiltValueField(wireName: r'kind')
  AdminGeneratePromoCodesDtoKindEnum get kind;
  // enum kindEnum {  percentage,  fixed_amount,  free_delivery,  };

  /// A percentage code: 2000 is 20%.
  @BuiltValueField(wireName: r'percentBp')
  int? get percentBp;

  /// A fixed-amount code: minor units of the base currency.
  @BuiltValueField(wireName: r'amount')
  String? get amount;

  /// A percentage code's cap, or null for none.
  @BuiltValueField(wireName: r'maxDiscount')
  String? get maxDiscount;

  /// On the items value before discounts; null for none.
  @BuiltValueField(wireName: r'minOrder')
  String? get minOrder;

  @BuiltValueField(wireName: r'validFrom')
  DateTime get validFrom;

  @BuiltValueField(wireName: r'validTo')
  DateTime get validTo;

  /// Optional hours: minutes from midnight on the city clock, 20:00 is 1200.
  @BuiltValueField(wireName: r'startMinute')
  int? get startMinute;

  /// At or before the start, the hours run past midnight.
  @BuiltValueField(wireName: r'endMinute')
  int? get endMinute;

  /// Null: no limit.
  @BuiltValueField(wireName: r'totalLimit')
  int? get totalLimit;

  /// Null: no limit.
  @BuiltValueField(wireName: r'perCustomerLimit')
  int? get perCustomerLimit;

  @BuiltValueField(wireName: r'audience')
  AdminGeneratePromoCodesDtoAudienceEnum get audience;
  // enum audienceEnum {  everyone,  new_users,  };

  /// None: every restaurant.
  @BuiltValueField(wireName: r'restaurantIds')
  BuiltList<String> get restaurantIds;

  /// None: every zone.
  @BuiltValueField(wireName: r'zoneIds')
  BuiltList<String> get zoneIds;

  @BuiltValueField(wireName: r'funding')
  AdminGeneratePromoCodesDtoFundingEnum get funding;
  // enum fundingEnum {  platform,  restaurant,  shared,  };

  /// A shared code: the restaurant's share, 4000 is 40%; null otherwise.
  @BuiltValueField(wireName: r'sharedMerchantBp')
  int? get sharedMerchantBp;

  /// Pauses the code for the business day; null for none.
  @BuiltValueField(wireName: r'dailyBudget')
  String? get dailyBudget;

  @BuiltValueField(wireName: r'visibility')
  AdminGeneratePromoCodesDtoVisibilityEnum get visibility;
  // enum visibilityEnum {  visible,  secret,  };

  AdminGeneratePromoCodesDto._();

  factory AdminGeneratePromoCodesDto([
    void updates(AdminGeneratePromoCodesDtoBuilder b),
  ]) = _$AdminGeneratePromoCodesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminGeneratePromoCodesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminGeneratePromoCodesDto> get serializer =>
      _$AdminGeneratePromoCodesDtoSerializer();
}

class _$AdminGeneratePromoCodesDtoSerializer
    implements PrimitiveSerializer<AdminGeneratePromoCodesDto> {
  @override
  final Iterable<Type> types = const [
    AdminGeneratePromoCodesDto,
    _$AdminGeneratePromoCodesDto,
  ];

  @override
  final String wireName = r'AdminGeneratePromoCodesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminGeneratePromoCodesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'prefix';
    yield serializers.serialize(
      object.prefix,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminGeneratePromoCodesDtoKindEnum),
    );
    yield r'percentBp';
    yield object.percentBp == null
        ? null
        : serializers.serialize(
            object.percentBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'maxDiscount';
    yield object.maxDiscount == null
        ? null
        : serializers.serialize(
            object.maxDiscount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'minOrder';
    yield object.minOrder == null
        ? null
        : serializers.serialize(
            object.minOrder,
            specifiedType: const FullType.nullable(String),
          );
    yield r'validFrom';
    yield serializers.serialize(
      object.validFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'validTo';
    yield serializers.serialize(
      object.validTo,
      specifiedType: const FullType(DateTime),
    );
    yield r'startMinute';
    yield object.startMinute == null
        ? null
        : serializers.serialize(
            object.startMinute,
            specifiedType: const FullType.nullable(int),
          );
    yield r'endMinute';
    yield object.endMinute == null
        ? null
        : serializers.serialize(
            object.endMinute,
            specifiedType: const FullType.nullable(int),
          );
    yield r'totalLimit';
    yield object.totalLimit == null
        ? null
        : serializers.serialize(
            object.totalLimit,
            specifiedType: const FullType.nullable(int),
          );
    yield r'perCustomerLimit';
    yield object.perCustomerLimit == null
        ? null
        : serializers.serialize(
            object.perCustomerLimit,
            specifiedType: const FullType.nullable(int),
          );
    yield r'audience';
    yield serializers.serialize(
      object.audience,
      specifiedType: const FullType(AdminGeneratePromoCodesDtoAudienceEnum),
    );
    yield r'restaurantIds';
    yield serializers.serialize(
      object.restaurantIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'zoneIds';
    yield serializers.serialize(
      object.zoneIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'funding';
    yield serializers.serialize(
      object.funding,
      specifiedType: const FullType(AdminGeneratePromoCodesDtoFundingEnum),
    );
    yield r'sharedMerchantBp';
    yield object.sharedMerchantBp == null
        ? null
        : serializers.serialize(
            object.sharedMerchantBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'dailyBudget';
    yield object.dailyBudget == null
        ? null
        : serializers.serialize(
            object.dailyBudget,
            specifiedType: const FullType.nullable(String),
          );
    yield r'visibility';
    yield serializers.serialize(
      object.visibility,
      specifiedType: const FullType(AdminGeneratePromoCodesDtoVisibilityEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminGeneratePromoCodesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(
      serializers,
      object,
      specifiedType: specifiedType,
    ).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminGeneratePromoCodesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.count = valueDes;
          break;
        case r'prefix':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.prefix = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminGeneratePromoCodesDtoKindEnum,
                    ),
                  )
                  as AdminGeneratePromoCodesDtoKindEnum;
          result.kind = valueDes;
          break;
        case r'percentBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.percentBp = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.amount = valueDes;
          break;
        case r'maxDiscount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.maxDiscount = valueDes;
          break;
        case r'minOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.minOrder = valueDes;
          break;
        case r'validFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.validFrom = valueDes;
          break;
        case r'validTo':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.validTo = valueDes;
          break;
        case r'startMinute':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.startMinute = valueDes;
          break;
        case r'endMinute':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.endMinute = valueDes;
          break;
        case r'totalLimit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.totalLimit = valueDes;
          break;
        case r'perCustomerLimit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.perCustomerLimit = valueDes;
          break;
        case r'audience':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminGeneratePromoCodesDtoAudienceEnum,
                    ),
                  )
                  as AdminGeneratePromoCodesDtoAudienceEnum;
          result.audience = valueDes;
          break;
        case r'restaurantIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.restaurantIds.replace(valueDes);
          break;
        case r'zoneIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.zoneIds.replace(valueDes);
          break;
        case r'funding':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminGeneratePromoCodesDtoFundingEnum,
                    ),
                  )
                  as AdminGeneratePromoCodesDtoFundingEnum;
          result.funding = valueDes;
          break;
        case r'sharedMerchantBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.sharedMerchantBp = valueDes;
          break;
        case r'dailyBudget':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.dailyBudget = valueDes;
          break;
        case r'visibility':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminGeneratePromoCodesDtoVisibilityEnum,
                    ),
                  )
                  as AdminGeneratePromoCodesDtoVisibilityEnum;
          result.visibility = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminGeneratePromoCodesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminGeneratePromoCodesDtoBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

class AdminGeneratePromoCodesDtoKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'percentage')
  static const AdminGeneratePromoCodesDtoKindEnum percentage =
      _$adminGeneratePromoCodesDtoKindEnum_percentage;
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const AdminGeneratePromoCodesDtoKindEnum fixedAmount =
      _$adminGeneratePromoCodesDtoKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'free_delivery')
  static const AdminGeneratePromoCodesDtoKindEnum freeDelivery =
      _$adminGeneratePromoCodesDtoKindEnum_freeDelivery;

  static Serializer<AdminGeneratePromoCodesDtoKindEnum> get serializer =>
      _$adminGeneratePromoCodesDtoKindEnumSerializer;

  const AdminGeneratePromoCodesDtoKindEnum._(String name) : super(name);

  static BuiltSet<AdminGeneratePromoCodesDtoKindEnum> get values =>
      _$adminGeneratePromoCodesDtoKindEnumValues;
  static AdminGeneratePromoCodesDtoKindEnum valueOf(String name) =>
      _$adminGeneratePromoCodesDtoKindEnumValueOf(name);
}

class AdminGeneratePromoCodesDtoAudienceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'everyone')
  static const AdminGeneratePromoCodesDtoAudienceEnum everyone =
      _$adminGeneratePromoCodesDtoAudienceEnum_everyone;
  @BuiltValueEnumConst(wireName: r'new_users')
  static const AdminGeneratePromoCodesDtoAudienceEnum newUsers =
      _$adminGeneratePromoCodesDtoAudienceEnum_newUsers;

  static Serializer<AdminGeneratePromoCodesDtoAudienceEnum> get serializer =>
      _$adminGeneratePromoCodesDtoAudienceEnumSerializer;

  const AdminGeneratePromoCodesDtoAudienceEnum._(String name) : super(name);

  static BuiltSet<AdminGeneratePromoCodesDtoAudienceEnum> get values =>
      _$adminGeneratePromoCodesDtoAudienceEnumValues;
  static AdminGeneratePromoCodesDtoAudienceEnum valueOf(String name) =>
      _$adminGeneratePromoCodesDtoAudienceEnumValueOf(name);
}

class AdminGeneratePromoCodesDtoFundingEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminGeneratePromoCodesDtoFundingEnum platform =
      _$adminGeneratePromoCodesDtoFundingEnum_platform;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminGeneratePromoCodesDtoFundingEnum restaurant =
      _$adminGeneratePromoCodesDtoFundingEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'shared')
  static const AdminGeneratePromoCodesDtoFundingEnum shared =
      _$adminGeneratePromoCodesDtoFundingEnum_shared;

  static Serializer<AdminGeneratePromoCodesDtoFundingEnum> get serializer =>
      _$adminGeneratePromoCodesDtoFundingEnumSerializer;

  const AdminGeneratePromoCodesDtoFundingEnum._(String name) : super(name);

  static BuiltSet<AdminGeneratePromoCodesDtoFundingEnum> get values =>
      _$adminGeneratePromoCodesDtoFundingEnumValues;
  static AdminGeneratePromoCodesDtoFundingEnum valueOf(String name) =>
      _$adminGeneratePromoCodesDtoFundingEnumValueOf(name);
}

class AdminGeneratePromoCodesDtoVisibilityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'visible')
  static const AdminGeneratePromoCodesDtoVisibilityEnum visible =
      _$adminGeneratePromoCodesDtoVisibilityEnum_visible;
  @BuiltValueEnumConst(wireName: r'secret')
  static const AdminGeneratePromoCodesDtoVisibilityEnum secret =
      _$adminGeneratePromoCodesDtoVisibilityEnum_secret;

  static Serializer<AdminGeneratePromoCodesDtoVisibilityEnum> get serializer =>
      _$adminGeneratePromoCodesDtoVisibilityEnumSerializer;

  const AdminGeneratePromoCodesDtoVisibilityEnum._(String name) : super(name);

  static BuiltSet<AdminGeneratePromoCodesDtoVisibilityEnum> get values =>
      _$adminGeneratePromoCodesDtoVisibilityEnumValues;
  static AdminGeneratePromoCodesDtoVisibilityEnum valueOf(String name) =>
      _$adminGeneratePromoCodesDtoVisibilityEnumValueOf(name);
}
