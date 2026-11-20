//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_figures_output_pause_minutes.g.dart';

/// MerchantFiguresOutputPauseMinutes
///
/// Properties:
/// * [restaurant]
/// * [ops]
/// * [auto]
@BuiltValue()
abstract class MerchantFiguresOutputPauseMinutes
    implements
        Built<
          MerchantFiguresOutputPauseMinutes,
          MerchantFiguresOutputPauseMinutesBuilder
        > {
  @BuiltValueField(wireName: r'restaurant')
  int get restaurant;

  @BuiltValueField(wireName: r'ops')
  int get ops;

  @BuiltValueField(wireName: r'auto')
  int get auto;

  MerchantFiguresOutputPauseMinutes._();

  factory MerchantFiguresOutputPauseMinutes([
    void updates(MerchantFiguresOutputPauseMinutesBuilder b),
  ]) = _$MerchantFiguresOutputPauseMinutes;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantFiguresOutputPauseMinutesBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantFiguresOutputPauseMinutes> get serializer =>
      _$MerchantFiguresOutputPauseMinutesSerializer();
}

class _$MerchantFiguresOutputPauseMinutesSerializer
    implements PrimitiveSerializer<MerchantFiguresOutputPauseMinutes> {
  @override
  final Iterable<Type> types = const [
    MerchantFiguresOutputPauseMinutes,
    _$MerchantFiguresOutputPauseMinutes,
  ];

  @override
  final String wireName = r'MerchantFiguresOutputPauseMinutes';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantFiguresOutputPauseMinutes object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'restaurant';
    yield serializers.serialize(
      object.restaurant,
      specifiedType: const FullType(int),
    );
    yield r'ops';
    yield serializers.serialize(object.ops, specifiedType: const FullType(int));
    yield r'auto';
    yield serializers.serialize(
      object.auto,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantFiguresOutputPauseMinutes object, {
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
    required MerchantFiguresOutputPauseMinutesBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'restaurant':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.restaurant = valueDes;
          break;
        case r'ops':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.ops = valueDes;
          break;
        case r'auto':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.auto = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantFiguresOutputPauseMinutes deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantFiguresOutputPauseMinutesBuilder();
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
