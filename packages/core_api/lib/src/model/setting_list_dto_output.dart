//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/setting_list_dto_output_settings_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'setting_list_dto_output.g.dart';

/// SettingListDtoOutput
///
/// Properties:
/// * [settings] 
@BuiltValue()
abstract class SettingListDtoOutput implements Built<SettingListDtoOutput, SettingListDtoOutputBuilder> {
  @BuiltValueField(wireName: r'settings')
  BuiltList<SettingListDtoOutputSettingsInner> get settings;

  SettingListDtoOutput._();

  factory SettingListDtoOutput([void updates(SettingListDtoOutputBuilder b)]) = _$SettingListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingListDtoOutput> get serializer => _$SettingListDtoOutputSerializer();
}

class _$SettingListDtoOutputSerializer implements PrimitiveSerializer<SettingListDtoOutput> {
  @override
  final Iterable<Type> types = const [SettingListDtoOutput, _$SettingListDtoOutput];

  @override
  final String wireName = r'SettingListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'settings';
    yield serializers.serialize(
      object.settings,
      specifiedType: const FullType(BuiltList, [FullType(SettingListDtoOutputSettingsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettingListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'settings':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SettingListDtoOutputSettingsInner)]),
          ) as BuiltList<SettingListDtoOutputSettingsInner>;
          result.settings.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettingListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingListDtoOutputBuilder();
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


