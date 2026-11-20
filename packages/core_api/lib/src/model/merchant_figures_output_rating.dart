//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_figures_output_rating.g.dart';

/// MerchantFiguresOutputRating
///
/// Properties:
/// * [count]
/// * [average]
@BuiltValue()
abstract class MerchantFiguresOutputRating
    implements
        Built<MerchantFiguresOutputRating, MerchantFiguresOutputRatingBuilder> {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'average')
  num? get average;

  MerchantFiguresOutputRating._();

  factory MerchantFiguresOutputRating([
    void updates(MerchantFiguresOutputRatingBuilder b),
  ]) = _$MerchantFiguresOutputRating;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantFiguresOutputRatingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantFiguresOutputRating> get serializer =>
      _$MerchantFiguresOutputRatingSerializer();
}

class _$MerchantFiguresOutputRatingSerializer
    implements PrimitiveSerializer<MerchantFiguresOutputRating> {
  @override
  final Iterable<Type> types = const [
    MerchantFiguresOutputRating,
    _$MerchantFiguresOutputRating,
  ];

  @override
  final String wireName = r'MerchantFiguresOutputRating';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantFiguresOutputRating object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'average';
    yield object.average == null
        ? null
        : serializers.serialize(
            object.average,
            specifiedType: const FullType.nullable(num),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantFiguresOutputRating object, {
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
    required MerchantFiguresOutputRatingBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.count = valueDes;
          break;
        case r'average':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.average = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantFiguresOutputRating deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantFiguresOutputRatingBuilder();
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
