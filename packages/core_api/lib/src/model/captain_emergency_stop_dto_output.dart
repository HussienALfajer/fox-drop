//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_emergency_stop_dto_output.g.dart';

/// CaptainEmergencyStopDtoOutput
///
/// Properties:
/// * [active]
/// * [startedAt]
@BuiltValue()
abstract class CaptainEmergencyStopDtoOutput
    implements
        Built<
          CaptainEmergencyStopDtoOutput,
          CaptainEmergencyStopDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'active')
  bool get active;

  @BuiltValueField(wireName: r'startedAt')
  DateTime? get startedAt;

  CaptainEmergencyStopDtoOutput._();

  factory CaptainEmergencyStopDtoOutput([
    void updates(CaptainEmergencyStopDtoOutputBuilder b),
  ]) = _$CaptainEmergencyStopDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainEmergencyStopDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainEmergencyStopDtoOutput> get serializer =>
      _$CaptainEmergencyStopDtoOutputSerializer();
}

class _$CaptainEmergencyStopDtoOutputSerializer
    implements PrimitiveSerializer<CaptainEmergencyStopDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainEmergencyStopDtoOutput,
    _$CaptainEmergencyStopDtoOutput,
  ];

  @override
  final String wireName = r'CaptainEmergencyStopDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainEmergencyStopDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
    yield r'startedAt';
    yield object.startedAt == null
        ? null
        : serializers.serialize(
            object.startedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainEmergencyStopDtoOutput object, {
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
    required CaptainEmergencyStopDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.active = valueDes;
          break;
        case r'startedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.startedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainEmergencyStopDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainEmergencyStopDtoOutputBuilder();
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
