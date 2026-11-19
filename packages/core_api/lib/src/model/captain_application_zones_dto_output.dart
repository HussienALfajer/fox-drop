//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_application_zones_dto_output_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_application_zones_dto_output.g.dart';

/// CaptainApplicationZonesDtoOutput
///
/// Properties:
/// * [zones]
@BuiltValue()
abstract class CaptainApplicationZonesDtoOutput
    implements
        Built<
          CaptainApplicationZonesDtoOutput,
          CaptainApplicationZonesDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'zones')
  BuiltList<CaptainApplicationZonesDtoOutputZonesInner> get zones;

  CaptainApplicationZonesDtoOutput._();

  factory CaptainApplicationZonesDtoOutput([
    void updates(CaptainApplicationZonesDtoOutputBuilder b),
  ]) = _$CaptainApplicationZonesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainApplicationZonesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainApplicationZonesDtoOutput> get serializer =>
      _$CaptainApplicationZonesDtoOutputSerializer();
}

class _$CaptainApplicationZonesDtoOutputSerializer
    implements PrimitiveSerializer<CaptainApplicationZonesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainApplicationZonesDtoOutput,
    _$CaptainApplicationZonesDtoOutput,
  ];

  @override
  final String wireName = r'CaptainApplicationZonesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainApplicationZonesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'zones';
    yield serializers.serialize(
      object.zones,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainApplicationZonesDtoOutputZonesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationZonesDtoOutput object, {
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
    required CaptainApplicationZonesDtoOutputBuilder result,
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
                      FullType(CaptainApplicationZonesDtoOutputZonesInner),
                    ]),
                  )
                  as BuiltList<CaptainApplicationZonesDtoOutputZonesInner>;
          result.zones.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainApplicationZonesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainApplicationZonesDtoOutputBuilder();
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
