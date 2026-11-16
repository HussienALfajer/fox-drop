//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_promo_codes_dto_output_codes_inner.g.dart';

/// AdminPromoCodesDtoOutputCodesInner
///
/// Properties:
/// * [id]
/// * [code]
/// * [batchId]
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
/// * [currency]
/// * [status] - Set by OWN.
/// * [state] - What the list shows: paused, not started, ended or running.
/// * [uses] - Uses held or spent (not given back).
/// * [costToDate] - The discounts of the uses not given back; null without marketing.read_costs.
/// * [createdAt]
/// * [updatedAt]
@BuiltValue()
abstract class AdminPromoCodesDtoOutputCodesInner
    implements
        Built<
          AdminPromoCodesDtoOutputCodesInner,
          AdminPromoCodesDtoOutputCodesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'batchId')
  String? get batchId;

  @BuiltValueField(wireName: r'kind')
  AdminPromoCodesDtoOutputCodesInnerKindEnum get kind;
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
  AdminPromoCodesDtoOutputCodesInnerAudienceEnum get audience;
  // enum audienceEnum {  everyone,  new_users,  };

  /// None: every restaurant.
  @BuiltValueField(wireName: r'restaurantIds')
  BuiltList<String> get restaurantIds;

  /// None: every zone.
  @BuiltValueField(wireName: r'zoneIds')
  BuiltList<String> get zoneIds;

  @BuiltValueField(wireName: r'funding')
  AdminPromoCodesDtoOutputCodesInnerFundingEnum get funding;
  // enum fundingEnum {  platform,  restaurant,  shared,  };

  /// A shared code: the restaurant's share, 4000 is 40%; null otherwise.
  @BuiltValueField(wireName: r'sharedMerchantBp')
  int? get sharedMerchantBp;

  /// Pauses the code for the business day; null for none.
  @BuiltValueField(wireName: r'dailyBudget')
  String? get dailyBudget;

  @BuiltValueField(wireName: r'visibility')
  AdminPromoCodesDtoOutputCodesInnerVisibilityEnum get visibility;
  // enum visibilityEnum {  visible,  secret,  };

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// Set by OWN.
  @BuiltValueField(wireName: r'status')
  AdminPromoCodesDtoOutputCodesInnerStatusEnum get status;
  // enum statusEnum {  active,  paused,  };

  /// What the list shows: paused, not started, ended or running.
  @BuiltValueField(wireName: r'state')
  AdminPromoCodesDtoOutputCodesInnerStateEnum get state;
  // enum stateEnum {  active,  paused,  scheduled,  expired,  };

  /// Uses held or spent (not given back).
  @BuiltValueField(wireName: r'uses')
  int get uses;

  /// The discounts of the uses not given back; null without marketing.read_costs.
  @BuiltValueField(wireName: r'costToDate')
  String? get costToDate;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  AdminPromoCodesDtoOutputCodesInner._();

  factory AdminPromoCodesDtoOutputCodesInner([
    void updates(AdminPromoCodesDtoOutputCodesInnerBuilder b),
  ]) = _$AdminPromoCodesDtoOutputCodesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminPromoCodesDtoOutputCodesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminPromoCodesDtoOutputCodesInner> get serializer =>
      _$AdminPromoCodesDtoOutputCodesInnerSerializer();
}

