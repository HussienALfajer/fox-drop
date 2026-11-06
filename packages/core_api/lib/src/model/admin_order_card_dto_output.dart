//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_card_dto_output_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_card_dto_output.g.dart';

/// AdminOrderCardDtoOutput
///
/// Properties:
/// * [order]
@BuiltValue()
abstract class AdminOrderCardDtoOutput
    implements Built<AdminOrderCardDtoOutput, AdminOrderCardDtoOutputBuilder> {
  @BuiltValueField(wireName: r'order')
  AdminOrderCardDtoOutputOrder get order;

  AdminOrderCardDtoOutput._();

  factory AdminOrderCardDtoOutput([
    void updates(AdminOrderCardDtoOutputBuilder b),
  ]) = _$AdminOrderCardDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderCardDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderCardDtoOutput> get serializer =>
      _$AdminOrderCardDtoOutputSerializer();
}

class _$AdminOrderCardDtoOutputSerializer
    implements PrimitiveSerializer<AdminOrderCardDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminOrderCardDtoOutput,
    _$AdminOrderCardDtoOutput,
  ];

  @override
  final String wireName = r'AdminOrderCardDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderCardDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(AdminOrderCardDtoOutputOrder),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderCardDtoOutput object, {
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
    required AdminOrderCardDtoOutputBuilder result,
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
                    specifiedType: const FullType(AdminOrderCardDtoOutputOrder),
                  )
                  as AdminOrderCardDtoOutputOrder;
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
  AdminOrderCardDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderCardDtoOutputBuilder();
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
