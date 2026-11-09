//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_dto_output_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output.g.dart';

/// AdminOrderDtoOutput
///
/// Properties:
/// * [order]
@BuiltValue()
abstract class AdminOrderDtoOutput
    implements Built<AdminOrderDtoOutput, AdminOrderDtoOutputBuilder> {
  @BuiltValueField(wireName: r'order')
  AdminOrderDtoOutputOrder get order;

  AdminOrderDtoOutput._();

  factory AdminOrderDtoOutput([void updates(AdminOrderDtoOutputBuilder b)]) =
      _$AdminOrderDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutput> get serializer =>
      _$AdminOrderDtoOutputSerializer();
}

class _$AdminOrderDtoOutputSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutput,
    _$AdminOrderDtoOutput,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(AdminOrderDtoOutputOrder),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutput object, {
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
    required AdminOrderDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminOrderDtoOutputOrder),
                  )
                  as AdminOrderDtoOutputOrder;
          result.order.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputBuilder();
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
