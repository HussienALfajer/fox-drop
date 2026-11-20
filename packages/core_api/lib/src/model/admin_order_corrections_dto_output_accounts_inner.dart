//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_corrections_dto_output_accounts_inner.g.dart';

/// AdminOrderCorrectionsDtoOutputAccountsInner
///
/// Properties:
/// * [partyKind]
/// * [partyId]
/// * [partyName]
/// * [account]
/// * [currencies]
@BuiltValue()
abstract class AdminOrderCorrectionsDtoOutputAccountsInner
    implements
        Built<
          AdminOrderCorrectionsDtoOutputAccountsInner,
          AdminOrderCorrectionsDtoOutputAccountsInnerBuilder
        > {
  @BuiltValueField(wireName: r'partyKind')
  AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum get partyKind;
  // enum partyKindEnum {  captain,  restaurant,  customer,  };

  @BuiltValueField(wireName: r'partyId')
  String get partyId;

  @BuiltValueField(wireName: r'partyName')
  String get partyName;

  @BuiltValueField(wireName: r'account')
  AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum get account;
  // enum accountEnum {  captain.custody,  captain.earnings,  merchant.account,  customer.dues,  };

  @BuiltValueField(wireName: r'currencies')
  BuiltList<String> get currencies;

  AdminOrderCorrectionsDtoOutputAccountsInner._();

  factory AdminOrderCorrectionsDtoOutputAccountsInner([
    void updates(AdminOrderCorrectionsDtoOutputAccountsInnerBuilder b),
  ]) = _$AdminOrderCorrectionsDtoOutputAccountsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderCorrectionsDtoOutputAccountsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderCorrectionsDtoOutputAccountsInner>
  get serializer => _$AdminOrderCorrectionsDtoOutputAccountsInnerSerializer();
}

class _$AdminOrderCorrectionsDtoOutputAccountsInnerSerializer
    implements
        PrimitiveSerializer<AdminOrderCorrectionsDtoOutputAccountsInner> {
  @override
  final Iterable<Type> types = const [
    AdminOrderCorrectionsDtoOutputAccountsInner,
    _$AdminOrderCorrectionsDtoOutputAccountsInner,
  ];

  @override
  final String wireName = r'AdminOrderCorrectionsDtoOutputAccountsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderCorrectionsDtoOutputAccountsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'partyKind';
    yield serializers.serialize(
      object.partyKind,
      specifiedType: const FullType(
        AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum,
      ),
    );
    yield r'partyId';
    yield serializers.serialize(
      object.partyId,
      specifiedType: const FullType(String),
    );
    yield r'partyName';
    yield serializers.serialize(
      object.partyName,
      specifiedType: const FullType(String),
    );
    yield r'account';
    yield serializers.serialize(
      object.account,
      specifiedType: const FullType(
        AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum,
      ),
    );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCorrectionsDtoOutputAccountsInner object, {
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
    required AdminOrderCorrectionsDtoOutputAccountsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'partyKind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum,
                    ),
                  )
                  as AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum;
          result.partyKind = valueDes;
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
        case r'partyName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.partyName = valueDes;
          break;
        case r'account':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum,
                    ),
                  )
                  as AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum;
          result.account = valueDes;
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.currencies.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderCorrectionsDtoOutputAccountsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderCorrectionsDtoOutputAccountsInnerBuilder();
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

class AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain')
  static const AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum
  captain = _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_captain;
  @BuiltValueEnumConst(wireName: r'restaurant')
  static const AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum
  restaurant =
      _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_restaurant;
  @BuiltValueEnumConst(wireName: r'customer')
  static const AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum
  customer =
      _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum_customer;

  static Serializer<AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum>
  get serializer =>
      _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnumSerializer;

  const AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum>
  get values =>
      _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnumValues;
  static AdminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnum valueOf(
    String name,
  ) => _$adminOrderCorrectionsDtoOutputAccountsInnerPartyKindEnumValueOf(name);
}

class AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'captain.custody')
  static const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum
  captainPeriodCustody =
      _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_captainPeriodCustody;
  @BuiltValueEnumConst(wireName: r'captain.earnings')
  static const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum
  captainPeriodEarnings =
      _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_captainPeriodEarnings;
  @BuiltValueEnumConst(wireName: r'merchant.account')
  static const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum
  merchantPeriodAccount =
      _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_merchantPeriodAccount;
  @BuiltValueEnumConst(wireName: r'customer.dues')
  static const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum
  customerPeriodDues =
      _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnum_customerPeriodDues;

  static Serializer<AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum>
  get serializer =>
      _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnumSerializer;

  const AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum._(String name)
    : super(name);

  static BuiltSet<AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum>
  get values => _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnumValues;
  static AdminOrderCorrectionsDtoOutputAccountsInnerAccountEnum valueOf(
    String name,
  ) => _$adminOrderCorrectionsDtoOutputAccountsInnerAccountEnumValueOf(name);
}
