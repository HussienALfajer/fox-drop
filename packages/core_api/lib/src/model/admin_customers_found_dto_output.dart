//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customers_found_dto_output_customers_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customers_found_dto_output.g.dart';

/// AdminCustomersFoundDtoOutput
///
/// Properties:
/// * [customers]
@BuiltValue()
abstract class AdminCustomersFoundDtoOutput
    implements
        Built<
          AdminCustomersFoundDtoOutput,
          AdminCustomersFoundDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'customers')
  BuiltList<AdminCustomersFoundDtoOutputCustomersInner> get customers;

  AdminCustomersFoundDtoOutput._();

  factory AdminCustomersFoundDtoOutput([
    void updates(AdminCustomersFoundDtoOutputBuilder b),
  ]) = _$AdminCustomersFoundDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomersFoundDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomersFoundDtoOutput> get serializer =>
      _$AdminCustomersFoundDtoOutputSerializer();
}

class _$AdminCustomersFoundDtoOutputSerializer
    implements PrimitiveSerializer<AdminCustomersFoundDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCustomersFoundDtoOutput,
    _$AdminCustomersFoundDtoOutput,
  ];

  @override
  final String wireName = r'AdminCustomersFoundDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomersFoundDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'customers';
    yield serializers.serialize(
      object.customers,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomersFoundDtoOutputCustomersInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomersFoundDtoOutput object, {
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
    required AdminCustomersFoundDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'customers':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomersFoundDtoOutputCustomersInner),
                    ]),
                  )
                  as BuiltList<AdminCustomersFoundDtoOutputCustomersInner>;
          result.customers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomersFoundDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomersFoundDtoOutputBuilder();
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
