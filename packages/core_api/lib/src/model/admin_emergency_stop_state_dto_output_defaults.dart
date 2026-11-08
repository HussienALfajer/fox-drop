//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_emergency_stop_state_dto_output_defaults.g.dart';

/// The dialog prefills (AP Appendix A), for OWN and OPS only.
///
/// Properties:
/// * [browseMessage]
/// * [delayNotice]
@BuiltValue()
abstract class AdminEmergencyStopStateDtoOutputDefaults
    implements
        Built<
          AdminEmergencyStopStateDtoOutputDefaults,
          AdminEmergencyStopStateDtoOutputDefaultsBuilder
        > {
  @BuiltValueField(wireName: r'browseMessage')
  String get browseMessage;

  @BuiltValueField(wireName: r'delayNotice')
  String get delayNotice;

  AdminEmergencyStopStateDtoOutputDefaults._();

  factory AdminEmergencyStopStateDtoOutputDefaults([
    void updates(AdminEmergencyStopStateDtoOutputDefaultsBuilder b),
  ]) = _$AdminEmergencyStopStateDtoOutputDefaults;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEmergencyStopStateDtoOutputDefaultsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEmergencyStopStateDtoOutputDefaults> get serializer =>
      _$AdminEmergencyStopStateDtoOutputDefaultsSerializer();
}

class _$AdminEmergencyStopStateDtoOutputDefaultsSerializer
    implements PrimitiveSerializer<AdminEmergencyStopStateDtoOutputDefaults> {
  @override
  final Iterable<Type> types = const [
    AdminEmergencyStopStateDtoOutputDefaults,
    _$AdminEmergencyStopStateDtoOutputDefaults,
  ];

  @override
  final String wireName = r'AdminEmergencyStopStateDtoOutputDefaults';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEmergencyStopStateDtoOutputDefaults object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'browseMessage';
    yield serializers.serialize(
      object.browseMessage,
      specifiedType: const FullType(String),
    );
    yield r'delayNotice';
    yield serializers.serialize(
      object.delayNotice,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEmergencyStopStateDtoOutputDefaults object, {
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
    required AdminEmergencyStopStateDtoOutputDefaultsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'browseMessage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.browseMessage = valueDes;
          break;
        case r'delayNotice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.delayNotice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEmergencyStopStateDtoOutputDefaults deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEmergencyStopStateDtoOutputDefaultsBuilder();
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
