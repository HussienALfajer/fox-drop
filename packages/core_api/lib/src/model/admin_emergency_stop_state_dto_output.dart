//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_emergency_stop_state_dto_output_defaults.dart';
import 'package:core_api/src/model/admin_emergency_stop_state_dto_output_stop.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_emergency_stop_state_dto_output.g.dart';

/// AdminEmergencyStopStateDtoOutput
///
/// Properties:
/// * [stop]
/// * [defaults]
@BuiltValue()
abstract class AdminEmergencyStopStateDtoOutput
    implements
        Built<
          AdminEmergencyStopStateDtoOutput,
          AdminEmergencyStopStateDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'stop')
  AdminEmergencyStopStateDtoOutputStop? get stop;

  @BuiltValueField(wireName: r'defaults')
  AdminEmergencyStopStateDtoOutputDefaults? get defaults;

  AdminEmergencyStopStateDtoOutput._();

  factory AdminEmergencyStopStateDtoOutput([
    void updates(AdminEmergencyStopStateDtoOutputBuilder b),
  ]) = _$AdminEmergencyStopStateDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEmergencyStopStateDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEmergencyStopStateDtoOutput> get serializer =>
      _$AdminEmergencyStopStateDtoOutputSerializer();
}

class _$AdminEmergencyStopStateDtoOutputSerializer
    implements PrimitiveSerializer<AdminEmergencyStopStateDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminEmergencyStopStateDtoOutput,
    _$AdminEmergencyStopStateDtoOutput,
  ];

  @override
  final String wireName = r'AdminEmergencyStopStateDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEmergencyStopStateDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stop';
    yield object.stop == null
        ? null
        : serializers.serialize(
            object.stop,
            specifiedType: const FullType.nullable(
              AdminEmergencyStopStateDtoOutputStop,
            ),
          );
    yield r'defaults';
    yield object.defaults == null
        ? null
        : serializers.serialize(
            object.defaults,
            specifiedType: const FullType.nullable(
              AdminEmergencyStopStateDtoOutputDefaults,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEmergencyStopStateDtoOutput object, {
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
    required AdminEmergencyStopStateDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stop':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminEmergencyStopStateDtoOutputStop,
                    ),
                  )
                  as AdminEmergencyStopStateDtoOutputStop?;
          if (valueDes == null) continue;
          result.stop.replace(valueDes);
          break;
        case r'defaults':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminEmergencyStopStateDtoOutputDefaults,
                    ),
                  )
                  as AdminEmergencyStopStateDtoOutputDefaults?;
          if (valueDes == null) continue;
          result.defaults.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEmergencyStopStateDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEmergencyStopStateDtoOutputBuilder();
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
