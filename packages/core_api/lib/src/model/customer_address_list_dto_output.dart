//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_address_list_dto_output_addresses_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_address_list_dto_output.g.dart';

/// CustomerAddressListDtoOutput
///
/// Properties:
/// * [addresses]
@BuiltValue()
abstract class CustomerAddressListDtoOutput
    implements
        Built<
          CustomerAddressListDtoOutput,
          CustomerAddressListDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'addresses')
  BuiltList<CustomerAddressListDtoOutputAddressesInner> get addresses;

  CustomerAddressListDtoOutput._();

  factory CustomerAddressListDtoOutput([
    void updates(CustomerAddressListDtoOutputBuilder b),
  ]) = _$CustomerAddressListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerAddressListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerAddressListDtoOutput> get serializer =>
      _$CustomerAddressListDtoOutputSerializer();
}

class _$CustomerAddressListDtoOutputSerializer
    implements PrimitiveSerializer<CustomerAddressListDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerAddressListDtoOutput,
    _$CustomerAddressListDtoOutput,
  ];

  @override
  final String wireName = r'CustomerAddressListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerAddressListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'addresses';
    yield serializers.serialize(
      object.addresses,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerAddressListDtoOutputAddressesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerAddressListDtoOutput object, {
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
    required CustomerAddressListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'addresses':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerAddressListDtoOutputAddressesInner),
                    ]),
                  )
                  as BuiltList<CustomerAddressListDtoOutputAddressesInner>;
          result.addresses.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerAddressListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerAddressListDtoOutputBuilder();
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
