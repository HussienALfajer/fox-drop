//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_ratings_dto_output_distribution_inner.dart';
import 'package:core_api/src/model/merchant_ratings_dto_output_ratings_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_ratings_dto_output.g.dart';

/// MerchantRatingsDtoOutput
///
/// Properties:
/// * [asOf] - The moment the pages are read up to.
/// * [count] - The ratings of the period, test orders left out.
/// * [average] - Their average stars to one decimal; null with none.
/// * [distribution] - The count of each star, from 5 down to 1.
/// * [ratings] - The page, newest first. Never the customer, the order or the time, so a comment cannot be traced (RA §13, CU §12.1).
/// * [more] - Whether a next page follows.
@BuiltValue()
abstract class MerchantRatingsDtoOutput
    implements
        Built<MerchantRatingsDtoOutput, MerchantRatingsDtoOutputBuilder> {
  /// The moment the pages are read up to.
  @BuiltValueField(wireName: r'asOf')
  DateTime get asOf;

  /// The ratings of the period, test orders left out.
  @BuiltValueField(wireName: r'count')
  int get count;

  /// Their average stars to one decimal; null with none.
  @BuiltValueField(wireName: r'average')
  num? get average;

  /// The count of each star, from 5 down to 1.
  @BuiltValueField(wireName: r'distribution')
  BuiltList<MerchantRatingsDtoOutputDistributionInner> get distribution;

  /// The page, newest first. Never the customer, the order or the time, so a comment cannot be traced (RA §13, CU §12.1).
  @BuiltValueField(wireName: r'ratings')
  BuiltList<MerchantRatingsDtoOutputRatingsInner> get ratings;

  /// Whether a next page follows.
  @BuiltValueField(wireName: r'more')
  bool get more;

  MerchantRatingsDtoOutput._();

  factory MerchantRatingsDtoOutput([
    void updates(MerchantRatingsDtoOutputBuilder b),
  ]) = _$MerchantRatingsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantRatingsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantRatingsDtoOutput> get serializer =>
      _$MerchantRatingsDtoOutputSerializer();
}

class _$MerchantRatingsDtoOutputSerializer
    implements PrimitiveSerializer<MerchantRatingsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantRatingsDtoOutput,
    _$MerchantRatingsDtoOutput,
  ];

  @override
  final String wireName = r'MerchantRatingsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantRatingsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'asOf';
    yield serializers.serialize(
      object.asOf,
      specifiedType: const FullType(DateTime),
    );
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
    yield r'distribution';
    yield serializers.serialize(
      object.distribution,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantRatingsDtoOutputDistributionInner),
      ]),
    );
    yield r'ratings';
    yield serializers.serialize(
      object.ratings,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantRatingsDtoOutputRatingsInner),
      ]),
    );
    yield r'more';
    yield serializers.serialize(
      object.more,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantRatingsDtoOutput object, {
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
    required MerchantRatingsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'asOf':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.asOf = valueDes;
          break;
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
        case r'distribution':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantRatingsDtoOutputDistributionInner),
                    ]),
                  )
                  as BuiltList<MerchantRatingsDtoOutputDistributionInner>;
          result.distribution.replace(valueDes);
          break;
        case r'ratings':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantRatingsDtoOutputRatingsInner),
                    ]),
                  )
                  as BuiltList<MerchantRatingsDtoOutputRatingsInner>;
          result.ratings.replace(valueDes);
          break;
        case r'more':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.more = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantRatingsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantRatingsDtoOutputBuilder();
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
