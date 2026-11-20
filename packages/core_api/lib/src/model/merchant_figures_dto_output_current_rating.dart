//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_figures_dto_output_current_rating.g.dart';

/// MerchantFiguresDtoOutputCurrentRating
///
/// Properties:
/// * [count]
/// * [average]
@BuiltValue()
abstract class MerchantFiguresDtoOutputCurrentRating
    implements
        Built<
          MerchantFiguresDtoOutputCurrentRating,
          MerchantFiguresDtoOutputCurrentRatingBuilder
        > {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'average')
  num? get average;

  MerchantFiguresDtoOutputCurrentRating._();

  factory MerchantFiguresDtoOutputCurrentRating([
    void updates(MerchantFiguresDtoOutputCurrentRatingBuilder b),
  ]) = _$MerchantFiguresDtoOutputCurrentRating;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantFiguresDtoOutputCurrentRatingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantFiguresDtoOutputCurrentRating> get serializer =>
      _$MerchantFiguresDtoOutputCurrentRatingSerializer();
}

class _$MerchantFiguresDtoOutputCurrentRatingSerializer
    implements PrimitiveSerializer<MerchantFiguresDtoOutputCurrentRating> {
  @override
  final Iterable<Type> types = const [
    MerchantFiguresDtoOutputCurrentRating,
    _$MerchantFiguresDtoOutputCurrentRating,
  ];

  @override
  final String wireName = r'MerchantFiguresDtoOutputCurrentRating';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantFiguresDtoOutputCurrentRating object, {
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
    MerchantFiguresDtoOutputCurrentRating object, {
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
    required MerchantFiguresDtoOutputCurrentRatingBuilder result,
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
  MerchantFiguresDtoOutputCurrentRating deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantFiguresDtoOutputCurrentRatingBuilder();
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
