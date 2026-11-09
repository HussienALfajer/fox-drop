//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_start_emergency_stop_dto.g.dart';

/// AdminStartEmergencyStopDto
///
/// Properties:
/// * [cityId]
/// * [internalReason]
/// * [browseMessage]
/// * [delayNotice]
/// * [customerReason] - Fills {السبب}, such as «سوء الأحوال الجوية».
/// * [resumeAt] - An optional automatic resume time.
@BuiltValue()
abstract class AdminStartEmergencyStopDto
    implements
        Built<AdminStartEmergencyStopDto, AdminStartEmergencyStopDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'internalReason')
  String get internalReason;

  @BuiltValueField(wireName: r'browseMessage')
  String get browseMessage;

  @BuiltValueField(wireName: r'delayNotice')
  String get delayNotice;

  /// Fills {السبب}, such as «سوء الأحوال الجوية».
  @BuiltValueField(wireName: r'customerReason')
  String get customerReason;

  /// An optional automatic resume time.
  @BuiltValueField(wireName: r'resumeAt')
  DateTime? get resumeAt;

  AdminStartEmergencyStopDto._();

  factory AdminStartEmergencyStopDto([
    void updates(AdminStartEmergencyStopDtoBuilder b),
  ]) = _$AdminStartEmergencyStopDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminStartEmergencyStopDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminStartEmergencyStopDto> get serializer =>
      _$AdminStartEmergencyStopDtoSerializer();
}

class _$AdminStartEmergencyStopDtoSerializer
    implements PrimitiveSerializer<AdminStartEmergencyStopDto> {
  @override
  final Iterable<Type> types = const [
    AdminStartEmergencyStopDto,
    _$AdminStartEmergencyStopDto,
  ];

  @override
  final String wireName = r'AdminStartEmergencyStopDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminStartEmergencyStopDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'internalReason';
    yield serializers.serialize(
      object.internalReason,
      specifiedType: const FullType(String),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminStartEmergencyStopDto object, {
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
    required AdminStartEmergencyStopDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'internalReason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminStartEmergencyStopDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminStartEmergencyStopDtoBuilder();
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
