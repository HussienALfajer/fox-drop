//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_city_office_dto_output_office_hours_inner.g.dart';

/// AdminCityOfficeDtoOutputOfficeHoursInner
///
/// Properties:
/// * [weekday] - 0 Sunday to 6 Saturday.
/// * [opensAt] - Minutes after midnight, city clock.
/// * [closesAt] - Minutes after midnight; at or before the opening it runs past midnight.
@BuiltValue()
abstract class AdminCityOfficeDtoOutputOfficeHoursInner
    implements
        Built<
          AdminCityOfficeDtoOutputOfficeHoursInner,
          AdminCityOfficeDtoOutputOfficeHoursInnerBuilder
        > {
  /// 0 Sunday to 6 Saturday.
  @BuiltValueField(wireName: r'weekday')
  int get weekday;

  /// Minutes after midnight, city clock.
  @BuiltValueField(wireName: r'opensAt')
  int get opensAt;

  /// Minutes after midnight; at or before the opening it runs past midnight.
  @BuiltValueField(wireName: r'closesAt')
  int get closesAt;

  AdminCityOfficeDtoOutputOfficeHoursInner._();

  factory AdminCityOfficeDtoOutputOfficeHoursInner([
    void updates(AdminCityOfficeDtoOutputOfficeHoursInnerBuilder b),
  ]) = _$AdminCityOfficeDtoOutputOfficeHoursInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCityOfficeDtoOutputOfficeHoursInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCityOfficeDtoOutputOfficeHoursInner> get serializer =>
      _$AdminCityOfficeDtoOutputOfficeHoursInnerSerializer();
}

class _$AdminCityOfficeDtoOutputOfficeHoursInnerSerializer
    implements PrimitiveSerializer<AdminCityOfficeDtoOutputOfficeHoursInner> {
  @override
  final Iterable<Type> types = const [
    AdminCityOfficeDtoOutputOfficeHoursInner,
    _$AdminCityOfficeDtoOutputOfficeHoursInner,
  ];

  @override
  final String wireName = r'AdminCityOfficeDtoOutputOfficeHoursInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCityOfficeDtoOutputOfficeHoursInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'weekday';
    yield serializers.serialize(
      object.weekday,
      specifiedType: const FullType(int),
    );
    yield r'opensAt';
    yield serializers.serialize(
      object.opensAt,
      specifiedType: const FullType(int),
    );
    yield r'closesAt';
    yield serializers.serialize(
      object.closesAt,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCityOfficeDtoOutputOfficeHoursInner object, {
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
    required AdminCityOfficeDtoOutputOfficeHoursInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'weekday':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.weekday = valueDes;
          break;
        case r'opensAt':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.opensAt = valueDes;
          break;
        case r'closesAt':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.closesAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCityOfficeDtoOutputOfficeHoursInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCityOfficeDtoOutputOfficeHoursInnerBuilder();
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
