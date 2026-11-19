//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_record_deposit_dto.g.dart';

/// AdminRecordDepositDto
///
/// Properties:
/// * [cityId]
/// * [applicationId]
/// * [amount] - The deposit, in the city's base.
/// * [instalment] - Deducted each Thursday until paid; null for none.
/// * [paidNow] - The cash received now; 0 records the plan alone.
@BuiltValue()
abstract class AdminRecordDepositDto
    implements Built<AdminRecordDepositDto, AdminRecordDepositDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'applicationId')
  String get applicationId;

  /// The deposit, in the city's base.
  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// Deducted each Thursday until paid; null for none.
  @BuiltValueField(wireName: r'instalment')
  String? get instalment;

  /// The cash received now; 0 records the plan alone.
  @BuiltValueField(wireName: r'paidNow')
  String get paidNow;

  AdminRecordDepositDto._();

  factory AdminRecordDepositDto([
    void updates(AdminRecordDepositDtoBuilder b),
  ]) = _$AdminRecordDepositDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRecordDepositDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRecordDepositDto> get serializer =>
      _$AdminRecordDepositDtoSerializer();
}

class _$AdminRecordDepositDtoSerializer
    implements PrimitiveSerializer<AdminRecordDepositDto> {
  @override
  final Iterable<Type> types = const [
    AdminRecordDepositDto,
    _$AdminRecordDepositDto,
  ];

  @override
  final String wireName = r'AdminRecordDepositDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRecordDepositDto object, {
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
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'instalment';
    yield object.instalment == null
        ? null
        : serializers.serialize(
            object.instalment,
            specifiedType: const FullType.nullable(String),
          );
    yield r'paidNow';
    yield serializers.serialize(
      object.paidNow,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRecordDepositDto object, {
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
    required AdminRecordDepositDtoBuilder result,
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
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'instalment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.instalment = valueDes;
          break;
        case r'paidNow':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.paidNow = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRecordDepositDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRecordDepositDtoBuilder();
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
