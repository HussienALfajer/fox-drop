//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_application_dto_output_application_documents_inner.g.dart';

/// CaptainApplicationDtoOutputApplicationDocumentsInner
///
/// Properties:
/// * [kind]
/// * [status]
/// * [reason] - Why it was rejected.
/// * [fileCount]
/// * [number] - The ID's number.
/// * [issueDate] - A calendar day, YYYY-MM-DD.
/// * [expiresOn] - A calendar day, YYYY-MM-DD.
/// * [uploadedAt]
@BuiltValue()
abstract class CaptainApplicationDtoOutputApplicationDocumentsInner
    implements
        Built<
          CaptainApplicationDtoOutputApplicationDocumentsInner,
          CaptainApplicationDtoOutputApplicationDocumentsInnerBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum get kind;
  // enum kindEnum {  national_id,  personal_photo,  civil_registry,  criminal_record,  vehicle_papers,  driving_licence,  };

  @BuiltValueField(wireName: r'status')
  CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum get status;
  // enum statusEnum {  pending,  accepted,  rejected,  };

  /// Why it was rejected.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'fileCount')
  int get fileCount;

  /// The ID's number.
  @BuiltValueField(wireName: r'number')
  String? get number;

  /// A calendar day, YYYY-MM-DD.
  @BuiltValueField(wireName: r'issueDate')
  Date? get issueDate;

  /// A calendar day, YYYY-MM-DD.
  @BuiltValueField(wireName: r'expiresOn')
  Date? get expiresOn;

  @BuiltValueField(wireName: r'uploadedAt')
  DateTime get uploadedAt;

  CaptainApplicationDtoOutputApplicationDocumentsInner._();

  factory CaptainApplicationDtoOutputApplicationDocumentsInner([
    void updates(CaptainApplicationDtoOutputApplicationDocumentsInnerBuilder b),
  ]) = _$CaptainApplicationDtoOutputApplicationDocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainApplicationDtoOutputApplicationDocumentsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainApplicationDtoOutputApplicationDocumentsInner>
  get serializer =>
      _$CaptainApplicationDtoOutputApplicationDocumentsInnerSerializer();
}

class _$CaptainApplicationDtoOutputApplicationDocumentsInnerSerializer
    implements
        PrimitiveSerializer<
          CaptainApplicationDtoOutputApplicationDocumentsInner
        > {
  @override
  final Iterable<Type> types = const [
    CaptainApplicationDtoOutputApplicationDocumentsInner,
    _$CaptainApplicationDtoOutputApplicationDocumentsInner,
  ];

  @override
  final String wireName =
      r'CaptainApplicationDtoOutputApplicationDocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainApplicationDtoOutputApplicationDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum,
      ),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum,
      ),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'fileCount';
    yield serializers.serialize(
      object.fileCount,
      specifiedType: const FullType(int),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationDtoOutputApplicationDocumentsInner object, {
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
    required CaptainApplicationDtoOutputApplicationDocumentsInnerBuilder result,
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
                      CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum,
                    ),
                  )
                  as CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum,
                    ),
                  )
                  as CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum;
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
        case r'fileCount':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.fileCount = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainApplicationDtoOutputApplicationDocumentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CaptainApplicationDtoOutputApplicationDocumentsInnerBuilder();
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

class CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'national_id')
  static const CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum
  nationalId =
      _$captainApplicationDtoOutputApplicationDocumentsInnerKindEnum_nationalId;
  @BuiltValueEnumConst(wireName: r'personal_photo')
  static const CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum
  personalPhoto =
      _$captainApplicationDtoOutputApplicationDocumentsInnerKindEnum_personalPhoto;
  @BuiltValueEnumConst(wireName: r'civil_registry')
  static const CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum
  civilRegistry =
      _$captainApplicationDtoOutputApplicationDocumentsInnerKindEnum_civilRegistry;
  @BuiltValueEnumConst(wireName: r'criminal_record')
  static const CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum
  criminalRecord =
      _$captainApplicationDtoOutputApplicationDocumentsInnerKindEnum_criminalRecord;
  @BuiltValueEnumConst(wireName: r'vehicle_papers')
  static const CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum
  vehiclePapers =
      _$captainApplicationDtoOutputApplicationDocumentsInnerKindEnum_vehiclePapers;
  @BuiltValueEnumConst(wireName: r'driving_licence')
  static const CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum
  drivingLicence =
      _$captainApplicationDtoOutputApplicationDocumentsInnerKindEnum_drivingLicence;

  static Serializer<
    CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum
  >
  get serializer =>
      _$captainApplicationDtoOutputApplicationDocumentsInnerKindEnumSerializer;

  const CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum._(
    String name,
  ) : super(name);

  static BuiltSet<CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum>
  get values =>
      _$captainApplicationDtoOutputApplicationDocumentsInnerKindEnumValues;
  static CaptainApplicationDtoOutputApplicationDocumentsInnerKindEnum valueOf(
    String name,
  ) => _$captainApplicationDtoOutputApplicationDocumentsInnerKindEnumValueOf(
    name,
  );
}

class CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum
  pending =
      _$captainApplicationDtoOutputApplicationDocumentsInnerStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum
  accepted =
      _$captainApplicationDtoOutputApplicationDocumentsInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum
  rejected =
      _$captainApplicationDtoOutputApplicationDocumentsInnerStatusEnum_rejected;

  static Serializer<
    CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum
  >
  get serializer =>
      _$captainApplicationDtoOutputApplicationDocumentsInnerStatusEnumSerializer;

  const CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum
  >
  get values =>
      _$captainApplicationDtoOutputApplicationDocumentsInnerStatusEnumValues;
  static CaptainApplicationDtoOutputApplicationDocumentsInnerStatusEnum valueOf(
    String name,
  ) => _$captainApplicationDtoOutputApplicationDocumentsInnerStatusEnumValueOf(
    name,
  );
}
