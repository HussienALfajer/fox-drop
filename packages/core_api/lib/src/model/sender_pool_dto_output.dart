//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/sender_pool_dto_output_alerts_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/sender_pool_dto_output_numbers_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sender_pool_dto_output.g.dart';

/// SenderPoolDtoOutput
///
/// Properties:
/// * [numbers]
/// * [alerts] - The alerts of architecture §8.3.3 item 14 (AP §9.1.3).
@BuiltValue()
abstract class SenderPoolDtoOutput
    implements Built<SenderPoolDtoOutput, SenderPoolDtoOutputBuilder> {
  @BuiltValueField(wireName: r'numbers')
  BuiltList<SenderPoolDtoOutputNumbersInner> get numbers;

  /// The alerts of architecture §8.3.3 item 14 (AP §9.1.3).
  @BuiltValueField(wireName: r'alerts')
  BuiltList<SenderPoolDtoOutputAlertsInner> get alerts;

  SenderPoolDtoOutput._();

  factory SenderPoolDtoOutput([void updates(SenderPoolDtoOutputBuilder b)]) =
      _$SenderPoolDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SenderPoolDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SenderPoolDtoOutput> get serializer =>
      _$SenderPoolDtoOutputSerializer();
}

class _$SenderPoolDtoOutputSerializer
    implements PrimitiveSerializer<SenderPoolDtoOutput> {
  @override
  final Iterable<Type> types = const [
    SenderPoolDtoOutput,
    _$SenderPoolDtoOutput,
  ];

  @override
  final String wireName = r'SenderPoolDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SenderPoolDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'numbers';
    yield serializers.serialize(
      object.numbers,
      specifiedType: const FullType(BuiltList, [
        FullType(SenderPoolDtoOutputNumbersInner),
      ]),
    );
    yield r'alerts';
    yield serializers.serialize(
      object.alerts,
      specifiedType: const FullType(BuiltList, [
        FullType(SenderPoolDtoOutputAlertsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutput object, {
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
    required SenderPoolDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'numbers':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(SenderPoolDtoOutputNumbersInner),
                    ]),
                  )
                  as BuiltList<SenderPoolDtoOutputNumbersInner>;
          result.numbers.replace(valueDes);
          break;
        case r'alerts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(SenderPoolDtoOutputAlertsInner),
                    ]),
                  )
                  as BuiltList<SenderPoolDtoOutputAlertsInner>;
          result.alerts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SenderPoolDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SenderPoolDtoOutputBuilder();
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
