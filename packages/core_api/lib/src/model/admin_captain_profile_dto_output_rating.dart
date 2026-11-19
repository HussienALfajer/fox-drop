//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_profile_dto_output_rating.g.dart';

/// AdminCaptainProfileDtoOutputRating
///
/// Properties:
/// * [count]
/// * [average]
@BuiltValue()
abstract class AdminCaptainProfileDtoOutputRating
    implements
        Built<
          AdminCaptainProfileDtoOutputRating,
          AdminCaptainProfileDtoOutputRatingBuilder
        > {
  @BuiltValueField(wireName: r'count')
  int get count;

  @BuiltValueField(wireName: r'average')
  num get average;

  AdminCaptainProfileDtoOutputRating._();

  factory AdminCaptainProfileDtoOutputRating([
    void updates(AdminCaptainProfileDtoOutputRatingBuilder b),
  ]) = _$AdminCaptainProfileDtoOutputRating;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainProfileDtoOutputRatingBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainProfileDtoOutputRating> get serializer =>
      _$AdminCaptainProfileDtoOutputRatingSerializer();
}

class _$AdminCaptainProfileDtoOutputRatingSerializer
    implements PrimitiveSerializer<AdminCaptainProfileDtoOutputRating> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainProfileDtoOutputRating,
    _$AdminCaptainProfileDtoOutputRating,
  ];

  @override
  final String wireName = r'AdminCaptainProfileDtoOutputRating';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainProfileDtoOutputRating object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'average';
    yield serializers.serialize(
      object.average,
      specifiedType: const FullType(num),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainProfileDtoOutputRating object, {
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
    required AdminCaptainProfileDtoOutputRatingBuilder result,
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
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
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
  AdminCaptainProfileDtoOutputRating deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainProfileDtoOutputRatingBuilder();
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
