//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_holiday_close_dto.g.dart';

/// AdminRestaurantHolidayCloseDto
///
/// Properties:
/// * [startsAt] - null: from now.
/// * [endsAt]
/// * [message] - To customers, up to 100 characters.
/// * [reason] - Why, for the change log (AP §9.6.4).
@BuiltValue()
abstract class AdminRestaurantHolidayCloseDto
    implements
        Built<
          AdminRestaurantHolidayCloseDto,
          AdminRestaurantHolidayCloseDtoBuilder
        > {
  /// null: from now.
  @BuiltValueField(wireName: r'startsAt')
  DateTime? get startsAt;

  @BuiltValueField(wireName: r'endsAt')
  DateTime get endsAt;

  /// To customers, up to 100 characters.
  @BuiltValueField(wireName: r'message')
  String? get message;

  /// Why, for the change log (AP §9.6.4).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminRestaurantHolidayCloseDto._();

  factory AdminRestaurantHolidayCloseDto([
    void updates(AdminRestaurantHolidayCloseDtoBuilder b),
  ]) = _$AdminRestaurantHolidayCloseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantHolidayCloseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantHolidayCloseDto> get serializer =>
      _$AdminRestaurantHolidayCloseDtoSerializer();
}

class _$AdminRestaurantHolidayCloseDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantHolidayCloseDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantHolidayCloseDto,
    _$AdminRestaurantHolidayCloseDto,
  ];

  @override
  final String wireName = r'AdminRestaurantHolidayCloseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantHolidayCloseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'startsAt';
    yield object.startsAt == null
        ? null
        : serializers.serialize(
            object.startsAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'endsAt';
    yield serializers.serialize(
      object.endsAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'message';
    yield object.message == null
        ? null
        : serializers.serialize(
            object.message,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantHolidayCloseDto object, {
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
    required AdminRestaurantHolidayCloseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'startsAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.startsAt = valueDes;
          break;
        case r'endsAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.endsAt = valueDes;
          break;
        case r'message':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.message = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantHolidayCloseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantHolidayCloseDtoBuilder();
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
