//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_all_cities_dto_output_cities_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_all_cities_dto_output.g.dart';

/// AdminAllCitiesDtoOutput
///
/// Properties:
/// * [cities] - Every city, active or not, by name.
@BuiltValue()
abstract class AdminAllCitiesDtoOutput
    implements Built<AdminAllCitiesDtoOutput, AdminAllCitiesDtoOutputBuilder> {
  /// Every city, active or not, by name.
  @BuiltValueField(wireName: r'cities')
  BuiltList<AdminAllCitiesDtoOutputCitiesInner> get cities;

  AdminAllCitiesDtoOutput._();

  factory AdminAllCitiesDtoOutput([
    void updates(AdminAllCitiesDtoOutputBuilder b),
  ]) = _$AdminAllCitiesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminAllCitiesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminAllCitiesDtoOutput> get serializer =>
      _$AdminAllCitiesDtoOutputSerializer();
}

class _$AdminAllCitiesDtoOutputSerializer
    implements PrimitiveSerializer<AdminAllCitiesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminAllCitiesDtoOutput,
    _$AdminAllCitiesDtoOutput,
  ];

  @override
  final String wireName = r'AdminAllCitiesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminAllCitiesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cities';
    yield serializers.serialize(
      object.cities,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminAllCitiesDtoOutputCitiesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminAllCitiesDtoOutput object, {
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
    required AdminAllCitiesDtoOutputBuilder result,
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
                      FullType(AdminAllCitiesDtoOutputCitiesInner),
                    ]),
                  )
                  as BuiltList<AdminAllCitiesDtoOutputCitiesInner>;
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
  AdminAllCitiesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminAllCitiesDtoOutputBuilder();
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
