//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_suggested_dto_output.g.dart';

/// CustomerSuggestedDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class CustomerSuggestedDtoOutput
    implements
        Built<CustomerSuggestedDtoOutput, CustomerSuggestedDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  CustomerSuggestedDtoOutputStatusEnum get status;
  // enum statusEnum {  received,  };

  CustomerSuggestedDtoOutput._();

  factory CustomerSuggestedDtoOutput([
    void updates(CustomerSuggestedDtoOutputBuilder b),
  ]) = _$CustomerSuggestedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerSuggestedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerSuggestedDtoOutput> get serializer =>
      _$CustomerSuggestedDtoOutputSerializer();
}

class _$CustomerSuggestedDtoOutputSerializer
    implements PrimitiveSerializer<CustomerSuggestedDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerSuggestedDtoOutput,
    _$CustomerSuggestedDtoOutput,
  ];

  @override
  final String wireName = r'CustomerSuggestedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSuggestedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CustomerSuggestedDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSuggestedDtoOutput object, {
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
    required CustomerSuggestedDtoOutputBuilder result,
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
                      CustomerSuggestedDtoOutputStatusEnum,
                    ),
                  )
                  as CustomerSuggestedDtoOutputStatusEnum;
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
  CustomerSuggestedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerSuggestedDtoOutputBuilder();
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

class CustomerSuggestedDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'received')
  static const CustomerSuggestedDtoOutputStatusEnum received =
      _$customerSuggestedDtoOutputStatusEnum_received;

  static Serializer<CustomerSuggestedDtoOutputStatusEnum> get serializer =>
      _$customerSuggestedDtoOutputStatusEnumSerializer;

  const CustomerSuggestedDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<CustomerSuggestedDtoOutputStatusEnum> get values =>
      _$customerSuggestedDtoOutputStatusEnumValues;
  static CustomerSuggestedDtoOutputStatusEnum valueOf(String name) =>
      _$customerSuggestedDtoOutputStatusEnumValueOf(name);
}
