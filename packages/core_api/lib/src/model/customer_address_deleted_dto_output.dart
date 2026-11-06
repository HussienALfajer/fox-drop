//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_address_deleted_dto_output.g.dart';

/// CustomerAddressDeletedDtoOutput
///
/// Properties:
/// * [status]
@BuiltValue()
abstract class CustomerAddressDeletedDtoOutput
    implements
        Built<
          CustomerAddressDeletedDtoOutput,
          CustomerAddressDeletedDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'status')
  CustomerAddressDeletedDtoOutputStatusEnum get status;
  // enum statusEnum {  deleted,  };

  CustomerAddressDeletedDtoOutput._();

  factory CustomerAddressDeletedDtoOutput([
    void updates(CustomerAddressDeletedDtoOutputBuilder b),
  ]) = _$CustomerAddressDeletedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerAddressDeletedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerAddressDeletedDtoOutput> get serializer =>
      _$CustomerAddressDeletedDtoOutputSerializer();
}

class _$CustomerAddressDeletedDtoOutputSerializer
    implements PrimitiveSerializer<CustomerAddressDeletedDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerAddressDeletedDtoOutput,
    _$CustomerAddressDeletedDtoOutput,
  ];

  @override
  final String wireName = r'CustomerAddressDeletedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerAddressDeletedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CustomerAddressDeletedDtoOutputStatusEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerAddressDeletedDtoOutput object, {
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
    required CustomerAddressDeletedDtoOutputBuilder result,
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
                      CustomerAddressDeletedDtoOutputStatusEnum,
                    ),
                  )
                  as CustomerAddressDeletedDtoOutputStatusEnum;
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
  CustomerAddressDeletedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerAddressDeletedDtoOutputBuilder();
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

class CustomerAddressDeletedDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'deleted')
  static const CustomerAddressDeletedDtoOutputStatusEnum deleted =
      _$customerAddressDeletedDtoOutputStatusEnum_deleted;

  static Serializer<CustomerAddressDeletedDtoOutputStatusEnum> get serializer =>
      _$customerAddressDeletedDtoOutputStatusEnumSerializer;

  const CustomerAddressDeletedDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<CustomerAddressDeletedDtoOutputStatusEnum> get values =>
      _$customerAddressDeletedDtoOutputStatusEnumValues;
  static CustomerAddressDeletedDtoOutputStatusEnum valueOf(String name) =>
      _$customerAddressDeletedDtoOutputStatusEnumValueOf(name);
}
