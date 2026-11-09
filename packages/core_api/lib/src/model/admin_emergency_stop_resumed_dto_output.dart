//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_emergency_stop_resumed_dto_output.g.dart';

/// AdminEmergencyStopResumedDtoOutput
///
/// Properties:
/// * [resumed] 
@BuiltValue()
abstract class AdminEmergencyStopResumedDtoOutput implements Built<AdminEmergencyStopResumedDtoOutput, AdminEmergencyStopResumedDtoOutputBuilder> {
  @BuiltValueField(wireName: r'resumed')
  AdminEmergencyStopResumedDtoOutputResumedEnum get resumed;
  // enum resumedEnum {  true,  };

  AdminEmergencyStopResumedDtoOutput._();

  factory AdminEmergencyStopResumedDtoOutput([void updates(AdminEmergencyStopResumedDtoOutputBuilder b)]) = _$AdminEmergencyStopResumedDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEmergencyStopResumedDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEmergencyStopResumedDtoOutput> get serializer => _$AdminEmergencyStopResumedDtoOutputSerializer();
}

class _$AdminEmergencyStopResumedDtoOutputSerializer implements PrimitiveSerializer<AdminEmergencyStopResumedDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminEmergencyStopResumedDtoOutput, _$AdminEmergencyStopResumedDtoOutput];

  @override
  final String wireName = r'AdminEmergencyStopResumedDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEmergencyStopResumedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'resumed';
    yield serializers.serialize(
      object.resumed,
      specifiedType: const FullType(AdminEmergencyStopResumedDtoOutputResumedEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEmergencyStopResumedDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminEmergencyStopResumedDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'resumed':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminEmergencyStopResumedDtoOutputResumedEnum),
          ) as AdminEmergencyStopResumedDtoOutputResumedEnum;
          result.resumed = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEmergencyStopResumedDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEmergencyStopResumedDtoOutputBuilder();
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


class AdminEmergencyStopResumedDtoOutputResumedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const AdminEmergencyStopResumedDtoOutputResumedEnum true_ = _$adminEmergencyStopResumedDtoOutputResumedEnum_true_;

  static Serializer<AdminEmergencyStopResumedDtoOutputResumedEnum> get serializer => _$adminEmergencyStopResumedDtoOutputResumedEnumSerializer;

  const AdminEmergencyStopResumedDtoOutputResumedEnum._(String name): super(name);

  static BuiltSet<AdminEmergencyStopResumedDtoOutputResumedEnum> get values => _$adminEmergencyStopResumedDtoOutputResumedEnumValues;
  static AdminEmergencyStopResumedDtoOutputResumedEnum valueOf(String name) => _$adminEmergencyStopResumedDtoOutputResumedEnumValueOf(name);
}

