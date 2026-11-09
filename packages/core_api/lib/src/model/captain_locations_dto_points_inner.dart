//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_locations_dto_points_inner.g.dart';

/// CaptainLocationsDtoPointsInner
///
/// Properties:
/// * [latitude] 
/// * [longitude] 
/// * [accuracyMetres] 
/// * [recordedAt] - On the server clock (CA §4.6).
/// * [simulated] 
@BuiltValue()
abstract class CaptainLocationsDtoPointsInner implements Built<CaptainLocationsDtoPointsInner, CaptainLocationsDtoPointsInnerBuilder> {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  @BuiltValueField(wireName: r'accuracyMetres')
  num get accuracyMetres;

  /// On the server clock (CA §4.6).
  @BuiltValueField(wireName: r'recordedAt')
  DateTime get recordedAt;

  @BuiltValueField(wireName: r'simulated')
  bool get simulated;

  CaptainLocationsDtoPointsInner._();

  factory CaptainLocationsDtoPointsInner([void updates(CaptainLocationsDtoPointsInnerBuilder b)]) = _$CaptainLocationsDtoPointsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainLocationsDtoPointsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainLocationsDtoPointsInner> get serializer => _$CaptainLocationsDtoPointsInnerSerializer();
}

class _$CaptainLocationsDtoPointsInnerSerializer implements PrimitiveSerializer<CaptainLocationsDtoPointsInner> {
  @override
  final Iterable<Type> types = const [CaptainLocationsDtoPointsInner, _$CaptainLocationsDtoPointsInner];

  @override
  final String wireName = r'CaptainLocationsDtoPointsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainLocationsDtoPointsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'latitude';
    yield serializers.serialize(
      object.latitude,
      specifiedType: const FullType(num),
    );
    yield r'longitude';
    yield serializers.serialize(
      object.longitude,
      specifiedType: const FullType(num),
    );
    yield r'accuracyMetres';
    yield serializers.serialize(
      object.accuracyMetres,
      specifiedType: const FullType(num),
    );
    yield r'recordedAt';
    yield serializers.serialize(
      object.recordedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'simulated';
    yield serializers.serialize(
      object.simulated,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainLocationsDtoPointsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainLocationsDtoPointsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.longitude = valueDes;
          break;
        case r'accuracyMetres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(num),
          ) as num;
          result.accuracyMetres = valueDes;
          break;
        case r'recordedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.recordedAt = valueDes;
          break;
        case r'simulated':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.simulated = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainLocationsDtoPointsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainLocationsDtoPointsInnerBuilder();
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


