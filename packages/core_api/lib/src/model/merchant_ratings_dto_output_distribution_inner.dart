//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_ratings_dto_output_distribution_inner.g.dart';

/// MerchantRatingsDtoOutputDistributionInner
///
/// Properties:
/// * [stars]
/// * [count]
@BuiltValue()
abstract class MerchantRatingsDtoOutputDistributionInner
    implements
        Built<
          MerchantRatingsDtoOutputDistributionInner,
          MerchantRatingsDtoOutputDistributionInnerBuilder
        > {
  @BuiltValueField(wireName: r'stars')
  int get stars;

  @BuiltValueField(wireName: r'count')
  int get count;

  MerchantRatingsDtoOutputDistributionInner._();

  factory MerchantRatingsDtoOutputDistributionInner([
    void updates(MerchantRatingsDtoOutputDistributionInnerBuilder b),
  ]) = _$MerchantRatingsDtoOutputDistributionInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantRatingsDtoOutputDistributionInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantRatingsDtoOutputDistributionInner> get serializer =>
      _$MerchantRatingsDtoOutputDistributionInnerSerializer();
}

class _$MerchantRatingsDtoOutputDistributionInnerSerializer
    implements PrimitiveSerializer<MerchantRatingsDtoOutputDistributionInner> {
  @override
  final Iterable<Type> types = const [
    MerchantRatingsDtoOutputDistributionInner,
    _$MerchantRatingsDtoOutputDistributionInner,
  ];

  @override
  final String wireName = r'MerchantRatingsDtoOutputDistributionInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantRatingsDtoOutputDistributionInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stars';
    yield serializers.serialize(
      object.stars,
      specifiedType: const FullType(int),
    );
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantRatingsDtoOutputDistributionInner object, {
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
    required MerchantRatingsDtoOutputDistributionInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stars':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.stars = valueDes;
          break;
        case r'count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.count = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantRatingsDtoOutputDistributionInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantRatingsDtoOutputDistributionInnerBuilder();
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
