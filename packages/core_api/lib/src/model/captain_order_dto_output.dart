//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_order_dto_output_order.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_dto_output.g.dart';

/// CaptainOrderDtoOutput
///
/// Properties:
/// * [order] 
@BuiltValue()
abstract class CaptainOrderDtoOutput implements Built<CaptainOrderDtoOutput, CaptainOrderDtoOutputBuilder> {
  @BuiltValueField(wireName: r'order')
  CaptainOrderDtoOutputOrder get order;

  CaptainOrderDtoOutput._();

  factory CaptainOrderDtoOutput([void updates(CaptainOrderDtoOutputBuilder b)]) = _$CaptainOrderDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOrderDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderDtoOutput> get serializer => _$CaptainOrderDtoOutputSerializer();
}

class _$CaptainOrderDtoOutputSerializer implements PrimitiveSerializer<CaptainOrderDtoOutput> {
  @override
  final Iterable<Type> types = const [CaptainOrderDtoOutput, _$CaptainOrderDtoOutput];

  @override
  final String wireName = r'CaptainOrderDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'order';
    yield serializers.serialize(
      object.order,
      specifiedType: const FullType(CaptainOrderDtoOutputOrder),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainOrderDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainOrderDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'order':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CaptainOrderDtoOutputOrder),
          ) as CaptainOrderDtoOutputOrder;
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
  CaptainOrderDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderDtoOutputBuilder();
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


