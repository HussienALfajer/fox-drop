//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_emergency_stop_dto_output_stop.g.dart';

/// AdminEmergencyStopDtoOutputStop
///
/// Properties:
/// * [id]
/// * [startedAt]
/// * [startedBy] - For OWN and OPS only (emergency_stop.toggle).
/// * [internalReason] - For OWN and OPS only (emergency_stop.toggle).
/// * [browseMessage]
/// * [delayNotice] - With its {السبب} placeholder.
/// * [customerReason]
/// * [resumeAt] - The automatic resume, if set.
/// * [attempts] - Customers who opened checkout during the stop, each once (AP §9.1.6 item 4).
@BuiltValue()
abstract class AdminEmergencyStopDtoOutputStop
    implements
        Built<
          AdminEmergencyStopDtoOutputStop,
          AdminEmergencyStopDtoOutputStopBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'startedAt')
  DateTime get startedAt;

  /// For OWN and OPS only (emergency_stop.toggle).
  @BuiltValueField(wireName: r'startedBy')
  String? get startedBy;

  /// For OWN and OPS only (emergency_stop.toggle).
  @BuiltValueField(wireName: r'internalReason')
  String? get internalReason;

  @BuiltValueField(wireName: r'browseMessage')
  String get browseMessage;

  /// With its {السبب} placeholder.
  @BuiltValueField(wireName: r'delayNotice')
  String get delayNotice;

  @BuiltValueField(wireName: r'customerReason')
  String get customerReason;

  /// The automatic resume, if set.
  @BuiltValueField(wireName: r'resumeAt')
  DateTime? get resumeAt;

  /// Customers who opened checkout during the stop, each once (AP §9.1.6 item 4).
  @BuiltValueField(wireName: r'attempts')
  int get attempts;

  AdminEmergencyStopDtoOutputStop._();

  factory AdminEmergencyStopDtoOutputStop([
    void updates(AdminEmergencyStopDtoOutputStopBuilder b),
  ]) = _$AdminEmergencyStopDtoOutputStop;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEmergencyStopDtoOutputStopBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEmergencyStopDtoOutputStop> get serializer =>
      _$AdminEmergencyStopDtoOutputStopSerializer();
}

class _$AdminEmergencyStopDtoOutputStopSerializer
    implements PrimitiveSerializer<AdminEmergencyStopDtoOutputStop> {
  @override
  final Iterable<Type> types = const [
    AdminEmergencyStopDtoOutputStop,
    _$AdminEmergencyStopDtoOutputStop,
  ];

  @override
  final String wireName = r'AdminEmergencyStopDtoOutputStop';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEmergencyStopDtoOutputStop object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'startedAt';
    yield serializers.serialize(
      object.startedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'startedBy';
    yield object.startedBy == null
        ? null
        : serializers.serialize(
            object.startedBy,
            specifiedType: const FullType.nullable(String),
          );
    yield r'internalReason';
    yield object.internalReason == null
        ? null
        : serializers.serialize(
            object.internalReason,
            specifiedType: const FullType.nullable(String),
          );
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
    yield r'customerReason';
    yield serializers.serialize(
      object.customerReason,
      specifiedType: const FullType(String),
    );
    yield r'resumeAt';
    yield object.resumeAt == null
        ? null
        : serializers.serialize(
            object.resumeAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'attempts';
    yield serializers.serialize(
      object.attempts,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEmergencyStopDtoOutputStop object, {
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
    required AdminEmergencyStopDtoOutputStopBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'startedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.startedAt = valueDes;
          break;
        case r'startedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.startedBy = valueDes;
          break;
        case r'internalReason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.internalReason = valueDes;
          break;
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
        case r'customerReason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.customerReason = valueDes;
          break;
        case r'resumeAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.resumeAt = valueDes;
          break;
        case r'attempts':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.attempts = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEmergencyStopDtoOutputStop deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEmergencyStopDtoOutputStopBuilder();
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
