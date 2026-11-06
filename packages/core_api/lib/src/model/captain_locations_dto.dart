//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_locations_dto_points_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_locations_dto.g.dart';

/// CaptainLocationsDto
///
/// Properties:
/// * [points] - Every 10 seconds, or the points queued without a signal (CA §4.3).
@BuiltValue()
abstract class CaptainLocationsDto
    implements Built<CaptainLocationsDto, CaptainLocationsDtoBuilder> {
  /// Every 10 seconds, or the points queued without a signal (CA §4.3).
  @BuiltValueField(wireName: r'points')
  BuiltList<CaptainLocationsDtoPointsInner> get points;

  CaptainLocationsDto._();

  factory CaptainLocationsDto([void updates(CaptainLocationsDtoBuilder b)]) =
      _$CaptainLocationsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainLocationsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainLocationsDto> get serializer =>
      _$CaptainLocationsDtoSerializer();
}

class _$CaptainLocationsDtoSerializer
    implements PrimitiveSerializer<CaptainLocationsDto> {
  @override
  final Iterable<Type> types = const [
    CaptainLocationsDto,
    _$CaptainLocationsDto,
  ];

  @override
  final String wireName = r'CaptainLocationsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainLocationsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'points';
    yield serializers.serialize(
      object.points,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainLocationsDtoPointsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainLocationsDto object, {
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
    required CaptainLocationsDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'points':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainLocationsDtoPointsInner),
                    ]),
                  )
                  as BuiltList<CaptainLocationsDtoPointsInner>;
          result.points.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainLocationsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainLocationsDtoBuilder();
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
