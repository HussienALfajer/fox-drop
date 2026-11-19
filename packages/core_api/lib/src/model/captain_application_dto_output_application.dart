//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_application_dto_output_application_interview.dart';
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_application_dto_output_application_history_inner.dart';
import 'package:core_api/src/model/captain_application_dto_output_application_documents_inner.dart';
import 'package:core_api/src/model/captain_application_dto_output_application_requests_inner.dart';
import 'package:core_api/src/model/captain_application_dto_output_application_rejection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_application_dto_output_application.g.dart';

/// CaptainApplicationDtoOutputApplication
///
/// Properties:
/// * [id]
/// * [stage] - draft until «إرسال الطلب», then the panel’s stage (CA §5.4).
/// * [fullName]
/// * [birthDate] - A calendar day, YYYY-MM-DD.
/// * [zoneId]
/// * [vehicle]
/// * [plate]
/// * [documents]
/// * [missing] - What «إرسال الطلب» waits for, in the form’s order.
/// * [submittedAt]
/// * [requests] - What the panel asked for: «يرجى رفع {المستند}: {السبب}».
/// * [interview]
/// * [rejection]
/// * [history] - The stages since «إرسال الطلب», oldest first.
@BuiltValue()
abstract class CaptainApplicationDtoOutputApplication
    implements
        Built<
          CaptainApplicationDtoOutputApplication,
          CaptainApplicationDtoOutputApplicationBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// draft until «إرسال الطلب», then the panel’s stage (CA §5.4).
  @BuiltValueField(wireName: r'stage')
  CaptainApplicationDtoOutputApplicationStageEnum get stage;
  // enum stageEnum {  draft,  new,  under_review,  interview,  awaiting_kit,  active,  waitlist,  rejected,  };

  @BuiltValueField(wireName: r'fullName')
  String get fullName;

  /// A calendar day, YYYY-MM-DD.
  @BuiltValueField(wireName: r'birthDate')
  Date get birthDate;

  @BuiltValueField(wireName: r'zoneId')
  String get zoneId;

  @BuiltValueField(wireName: r'vehicle')
  CaptainApplicationDtoOutputApplicationVehicleEnum? get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  @BuiltValueField(wireName: r'plate')
  String? get plate;

  @BuiltValueField(wireName: r'documents')
  BuiltList<CaptainApplicationDtoOutputApplicationDocumentsInner> get documents;

  /// What «إرسال الطلب» waits for, in the form’s order.
  @BuiltValueField(wireName: r'missing')
  BuiltList<CaptainApplicationDtoOutputApplicationMissingEnum> get missing;
  // enum missingEnum {  vehicle,  document:national_id,  document:personal_photo,  document:civil_registry,  document:criminal_record,  document:vehicle_papers,  document:driving_licence,  terms,  };

  @BuiltValueField(wireName: r'submittedAt')
  DateTime? get submittedAt;

  /// What the panel asked for: «يرجى رفع {المستند}: {السبب}».
  @BuiltValueField(wireName: r'requests')
  BuiltList<CaptainApplicationDtoOutputApplicationRequestsInner> get requests;

  @BuiltValueField(wireName: r'interview')
  CaptainApplicationDtoOutputApplicationInterview? get interview;

  @BuiltValueField(wireName: r'rejection')
  CaptainApplicationDtoOutputApplicationRejection? get rejection;

  /// The stages since «إرسال الطلب», oldest first.
  @BuiltValueField(wireName: r'history')
  BuiltList<CaptainApplicationDtoOutputApplicationHistoryInner> get history;

  CaptainApplicationDtoOutputApplication._();

  factory CaptainApplicationDtoOutputApplication([
    void updates(CaptainApplicationDtoOutputApplicationBuilder b),
  ]) = _$CaptainApplicationDtoOutputApplication;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainApplicationDtoOutputApplicationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainApplicationDtoOutputApplication> get serializer =>
      _$CaptainApplicationDtoOutputApplicationSerializer();
}