class _$AdminPromoCodesDtoOutputCodesInnerSerializer
    implements PrimitiveSerializer<AdminPromoCodesDtoOutputCodesInner> {
  @override
  final Iterable<Type> types = const [
    AdminPromoCodesDtoOutputCodesInner,
    _$AdminPromoCodesDtoOutputCodesInner,
  ];

  @override
  final String wireName = r'AdminPromoCodesDtoOutputCodesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminPromoCodesDtoOutputCodesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'batchId';
    yield object.batchId == null
        ? null
        : serializers.serialize(
            object.batchId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminPromoCodesDtoOutputCodesInnerKindEnum),
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
      specifiedType: const FullType(
        AdminPromoCodesDtoOutputCodesInnerAudienceEnum,
      ),
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
      specifiedType: const FullType(
        AdminPromoCodesDtoOutputCodesInnerFundingEnum,
      ),
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
      specifiedType: const FullType(
        AdminPromoCodesDtoOutputCodesInnerVisibilityEnum,
      ),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminPromoCodesDtoOutputCodesInnerStatusEnum,
      ),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        AdminPromoCodesDtoOutputCodesInnerStateEnum,
      ),
    );
    yield r'uses';
    yield serializers.serialize(
      object.uses,
      specifiedType: const FullType(int),
    );
    yield r'costToDate';
    yield object.costToDate == null
        ? null
        : serializers.serialize(
            object.costToDate,
            specifiedType: const FullType.nullable(String),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminPromoCodesDtoOutputCodesInner object, {
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
    required AdminPromoCodesDtoOutputCodesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
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
        case r'batchId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.batchId = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPromoCodesDtoOutputCodesInnerKindEnum,
                    ),
                  )
                  as AdminPromoCodesDtoOutputCodesInnerKindEnum;
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
                      AdminPromoCodesDtoOutputCodesInnerAudienceEnum,
                    ),
                  )
                  as AdminPromoCodesDtoOutputCodesInnerAudienceEnum;
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
                      AdminPromoCodesDtoOutputCodesInnerFundingEnum,
                    ),
                  )
                  as AdminPromoCodesDtoOutputCodesInnerFundingEnum;
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
                      AdminPromoCodesDtoOutputCodesInnerVisibilityEnum,
                    ),
                  )
                  as AdminPromoCodesDtoOutputCodesInnerVisibilityEnum;
          result.visibility = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPromoCodesDtoOutputCodesInnerStatusEnum,
                    ),
                  )
                  as AdminPromoCodesDtoOutputCodesInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminPromoCodesDtoOutputCodesInnerStateEnum,
                    ),
                  )
                  as AdminPromoCodesDtoOutputCodesInnerStateEnum;
          result.state = valueDes;
          break;
        case r'uses':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.uses = valueDes;
          break;
        case r'costToDate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.costToDate = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.updatedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminPromoCodesDtoOutputCodesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminPromoCodesDtoOutputCodesInnerBuilder();
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

class AdminPromoCodesDtoOutputCodesInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'percentage')
  static const AdminPromoCodesDtoOutputCodesInnerKindEnum percentage =
      _$adminPromoCodesDtoOutputCodesInnerKindEnum_percentage;
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const AdminPromoCodesDtoOutputCodesInnerKindEnum fixedAmount =
      _$adminPromoCodesDtoOutputCodesInnerKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'free_delivery')
  static const AdminPromoCodesDtoOutputCodesInnerKindEnum freeDelivery =
      _$adminPromoCodesDtoOutputCodesInnerKindEnum_freeDelivery;

  static Serializer<AdminPromoCodesDtoOutputCodesInnerKindEnum>
  get serializer => _$adminPromoCodesDtoOutputCodesInnerKindEnumSerializer;

  const AdminPromoCodesDtoOutputCodesInnerKindEnum._(String name) : super(name);

  static BuiltSet<AdminPromoCodesDtoOutputCodesInnerKindEnum> get values =>
      _$adminPromoCodesDtoOutputCodesInnerKindEnumValues;
  static AdminPromoCodesDtoOutputCodesInnerKindEnum valueOf(String name) =>
      _$adminPromoCodesDtoOutputCodesInnerKindEnumValueOf(name);
}

class AdminPromoCodesDtoOutputCodesInnerAudienceEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'everyone')
  static const AdminPromoCodesDtoOutputCodesInnerAudienceEnum everyone =
      _$adminPromoCodesDtoOutputCodesInnerAudienceEnum_everyone;
  @BuiltValueEnumConst(wireName: r'new_users')
  static const AdminPromoCodesDtoOutputCodesInnerAudienceEnum newUsers =
      _$adminPromoCodesDtoOutputCodesInnerAudienceEnum_newUsers;

  static Serializer<AdminPromoCodesDtoOutputCodesInnerAudienceEnum>
  get serializer => _$adminPromoCodesDtoOutputCodesInnerAudienceEnumSerializer;

  const AdminPromoCodesDtoOutputCodesInnerAudienceEnum._(String name)
    : super(name);

  static BuiltSet<AdminPromoCodesDtoOutputCodesInnerAudienceEnum> get values =>
      _$adminPromoCodesDtoOutputCodesInnerAudienceEnumValues;
  static AdminPromoCodesDtoOutputCodesInnerAudienceEnum valueOf(String name) =>
      _$adminPromoCodesDtoOutputCodesInnerAudienceEnumValueOf(name);
}

