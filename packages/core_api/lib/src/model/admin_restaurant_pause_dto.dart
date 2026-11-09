//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_pause_dto.g.dart';

/// AdminRestaurantPauseDto
///
/// Properties:
/// * [minutes] - 15, 30 or 60; null with until, or for «حتى الاستئناف».
/// * [until] - A later time; null with minutes, or for «حتى الاستئناف».
/// * [message] - To customers, up to 100 characters.
/// * [reason] - Why, for the change log (AP §9.6.4).
@BuiltValue()
abstract class AdminRestaurantPauseDto
    implements Built<AdminRestaurantPauseDto, AdminRestaurantPauseDtoBuilder> {
  /// 15, 30 or 60; null with until, or for «حتى الاستئناف».
  @BuiltValueField(wireName: r'minutes')
  int? get minutes;

  /// A later time; null with minutes, or for «حتى الاستئناف».
  @BuiltValueField(wireName: r'until')
  DateTime? get until;

  /// To customers, up to 100 characters.
  @BuiltValueField(wireName: r'message')
  String? get message;

  /// Why, for the change log (AP §9.6.4).
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminRestaurantPauseDto._();

  factory AdminRestaurantPauseDto([
    void updates(AdminRestaurantPauseDtoBuilder b),
  ]) = _$AdminRestaurantPauseDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantPauseDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantPauseDto> get serializer =>
      _$AdminRestaurantPauseDtoSerializer();
}

class _$AdminRestaurantPauseDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantPauseDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantPauseDto,
    _$AdminRestaurantPauseDto,
  ];

  @override
  final String wireName = r'AdminRestaurantPauseDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantPauseDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'minutes';
    yield object.minutes == null
        ? null
        : serializers.serialize(
            object.minutes,
            specifiedType: const FullType.nullable(int),
          );
    yield r'until';
    yield object.until == null
        ? null
        : serializers.serialize(
            object.until,
            specifiedType: const FullType.nullable(DateTime),
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
    AdminRestaurantPauseDto object, {
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
    required AdminRestaurantPauseDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'minutes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.minutes = valueDes;
          break;
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.until = valueDes;
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
  AdminRestaurantPauseDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantPauseDtoBuilder();
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
