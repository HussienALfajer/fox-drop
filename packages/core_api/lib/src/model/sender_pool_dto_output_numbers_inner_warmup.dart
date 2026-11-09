//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sender_pool_dto_output_numbers_inner_warmup.g.dart';

/// While warming.
///
/// Properties:
/// * [step] - 1 for the first step of otp.sender_warmup_caps.
/// * [cap]
/// * [nextStepAt]
@BuiltValue()
abstract class SenderPoolDtoOutputNumbersInnerWarmup
    implements
        Built<
          SenderPoolDtoOutputNumbersInnerWarmup,
          SenderPoolDtoOutputNumbersInnerWarmupBuilder
        > {
  /// 1 for the first step of otp.sender_warmup_caps.
  @BuiltValueField(wireName: r'step')
  int get step;

  @BuiltValueField(wireName: r'cap')
  int get cap;

  @BuiltValueField(wireName: r'nextStepAt')
  DateTime get nextStepAt;

  SenderPoolDtoOutputNumbersInnerWarmup._();

  factory SenderPoolDtoOutputNumbersInnerWarmup([
    void updates(SenderPoolDtoOutputNumbersInnerWarmupBuilder b),
  ]) = _$SenderPoolDtoOutputNumbersInnerWarmup;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SenderPoolDtoOutputNumbersInnerWarmupBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SenderPoolDtoOutputNumbersInnerWarmup> get serializer =>
      _$SenderPoolDtoOutputNumbersInnerWarmupSerializer();
}

class _$SenderPoolDtoOutputNumbersInnerWarmupSerializer
    implements PrimitiveSerializer<SenderPoolDtoOutputNumbersInnerWarmup> {
  @override
  final Iterable<Type> types = const [
    SenderPoolDtoOutputNumbersInnerWarmup,
    _$SenderPoolDtoOutputNumbersInnerWarmup,
  ];

  @override
  final String wireName = r'SenderPoolDtoOutputNumbersInnerWarmup';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SenderPoolDtoOutputNumbersInnerWarmup object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'step';
    yield serializers.serialize(
      object.step,
      specifiedType: const FullType(int),
    );
    yield r'cap';
    yield serializers.serialize(object.cap, specifiedType: const FullType(int));
    yield r'nextStepAt';
    yield serializers.serialize(
      object.nextStepAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputNumbersInnerWarmup object, {
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
    required SenderPoolDtoOutputNumbersInnerWarmupBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'step':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.step = valueDes;
          break;
        case r'cap':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.cap = valueDes;
          break;
        case r'nextStepAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.nextStepAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SenderPoolDtoOutputNumbersInnerWarmup deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SenderPoolDtoOutputNumbersInnerWarmupBuilder();
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
