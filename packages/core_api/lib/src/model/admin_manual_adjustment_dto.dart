//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_manual_adjustment_dto.g.dart';

/// AdminManualAdjustmentDto
///
/// Properties:
/// * [cityId]
/// * [party]
/// * [partyId]
/// * [account]
/// * [currency]
/// * [amount] - From the party's view, never zero.
/// * [reason]
@BuiltValue()
abstract class AdminManualAdjustmentDto
    implements
        Built<AdminManualAdjustmentDto, AdminManualAdjustmentDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'party')
  AdminManualAdjustmentDtoPartyEnum get party;
  // enum partyEnum {  captain,  restaurant,  customer,  };

  @BuiltValueField(wireName: r'partyId')
  String get partyId;

  @BuiltValueField(wireName: r'account')
  AdminManualAdjustmentDtoAccountEnum get account;
  // enum accountEnum {  captain.custody,  captain.earnings,  merchant.account,  customer.dues,  };

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// From the party's view, never zero.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminManualAdjustmentDto._();

  factory AdminManualAdjustmentDto([
    void updates(AdminManualAdjustmentDtoBuilder b),
  ]) = _$AdminManualAdjustmentDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminManualAdjustmentDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminManualAdjustmentDto> get serializer =>
      _$AdminManualAdjustmentDtoSerializer();
}

class _$AdminManualAdjustmentDtoSerializer
    implements PrimitiveSerializer<AdminManualAdjustmentDto> {
  @override
  final Iterable<Type> types = const [
    AdminManualAdjustmentDto,
    _$AdminManualAdjustmentDto,
  ];

  @override
  final String wireName = r'AdminManualAdjustmentDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminManualAdjustmentDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(AdminManualAdjustmentDtoPartyEnum),
    );
    yield r'partyId';
    yield serializers.serialize(
      object.partyId,
      specifiedType: const FullType(String),
    );
    yield r'account';
    yield serializers.serialize(
      object.account,
      specifiedType: const FullType(AdminManualAdjustmentDtoAccountEnum),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminManualAdjustmentDto object, {
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
    required AdminManualAdjustmentDtoBuilder result,
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
        case r'party':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminManualAdjustmentDtoPartyEnum,
                    ),
                  )
                  as AdminManualAdjustmentDtoPartyEnum;
          result.party = valueDes;
          break;
        case r'partyId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.partyId = valueDes;
          break;
        case r'account':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminManualAdjustmentDtoAccountEnum,
                    ),
                  )
                  as AdminManualAdjustmentDtoAccountEnum;
          result.account = valueDes;
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
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminManualAdjustmentDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminManualAdjustmentDtoBuilder();
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

class AdminManualAdjustmentDtoPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminManualAdjustmentDtoPartyEnum captain =
      _$adminManualAdjustmentDtoPartyEnum_captain;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminManualAdjustmentDtoPartyEnum restaurant =
      _$adminManualAdjustmentDtoPartyEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminManualAdjustmentDtoPartyEnum customer =
      _$adminManualAdjustmentDtoPartyEnum_customer;

  static Serializer<AdminManualAdjustmentDtoPartyEnum> get serializer =>
      _$adminManualAdjustmentDtoPartyEnumSerializer;

  const AdminManualAdjustmentDtoPartyEnum._(String name) : super(name);

  static BuiltSet<AdminManualAdjustmentDtoPartyEnum> get values =>
      _$adminManualAdjustmentDtoPartyEnumValues;
  static AdminManualAdjustmentDtoPartyEnum valueOf(String name) =>
      _$adminManualAdjustmentDtoPartyEnumValueOf(name);
}

class AdminManualAdjustmentDtoAccountEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain.custody')
  static const AdminManualAdjustmentDtoAccountEnum captainPeriodCustody =
      _$adminManualAdjustmentDtoAccountEnum_captainPeriodCustody;
  @BuiltValueEnumConst(wireName: r'captain.earnings')
  static const AdminManualAdjustmentDtoAccountEnum captainPeriodEarnings =
      _$adminManualAdjustmentDtoAccountEnum_captainPeriodEarnings;
  @BuiltValueEnumConst(wireName: r'merchant.account')
  static const AdminManualAdjustmentDtoAccountEnum merchantPeriodAccount =
      _$adminManualAdjustmentDtoAccountEnum_merchantPeriodAccount;
  @BuiltValueEnumConst(wireName: r'customer.dues')
  static const AdminManualAdjustmentDtoAccountEnum customerPeriodDues =
      _$adminManualAdjustmentDtoAccountEnum_customerPeriodDues;

  static Serializer<AdminManualAdjustmentDtoAccountEnum> get serializer =>
      _$adminManualAdjustmentDtoAccountEnumSerializer;

  const AdminManualAdjustmentDtoAccountEnum._(String name) : super(name);

  static BuiltSet<AdminManualAdjustmentDtoAccountEnum> get values =>
      _$adminManualAdjustmentDtoAccountEnumValues;
  static AdminManualAdjustmentDtoAccountEnum valueOf(String name) =>
      _$adminManualAdjustmentDtoAccountEnumValueOf(name);
}
