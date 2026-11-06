//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_active_order_dto_output_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output.g.dart';

/// CaptainActiveOrderDtoOutput
///
/// Properties:
/// * [order]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutput
    implements
        Built<CaptainActiveOrderDtoOutput, CaptainActiveOrderDtoOutputBuilder> {
  @BuiltValueField(wireName: r'order')
  CaptainActiveOrderDtoOutputOrder? get order;

  CaptainActiveOrderDtoOutput._();

  factory CaptainActiveOrderDtoOutput([
    void updates(CaptainActiveOrderDtoOutputBuilder b),
  ]) = _$CaptainActiveOrderDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutput> get serializer =>
      _$CaptainActiveOrderDtoOutputSerializer();
}

class _$CaptainActiveOrderDtoOutputSerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutput,
    _$CaptainActiveOrderDtoOutput,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order';
    yield object.order == null
        ? null
        : serializers.serialize(
            object.order,
            specifiedType: const FullType.nullable(
              CaptainActiveOrderDtoOutputOrder,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutput object, {
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
    required CaptainActiveOrderDtoOutputBuilder result,
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
                    specifiedType: const FullType.nullable(
                      CaptainActiveOrderDtoOutputOrder,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrder?;
          if (valueDes == null) continue;
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
  CaptainActiveOrderDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputBuilder();
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
