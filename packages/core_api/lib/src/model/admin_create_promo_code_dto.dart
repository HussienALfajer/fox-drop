//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_create_promo_code_dto.g.dart';

/// AdminCreatePromoCodeDto
///
/// Properties:
/// * [cityId]
/// * [code] - Letters and digits, saved in upper case.
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
abstract class AdminCreatePromoCodeDto
    implements Built<AdminCreatePromoCodeDto, AdminCreatePromoCodeDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Letters and digits, saved in upper case.
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'kind')
  AdminCreatePromoCodeDtoKindEnum get kind;
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
  AdminCreatePromoCodeDtoAudienceEnum get audience;
  // enum audienceEnum {  everyone,  new_users,  };

  /// None: every restaurant.
  @BuiltValueField(wireName: r'restaurantIds')
  BuiltList<String> get restaurantIds;

  /// None: every zone.
  @BuiltValueField(wireName: r'zoneIds')
  BuiltList<String> get zoneIds;

  @BuiltValueField(wireName: r'funding')
  AdminCreatePromoCodeDtoFundingEnum get funding;
  // enum fundingEnum {  platform,  restaurant,  shared,  };

  /// A shared code: the restaurant's share, 4000 is 40%; null otherwise.
  @BuiltValueField(wireName: r'sharedMerchantBp')
  int? get sharedMerchantBp;

  /// Pauses the code for the business day; null for none.
  @BuiltValueField(wireName: r'dailyBudget')
  String? get dailyBudget;

  @BuiltValueField(wireName: r'visibility')
  AdminCreatePromoCodeDtoVisibilityEnum get visibility;
  // enum visibilityEnum {  visible,  secret,  };

  AdminCreatePromoCodeDto._();

  factory AdminCreatePromoCodeDto([
    void updates(AdminCreatePromoCodeDtoBuilder b),
  ]) = _$AdminCreatePromoCodeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCreatePromoCodeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCreatePromoCodeDto> get serializer =>
      _$AdminCreatePromoCodeDtoSerializer();
}

class _$AdminCreatePromoCodeDtoSerializer
    implements PrimitiveSerializer<AdminCreatePromoCodeDto> {
  @override
  final Iterable<Type> types = const [
    AdminCreatePromoCodeDto,
    _$AdminCreatePromoCodeDto,
  ];

  @override
  final String wireName = r'AdminCreatePromoCodeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCreatePromoCodeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminCreatePromoCodeDtoKindEnum),
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
      specifiedType: const FullType(AdminCreatePromoCodeDtoAudienceEnum),
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
      specifiedType: const FullType(AdminCreatePromoCodeDtoFundingEnum),
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
      specifiedType: const FullType(AdminCreatePromoCodeDtoVisibilityEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCreatePromoCodeDto object, {
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
    required AdminCreatePromoCodeDtoBuilder result,
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
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCreatePromoCodeDtoKindEnum,
                    ),
                  )
                  as AdminCreatePromoCodeDtoKindEnum;
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
                      AdminCreatePromoCodeDtoAudienceEnum,
                    ),
                  )
                  as AdminCreatePromoCodeDtoAudienceEnum;
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
                      AdminCreatePromoCodeDtoFundingEnum,
                    ),
                  )
                  as AdminCreatePromoCodeDtoFundingEnum;
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
                      AdminCreatePromoCodeDtoVisibilityEnum,
                    ),
                  )
                  as AdminCreatePromoCodeDtoVisibilityEnum;
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
  AdminCreatePromoCodeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCreatePromoCodeDtoBuilder();
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

class AdminCreatePromoCodeDtoKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'percentage')
  static const AdminCreatePromoCodeDtoKindEnum percentage =
      _$adminCreatePromoCodeDtoKindEnum_percentage;
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const AdminCreatePromoCodeDtoKindEnum fixedAmount =
      _$adminCreatePromoCodeDtoKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'free_delivery')
  static const AdminCreatePromoCodeDtoKindEnum freeDelivery =
      _$adminCreatePromoCodeDtoKindEnum_freeDelivery;

  static Serializer<AdminCreatePromoCodeDtoKindEnum> get serializer =>
      _$adminCreatePromoCodeDtoKindEnumSerializer;

  const AdminCreatePromoCodeDtoKindEnum._(String name) : super(name);

  static BuiltSet<AdminCreatePromoCodeDtoKindEnum> get values =>
      _$adminCreatePromoCodeDtoKindEnumValues;
  static AdminCreatePromoCodeDtoKindEnum valueOf(String name) =>
      _$adminCreatePromoCodeDtoKindEnumValueOf(name);
}

class AdminCreatePromoCodeDtoAudienceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'everyone')
  static const AdminCreatePromoCodeDtoAudienceEnum everyone =
      _$adminCreatePromoCodeDtoAudienceEnum_everyone;
  @BuiltValueEnumConst(wireName: r'new_users')
  static const AdminCreatePromoCodeDtoAudienceEnum newUsers =
      _$adminCreatePromoCodeDtoAudienceEnum_newUsers;

  static Serializer<AdminCreatePromoCodeDtoAudienceEnum> get serializer =>
      _$adminCreatePromoCodeDtoAudienceEnumSerializer;

  const AdminCreatePromoCodeDtoAudienceEnum._(String name) : super(name);

  static BuiltSet<AdminCreatePromoCodeDtoAudienceEnum> get values =>
      _$adminCreatePromoCodeDtoAudienceEnumValues;
  static AdminCreatePromoCodeDtoAudienceEnum valueOf(String name) =>
      _$adminCreatePromoCodeDtoAudienceEnumValueOf(name);
}

class AdminCreatePromoCodeDtoFundingEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminCreatePromoCodeDtoFundingEnum platform =
      _$adminCreatePromoCodeDtoFundingEnum_platform;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminCreatePromoCodeDtoFundingEnum restaurant =
      _$adminCreatePromoCodeDtoFundingEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'shared')
  static const AdminCreatePromoCodeDtoFundingEnum shared =
      _$adminCreatePromoCodeDtoFundingEnum_shared;

  static Serializer<AdminCreatePromoCodeDtoFundingEnum> get serializer =>
      _$adminCreatePromoCodeDtoFundingEnumSerializer;

  const AdminCreatePromoCodeDtoFundingEnum._(String name) : super(name);

  static BuiltSet<AdminCreatePromoCodeDtoFundingEnum> get values =>
      _$adminCreatePromoCodeDtoFundingEnumValues;
  static AdminCreatePromoCodeDtoFundingEnum valueOf(String name) =>
      _$adminCreatePromoCodeDtoFundingEnumValueOf(name);
}

class AdminCreatePromoCodeDtoVisibilityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'visible')
  static const AdminCreatePromoCodeDtoVisibilityEnum visible =
      _$adminCreatePromoCodeDtoVisibilityEnum_visible;
  @BuiltValueEnumConst(wireName: r'secret')
  static const AdminCreatePromoCodeDtoVisibilityEnum secret =
      _$adminCreatePromoCodeDtoVisibilityEnum_secret;

  static Serializer<AdminCreatePromoCodeDtoVisibilityEnum> get serializer =>
      _$adminCreatePromoCodeDtoVisibilityEnumSerializer;

  const AdminCreatePromoCodeDtoVisibilityEnum._(String name) : super(name);

  static BuiltSet<AdminCreatePromoCodeDtoVisibilityEnum> get values =>
      _$adminCreatePromoCodeDtoVisibilityEnumValues;
  static AdminCreatePromoCodeDtoVisibilityEnum valueOf(String name) =>
      _$adminCreatePromoCodeDtoVisibilityEnumValueOf(name);
}
