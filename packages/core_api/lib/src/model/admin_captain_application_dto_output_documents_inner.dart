//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_documents_inner.g.dart';

/// AdminCaptainApplicationDtoOutputDocumentsInner
///
/// Properties:
/// * [id]
/// * [kind]
/// * [status]
/// * [reason]
/// * [number]
/// * [issueDate]
/// * [expiresOn]
/// * [uploadedAt]
/// * [uploadedByOffice]
/// * [uploadedBy] - The office's admin; null for the applicant.
/// * [reviewedBy]
/// * [reviewedAt]
/// * [inForce] - False for an upload a newer one replaced.
/// * [fileUrls] - Signed GETs on the panel’s origin, 10 minutes.
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputDocumentsInner
    implements
        Built<
          AdminCaptainApplicationDtoOutputDocumentsInner,
          AdminCaptainApplicationDtoOutputDocumentsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum get kind;
  // enum kindEnum {  national_id,  personal_photo,  civil_registry,  criminal_record,  vehicle_papers,  driving_licence,  signed_contract,  };

  @BuiltValueField(wireName: r'status')
  AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum get status;
  // enum statusEnum {  pending,  accepted,  rejected,  };

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'number')
  String? get number;

  @BuiltValueField(wireName: r'issueDate')
  Date? get issueDate;

  @BuiltValueField(wireName: r'expiresOn')
  Date? get expiresOn;

  @BuiltValueField(wireName: r'uploadedAt')
  DateTime get uploadedAt;

  @BuiltValueField(wireName: r'uploadedByOffice')
  bool get uploadedByOffice;

  /// The office's admin; null for the applicant.
  @BuiltValueField(wireName: r'uploadedBy')
  String? get uploadedBy;

  @BuiltValueField(wireName: r'reviewedBy')
  String? get reviewedBy;

  @BuiltValueField(wireName: r'reviewedAt')
  DateTime? get reviewedAt;

  /// False for an upload a newer one replaced.
  @BuiltValueField(wireName: r'inForce')
  bool get inForce;

  /// Signed GETs on the panel’s origin, 10 minutes.
  @BuiltValueField(wireName: r'fileUrls')
  BuiltList<String> get fileUrls;

  AdminCaptainApplicationDtoOutputDocumentsInner._();

  factory AdminCaptainApplicationDtoOutputDocumentsInner([
    void updates(AdminCaptainApplicationDtoOutputDocumentsInnerBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutputDocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCaptainApplicationDtoOutputDocumentsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputDocumentsInner>
  get serializer =>
      _$AdminCaptainApplicationDtoOutputDocumentsInnerSerializer();
}

class _$AdminCaptainApplicationDtoOutputDocumentsInnerSerializer
    implements
        PrimitiveSerializer<AdminCaptainApplicationDtoOutputDocumentsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputDocumentsInner,
    _$AdminCaptainApplicationDtoOutputDocumentsInner,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutputDocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum,
      ),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum,
      ),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'number';
    yield object.number == null
        ? null
        : serializers.serialize(
            object.number,
            specifiedType: const FullType.nullable(String),
          );
    yield r'issueDate';
    yield object.issueDate == null
        ? null
        : serializers.serialize(
            object.issueDate,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'expiresOn';
    yield object.expiresOn == null
        ? null
        : serializers.serialize(
            object.expiresOn,
            specifiedType: const FullType.nullable(Date),
          );
    yield r'uploadedAt';
    yield serializers.serialize(
      object.uploadedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'uploadedByOffice';
    yield serializers.serialize(
      object.uploadedByOffice,
      specifiedType: const FullType(bool),
    );
    yield r'uploadedBy';
    yield object.uploadedBy == null
        ? null
        : serializers.serialize(
            object.uploadedBy,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reviewedBy';
    yield object.reviewedBy == null
        ? null
        : serializers.serialize(
            object.reviewedBy,
            specifiedType: const FullType.nullable(String),
          );
    yield r'reviewedAt';
    yield object.reviewedAt == null
        ? null
        : serializers.serialize(
            object.reviewedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'inForce';
    yield serializers.serialize(
      object.inForce,
      specifiedType: const FullType(bool),
    );
    yield r'fileUrls';
    yield serializers.serialize(
      object.fileUrls,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputDocumentsInner object, {
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
    required AdminCaptainApplicationDtoOutputDocumentsInnerBuilder result,
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
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.number = valueDes;
          break;
        case r'issueDate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(Date),
                  )
                  as Date?;
          if (valueDes == null) continue;
          result.issueDate = valueDes;
          break;
        case r'expiresOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(Date),
                  )
                  as Date?;
          if (valueDes == null) continue;
          result.expiresOn = valueDes;
          break;
        case r'uploadedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.uploadedAt = valueDes;
          break;
        case r'uploadedByOffice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.uploadedByOffice = valueDes;
          break;
        case r'uploadedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.uploadedBy = valueDes;
          break;
        case r'reviewedBy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reviewedBy = valueDes;
          break;
        case r'reviewedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.reviewedAt = valueDes;
          break;
        case r'inForce':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.inForce = valueDes;
          break;
        case r'fileUrls':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.fileUrls.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputDocumentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputDocumentsInnerBuilder();
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

class AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'national_id')
  static const AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum
  nationalId =
      _$adminCaptainApplicationDtoOutputDocumentsInnerKindEnum_nationalId;
  @BuiltValueEnumConst(wireName: r'personal_photo')
  static const AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum
  personalPhoto =
      _$adminCaptainApplicationDtoOutputDocumentsInnerKindEnum_personalPhoto;
  @BuiltValueEnumConst(wireName: r'civil_registry')
  static const AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum
  civilRegistry =
      _$adminCaptainApplicationDtoOutputDocumentsInnerKindEnum_civilRegistry;
  @BuiltValueEnumConst(wireName: r'criminal_record')
  static const AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum
  criminalRecord =
      _$adminCaptainApplicationDtoOutputDocumentsInnerKindEnum_criminalRecord;
  @BuiltValueEnumConst(wireName: r'vehicle_papers')
  static const AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum
  vehiclePapers =
      _$adminCaptainApplicationDtoOutputDocumentsInnerKindEnum_vehiclePapers;
  @BuiltValueEnumConst(wireName: r'driving_licence')
  static const AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum
  drivingLicence =
      _$adminCaptainApplicationDtoOutputDocumentsInnerKindEnum_drivingLicence;
  @BuiltValueEnumConst(wireName: r'signed_contract')
  static const AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum
  signedContract =
      _$adminCaptainApplicationDtoOutputDocumentsInnerKindEnum_signedContract;

  static Serializer<AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum>
  get serializer =>
      _$adminCaptainApplicationDtoOutputDocumentsInnerKindEnumSerializer;

  const AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum>
  get values => _$adminCaptainApplicationDtoOutputDocumentsInnerKindEnumValues;
  static AdminCaptainApplicationDtoOutputDocumentsInnerKindEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputDocumentsInnerKindEnumValueOf(name);
}

class AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum
  pending = _$adminCaptainApplicationDtoOutputDocumentsInnerStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum
  accepted =
      _$adminCaptainApplicationDtoOutputDocumentsInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum
  rejected =
      _$adminCaptainApplicationDtoOutputDocumentsInnerStatusEnum_rejected;

  static Serializer<AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum>
  get serializer =>
      _$adminCaptainApplicationDtoOutputDocumentsInnerStatusEnumSerializer;

  const AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum>
  get values =>
      _$adminCaptainApplicationDtoOutputDocumentsInnerStatusEnumValues;
  static AdminCaptainApplicationDtoOutputDocumentsInnerStatusEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputDocumentsInnerStatusEnumValueOf(name);
}
