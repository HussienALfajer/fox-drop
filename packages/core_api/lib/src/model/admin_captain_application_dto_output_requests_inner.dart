//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_requests_inner.g.dart';

/// AdminCaptainApplicationDtoOutputRequestsInner
///
/// Properties:
/// * [kind]
/// * [reason]
/// * [requestedAt]
/// * [requestedBy]
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputRequestsInner
    implements
        Built<
          AdminCaptainApplicationDtoOutputRequestsInner,
          AdminCaptainApplicationDtoOutputRequestsInnerBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminCaptainApplicationDtoOutputRequestsInnerKindEnum get kind;
  // enum kindEnum {  national_id,  personal_photo,  civil_registry,  criminal_record,  vehicle_papers,  driving_licence,  signed_contract,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'requestedAt')
  DateTime get requestedAt;

  @BuiltValueField(wireName: r'requestedBy')
  String? get requestedBy;

  AdminCaptainApplicationDtoOutputRequestsInner._();

  factory AdminCaptainApplicationDtoOutputRequestsInner([
    void updates(AdminCaptainApplicationDtoOutputRequestsInnerBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutputRequestsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainApplicationDtoOutputRequestsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputRequestsInner>
  get serializer => _$AdminCaptainApplicationDtoOutputRequestsInnerSerializer();
}

class _$AdminCaptainApplicationDtoOutputRequestsInnerSerializer
    implements
        PrimitiveSerializer<AdminCaptainApplicationDtoOutputRequestsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputRequestsInner,
    _$AdminCaptainApplicationDtoOutputRequestsInner,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutputRequestsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputRequestsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminCaptainApplicationDtoOutputRequestsInnerKindEnum,
      ),
    );
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'requestedAt';
    yield serializers.serialize(
      object.requestedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'requestedBy';
    yield object.requestedBy == null
        ? null
        : serializers.serialize(
            object.requestedBy,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputRequestsInner object, {
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
    required AdminCaptainApplicationDtoOutputRequestsInnerBuilder result,
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
                      AdminCaptainApplicationDtoOutputRequestsInnerKindEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputRequestsInnerKindEnum;
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
        case r'requestedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.requestedAt = valueDes;
          break;
        case r'requestedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.requestedBy = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputRequestsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputRequestsInnerBuilder();
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

class AdminCaptainApplicationDtoOutputRequestsInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'national_id')
  static const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
  nationalId =
      _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_nationalId;
  @BuiltValueEnumConst(wireName: r'personal_photo')
  static const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
  personalPhoto =
      _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_personalPhoto;
  @BuiltValueEnumConst(wireName: r'civil_registry')
  static const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
  civilRegistry =
      _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_civilRegistry;
  @BuiltValueEnumConst(wireName: r'criminal_record')
  static const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
  criminalRecord =
      _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_criminalRecord;
  @BuiltValueEnumConst(wireName: r'vehicle_papers')
  static const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
  vehiclePapers =
      _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_vehiclePapers;
  @BuiltValueEnumConst(wireName: r'driving_licence')
  static const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
  drivingLicence =
      _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_drivingLicence;
  @BuiltValueEnumConst(wireName: r'signed_contract')
  static const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum
  signedContract =
      _$adminCaptainApplicationDtoOutputRequestsInnerKindEnum_signedContract;

  static Serializer<AdminCaptainApplicationDtoOutputRequestsInnerKindEnum>
  get serializer =>
      _$adminCaptainApplicationDtoOutputRequestsInnerKindEnumSerializer;

  const AdminCaptainApplicationDtoOutputRequestsInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputRequestsInnerKindEnum>
  get values => _$adminCaptainApplicationDtoOutputRequestsInnerKindEnumValues;
  static AdminCaptainApplicationDtoOutputRequestsInnerKindEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputRequestsInnerKindEnumValueOf(name);
}
