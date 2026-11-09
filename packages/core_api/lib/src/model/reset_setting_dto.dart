//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'reset_setting_dto.g.dart';

/// ResetSettingDto
///
/// Properties:
/// * [cityId] - The city of a city setting; none for a global one.
/// * [reason] - Required for the settings with money impact (reasonRequired).
@BuiltValue()
abstract class ResetSettingDto implements Built<ResetSettingDto, ResetSettingDtoBuilder> {
  /// The city of a city setting; none for a global one.
  @BuiltValueField(wireName: r'cityId')
  String? get cityId;

  /// Required for the settings with money impact (reasonRequired).
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  ResetSettingDto._();

  factory ResetSettingDto([void updates(ResetSettingDtoBuilder b)]) = _$ResetSettingDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResetSettingDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResetSettingDto> get serializer => _$ResetSettingDtoSerializer();
}

class _$ResetSettingDtoSerializer implements PrimitiveSerializer<ResetSettingDto> {
  @override
  final Iterable<Type> types = const [ResetSettingDto, _$ResetSettingDto];

  @override
  final String wireName = r'ResetSettingDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResetSettingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.cityId != null) {
      yield r'cityId';
      yield serializers.serialize(
        object.cityId,
        specifiedType: const FullType.nullable(String),
      );
    }
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
    ResetSettingDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResetSettingDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.cityId = valueDes;
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
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
  ResetSettingDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResetSettingDtoBuilder();
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


