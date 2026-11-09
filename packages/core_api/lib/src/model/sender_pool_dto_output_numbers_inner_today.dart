//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sender_pool_dto_output_numbers_inner_today.g.dart';

/// Today in Asia/Damascus.
///
/// Properties:
/// * [sent]
/// * [failed]
/// * [delivered]
/// * [read]
@BuiltValue()
abstract class SenderPoolDtoOutputNumbersInnerToday
    implements
        Built<
          SenderPoolDtoOutputNumbersInnerToday,
          SenderPoolDtoOutputNumbersInnerTodayBuilder
        > {
  @BuiltValueField(wireName: r'sent')
  int get sent;

  @BuiltValueField(wireName: r'failed')
  int get failed;

  @BuiltValueField(wireName: r'delivered')
  int get delivered;

  @BuiltValueField(wireName: r'read')
  int get read;

  SenderPoolDtoOutputNumbersInnerToday._();

  factory SenderPoolDtoOutputNumbersInnerToday([
    void updates(SenderPoolDtoOutputNumbersInnerTodayBuilder b),
  ]) = _$SenderPoolDtoOutputNumbersInnerToday;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SenderPoolDtoOutputNumbersInnerTodayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SenderPoolDtoOutputNumbersInnerToday> get serializer =>
      _$SenderPoolDtoOutputNumbersInnerTodaySerializer();
}

class _$SenderPoolDtoOutputNumbersInnerTodaySerializer
    implements PrimitiveSerializer<SenderPoolDtoOutputNumbersInnerToday> {
  @override
  final Iterable<Type> types = const [
    SenderPoolDtoOutputNumbersInnerToday,
    _$SenderPoolDtoOutputNumbersInnerToday,
  ];

  @override
  final String wireName = r'SenderPoolDtoOutputNumbersInnerToday';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SenderPoolDtoOutputNumbersInnerToday object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sent';
    yield serializers.serialize(
      object.sent,
      specifiedType: const FullType(int),
    );
    yield r'failed';
    yield serializers.serialize(
      object.failed,
      specifiedType: const FullType(int),
    );
    yield r'delivered';
    yield serializers.serialize(
      object.delivered,
      specifiedType: const FullType(int),
    );
    yield r'read';
    yield serializers.serialize(
      object.read,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SenderPoolDtoOutputNumbersInnerToday object, {
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
    required SenderPoolDtoOutputNumbersInnerTodayBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sent':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.sent = valueDes;
          break;
        case r'failed':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.failed = valueDes;
          break;
        case r'delivered':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.delivered = valueDes;
          break;
        case r'read':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.read = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SenderPoolDtoOutputNumbersInnerToday deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SenderPoolDtoOutputNumbersInnerTodayBuilder();
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