class AdminPromoCodesDtoOutputCodesInnerFundingEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'platform')
  static const AdminPromoCodesDtoOutputCodesInnerFundingEnum platform =
      _$adminPromoCodesDtoOutputCodesInnerFundingEnum_platform;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminPromoCodesDtoOutputCodesInnerFundingEnum restaurant =
      _$adminPromoCodesDtoOutputCodesInnerFundingEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'shared')
  static const AdminPromoCodesDtoOutputCodesInnerFundingEnum shared =
      _$adminPromoCodesDtoOutputCodesInnerFundingEnum_shared;

  static Serializer<AdminPromoCodesDtoOutputCodesInnerFundingEnum>
  get serializer => _$adminPromoCodesDtoOutputCodesInnerFundingEnumSerializer;

  const AdminPromoCodesDtoOutputCodesInnerFundingEnum._(String name)
    : super(name);

  static BuiltSet<AdminPromoCodesDtoOutputCodesInnerFundingEnum> get values =>
      _$adminPromoCodesDtoOutputCodesInnerFundingEnumValues;
  static AdminPromoCodesDtoOutputCodesInnerFundingEnum valueOf(String name) =>
      _$adminPromoCodesDtoOutputCodesInnerFundingEnumValueOf(name);
}

class AdminPromoCodesDtoOutputCodesInnerVisibilityEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'visible')
  static const AdminPromoCodesDtoOutputCodesInnerVisibilityEnum visible =
      _$adminPromoCodesDtoOutputCodesInnerVisibilityEnum_visible;
  @BuiltValueEnumConst(wireName: r'secret')
  static const AdminPromoCodesDtoOutputCodesInnerVisibilityEnum secret =
      _$adminPromoCodesDtoOutputCodesInnerVisibilityEnum_secret;

  static Serializer<AdminPromoCodesDtoOutputCodesInnerVisibilityEnum>
  get serializer =>
      _$adminPromoCodesDtoOutputCodesInnerVisibilityEnumSerializer;

  const AdminPromoCodesDtoOutputCodesInnerVisibilityEnum._(String name)
    : super(name);

  static BuiltSet<AdminPromoCodesDtoOutputCodesInnerVisibilityEnum>
  get values => _$adminPromoCodesDtoOutputCodesInnerVisibilityEnumValues;
  static AdminPromoCodesDtoOutputCodesInnerVisibilityEnum valueOf(
    String name,
  ) => _$adminPromoCodesDtoOutputCodesInnerVisibilityEnumValueOf(name);
}

/// Set by OWN.
class AdminPromoCodesDtoOutputCodesInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminPromoCodesDtoOutputCodesInnerStatusEnum active =
      _$adminPromoCodesDtoOutputCodesInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'paused')
  static const AdminPromoCodesDtoOutputCodesInnerStatusEnum paused =
      _$adminPromoCodesDtoOutputCodesInnerStatusEnum_paused;

  static Serializer<AdminPromoCodesDtoOutputCodesInnerStatusEnum>
  get serializer => _$adminPromoCodesDtoOutputCodesInnerStatusEnumSerializer;

  const AdminPromoCodesDtoOutputCodesInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminPromoCodesDtoOutputCodesInnerStatusEnum> get values =>
      _$adminPromoCodesDtoOutputCodesInnerStatusEnumValues;
  static AdminPromoCodesDtoOutputCodesInnerStatusEnum valueOf(String name) =>
      _$adminPromoCodesDtoOutputCodesInnerStatusEnumValueOf(name);
}

/// What the list shows: paused, not started, ended or running.
class AdminPromoCodesDtoOutputCodesInnerStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminPromoCodesDtoOutputCodesInnerStateEnum active =
      _$adminPromoCodesDtoOutputCodesInnerStateEnum_active;
  @BuiltValueEnumConst(wireName: r'paused')
  static const AdminPromoCodesDtoOutputCodesInnerStateEnum paused =
      _$adminPromoCodesDtoOutputCodesInnerStateEnum_paused;
  @BuiltValueEnumConst(wireName: r'scheduled')
  static const AdminPromoCodesDtoOutputCodesInnerStateEnum scheduled =
      _$adminPromoCodesDtoOutputCodesInnerStateEnum_scheduled;
  @BuiltValueEnumConst(wireName: r'expired')
  static const AdminPromoCodesDtoOutputCodesInnerStateEnum expired =
      _$adminPromoCodesDtoOutputCodesInnerStateEnum_expired;

  static Serializer<AdminPromoCodesDtoOutputCodesInnerStateEnum>
  get serializer => _$adminPromoCodesDtoOutputCodesInnerStateEnumSerializer;

  const AdminPromoCodesDtoOutputCodesInnerStateEnum._(String name)
    : super(name);

  static BuiltSet<AdminPromoCodesDtoOutputCodesInnerStateEnum> get values =>
      _$adminPromoCodesDtoOutputCodesInnerStateEnumValues;
  static AdminPromoCodesDtoOutputCodesInnerStateEnum valueOf(String name) =>
      _$adminPromoCodesDtoOutputCodesInnerStateEnumValueOf(name);
}
