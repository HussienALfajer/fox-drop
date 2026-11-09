//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'backup_codes_dto_output.g.dart';

/// BackupCodesDtoOutput
///
/// Properties:
/// * [backupCodes] - The 10 single-use backup codes, shown this once only (AP §5.1).
@BuiltValue()
abstract class BackupCodesDtoOutput implements Built<BackupCodesDtoOutput, BackupCodesDtoOutputBuilder> {
  /// The 10 single-use backup codes, shown this once only (AP §5.1).
  @BuiltValueField(wireName: r'backupCodes')
  BuiltList<String> get backupCodes;

  BackupCodesDtoOutput._();

  factory BackupCodesDtoOutput([void updates(BackupCodesDtoOutputBuilder b)]) = _$BackupCodesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BackupCodesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BackupCodesDtoOutput> get serializer => _$BackupCodesDtoOutputSerializer();
}

class _$BackupCodesDtoOutputSerializer implements PrimitiveSerializer<BackupCodesDtoOutput> {
  @override
  final Iterable<Type> types = const [BackupCodesDtoOutput, _$BackupCodesDtoOutput];

  @override
  final String wireName = r'BackupCodesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BackupCodesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'backupCodes';
    yield serializers.serialize(
      object.backupCodes,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BackupCodesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BackupCodesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'backupCodes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.backupCodes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BackupCodesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BackupCodesDtoOutputBuilder();
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


