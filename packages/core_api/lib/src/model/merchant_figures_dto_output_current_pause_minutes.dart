//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_figures_dto_output_current_pause_minutes.g.dart';

/// MerchantFiguresDtoOutputCurrentPauseMinutes
///
/// Properties:
/// * [restaurant]
/// * [ops]
/// * [auto]
@BuiltValue()
abstract class MerchantFiguresDtoOutputCurrentPauseMinutes
    implements
        Built<
          MerchantFiguresDtoOutputCurrentPauseMinutes,
          MerchantFiguresDtoOutputCurrentPauseMinutesBuilder
        > {
  @BuiltValueField(wireName: r'restaurant')
  int get restaurant;

  @BuiltValueField(wireName: r'ops')
  int get ops;

  @BuiltValueField(wireName: r'auto')
  int get auto;

  MerchantFiguresDtoOutputCurrentPauseMinutes._();

  factory MerchantFiguresDtoOutputCurrentPauseMinutes([
    void updates(MerchantFiguresDtoOutputCurrentPauseMinutesBuilder b),
  ]) = _$MerchantFiguresDtoOutputCurrentPauseMinutes;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantFiguresDtoOutputCurrentPauseMinutesBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantFiguresDtoOutputCurrentPauseMinutes>
  get serializer => _$MerchantFiguresDtoOutputCurrentPauseMinutesSerializer();
}

class _$MerchantFiguresDtoOutputCurrentPauseMinutesSerializer
    implements
        PrimitiveSerializer<MerchantFiguresDtoOutputCurrentPauseMinutes> {
  @override
  final Iterable<Type> types = const [
    MerchantFiguresDtoOutputCurrentPauseMinutes,
    _$MerchantFiguresDtoOutputCurrentPauseMinutes,
  ];

  @override
  final String wireName = r'MerchantFiguresDtoOutputCurrentPauseMinutes';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantFiguresDtoOutputCurrentPauseMinutes object, {
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
    MerchantFiguresDtoOutputCurrentPauseMinutes object, {
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
    required MerchantFiguresDtoOutputCurrentPauseMinutesBuilder result,
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
  MerchantFiguresDtoOutputCurrentPauseMinutes deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantFiguresDtoOutputCurrentPauseMinutesBuilder();
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