class _$CaptainApplicationDtoOutputApplicationSerializer
    implements PrimitiveSerializer<CaptainApplicationDtoOutputApplication> {
  @override
  final Iterable<Type> types = const [
    CaptainApplicationDtoOutputApplication,
    _$CaptainApplicationDtoOutputApplication,
  ];

  @override
  final String wireName = r'CaptainApplicationDtoOutputApplication';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainApplicationDtoOutputApplication object, {
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
      specifiedType: const FullType(
        CaptainApplicationDtoOutputApplicationStageEnum,
      ),
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
    yield r'vehicle';
    yield object.vehicle == null
        ? null
        : serializers.serialize(
            object.vehicle,
            specifiedType: const FullType.nullable(
              CaptainApplicationDtoOutputApplicationVehicleEnum,
            ),
          );
    yield r'plate';
    yield object.plate == null
        ? null
        : serializers.serialize(
            object.plate,
            specifiedType: const FullType.nullable(String),
          );
    yield r'documents';
    yield serializers.serialize(
      object.documents,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainApplicationDtoOutputApplicationDocumentsInner),
      ]),
    );
    yield r'missing';
    yield serializers.serialize(
      object.missing,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainApplicationDtoOutputApplicationMissingEnum),
      ]),
    );
    yield r'submittedAt';
    yield object.submittedAt == null
        ? null
        : serializers.serialize(
            object.submittedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'requests';
    yield serializers.serialize(
      object.requests,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainApplicationDtoOutputApplicationRequestsInner),
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
              CaptainApplicationDtoOutputApplicationRejection,
            ),
          );
    yield r'history';
    yield serializers.serialize(
      object.history,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainApplicationDtoOutputApplicationHistoryInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationDtoOutputApplication object, {
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
    required CaptainApplicationDtoOutputApplicationBuilder result,
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
                      CaptainApplicationDtoOutputApplicationStageEnum,
                    ),
                  )
                  as CaptainApplicationDtoOutputApplicationStageEnum;
          result.stage = valueDes;
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
        case r'vehicle':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainApplicationDtoOutputApplicationVehicleEnum,
                    ),
                  )
                  as CaptainApplicationDtoOutputApplicationVehicleEnum?;
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
        case r'documents':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainApplicationDtoOutputApplicationDocumentsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainApplicationDtoOutputApplicationDocumentsInner
                  >;
          result.documents.replace(valueDes);
          break;
        case r'missing':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainApplicationDtoOutputApplicationMissingEnum,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainApplicationDtoOutputApplicationMissingEnum
                  >;
          result.missing.replace(valueDes);
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
        case r'requests':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainApplicationDtoOutputApplicationRequestsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainApplicationDtoOutputApplicationRequestsInner
                  >;
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
                      CaptainApplicationDtoOutputApplicationRejection,
                    ),
                  )
                  as CaptainApplicationDtoOutputApplicationRejection?;
          if (valueDes == null) continue;
          result.rejection.replace(valueDes);
          break;
        case r'history':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CaptainApplicationDtoOutputApplicationHistoryInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainApplicationDtoOutputApplicationHistoryInner
                  >;
          result.history.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainApplicationDtoOutputApplication deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainApplicationDtoOutputApplicationBuilder();
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

/// draft until «إرسال الطلب», then the panel’s stage (CA §5.4).
class CaptainApplicationDtoOutputApplicationStageEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const CaptainApplicationDtoOutputApplicationStageEnum draft =
      _$captainApplicationDtoOutputApplicationStageEnum_draft;
  @BuiltValueEnumConst(wireName: r'new')
  static const CaptainApplicationDtoOutputApplicationStageEnum new_ =
      _$captainApplicationDtoOutputApplicationStageEnum_new_;
  @BuiltValueEnumConst(wireName: r'under_review')
  static const CaptainApplicationDtoOutputApplicationStageEnum underReview =
      _$captainApplicationDtoOutputApplicationStageEnum_underReview;
  @BuiltValueEnumConst(wireName: r'interview')
  static const CaptainApplicationDtoOutputApplicationStageEnum interview =
      _$captainApplicationDtoOutputApplicationStageEnum_interview;
  @BuiltValueEnumConst(wireName: r'awaiting_kit')
  static const CaptainApplicationDtoOutputApplicationStageEnum awaitingKit =
      _$captainApplicationDtoOutputApplicationStageEnum_awaitingKit;
  @BuiltValueEnumConst(wireName: r'active')
  static const CaptainApplicationDtoOutputApplicationStageEnum active =
      _$captainApplicationDtoOutputApplicationStageEnum_active;
  @BuiltValueEnumConst(wireName: r'waitlist')
  static const CaptainApplicationDtoOutputApplicationStageEnum waitlist =
      _$captainApplicationDtoOutputApplicationStageEnum_waitlist;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CaptainApplicationDtoOutputApplicationStageEnum rejected =
      _$captainApplicationDtoOutputApplicationStageEnum_rejected;

  static Serializer<CaptainApplicationDtoOutputApplicationStageEnum>
  get serializer => _$captainApplicationDtoOutputApplicationStageEnumSerializer;

  const CaptainApplicationDtoOutputApplicationStageEnum._(String name)
    : super(name);

  static BuiltSet<CaptainApplicationDtoOutputApplicationStageEnum> get values =>
      _$captainApplicationDtoOutputApplicationStageEnumValues;
  static CaptainApplicationDtoOutputApplicationStageEnum valueOf(String name) =>
      _$captainApplicationDtoOutputApplicationStageEnumValueOf(name);
}

