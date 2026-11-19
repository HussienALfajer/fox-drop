//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_request_dto.g.dart';

/// AdminCaptainApplicationRequestDto
///
/// Properties:
/// * [kind]
/// * [reason] - Sent to the applicant.
@BuiltValue()
abstract class AdminCaptainApplicationRequestDto
    implements
        Built<
          AdminCaptainApplicationRequestDto,
          AdminCaptainApplicationRequestDtoBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminCaptainApplicationRequestDtoKindEnum get kind;
  // enum kindEnum {  national_id,  personal_photo,  civil_registry,  criminal_record,  vehicle_papers,  driving_licence,  };

  /// Sent to the applicant.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  AdminCaptainApplicationRequestDto._();

  factory AdminCaptainApplicationRequestDto([
    void updates(AdminCaptainApplicationRequestDtoBuilder b),
  ]) = _$AdminCaptainApplicationRequestDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationRequestDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationRequestDto> get serializer =>
      _$AdminCaptainApplicationRequestDtoSerializer();
}

class _$AdminCaptainApplicationRequestDtoSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationRequestDto> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationRequestDto,
    _$AdminCaptainApplicationRequestDto,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationRequestDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationRequestDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminCaptainApplicationRequestDtoKindEnum),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationRequestDto object, {
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
    required AdminCaptainApplicationRequestDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationRequestDtoKindEnum,
                    ),
                  )
                  as AdminCaptainApplicationRequestDtoKindEnum;
          result.kind = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationRequestDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationRequestDtoBuilder();
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

class AdminCaptainApplicationRequestDtoKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'national_id')
  static const AdminCaptainApplicationRequestDtoKindEnum nationalId =
      _$adminCaptainApplicationRequestDtoKindEnum_nationalId;
  @BuiltValueEnumConst(wireName: r'personal_photo')
  static const AdminCaptainApplicationRequestDtoKindEnum personalPhoto =
      _$adminCaptainApplicationRequestDtoKindEnum_personalPhoto;
  @BuiltValueEnumConst(wireName: r'civil_registry')
  static const AdminCaptainApplicationRequestDtoKindEnum civilRegistry =
      _$adminCaptainApplicationRequestDtoKindEnum_civilRegistry;
  @BuiltValueEnumConst(wireName: r'criminal_record')
  static const AdminCaptainApplicationRequestDtoKindEnum criminalRecord =
      _$adminCaptainApplicationRequestDtoKindEnum_criminalRecord;
  @BuiltValueEnumConst(wireName: r'vehicle_papers')
  static const AdminCaptainApplicationRequestDtoKindEnum vehiclePapers =
      _$adminCaptainApplicationRequestDtoKindEnum_vehiclePapers;
  @BuiltValueEnumConst(wireName: r'driving_licence')
  static const AdminCaptainApplicationRequestDtoKindEnum drivingLicence =
      _$adminCaptainApplicationRequestDtoKindEnum_drivingLicence;

  static Serializer<AdminCaptainApplicationRequestDtoKindEnum> get serializer =>
      _$adminCaptainApplicationRequestDtoKindEnumSerializer;

  const AdminCaptainApplicationRequestDtoKindEnum._(String name) : super(name);

  static BuiltSet<AdminCaptainApplicationRequestDtoKindEnum> get values =>
      _$adminCaptainApplicationRequestDtoKindEnumValues;
  static AdminCaptainApplicationRequestDtoKindEnum valueOf(String name) =>
      _$adminCaptainApplicationRequestDtoKindEnumValueOf(name);
}
