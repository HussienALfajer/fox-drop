//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_zones_dto_output_votes_inner.g.dart';

/// AdminZonesDtoOutputVotesInner
///
/// Properties:
/// * [latitude]
/// * [longitude]
/// * [votes] - The votes in this cell of about 100 m.
@BuiltValue()
abstract class AdminZonesDtoOutputVotesInner
    implements
        Built<
          AdminZonesDtoOutputVotesInner,
          AdminZonesDtoOutputVotesInnerBuilder
        > {
  @BuiltValueField(wireName: r'latitude')
  num get latitude;

  @BuiltValueField(wireName: r'longitude')
  num get longitude;

  /// The votes in this cell of about 100 m.
  @BuiltValueField(wireName: r'votes')
  int get votes;

  AdminZonesDtoOutputVotesInner._();

  factory AdminZonesDtoOutputVotesInner([
    void updates(AdminZonesDtoOutputVotesInnerBuilder b),
  ]) = _$AdminZonesDtoOutputVotesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminZonesDtoOutputVotesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminZonesDtoOutputVotesInner> get serializer =>
      _$AdminZonesDtoOutputVotesInnerSerializer();
}

class _$AdminZonesDtoOutputVotesInnerSerializer
    implements PrimitiveSerializer<AdminZonesDtoOutputVotesInner> {
  @override
  final Iterable<Type> types = const [
    AdminZonesDtoOutputVotesInner,
    _$AdminZonesDtoOutputVotesInner,
  ];

  @override
  final String wireName = r'AdminZonesDtoOutputVotesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminZonesDtoOutputVotesInner object, {
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
    yield r'votes';
    yield serializers.serialize(
      object.votes,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminZonesDtoOutputVotesInner object, {
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
    required AdminZonesDtoOutputVotesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'latitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.latitude = valueDes;
          break;
        case r'longitude':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.longitude = valueDes;
          break;
        case r'votes':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.votes = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminZonesDtoOutputVotesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminZonesDtoOutputVotesInnerBuilder();
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
