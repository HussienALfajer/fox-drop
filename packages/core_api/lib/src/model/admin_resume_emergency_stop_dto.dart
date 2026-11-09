//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_resume_emergency_stop_dto.g.dart';

/// AdminResumeEmergencyStopDto
///
/// Properties:
/// * [cityId] 
/// * [stopId] - The stop the panel shows, so a resume never ends a newer one.
/// * [serviceBack] - «الخدمة عادت» (CU §14 #19), to the customers who tried to order; null sends none.
@BuiltValue()
abstract class AdminResumeEmergencyStopDto implements Built<AdminResumeEmergencyStopDto, AdminResumeEmergencyStopDtoBuilder> {
  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// The stop the panel shows, so a resume never ends a newer one.
  @BuiltValueField(wireName: r'stopId')
  String get stopId;

  /// «الخدمة عادت» (CU §14 #19), to the customers who tried to order; null sends none.
  @BuiltValueField(wireName: r'serviceBack')
  String? get serviceBack;

  AdminResumeEmergencyStopDto._();

  factory AdminResumeEmergencyStopDto([void updates(AdminResumeEmergencyStopDtoBuilder b)]) = _$AdminResumeEmergencyStopDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminResumeEmergencyStopDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminResumeEmergencyStopDto> get serializer => _$AdminResumeEmergencyStopDtoSerializer();
}

class _$AdminResumeEmergencyStopDtoSerializer implements PrimitiveSerializer<AdminResumeEmergencyStopDto> {
  @override
  final Iterable<Type> types = const [AdminResumeEmergencyStopDto, _$AdminResumeEmergencyStopDto];

  @override
  final String wireName = r'AdminResumeEmergencyStopDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminResumeEmergencyStopDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'stopId';
    yield serializers.serialize(
      object.stopId,
      specifiedType: const FullType(String),
    );
    yield r'serviceBack';
    yield object.serviceBack == null ? null : serializers.serialize(
      object.serviceBack,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminResumeEmergencyStopDto object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminResumeEmergencyStopDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'cityId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.cityId = valueDes;
          break;
        case r'stopId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.stopId = valueDes;
          break;
        case r'serviceBack':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.serviceBack = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminResumeEmergencyStopDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminResumeEmergencyStopDtoBuilder();
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


