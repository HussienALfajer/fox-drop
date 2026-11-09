//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_cities_dto_output_cities_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cities_dto_output.g.dart';

/// AdminCitiesDtoOutput
///
/// Properties:
/// * [cities] - The active cities, by name.
@BuiltValue()
abstract class AdminCitiesDtoOutput
    implements Built<AdminCitiesDtoOutput, AdminCitiesDtoOutputBuilder> {
  /// The active cities, by name.
  @BuiltValueField(wireName: r'cities')
  BuiltList<AdminCitiesDtoOutputCitiesInner> get cities;

  AdminCitiesDtoOutput._();

  factory AdminCitiesDtoOutput([void updates(AdminCitiesDtoOutputBuilder b)]) =
      _$AdminCitiesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCitiesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCitiesDtoOutput> get serializer =>
      _$AdminCitiesDtoOutputSerializer();
}

class _$AdminCitiesDtoOutputSerializer
    implements PrimitiveSerializer<AdminCitiesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCitiesDtoOutput,
    _$AdminCitiesDtoOutput,
  ];

  @override
  final String wireName = r'AdminCitiesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCitiesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cities';
    yield serializers.serialize(
      object.cities,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCitiesDtoOutputCitiesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCitiesDtoOutput object, {
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
    required AdminCitiesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cities':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCitiesDtoOutputCitiesInner),
                    ]),
                  )
                  as BuiltList<AdminCitiesDtoOutputCitiesInner>;
          result.cities.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCitiesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCitiesDtoOutputBuilder();
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
