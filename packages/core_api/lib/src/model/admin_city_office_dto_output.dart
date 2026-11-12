//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_city_office_dto_output_office.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_city_office_dto_output.g.dart';

/// AdminCityOfficeDtoOutput
///
/// Properties:
/// * [office]
@BuiltValue()
abstract class AdminCityOfficeDtoOutput
    implements
        Built<AdminCityOfficeDtoOutput, AdminCityOfficeDtoOutputBuilder> {
  @BuiltValueField(wireName: r'office')
  AdminCityOfficeDtoOutputOffice? get office;

  AdminCityOfficeDtoOutput._();

  factory AdminCityOfficeDtoOutput([
    void updates(AdminCityOfficeDtoOutputBuilder b),
  ]) = _$AdminCityOfficeDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCityOfficeDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCityOfficeDtoOutput> get serializer =>
      _$AdminCityOfficeDtoOutputSerializer();
}

class _$AdminCityOfficeDtoOutputSerializer
    implements PrimitiveSerializer<AdminCityOfficeDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCityOfficeDtoOutput,
    _$AdminCityOfficeDtoOutput,
  ];

  @override
  final String wireName = r'AdminCityOfficeDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCityOfficeDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'office';
    yield object.office == null
        ? null
        : serializers.serialize(
            object.office,
            specifiedType: const FullType.nullable(
              AdminCityOfficeDtoOutputOffice,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCityOfficeDtoOutput object, {
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
    required AdminCityOfficeDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'office':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCityOfficeDtoOutputOffice,
                    ),
                  )
                  as AdminCityOfficeDtoOutputOffice?;
          if (valueDes == null) continue;
          result.office.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCityOfficeDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCityOfficeDtoOutputBuilder();
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
