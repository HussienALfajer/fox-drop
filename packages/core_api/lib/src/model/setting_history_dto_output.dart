//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/setting_history_dto_output_changes_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'setting_history_dto_output.g.dart';

/// SettingHistoryDtoOutput
///
/// Properties:
/// * [changes] 
@BuiltValue()
abstract class SettingHistoryDtoOutput implements Built<SettingHistoryDtoOutput, SettingHistoryDtoOutputBuilder> {
  @BuiltValueField(wireName: r'changes')
  BuiltList<SettingHistoryDtoOutputChangesInner> get changes;

  SettingHistoryDtoOutput._();

  factory SettingHistoryDtoOutput([void updates(SettingHistoryDtoOutputBuilder b)]) = _$SettingHistoryDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SettingHistoryDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SettingHistoryDtoOutput> get serializer => _$SettingHistoryDtoOutputSerializer();
}

class _$SettingHistoryDtoOutputSerializer implements PrimitiveSerializer<SettingHistoryDtoOutput> {
  @override
  final Iterable<Type> types = const [SettingHistoryDtoOutput, _$SettingHistoryDtoOutput];

  @override
  final String wireName = r'SettingHistoryDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SettingHistoryDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'changes';
    yield serializers.serialize(
      object.changes,
      specifiedType: const FullType(BuiltList, [FullType(SettingHistoryDtoOutputChangesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    SettingHistoryDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SettingHistoryDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'changes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(SettingHistoryDtoOutputChangesInner)]),
          ) as BuiltList<SettingHistoryDtoOutputChangesInner>;
          result.changes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SettingHistoryDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SettingHistoryDtoOutputBuilder();
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


