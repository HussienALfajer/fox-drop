//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_zones_dto_output_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_zones_dto_output_votes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_zones_dto_output.g.dart';

/// AdminZonesDtoOutput
///
/// Properties:
/// * [zones] - The city's zones, active or not, by name.
/// * [votes] - Votes from outside the zones, the most voted first (AP §9.12.2).
@BuiltValue()
abstract class AdminZonesDtoOutput
    implements Built<AdminZonesDtoOutput, AdminZonesDtoOutputBuilder> {
  /// The city's zones, active or not, by name.
  @BuiltValueField(wireName: r'zones')
  BuiltList<AdminZonesDtoOutputZonesInner> get zones;

  /// Votes from outside the zones, the most voted first (AP §9.12.2).
  @BuiltValueField(wireName: r'votes')
  BuiltList<AdminZonesDtoOutputVotesInner> get votes;

  AdminZonesDtoOutput._();

  factory AdminZonesDtoOutput([void updates(AdminZonesDtoOutputBuilder b)]) =
      _$AdminZonesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminZonesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminZonesDtoOutput> get serializer =>
      _$AdminZonesDtoOutputSerializer();
}

class _$AdminZonesDtoOutputSerializer
    implements PrimitiveSerializer<AdminZonesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminZonesDtoOutput,
    _$AdminZonesDtoOutput,
  ];

  @override
  final String wireName = r'AdminZonesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminZonesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'zones';
    yield serializers.serialize(
      object.zones,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminZonesDtoOutputZonesInner),
      ]),
    );
    yield r'votes';
    yield serializers.serialize(
      object.votes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminZonesDtoOutputVotesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminZonesDtoOutput object, {
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
    required AdminZonesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'zones':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminZonesDtoOutputZonesInner),
                    ]),
                  )
                  as BuiltList<AdminZonesDtoOutputZonesInner>;
          result.zones.replace(valueDes);
          break;
        case r'votes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminZonesDtoOutputVotesInner),
                    ]),
                  )
                  as BuiltList<AdminZonesDtoOutputVotesInner>;
          result.votes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminZonesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminZonesDtoOutputBuilder();
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
