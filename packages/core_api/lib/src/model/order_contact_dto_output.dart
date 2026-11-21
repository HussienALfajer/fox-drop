//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'order_contact_dto_output.g.dart';

/// OrderContactDtoOutput
///
/// Properties:
/// * [phone] - E.164, for the dialer or WhatsApp only: the app never prints it (RA §8.9, CU §11.3, CA §9.5).
@BuiltValue()
abstract class OrderContactDtoOutput
    implements Built<OrderContactDtoOutput, OrderContactDtoOutputBuilder> {
  /// E.164, for the dialer or WhatsApp only: the app never prints it (RA §8.9, CU §11.3, CA §9.5).
  @BuiltValueField(wireName: r'phone')
  String get phone;

  OrderContactDtoOutput._();

  factory OrderContactDtoOutput([
    void updates(OrderContactDtoOutputBuilder b),
  ]) = _$OrderContactDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(OrderContactDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<OrderContactDtoOutput> get serializer =>
      _$OrderContactDtoOutputSerializer();
}

class _$OrderContactDtoOutputSerializer
    implements PrimitiveSerializer<OrderContactDtoOutput> {
  @override
  final Iterable<Type> types = const [
    OrderContactDtoOutput,
    _$OrderContactDtoOutput,
  ];

  @override
  final String wireName = r'OrderContactDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    OrderContactDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'phone';
    yield serializers.serialize(
      object.phone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    OrderContactDtoOutput object, {
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
    required OrderContactDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.phone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  OrderContactDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OrderContactDtoOutputBuilder();
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
