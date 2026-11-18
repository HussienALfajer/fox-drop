//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_ratings_dto_output_reasons_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_ratings_dto_output.g.dart';

/// CaptainRatingsDtoOutput
///
/// Properties:
/// * [count] - Every rating of the captain, test orders left out.
/// * [average] - Their average stars to one decimal; null with none.
/// * [reasons] - Each reason customers picked with its count, most picked first.
@BuiltValue()
abstract class CaptainRatingsDtoOutput
    implements Built<CaptainRatingsDtoOutput, CaptainRatingsDtoOutputBuilder> {
  /// Every rating of the captain, test orders left out.
  @BuiltValueField(wireName: r'count')
  int get count;

  /// Their average stars to one decimal; null with none.
  @BuiltValueField(wireName: r'average')
  num? get average;

  /// Each reason customers picked with its count, most picked first.
  @BuiltValueField(wireName: r'reasons')
  BuiltList<CaptainRatingsDtoOutputReasonsInner> get reasons;

  CaptainRatingsDtoOutput._();

  factory CaptainRatingsDtoOutput([
    void updates(CaptainRatingsDtoOutputBuilder b),
  ]) = _$CaptainRatingsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainRatingsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainRatingsDtoOutput> get serializer =>
      _$CaptainRatingsDtoOutputSerializer();
}

class _$CaptainRatingsDtoOutputSerializer
    implements PrimitiveSerializer<CaptainRatingsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainRatingsDtoOutput,
    _$CaptainRatingsDtoOutput,
  ];

  @override
  final String wireName = r'CaptainRatingsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainRatingsDtoOutput object, {
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
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainRatingsDtoOutputReasonsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainRatingsDtoOutput object, {
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
    required CaptainRatingsDtoOutputBuilder result,
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
        case r'reasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainRatingsDtoOutputReasonsInner),
                    ]),
                  )
                  as BuiltList<CaptainRatingsDtoOutputReasonsInner>;
          result.reasons.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainRatingsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainRatingsDtoOutputBuilder();
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