class CaptainApplicationDtoOutputApplicationVehicleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'walking')
  static const CaptainApplicationDtoOutputApplicationVehicleEnum walking =
      _$captainApplicationDtoOutputApplicationVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const CaptainApplicationDtoOutputApplicationVehicleEnum bicycle =
      _$captainApplicationDtoOutputApplicationVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const CaptainApplicationDtoOutputApplicationVehicleEnum motorbike =
      _$captainApplicationDtoOutputApplicationVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const CaptainApplicationDtoOutputApplicationVehicleEnum car =
      _$captainApplicationDtoOutputApplicationVehicleEnum_car;

  static Serializer<CaptainApplicationDtoOutputApplicationVehicleEnum>
  get serializer =>
      _$captainApplicationDtoOutputApplicationVehicleEnumSerializer;

  const CaptainApplicationDtoOutputApplicationVehicleEnum._(String name)
    : super(name);

  static BuiltSet<CaptainApplicationDtoOutputApplicationVehicleEnum>
  get values => _$captainApplicationDtoOutputApplicationVehicleEnumValues;
  static CaptainApplicationDtoOutputApplicationVehicleEnum valueOf(
    String name,
  ) => _$captainApplicationDtoOutputApplicationVehicleEnumValueOf(name);
}

class CaptainApplicationDtoOutputApplicationMissingEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'vehicle')
  static const CaptainApplicationDtoOutputApplicationMissingEnum vehicle =
      _$captainApplicationDtoOutputApplicationMissingEnum_vehicle;
  @BuiltValueEnumConst(wireName: r'document:national_id')
  static const CaptainApplicationDtoOutputApplicationMissingEnum
  documentColonNationalId =
      _$captainApplicationDtoOutputApplicationMissingEnum_documentColonNationalId;
  @BuiltValueEnumConst(wireName: r'document:personal_photo')
  static const CaptainApplicationDtoOutputApplicationMissingEnum
  documentColonPersonalPhoto =
      _$captainApplicationDtoOutputApplicationMissingEnum_documentColonPersonalPhoto;
  @BuiltValueEnumConst(wireName: r'document:civil_registry')
  static const CaptainApplicationDtoOutputApplicationMissingEnum
  documentColonCivilRegistry =
      _$captainApplicationDtoOutputApplicationMissingEnum_documentColonCivilRegistry;
  @BuiltValueEnumConst(wireName: r'document:criminal_record')
  static const CaptainApplicationDtoOutputApplicationMissingEnum
  documentColonCriminalRecord =
      _$captainApplicationDtoOutputApplicationMissingEnum_documentColonCriminalRecord;
  @BuiltValueEnumConst(wireName: r'document:vehicle_papers')
  static const CaptainApplicationDtoOutputApplicationMissingEnum
  documentColonVehiclePapers =
      _$captainApplicationDtoOutputApplicationMissingEnum_documentColonVehiclePapers;
  @BuiltValueEnumConst(wireName: r'document:driving_licence')
  static const CaptainApplicationDtoOutputApplicationMissingEnum
  documentColonDrivingLicence =
      _$captainApplicationDtoOutputApplicationMissingEnum_documentColonDrivingLicence;
  @BuiltValueEnumConst(wireName: r'terms')
  static const CaptainApplicationDtoOutputApplicationMissingEnum terms =
      _$captainApplicationDtoOutputApplicationMissingEnum_terms;

  static Serializer<CaptainApplicationDtoOutputApplicationMissingEnum>
  get serializer =>
      _$captainApplicationDtoOutputApplicationMissingEnumSerializer;

  const CaptainApplicationDtoOutputApplicationMissingEnum._(String name)
    : super(name);

  static BuiltSet<CaptainApplicationDtoOutputApplicationMissingEnum>
  get values => _$captainApplicationDtoOutputApplicationMissingEnumValues;
  static CaptainApplicationDtoOutputApplicationMissingEnum valueOf(
    String name,
  ) => _$captainApplicationDtoOutputApplicationMissingEnumValueOf(name);
}
