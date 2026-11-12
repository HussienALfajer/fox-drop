//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_city_office_dto_output_office_location.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_city_office_dto_output_office_hours_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_city_office_dto_output_office.g.dart';

/// Null until the owner saves one.
///
/// Properties:
/// * [location]
/// * [hours] - One period per weekday at most; none is closed.
/// * [open] - Whether the desk is open now.
/// * [closesAt] - While open: when it closes.
/// * [opensAt] - While closed: when it opens next.
@BuiltValue()
abstract class AdminCityOfficeDtoOutputOffice
    implements
        Built<
          AdminCityOfficeDtoOutputOffice,
          AdminCityOfficeDtoOutputOfficeBuilder
        > {
  @BuiltValueField(wireName: r'location')
  AdminCityOfficeDtoOutputOfficeLocation get location;

  /// One period per weekday at most; none is closed.
  @BuiltValueField(wireName: r'hours')
  BuiltList<AdminCityOfficeDtoOutputOfficeHoursInner> get hours;

  /// Whether the desk is open now.
  @BuiltValueField(wireName: r'open')
  bool get open;

  /// While open: when it closes.
  @BuiltValueField(wireName: r'closesAt')
  DateTime? get closesAt;

  /// While closed: when it opens next.
  @BuiltValueField(wireName: r'opensAt')
  DateTime? get opensAt;

  AdminCityOfficeDtoOutputOffice._();

  factory AdminCityOfficeDtoOutputOffice([
    void updates(AdminCityOfficeDtoOutputOfficeBuilder b),
  ]) = _$AdminCityOfficeDtoOutputOffice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCityOfficeDtoOutputOfficeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCityOfficeDtoOutputOffice> get serializer =>
      _$AdminCityOfficeDtoOutputOfficeSerializer();
}

class _$AdminCityOfficeDtoOutputOfficeSerializer
    implements PrimitiveSerializer<AdminCityOfficeDtoOutputOffice> {
  @override
  final Iterable<Type> types = const [
    AdminCityOfficeDtoOutputOffice,
    _$AdminCityOfficeDtoOutputOffice,
  ];

  @override
  final String wireName = r'AdminCityOfficeDtoOutputOffice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCityOfficeDtoOutputOffice object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(AdminCityOfficeDtoOutputOfficeLocation),
    );
    yield r'hours';
    yield serializers.serialize(
      object.hours,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCityOfficeDtoOutputOfficeHoursInner),
      ]),
    );
    yield r'open';
    yield serializers.serialize(
      object.open,
      specifiedType: const FullType(bool),
    );
    yield r'closesAt';
    yield object.closesAt == null
        ? null
        : serializers.serialize(
            object.closesAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'opensAt';
    yield object.opensAt == null
        ? null
        : serializers.serialize(
            object.opensAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCityOfficeDtoOutputOffice object, {
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
    required AdminCityOfficeDtoOutputOfficeBuilder result,
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
                      AdminCityOfficeDtoOutputOfficeLocation,
                    ),
                  )
                  as AdminCityOfficeDtoOutputOfficeLocation;
          result.location.replace(valueDes);
          break;
        case r'hours':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCityOfficeDtoOutputOfficeHoursInner),
                    ]),
                  )
                  as BuiltList<AdminCityOfficeDtoOutputOfficeHoursInner>;
          result.hours.replace(valueDes);
          break;
        case r'open':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.open = valueDes;
          break;
        case r'closesAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.closesAt = valueDes;
          break;
        case r'opensAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.opensAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCityOfficeDtoOutputOffice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCityOfficeDtoOutputOfficeBuilder();
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
