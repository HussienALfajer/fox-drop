//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_application_dto_output_events_inner.g.dart';

/// AdminCaptainApplicationDtoOutputEventsInner
///
/// Properties:
/// * [id]
/// * [at]
/// * [actor] - The admin; null for the applicant.
/// * [kind]
/// * [stage]
/// * [documentKind]
/// * [documentStatus]
/// * [note]
@BuiltValue()
abstract class AdminCaptainApplicationDtoOutputEventsInner
    implements
        Built<
          AdminCaptainApplicationDtoOutputEventsInner,
          AdminCaptainApplicationDtoOutputEventsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The admin; null for the applicant.
  @BuiltValueField(wireName: r'actor')
  String? get actor;

  @BuiltValueField(wireName: r'kind')
  AdminCaptainApplicationDtoOutputEventsInnerKindEnum get kind;
  // enum kindEnum {  submitted,  stage,  note,  document_review,  document_request,  document_upload,  interview,  kit,  cash_limit,  contract,  deposit,  };

  @BuiltValueField(wireName: r'stage')
  AdminCaptainApplicationDtoOutputEventsInnerStageEnum get stage;
  // enum stageEnum {  draft,  new,  under_review,  interview,  awaiting_kit,  active,  waitlist,  rejected,  };

  @BuiltValueField(wireName: r'documentKind')
  AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum? get documentKind;
  // enum documentKindEnum {  national_id,  personal_photo,  civil_registry,  criminal_record,  vehicle_papers,  driving_licence,  signed_contract,  };

  @BuiltValueField(wireName: r'documentStatus')
  AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum?
  get documentStatus;
  // enum documentStatusEnum {  pending,  accepted,  rejected,  };

  @BuiltValueField(wireName: r'note')
  String? get note;

  AdminCaptainApplicationDtoOutputEventsInner._();

  factory AdminCaptainApplicationDtoOutputEventsInner([
    void updates(AdminCaptainApplicationDtoOutputEventsInnerBuilder b),
  ]) = _$AdminCaptainApplicationDtoOutputEventsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainApplicationDtoOutputEventsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainApplicationDtoOutputEventsInner>
  get serializer => _$AdminCaptainApplicationDtoOutputEventsInnerSerializer();
}

class _$AdminCaptainApplicationDtoOutputEventsInnerSerializer
    implements
        PrimitiveSerializer<AdminCaptainApplicationDtoOutputEventsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainApplicationDtoOutputEventsInner,
    _$AdminCaptainApplicationDtoOutputEventsInner,
  ];

  @override
  final String wireName = r'AdminCaptainApplicationDtoOutputEventsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputEventsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'actor';
    yield object.actor == null
        ? null
        : serializers.serialize(
            object.actor,
            specifiedType: const FullType.nullable(String),
          );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminCaptainApplicationDtoOutputEventsInnerKindEnum,
      ),
    );
    yield r'stage';
    yield serializers.serialize(
      object.stage,
      specifiedType: const FullType(
        AdminCaptainApplicationDtoOutputEventsInnerStageEnum,
      ),
    );
    yield r'documentKind';
    yield object.documentKind == null
        ? null
        : serializers.serialize(
            object.documentKind,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum,
            ),
          );
    yield r'documentStatus';
    yield object.documentStatus == null
        ? null
        : serializers.serialize(
            object.documentStatus,
            specifiedType: const FullType.nullable(
              AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum,
            ),
          );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainApplicationDtoOutputEventsInner object, {
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
    required AdminCaptainApplicationDtoOutputEventsInnerBuilder result,
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
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'actor':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.actor = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationDtoOutputEventsInnerKindEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputEventsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'stage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainApplicationDtoOutputEventsInnerStageEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputEventsInnerStageEnum;
          result.stage = valueDes;
          break;
        case r'documentKind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum?;
          if (valueDes == null) continue;
          result.documentKind = valueDes;
          break;
        case r'documentStatus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum,
                    ),
                  )
                  as AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum?;
          if (valueDes == null) continue;
          result.documentStatus = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCaptainApplicationDtoOutputEventsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainApplicationDtoOutputEventsInnerBuilder();
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

class AdminCaptainApplicationDtoOutputEventsInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'submitted')
  static const AdminCaptainApplicationDtoOutputEventsInnerKindEnum submitted =
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnum_submitted;
  @BuiltValueEnumConst(wireName: r'stage')
  static const AdminCaptainApplicationDtoOutputEventsInnerKindEnum stage =
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnum_stage;
  @BuiltValueEnumConst(wireName: r'note')
  static const AdminCaptainApplicationDtoOutputEventsInnerKindEnum note =
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnum_note;
  @BuiltValueEnumConst(wireName: r'document_review')
  static const AdminCaptainApplicationDtoOutputEventsInnerKindEnum
  documentReview =
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnum_documentReview;
  @BuiltValueEnumConst(wireName: r'document_request')
  static const AdminCaptainApplicationDtoOutputEventsInnerKindEnum
  documentRequest =
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnum_documentRequest;
  @BuiltValueEnumConst(wireName: r'document_upload')
  static const AdminCaptainApplicationDtoOutputEventsInnerKindEnum
  documentUpload =
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnum_documentUpload;
  @BuiltValueEnumConst(wireName: r'interview')
  static const AdminCaptainApplicationDtoOutputEventsInnerKindEnum interview =
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnum_interview;
  @BuiltValueEnumConst(wireName: r'kit')
  static const AdminCaptainApplicationDtoOutputEventsInnerKindEnum kit =
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnum_kit;
  @BuiltValueEnumConst(wireName: r'cash_limit')
  static const AdminCaptainApplicationDtoOutputEventsInnerKindEnum cashLimit =
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnum_cashLimit;
  @BuiltValueEnumConst(wireName: r'contract')
  static const AdminCaptainApplicationDtoOutputEventsInnerKindEnum contract =
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnum_contract;
  @BuiltValueEnumConst(wireName: r'deposit')
  static const AdminCaptainApplicationDtoOutputEventsInnerKindEnum deposit =
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnum_deposit;

  static Serializer<AdminCaptainApplicationDtoOutputEventsInnerKindEnum>
  get serializer =>
      _$adminCaptainApplicationDtoOutputEventsInnerKindEnumSerializer;

  const AdminCaptainApplicationDtoOutputEventsInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputEventsInnerKindEnum>
  get values => _$adminCaptainApplicationDtoOutputEventsInnerKindEnumValues;
  static AdminCaptainApplicationDtoOutputEventsInnerKindEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputEventsInnerKindEnumValueOf(name);
}

class AdminCaptainApplicationDtoOutputEventsInnerStageEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminCaptainApplicationDtoOutputEventsInnerStageEnum draft =
      _$adminCaptainApplicationDtoOutputEventsInnerStageEnum_draft;
  @BuiltValueEnumConst(wireName: r'new')
  static const AdminCaptainApplicationDtoOutputEventsInnerStageEnum new_ =
      _$adminCaptainApplicationDtoOutputEventsInnerStageEnum_new_;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const AdminCaptainApplicationDtoOutputEventsInnerStageEnum
  underReview =
      _$adminCaptainApplicationDtoOutputEventsInnerStageEnum_underReview;
  @BuiltValueEnumConst(wireName: r'interview')
  static const AdminCaptainApplicationDtoOutputEventsInnerStageEnum interview =
      _$adminCaptainApplicationDtoOutputEventsInnerStageEnum_interview;
  @BuiltValueEnumConst(wireName: r'awaiting_kit')
  static const AdminCaptainApplicationDtoOutputEventsInnerStageEnum
  awaitingKit =
      _$adminCaptainApplicationDtoOutputEventsInnerStageEnum_awaitingKit;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminCaptainApplicationDtoOutputEventsInnerStageEnum active =
      _$adminCaptainApplicationDtoOutputEventsInnerStageEnum_active;
  @BuiltValueEnumConst(wireName: r'waitlist')
  static const AdminCaptainApplicationDtoOutputEventsInnerStageEnum waitlist =
      _$adminCaptainApplicationDtoOutputEventsInnerStageEnum_waitlist;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminCaptainApplicationDtoOutputEventsInnerStageEnum rejected =
      _$adminCaptainApplicationDtoOutputEventsInnerStageEnum_rejected;

  static Serializer<AdminCaptainApplicationDtoOutputEventsInnerStageEnum>
  get serializer =>
      _$adminCaptainApplicationDtoOutputEventsInnerStageEnumSerializer;

  const AdminCaptainApplicationDtoOutputEventsInnerStageEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputEventsInnerStageEnum>
  get values => _$adminCaptainApplicationDtoOutputEventsInnerStageEnumValues;
  static AdminCaptainApplicationDtoOutputEventsInnerStageEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputEventsInnerStageEnumValueOf(name);
}

class AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'national_id')
  static const AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum
  nationalId =
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum_nationalId;
  @BuiltValueEnumConst(wireName: r'personal_photo')
  static const AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum
  personalPhoto =
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum_personalPhoto;
  @BuiltValueEnumConst(wireName: r'civil_registry')
  static const AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum
  civilRegistry =
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum_civilRegistry;
  @BuiltValueEnumConst(wireName: r'criminal_record')
  static const AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum
  criminalRecord =
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum_criminalRecord;
  @BuiltValueEnumConst(wireName: r'vehicle_papers')
  static const AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum
  vehiclePapers =
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum_vehiclePapers;
  @BuiltValueEnumConst(wireName: r'driving_licence')
  static const AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum
  drivingLicence =
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum_drivingLicence;
  @BuiltValueEnumConst(wireName: r'signed_contract')
  static const AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum
  signedContract =
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum_signedContract;

  static Serializer<AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum>
  get serializer =>
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentKindEnumSerializer;

  const AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum>
  get values =>
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentKindEnumValues;
  static AdminCaptainApplicationDtoOutputEventsInnerDocumentKindEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputEventsInnerDocumentKindEnumValueOf(
    name,
  );
}

class AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum
  pending =
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum
  accepted =
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum
  rejected =
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum_rejected;

  static Serializer<
    AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum
  >
  get serializer =>
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnumSerializer;

  const AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum>
  get values =>
      _$adminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnumValues;
  static AdminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnum valueOf(
    String name,
  ) => _$adminCaptainApplicationDtoOutputEventsInnerDocumentStatusEnumValueOf(
    name,
  );
}
