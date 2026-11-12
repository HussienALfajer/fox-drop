//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_set_city_office_dto_hours_inner.dart';
import 'package:core_api/src/model/admin_set_city_office_dto_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_city_office_dto.g.dart';

/// AdminSetCityOfficeDto
///
/// Properties:
/// * [location]
/// * [hours]
@BuiltValue()
abstract class AdminSetCityOfficeDto
    implements Built<AdminSetCityOfficeDto, AdminSetCityOfficeDtoBuilder> {
  @BuiltValueField(wireName: r'location')
  AdminSetCityOfficeDtoLocation get location;

  @BuiltValueField(wireName: r'hours')
  BuiltList<AdminSetCityOfficeDtoHoursInner> get hours;

  AdminSetCityOfficeDto._();

  factory AdminSetCityOfficeDto([
    void updates(AdminSetCityOfficeDtoBuilder b),
  ]) = _$AdminSetCityOfficeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetCityOfficeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetCityOfficeDto> get serializer =>
      _$AdminSetCityOfficeDtoSerializer();
}

class _$AdminSetCityOfficeDtoSerializer
    implements PrimitiveSerializer<AdminSetCityOfficeDto> {
  @override
  final Iterable<Type> types = const [
    AdminSetCityOfficeDto,
    _$AdminSetCityOfficeDto,
  ];

  @override
  final String wireName = r'AdminSetCityOfficeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetCityOfficeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(AdminSetCityOfficeDtoLocation),
    );
    yield r'hours';
    yield serializers.serialize(
      object.hours,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSetCityOfficeDtoHoursInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSetCityOfficeDto object, {
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
    required AdminSetCityOfficeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminSetCityOfficeDtoLocation,
                    ),
                  )
                  as AdminSetCityOfficeDtoLocation;
          result.location.replace(valueDes);
          break;
        case r'hours':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSetCityOfficeDtoHoursInner),
                    ]),
                  )
                  as BuiltList<AdminSetCityOfficeDtoHoursInner>;
          result.hours.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSetCityOfficeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetCityOfficeDtoBuilder();
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
