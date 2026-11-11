//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_signed_out_dto_output.g.dart';

/// CustomerSignedOutDtoOutput
///
/// Properties:
/// * [status] 
@BuiltValue()
abstract class CustomerSignedOutDtoOutput implements Built<CustomerSignedOutDtoOutput, CustomerSignedOutDtoOutputBuilder> {
  @BuiltValueField(wireName: r'status')
  CustomerSignedOutDtoOutputStatusEnum get status;
  // enum statusEnum {  signed_out,  };

  CustomerSignedOutDtoOutput._();

  factory CustomerSignedOutDtoOutput([void updates(CustomerSignedOutDtoOutputBuilder b)]) = _$CustomerSignedOutDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerSignedOutDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerSignedOutDtoOutput> get serializer => _$CustomerSignedOutDtoOutputSerializer();
}

class _$CustomerSignedOutDtoOutputSerializer implements PrimitiveSerializer<CustomerSignedOutDtoOutput> {
  @override
  final Iterable<Type> types = const [CustomerSignedOutDtoOutput, _$CustomerSignedOutDtoOutput];

  @override
  final String wireName = r'CustomerSignedOutDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSignedOutDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CustomerSignedOutDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSignedOutDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerSignedOutDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerSignedOutDtoOutputStatusEnum),
          ) as CustomerSignedOutDtoOutputStatusEnum;
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
  CustomerSignedOutDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerSignedOutDtoOutputBuilder();
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


class CustomerSignedOutDtoOutputStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'signed_out')
  static const CustomerSignedOutDtoOutputStatusEnum signedOut = _$customerSignedOutDtoOutputStatusEnum_signedOut;

  static Serializer<CustomerSignedOutDtoOutputStatusEnum> get serializer => _$customerSignedOutDtoOutputStatusEnumSerializer;

  const CustomerSignedOutDtoOutputStatusEnum._(String name): super(name);

  static BuiltSet<CustomerSignedOutDtoOutputStatusEnum> get values => _$customerSignedOutDtoOutputStatusEnumValues;
  static CustomerSignedOutDtoOutputStatusEnum valueOf(String name) => _$customerSignedOutDtoOutputStatusEnumValueOf(name);
}

