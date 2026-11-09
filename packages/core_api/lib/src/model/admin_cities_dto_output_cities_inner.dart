//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cities_dto_output_cities_inner.g.dart';

/// AdminCitiesDtoOutputCitiesInner
///
/// Properties:
/// * [id]
/// * [code] - Such as AZ (AP §4.8).
/// * [name]
/// * [timeZone] - The city's clock, such as Asia/Damascus.
@BuiltValue()
abstract class AdminCitiesDtoOutputCitiesInner
    implements
        Built<
          AdminCitiesDtoOutputCitiesInner,
          AdminCitiesDtoOutputCitiesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Such as AZ (AP §4.8).
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// The city's clock, such as Asia/Damascus.
  @BuiltValueField(wireName: r'timeZone')
  String get timeZone;

  AdminCitiesDtoOutputCitiesInner._();

  factory AdminCitiesDtoOutputCitiesInner([
    void updates(AdminCitiesDtoOutputCitiesInnerBuilder b),
  ]) = _$AdminCitiesDtoOutputCitiesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCitiesDtoOutputCitiesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCitiesDtoOutputCitiesInner> get serializer =>
      _$AdminCitiesDtoOutputCitiesInnerSerializer();
}

class _$AdminCitiesDtoOutputCitiesInnerSerializer
    implements PrimitiveSerializer<AdminCitiesDtoOutputCitiesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCitiesDtoOutputCitiesInner,
    _$AdminCitiesDtoOutputCitiesInner,
  ];

  @override
  final String wireName = r'AdminCitiesDtoOutputCitiesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCitiesDtoOutputCitiesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'timeZone';
    yield serializers.serialize(
      object.timeZone,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCitiesDtoOutputCitiesInner object, {
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
    required AdminCitiesDtoOutputCitiesInnerBuilder result,
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
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
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
        case r'timeZone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.timeZone = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCitiesDtoOutputCitiesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCitiesDtoOutputCitiesInnerBuilder();
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
