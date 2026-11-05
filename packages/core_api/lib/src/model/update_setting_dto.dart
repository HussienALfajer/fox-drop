//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'update_setting_dto.g.dart';

/// UpdateSettingDto
///
/// Properties:
/// * [cityId] - The city of a city setting; none for a global one.
/// * [value] - The new value, in the shape of its setting; null where the setting allows it.
/// * [reason] - Required for the settings with money impact (reasonRequired).
@BuiltValue()
abstract class UpdateSettingDto
    implements Built<UpdateSettingDto, UpdateSettingDtoBuilder> {
  /// The city of a city setting; none for a global one.
  @BuiltValueField(wireName: r'cityId')
  String? get cityId;

  /// The new value, in the shape of its setting; null where the setting allows it.
  @BuiltValueField(wireName: r'value')
  JsonObject? get value;

  /// Required for the settings with money impact (reasonRequired).
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  UpdateSettingDto._();

  factory UpdateSettingDto([void updates(UpdateSettingDtoBuilder b)]) =
      _$UpdateSettingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UpdateSettingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UpdateSettingDto> get serializer =>
      _$UpdateSettingDtoSerializer();
}

class _$UpdateSettingDtoSerializer
    implements PrimitiveSerializer<UpdateSettingDto> {
  @override
  final Iterable<Type> types = const [UpdateSettingDto, _$UpdateSettingDto];

  @override
  final String wireName = r'UpdateSettingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UpdateSettingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.cityId != null) {
      yield r'cityId';
      yield serializers.serialize(
        object.cityId,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'value';
    yield object.value == null
        ? null
        : serializers.serialize(
            object.value,
            specifiedType: const FullType.nullable(JsonObject),
          );
    if (object.reason != null) {
      yield r'reason';
      yield serializers.serialize(
        object.reason,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    UpdateSettingDto object, {
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
    required UpdateSettingDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.cityId = valueDes;
          break;
        case r'value':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(JsonObject),
                  )
                  as JsonObject?;
          if (valueDes == null) continue;
          result.value = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
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
  UpdateSettingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UpdateSettingDtoBuilder();
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
