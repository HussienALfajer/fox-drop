//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_emergency_stop_dto_output_stop.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_emergency_stop_dto_output.g.dart';

/// AdminEmergencyStopDtoOutput
///
/// Properties:
/// * [stop] 
@BuiltValue()
abstract class AdminEmergencyStopDtoOutput implements Built<AdminEmergencyStopDtoOutput, AdminEmergencyStopDtoOutputBuilder> {
  @BuiltValueField(wireName: r'stop')
  AdminEmergencyStopDtoOutputStop get stop;

  AdminEmergencyStopDtoOutput._();

  factory AdminEmergencyStopDtoOutput([void updates(AdminEmergencyStopDtoOutputBuilder b)]) = _$AdminEmergencyStopDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEmergencyStopDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEmergencyStopDtoOutput> get serializer => _$AdminEmergencyStopDtoOutputSerializer();
}

class _$AdminEmergencyStopDtoOutputSerializer implements PrimitiveSerializer<AdminEmergencyStopDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminEmergencyStopDtoOutput, _$AdminEmergencyStopDtoOutput];

  @override
  final String wireName = r'AdminEmergencyStopDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEmergencyStopDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stop';
    yield serializers.serialize(
      object.stop,
      specifiedType: const FullType(AdminEmergencyStopDtoOutputStop),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEmergencyStopDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminEmergencyStopDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stop':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminEmergencyStopDtoOutputStop),
          ) as AdminEmergencyStopDtoOutputStop;
          result.stop.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEmergencyStopDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEmergencyStopDtoOutputBuilder();
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


