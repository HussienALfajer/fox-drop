//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settle_deposit_dto.g.dart';

/// AdminSettleDepositDto
///
/// Properties:
/// * [cityId]
/// * [applicationId]
/// * [settlement] - refunded when the kit came back (cash, a receipt), withheld otherwise.
@BuiltValue()
abstract class AdminSettleDepositDto
    implements Built<AdminSettleDepositDto, AdminSettleDepositDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'applicationId')
  String get applicationId;

  /// refunded when the kit came back (cash, a receipt), withheld otherwise.
  @BuiltValueField(wireName: r'settlement')
  AdminSettleDepositDtoSettlementEnum get settlement;
  // enum settlementEnum {  refunded,  withheld,  };

  AdminSettleDepositDto._();

  factory AdminSettleDepositDto([
    void updates(AdminSettleDepositDtoBuilder b),
  ]) = _$AdminSettleDepositDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettleDepositDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettleDepositDto> get serializer =>
      _$AdminSettleDepositDtoSerializer();
}

class _$AdminSettleDepositDtoSerializer
    implements PrimitiveSerializer<AdminSettleDepositDto> {
  @override
  final Iterable<Type> types = const [
    AdminSettleDepositDto,
    _$AdminSettleDepositDto,
  ];

  @override
  final String wireName = r'AdminSettleDepositDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettleDepositDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'applicationId';
    yield serializers.serialize(
      object.applicationId,
      specifiedType: const FullType(String),
    );
    yield r'settlement';
    yield serializers.serialize(
      object.settlement,
      specifiedType: const FullType(AdminSettleDepositDtoSettlementEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettleDepositDto object, {
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
    required AdminSettleDepositDtoBuilder result,
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
        case r'applicationId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.applicationId = valueDes;
          break;
        case r'settlement':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminSettleDepositDtoSettlementEnum,
                    ),
                  )
                  as AdminSettleDepositDtoSettlementEnum;
          result.settlement = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSettleDepositDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettleDepositDtoBuilder();
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

/// refunded when the kit came back (cash, a receipt), withheld otherwise.
class AdminSettleDepositDtoSettlementEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'refunded')
  static const AdminSettleDepositDtoSettlementEnum refunded =
      _$adminSettleDepositDtoSettlementEnum_refunded;
  @BuiltValueEnumConst(wireName: r'withheld')
  static const AdminSettleDepositDtoSettlementEnum withheld =
      _$adminSettleDepositDtoSettlementEnum_withheld;

  static Serializer<AdminSettleDepositDtoSettlementEnum> get serializer =>
      _$adminSettleDepositDtoSettlementEnumSerializer;

  const AdminSettleDepositDtoSettlementEnum._(String name) : super(name);

  static BuiltSet<AdminSettleDepositDtoSettlementEnum> get values =>
      _$adminSettleDepositDtoSettlementEnumValues;
  static AdminSettleDepositDtoSettlementEnum valueOf(String name) =>
      _$adminSettleDepositDtoSettlementEnumValueOf(name);
}
