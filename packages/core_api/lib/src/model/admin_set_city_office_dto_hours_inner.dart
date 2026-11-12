//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_city_office_dto_hours_inner.g.dart';

/// AdminSetCityOfficeDtoHoursInner
///
/// Properties:
/// * [weekday] - 0 Sunday to 6 Saturday.
/// * [opensAt] - Minutes after midnight, city clock.
/// * [closesAt] - Minutes after midnight; at or before the opening it runs past midnight.
@BuiltValue()
abstract class AdminSetCityOfficeDtoHoursInner
    implements
        Built<
          AdminSetCityOfficeDtoHoursInner,
          AdminSetCityOfficeDtoHoursInnerBuilder
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

  AdminSetCityOfficeDtoHoursInner._();

  factory AdminSetCityOfficeDtoHoursInner([
    void updates(AdminSetCityOfficeDtoHoursInnerBuilder b),
  ]) = _$AdminSetCityOfficeDtoHoursInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetCityOfficeDtoHoursInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetCityOfficeDtoHoursInner> get serializer =>
      _$AdminSetCityOfficeDtoHoursInnerSerializer();
}

class _$AdminSetCityOfficeDtoHoursInnerSerializer
    implements PrimitiveSerializer<AdminSetCityOfficeDtoHoursInner> {
  @override
  final Iterable<Type> types = const [
    AdminSetCityOfficeDtoHoursInner,
    _$AdminSetCityOfficeDtoHoursInner,
  ];

  @override
  final String wireName = r'AdminSetCityOfficeDtoHoursInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetCityOfficeDtoHoursInner object, {
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
    AdminSetCityOfficeDtoHoursInner object, {
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
    required AdminSetCityOfficeDtoHoursInnerBuilder result,
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
  AdminSetCityOfficeDtoHoursInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetCityOfficeDtoHoursInnerBuilder();
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
