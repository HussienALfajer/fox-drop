//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'setting_history_dto_output_changes_inner.g.dart';

/// SettingHistoryDtoOutputChangesInner
///
/// Properties:
/// * [action] 
/// * [before] 
/// * [after] 
/// * [editorId] 
/// * [editorRoles] 
/// * [reason] 
/// * [changedAt] 
@BuiltValue()
abstract class SettingHistoryDtoOutputChangesInner implements Built<SettingHistoryDtoOutputChangesInner, SettingHistoryDtoOutputChangesInnerBuilder> {
  @BuiltValueField(wireName: r'action')
  SettingHistoryDtoOutputChangesInnerActionEnum get action;
  // enum actionEnum {  update,  reset,  };

  @BuiltValueField(wireName: r'before')
  JsonObject? get before;

  @BuiltValueField(wireName: r'after')
  JsonObject? get after;

  @BuiltValueField(wireName: r'editorId')
  String? get editorId;

  @BuiltValueField(wireName: r'editorRoles')
  BuiltList<String> get editorRoles;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'changedAt')
  DateTime get changedAt;

  SettingHistoryDtoOutputChangesInner._();

  factory SettingHistoryDtoOutputChangesInner([void updates(SettingHistoryDtoOutputChangesInnerBuilder b)]) = _$SettingHistoryDtoOutputChangesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingHistoryDtoOutputChangesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingHistoryDtoOutputChangesInner> get serializer => _$SettingHistoryDtoOutputChangesInnerSerializer();
}

class _$SettingHistoryDtoOutputChangesInnerSerializer implements PrimitiveSerializer<SettingHistoryDtoOutputChangesInner> {
  @override
  final Iterable<Type> types = const [SettingHistoryDtoOutputChangesInner, _$SettingHistoryDtoOutputChangesInner];

  @override
  final String wireName = r'SettingHistoryDtoOutputChangesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingHistoryDtoOutputChangesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'action';
    yield serializers.serialize(
      object.action,
      specifiedType: const FullType(SettingHistoryDtoOutputChangesInnerActionEnum),
    );
    yield r'before';
    yield object.before == null ? null : serializers.serialize(
      object.before,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'after';
    yield object.after == null ? null : serializers.serialize(
      object.after,
      specifiedType: const FullType.nullable(JsonObject),
    );
    yield r'editorId';
    yield object.editorId == null ? null : serializers.serialize(
      object.editorId,
      specifiedType: const FullType.nullable(String),
    );
    yield r'editorRoles';
    yield serializers.serialize(
      object.editorRoles,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'reason';
    yield object.reason == null ? null : serializers.serialize(
      object.reason,
      specifiedType: const FullType.nullable(String),
    );
    yield r'changedAt';
    yield serializers.serialize(
      object.changedAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingHistoryDtoOutputChangesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettingHistoryDtoOutputChangesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'action':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(SettingHistoryDtoOutputChangesInnerActionEnum),
          ) as SettingHistoryDtoOutputChangesInnerActionEnum;
          result.action = valueDes;
          break;
        case r'before':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.before = valueDes;
          break;
        case r'after':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(JsonObject),
          ) as JsonObject?;
          if (valueDes == null) continue;
          result.after = valueDes;
          break;
        case r'editorId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.editorId = valueDes;
          break;
        case r'editorRoles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.editorRoles.replace(valueDes);
          break;
        case r'reason':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'changedAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.changedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettingHistoryDtoOutputChangesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingHistoryDtoOutputChangesInnerBuilder();
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


class SettingHistoryDtoOutputChangesInnerActionEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'update')
  static const SettingHistoryDtoOutputChangesInnerActionEnum update = _$settingHistoryDtoOutputChangesInnerActionEnum_update;
  @BuiltValueEnumConst(wireName: r'reset')
  static const SettingHistoryDtoOutputChangesInnerActionEnum reset = _$settingHistoryDtoOutputChangesInnerActionEnum_reset;

  static Serializer<SettingHistoryDtoOutputChangesInnerActionEnum> get serializer => _$settingHistoryDtoOutputChangesInnerActionEnumSerializer;

  const SettingHistoryDtoOutputChangesInnerActionEnum._(String name): super(name);

  static BuiltSet<SettingHistoryDtoOutputChangesInnerActionEnum> get values => _$settingHistoryDtoOutputChangesInnerActionEnumValues;
  static SettingHistoryDtoOutputChangesInnerActionEnum valueOf(String name) => _$settingHistoryDtoOutputChangesInnerActionEnumValueOf(name);
}

