//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_correction_dto.g.dart';

/// AdminOrderCorrectionDto
///
/// Properties:
/// * [party]
/// * [partyId]
/// * [account]
/// * [currency]
/// * [amount] - From the party's view, never zero.
/// * [reason]
@BuiltValue()
abstract class AdminOrderCorrectionDto
    implements Built<AdminOrderCorrectionDto, AdminOrderCorrectionDtoBuilder> {
  @BuiltValueField(wireName: r'party')
  AdminOrderCorrectionDtoPartyEnum get party;
  // enum partyEnum {  captain,  restaurant,  customer,  };

  @BuiltValueField(wireName: r'partyId')
  String get partyId;

  @BuiltValueField(wireName: r'account')
  AdminOrderCorrectionDtoAccountEnum get account;
  // enum accountEnum {  captain.custody,  captain.earnings,  merchant.account,  customer.dues,  };

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// From the party's view, never zero.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminOrderCorrectionDto._();

  factory AdminOrderCorrectionDto([
    void updates(AdminOrderCorrectionDtoBuilder b),
  ]) = _$AdminOrderCorrectionDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderCorrectionDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderCorrectionDto> get serializer =>
      _$AdminOrderCorrectionDtoSerializer();
}

class _$AdminOrderCorrectionDtoSerializer
    implements PrimitiveSerializer<AdminOrderCorrectionDto> {
  @override
  final Iterable<Type> types = const [
    AdminOrderCorrectionDto,
    _$AdminOrderCorrectionDto,
  ];

  @override
  final String wireName = r'AdminOrderCorrectionDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderCorrectionDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'party';
    yield serializers.serialize(
      object.party,
      specifiedType: const FullType(AdminOrderCorrectionDtoPartyEnum),
    );
    yield r'partyId';
    yield serializers.serialize(
      object.partyId,
      specifiedType: const FullType(String),
    );
    yield r'account';
    yield serializers.serialize(
      object.account,
      specifiedType: const FullType(AdminOrderCorrectionDtoAccountEnum),
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
    AdminOrderCorrectionDto object, {
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
    required AdminOrderCorrectionDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'party':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCorrectionDtoPartyEnum,
                    ),
                  )
                  as AdminOrderCorrectionDtoPartyEnum;
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
                      AdminOrderCorrectionDtoAccountEnum,
                    ),
                  )
                  as AdminOrderCorrectionDtoAccountEnum;
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
  AdminOrderCorrectionDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderCorrectionDtoBuilder();
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

class AdminOrderCorrectionDtoPartyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderCorrectionDtoPartyEnum captain =
      _$adminOrderCorrectionDtoPartyEnum_captain;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderCorrectionDtoPartyEnum restaurant =
      _$adminOrderCorrectionDtoPartyEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOrderCorrectionDtoPartyEnum customer =
      _$adminOrderCorrectionDtoPartyEnum_customer;

  static Serializer<AdminOrderCorrectionDtoPartyEnum> get serializer =>
      _$adminOrderCorrectionDtoPartyEnumSerializer;

  const AdminOrderCorrectionDtoPartyEnum._(String name) : super(name);

  static BuiltSet<AdminOrderCorrectionDtoPartyEnum> get values =>
      _$adminOrderCorrectionDtoPartyEnumValues;
  static AdminOrderCorrectionDtoPartyEnum valueOf(String name) =>
      _$adminOrderCorrectionDtoPartyEnumValueOf(name);
}

class AdminOrderCorrectionDtoAccountEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain.custody')
  static const AdminOrderCorrectionDtoAccountEnum captainPeriodCustody =
      _$adminOrderCorrectionDtoAccountEnum_captainPeriodCustody;
  @BuiltValueEnumConst(wireName: r'captain.earnings')
  static const AdminOrderCorrectionDtoAccountEnum captainPeriodEarnings =
      _$adminOrderCorrectionDtoAccountEnum_captainPeriodEarnings;
  @BuiltValueEnumConst(wireName: r'merchant.account')
  static const AdminOrderCorrectionDtoAccountEnum merchantPeriodAccount =
      _$adminOrderCorrectionDtoAccountEnum_merchantPeriodAccount;
  @BuiltValueEnumConst(wireName: r'customer.dues')
  static const AdminOrderCorrectionDtoAccountEnum customerPeriodDues =
      _$adminOrderCorrectionDtoAccountEnum_customerPeriodDues;

  static Serializer<AdminOrderCorrectionDtoAccountEnum> get serializer =>
      _$adminOrderCorrectionDtoAccountEnumSerializer;

  const AdminOrderCorrectionDtoAccountEnum._(String name) : super(name);

  static BuiltSet<AdminOrderCorrectionDtoAccountEnum> get values =>
      _$adminOrderCorrectionDtoAccountEnumValues;
  static AdminOrderCorrectionDtoAccountEnum valueOf(String name) =>
      _$adminOrderCorrectionDtoAccountEnumValueOf(name);
}
