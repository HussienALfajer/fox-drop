//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_application_dto_output_application_interview.dart';
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_captain_application_dto_output_duplicates_inner.dart';
import 'package:core_api/src/model/admin_captain_application_dto_output_requests_inner.dart';
import 'package:core_api/src/model/admin_captain_application_dto_output_events_inner.dart';
import 'package:core_api/src/model/admin_captain_application_dto_output_documents_inner.dart';
import 'package:core_api/src/model/admin_captain_application_dto_output_rejection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output.g.dart';

/// AdminCaptainApplicationDtoOutput
///
/// Properties:
/// * [id]
/// * [stage]
/// * [cityId]
/// * [fullName]
/// * [birthDate]
/// * [zoneId]
/// * [zoneName]
/// * [vehicle]
/// * [plate]
/// * [phone] - In full for captains.manage, masked otherwise (architecture §15.3).
/// * [submittedAt]
/// * [updatedAt]
/// * [requiredDocuments] - The documents activation waits for (D24).
/// * [documents] - Every upload, newest first.
/// * [requests]
/// * [interview]
/// * [rejection]
/// * [duplicates] - Another applicant or captain with the same ID number, phone or plate.
/// * [events]
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutput
    implements
        Built<
          AdminCaptainApplicationDtoOutput,
          AdminCaptainApplicationDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'stage')
  AdminCaptainApplicationDtoOutputStageEnum get stage;
  // enum stageEnum {  draft,  new,  under_review,  interview,  awaiting_kit,  active,  waitlist,  rejected,  };

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  @BuiltValueField(wireName: r'birthDate')
  Date get birthDate;

  @BuiltValueField(wireName: r'zoneId')
  String get zoneId;

  @BuiltValueField(wireName: r'zoneName')
  String? get zoneName;

  @BuiltValueField(wireName: r'vehicle')
  AdminCaptainApplicationDtoOutputVehicleEnum? get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  @BuiltValueField(wireName: r'plate')
  String? get plate;

  /// In full for captains.manage, masked otherwise (architecture §15.3).
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'submittedAt')
  DateTime? get submittedAt;

  @BuiltValueField(wireName: r'updatedAt')
  DateTime get updatedAt;

  /// The documents activation waits for (D24).
  @BuiltValueField(wireName: r'requiredDocuments')
  BuiltList<AdminCaptainApplicationDtoOutputRequiredDocumentsEnum>
  get requiredDocuments;
  // enum requiredDocumentsEnum {  national_id,  personal_photo,  civil_registry,  criminal_record,  vehicle_papers,  driving_licence,  };

  /// Every upload, newest first.
  @BuiltValueField(wireName: r'documents')
  BuiltList<AdminCaptainApplicationDtoOutputDocumentsInner> get documents;

  @BuiltValueField(wireName: r'requests')
  BuiltList<AdminCaptainApplicationDtoOutputRequestsInner> get requests;

  @BuiltValueField(wireName: r'interview')
  CaptainApplicationDtoOutputApplicationInterview? get interview;

  @BuiltValueField(wireName: r'rejection')
  AdminCaptainApplicationDtoOutputRejection? get rejection;

  /// Another applicant or captain with the same ID number, phone or plate.
  @BuiltValueField(wireName: r'duplicates')
  BuiltList<AdminCaptainApplicationDtoOutputDuplicatesInner> get duplicates;

  @BuiltValueField(wireName: r'events')
  BuiltList<AdminCaptainApplicationDtoOutputEventsInner> get events;

  AdminCaptainApplicationDtoOutput._();

  factory AdminCaptainApplicationDtoOutput([
    void updates(AdminCaptainApplicationDtoOutputBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutput> get serializer =>
      _$AdminCaptainApplicationDtoOutputSerializer();
}

class _$AdminCaptainApplicationDtoOutputSerializer
    implements PrimitiveSerializer<AdminCaptainApplicationDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutput,
    _$AdminCaptainApplicationDtoOutput,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'stage';
    yield serializers.serialize(
      object.stage,
      specifiedType: const FullType(AdminCaptainApplicationDtoOutputStageEnum),
    );
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'fullName';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'birthDate';
    yield serializers.serialize(
      object.birthDate,
      specifiedType: const FullType(Date),
    );
    yield r'zoneId';
    yield serializers.serialize(
      object.zoneId,
      specifiedType: const FullType(String),
    );
    yield r'zoneName';
    yield object.zoneName == null
        ? null
        : serializers.serialize(
            object.zoneName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'vehicle';
    yield object.vehicle == null
        ? null
        : serializers.serialize(
            object.vehicle,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputVehicleEnum,
            ),
          );
    yield r'plate';
    yield object.plate == null
        ? null
        : serializers.serialize(
            object.plate,
            specifiedType: const FullType.nullable(String),
          );
    yield r'phone';
    yield object.phone == null
        ? null
        : serializers.serialize(
            object.phone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'submittedAt';
    yield object.submittedAt == null
        ? null
        : serializers.serialize(
            object.submittedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'updatedAt';
    yield serializers.serialize(
      object.updatedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'requiredDocuments';
    yield serializers.serialize(
      object.requiredDocuments,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainApplicationDtoOutputRequiredDocumentsEnum),
      ]),
    );
    yield r'documents';
    yield serializers.serialize(
      object.documents,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainApplicationDtoOutputDocumentsInner),
      ]),
    );
    yield r'requests';
    yield serializers.serialize(
      object.requests,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainApplicationDtoOutputRequestsInner),
      ]),
    );
    yield r'interview';
    yield object.interview == null
        ? null
        : serializers.serialize(
            object.interview,
            specifiedType: const FullType.nullable(
              CaptainApplicationDtoOutputApplicationInterview,
            ),
          );
    yield r'rejection';
    yield object.rejection == null
        ? null
        : serializers.serialize(
            object.rejection,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputRejection,
            ),
          );
    yield r'duplicates';
    yield serializers.serialize(
      object.duplicates,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainApplicationDtoOutputDuplicatesInner),
      ]),
    );
    yield r'events';
    yield serializers.serialize(
      object.events,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCaptainApplicationDtoOutputEventsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutput object, {
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
    required AdminCaptainApplicationDtoOutputBuilder result,
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
        case r'stage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationDtoOutputStageEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputStageEnum;
          result.stage = valueDes;
          break;
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'fullName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fullName = valueDes;
          break;
        case r'birthDate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.birthDate = valueDes;
          break;
        case r'zoneId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.zoneId = valueDes;
          break;
        case r'zoneName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.zoneName = valueDes;
          break;
        case r'vehicle':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputVehicleEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputVehicleEnum?;
          if (valueDes == null) continue;
          result.vehicle = valueDes;
          break;
        case r'plate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.plate = valueDes;
          break;
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'submittedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.submittedAt = valueDes;
          break;
        case r'updatedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.updatedAt = valueDes;
          break;
        case r'requiredDocuments':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCaptainApplicationDtoOutputRequiredDocumentsEnum,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCaptainApplicationDtoOutputRequiredDocumentsEnum
                  >;
          result.requiredDocuments.replace(valueDes);
          break;
        case r'documents':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCaptainApplicationDtoOutputDocumentsInner),
                    ]),
                  )
                  as BuiltList<AdminCaptainApplicationDtoOutputDocumentsInner>;
          result.documents.replace(valueDes);
          break;
        case r'requests':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCaptainApplicationDtoOutputRequestsInner),
                    ]),
                  )
                  as BuiltList<AdminCaptainApplicationDtoOutputRequestsInner>;
          result.requests.replace(valueDes);
          break;
        case r'interview':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainApplicationDtoOutputApplicationInterview,
                    ),
                  )
                  as CaptainApplicationDtoOutputApplicationInterview?;
          if (valueDes == null) continue;
          result.interview.replace(valueDes);
          break;
        case r'rejection':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputRejection,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputRejection?;
          if (valueDes == null) continue;
          result.rejection.replace(valueDes);
          break;
        case r'duplicates':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCaptainApplicationDtoOutputDuplicatesInner),
                    ]),
                  )
                  as BuiltList<AdminCaptainApplicationDtoOutputDuplicatesInner>;
          result.duplicates.replace(valueDes);
          break;
        case r'events':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCaptainApplicationDtoOutputEventsInner),
                    ]),
                  )
                  as BuiltList<AdminCaptainApplicationDtoOutputEventsInner>;
          result.events.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputBuilder();
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

class AdminCaptainApplicationDtoOutputStageEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminCaptainApplicationDtoOutputStageEnum draft =
      _$adminCaptainApplicationDtoOutputStageEnum_draft;
  @BuiltValueEnumConst(wireName: r'new')
  static const AdminCaptainApplicationDtoOutputStageEnum new_ =
      _$adminCaptainApplicationDtoOutputStageEnum_new_;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const AdminCaptainApplicationDtoOutputStageEnum underReview =
      _$adminCaptainApplicationDtoOutputStageEnum_underReview;
  @BuiltValueEnumConst(wireName: r'interview')
  static const AdminCaptainApplicationDtoOutputStageEnum interview =
      _$adminCaptainApplicationDtoOutputStageEnum_interview;
  @BuiltValueEnumConst(wireName: r'awaiting_kit')
  static const AdminCaptainApplicationDtoOutputStageEnum awaitingKit =
      _$adminCaptainApplicationDtoOutputStageEnum_awaitingKit;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminCaptainApplicationDtoOutputStageEnum active =
      _$adminCaptainApplicationDtoOutputStageEnum_active;
  @BuiltValueEnumConst(wireName: r'waitlist')
  static const AdminCaptainApplicationDtoOutputStageEnum waitlist =
      _$adminCaptainApplicationDtoOutputStageEnum_waitlist;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminCaptainApplicationDtoOutputStageEnum rejected =
      _$adminCaptainApplicationDtoOutputStageEnum_rejected;

  static Serializer<AdminCaptainApplicationDtoOutputStageEnum> get serializer =>
      _$adminCaptainApplicationDtoOutputStageEnumSerializer;

  const AdminCaptainApplicationDtoOutputStageEnum._(String name) : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputStageEnum> get values =>
      _$adminCaptainApplicationDtoOutputStageEnumValues;
  static AdminCaptainApplicationDtoOutputStageEnum valueOf(String name) =>
      _$adminCaptainApplicationDtoOutputStageEnumValueOf(name);
}

class AdminCaptainApplicationDtoOutputVehicleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'walking')
  static const AdminCaptainApplicationDtoOutputVehicleEnum walking =
      _$adminCaptainApplicationDtoOutputVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const AdminCaptainApplicationDtoOutputVehicleEnum bicycle =
      _$adminCaptainApplicationDtoOutputVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const AdminCaptainApplicationDtoOutputVehicleEnum motorbike =
      _$adminCaptainApplicationDtoOutputVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const AdminCaptainApplicationDtoOutputVehicleEnum car =
      _$adminCaptainApplicationDtoOutputVehicleEnum_car;

  static Serializer<AdminCaptainApplicationDtoOutputVehicleEnum>
  get serializer => _$adminCaptainApplicationDtoOutputVehicleEnumSerializer;

  const AdminCaptainApplicationDtoOutputVehicleEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputVehicleEnum> get values =>
      _$adminCaptainApplicationDtoOutputVehicleEnumValues;
  static AdminCaptainApplicationDtoOutputVehicleEnum valueOf(String name) =>
      _$adminCaptainApplicationDtoOutputVehicleEnumValueOf(name);
}

class AdminCaptainApplicationDtoOutputRequiredDocumentsEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'national_id')
  static const AdminCaptainApplicationDtoOutputRequiredDocumentsEnum
  nationalId =
      _$adminCaptainApplicationDtoOutputRequiredDocumentsEnum_nationalId;
  @BuiltValueEnumConst(wireName: r'personal_photo')
  static const AdminCaptainApplicationDtoOutputRequiredDocumentsEnum
  personalPhoto =
      _$adminCaptainApplicationDtoOutputRequiredDocumentsEnum_personalPhoto;
  @BuiltValueEnumConst(wireName: r'civil_registry')
  static const AdminCaptainApplicationDtoOutputRequiredDocumentsEnum
  civilRegistry =
      _$adminCaptainApplicationDtoOutputRequiredDocumentsEnum_civilRegistry;
  @BuiltValueEnumConst(wireName: r'criminal_record')
  static const AdminCaptainApplicationDtoOutputRequiredDocumentsEnum
  criminalRecord =
      _$adminCaptainApplicationDtoOutputRequiredDocumentsEnum_criminalRecord;
  @BuiltValueEnumConst(wireName: r'vehicle_papers')
  static const AdminCaptainApplicationDtoOutputRequiredDocumentsEnum
  vehiclePapers =
      _$adminCaptainApplicationDtoOutputRequiredDocumentsEnum_vehiclePapers;
  @BuiltValueEnumConst(wireName: r'driving_licence')
  static const AdminCaptainApplicationDtoOutputRequiredDocumentsEnum
  drivingLicence =
      _$adminCaptainApplicationDtoOutputRequiredDocumentsEnum_drivingLicence;

  static Serializer<AdminCaptainApplicationDtoOutputRequiredDocumentsEnum>
  get serializer =>
      _$adminCaptainApplicationDtoOutputRequiredDocumentsEnumSerializer;

  const AdminCaptainApplicationDtoOutputRequiredDocumentsEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputRequiredDocumentsEnum>
  get values => _$adminCaptainApplicationDtoOutputRequiredDocumentsEnumValues;
  static AdminCaptainApplicationDtoOutputRequiredDocumentsEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputRequiredDocumentsEnumValueOf(name);
}
