//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_push_received_dto_output.g.dart';

/// CustomerPushReceivedDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class CustomerPushReceivedDtoOutput
    implements
        Built<
          CustomerPushReceivedDtoOutput,
          CustomerPushReceivedDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'status')
  CustomerPushReceivedDtoOutputStatusEnum get status;
  // enum statusEnum {  received,  };

  CustomerPushReceivedDtoOutput._();

  factory CustomerPushReceivedDtoOutput([
    void updates(CustomerPushReceivedDtoOutputBuilder b),
  ]) = _$CustomerPushReceivedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerPushReceivedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerPushReceivedDtoOutput> get serializer =>
      _$CustomerPushReceivedDtoOutputSerializer();
}

class _$CustomerPushReceivedDtoOutputSerializer
    implements PrimitiveSerializer<CustomerPushReceivedDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerPushReceivedDtoOutput,
    _$CustomerPushReceivedDtoOutput,
  ];

  @override
  final String wireName = r'CustomerPushReceivedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerPushReceivedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CustomerPushReceivedDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerPushReceivedDtoOutput object, {
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
    required CustomerPushReceivedDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerPushReceivedDtoOutputStatusEnum,
                    ),
                  )
                  as CustomerPushReceivedDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerPushReceivedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerPushReceivedDtoOutputBuilder();
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

class CustomerPushReceivedDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'received')
  static const CustomerPushReceivedDtoOutputStatusEnum received =
      _$customerPushReceivedDtoOutputStatusEnum_received;

  static Serializer<CustomerPushReceivedDtoOutputStatusEnum> get serializer =>
      _$customerPushReceivedDtoOutputStatusEnumSerializer;

  const CustomerPushReceivedDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<CustomerPushReceivedDtoOutputStatusEnum> get values =>
      _$customerPushReceivedDtoOutputStatusEnumValues;
  static CustomerPushReceivedDtoOutputStatusEnum valueOf(String name) =>
      _$customerPushReceivedDtoOutputStatusEnumValueOf(name);
}
