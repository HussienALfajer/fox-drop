//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_application_zones_dto_output_zones_inner.g.dart';

/// CaptainApplicationZonesDtoOutputZonesInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [cityId]
/// * [cityName]
@BuiltValue()
abstract class CaptainApplicationZonesDtoOutputZonesInner
    implements
        Built<
          CaptainApplicationZonesDtoOutputZonesInner,
          CaptainApplicationZonesDtoOutputZonesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'cityName')
  String get cityName;

  CaptainApplicationZonesDtoOutputZonesInner._();

  factory CaptainApplicationZonesDtoOutputZonesInner([
    void updates(CaptainApplicationZonesDtoOutputZonesInnerBuilder b),
  ]) = _$CaptainApplicationZonesDtoOutputZonesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainApplicationZonesDtoOutputZonesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainApplicationZonesDtoOutputZonesInner>
  get serializer => _$CaptainApplicationZonesDtoOutputZonesInnerSerializer();
}

class _$CaptainApplicationZonesDtoOutputZonesInnerSerializer
    implements PrimitiveSerializer<CaptainApplicationZonesDtoOutputZonesInner> {
  @override
  final Iterable<Type> types = const [
    CaptainApplicationZonesDtoOutputZonesInner,
    _$CaptainApplicationZonesDtoOutputZonesInner,
  ];

  @override
  final String wireName = r'CaptainApplicationZonesDtoOutputZonesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainApplicationZonesDtoOutputZonesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'cityName';
    yield serializers.serialize(
      object.cityName,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationZonesDtoOutputZonesInner object, {
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
    required CaptainApplicationZonesDtoOutputZonesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'cityName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityName = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainApplicationZonesDtoOutputZonesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainApplicationZonesDtoOutputZonesInnerBuilder();
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
