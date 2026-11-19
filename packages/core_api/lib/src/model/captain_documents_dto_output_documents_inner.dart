//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_documents_dto_output_documents_inner_valid.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_documents_dto_output_documents_inner_rejection.dart';
import 'package:core_api/src/model/captain_documents_dto_output_documents_inner_pending.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_documents_dto_output_documents_inner.g.dart';

/// CaptainDocumentsDtoOutputDocumentsInner
///
/// Properties:
/// * [kind]
/// * [required_]
/// * [state] - «expiring» from captain.document_expiry_notice_days before its expiry.
/// * [valid]
/// * [pending]
/// * [rejection]
@BuiltValue()
abstract class CaptainDocumentsDtoOutputDocumentsInner
    implements
        Built<
          CaptainDocumentsDtoOutputDocumentsInner,
          CaptainDocumentsDtoOutputDocumentsInnerBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  CaptainDocumentsDtoOutputDocumentsInnerKindEnum get kind;
  // enum kindEnum {  national_id,  personal_photo,  civil_registry,  criminal_record,  vehicle_papers,  driving_licence,  };

  @BuiltValueField(wireName: r'required')
  bool get required_;

  /// «expiring» from captain.document_expiry_notice_days before its expiry.
  @BuiltValueField(wireName: r'state')
  CaptainDocumentsDtoOutputDocumentsInnerStateEnum get state;
  // enum stateEnum {  valid,  expiring,  expired,  missing,  };

  @BuiltValueField(wireName: r'valid')
  CaptainDocumentsDtoOutputDocumentsInnerValid? get valid;

  @BuiltValueField(wireName: r'pending')
  CaptainDocumentsDtoOutputDocumentsInnerPending? get pending;

  @BuiltValueField(wireName: r'rejection')
  CaptainDocumentsDtoOutputDocumentsInnerRejection? get rejection;

  CaptainDocumentsDtoOutputDocumentsInner._();

  factory CaptainDocumentsDtoOutputDocumentsInner([
    void updates(CaptainDocumentsDtoOutputDocumentsInnerBuilder b),
  ]) = _$CaptainDocumentsDtoOutputDocumentsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainDocumentsDtoOutputDocumentsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDocumentsDtoOutputDocumentsInner> get serializer =>
      _$CaptainDocumentsDtoOutputDocumentsInnerSerializer();
}

class _$CaptainDocumentsDtoOutputDocumentsInnerSerializer
    implements PrimitiveSerializer<CaptainDocumentsDtoOutputDocumentsInner> {
  @override
  final Iterable<Type> types = const [
    CaptainDocumentsDtoOutputDocumentsInner,
    _$CaptainDocumentsDtoOutputDocumentsInner,
  ];

  @override
  final String wireName = r'CaptainDocumentsDtoOutputDocumentsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDocumentsDtoOutputDocumentsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        CaptainDocumentsDtoOutputDocumentsInnerKindEnum,
      ),
    );
    yield r'required';
    yield serializers.serialize(
      object.required_,
      specifiedType: const FullType(bool),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(
        CaptainDocumentsDtoOutputDocumentsInnerStateEnum,
      ),
    );
    yield r'valid';
    yield object.valid == null
        ? null
        : serializers.serialize(
            object.valid,
            specifiedType: const FullType.nullable(
              CaptainDocumentsDtoOutputDocumentsInnerValid,
            ),
          );
    yield r'pending';
    yield object.pending == null
        ? null
        : serializers.serialize(
            object.pending,
            specifiedType: const FullType.nullable(
              CaptainDocumentsDtoOutputDocumentsInnerPending,
            ),
          );
    yield r'rejection';
    yield object.rejection == null
        ? null
        : serializers.serialize(
            object.rejection,
            specifiedType: const FullType.nullable(
              CaptainDocumentsDtoOutputDocumentsInnerRejection,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDocumentsDtoOutputDocumentsInner object, {
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
    required CaptainDocumentsDtoOutputDocumentsInnerBuilder result,
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
                      CaptainDocumentsDtoOutputDocumentsInnerKindEnum,
                    ),
                  )
                  as CaptainDocumentsDtoOutputDocumentsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'required':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.required_ = valueDes;
          break;
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainDocumentsDtoOutputDocumentsInnerStateEnum,
                    ),
                  )
                  as CaptainDocumentsDtoOutputDocumentsInnerStateEnum;
          result.state = valueDes;
          break;
        case r'valid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainDocumentsDtoOutputDocumentsInnerValid,
                    ),
                  )
                  as CaptainDocumentsDtoOutputDocumentsInnerValid?;
          if (valueDes == null) continue;
          result.valid.replace(valueDes);
          break;
        case r'pending':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainDocumentsDtoOutputDocumentsInnerPending,
                    ),
                  )
                  as CaptainDocumentsDtoOutputDocumentsInnerPending?;
          if (valueDes == null) continue;
          result.pending.replace(valueDes);
          break;
        case r'rejection':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainDocumentsDtoOutputDocumentsInnerRejection,
                    ),
                  )
                  as CaptainDocumentsDtoOutputDocumentsInnerRejection?;
          if (valueDes == null) continue;
          result.rejection.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainDocumentsDtoOutputDocumentsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDocumentsDtoOutputDocumentsInnerBuilder();
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

class CaptainDocumentsDtoOutputDocumentsInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'national_id')
  static const CaptainDocumentsDtoOutputDocumentsInnerKindEnum nationalId =
      _$captainDocumentsDtoOutputDocumentsInnerKindEnum_nationalId;
  @BuiltValueEnumConst(wireName: r'personal_photo')
  static const CaptainDocumentsDtoOutputDocumentsInnerKindEnum personalPhoto =
      _$captainDocumentsDtoOutputDocumentsInnerKindEnum_personalPhoto;
  @BuiltValueEnumConst(wireName: r'civil_registry')
  static const CaptainDocumentsDtoOutputDocumentsInnerKindEnum civilRegistry =
      _$captainDocumentsDtoOutputDocumentsInnerKindEnum_civilRegistry;
  @BuiltValueEnumConst(wireName: r'criminal_record')
  static const CaptainDocumentsDtoOutputDocumentsInnerKindEnum criminalRecord =
      _$captainDocumentsDtoOutputDocumentsInnerKindEnum_criminalRecord;
  @BuiltValueEnumConst(wireName: r'vehicle_papers')
  static const CaptainDocumentsDtoOutputDocumentsInnerKindEnum vehiclePapers =
      _$captainDocumentsDtoOutputDocumentsInnerKindEnum_vehiclePapers;
  @BuiltValueEnumConst(wireName: r'driving_licence')
  static const CaptainDocumentsDtoOutputDocumentsInnerKindEnum drivingLicence =
      _$captainDocumentsDtoOutputDocumentsInnerKindEnum_drivingLicence;

  static Serializer<CaptainDocumentsDtoOutputDocumentsInnerKindEnum>
  get serializer => _$captainDocumentsDtoOutputDocumentsInnerKindEnumSerializer;

  const CaptainDocumentsDtoOutputDocumentsInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<CaptainDocumentsDtoOutputDocumentsInnerKindEnum> get values =>
      _$captainDocumentsDtoOutputDocumentsInnerKindEnumValues;
  static CaptainDocumentsDtoOutputDocumentsInnerKindEnum valueOf(String name) =>
      _$captainDocumentsDtoOutputDocumentsInnerKindEnumValueOf(name);
}

/// «expiring» from captain.document_expiry_notice_days before its expiry.
class CaptainDocumentsDtoOutputDocumentsInnerStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'valid')
  static const CaptainDocumentsDtoOutputDocumentsInnerStateEnum valid =
      _$captainDocumentsDtoOutputDocumentsInnerStateEnum_valid;
  @BuiltValueEnumConst(wireName: r'expiring')
  static const CaptainDocumentsDtoOutputDocumentsInnerStateEnum expiring =
      _$captainDocumentsDtoOutputDocumentsInnerStateEnum_expiring;
  @BuiltValueEnumConst(wireName: r'expired')
  static const CaptainDocumentsDtoOutputDocumentsInnerStateEnum expired =
      _$captainDocumentsDtoOutputDocumentsInnerStateEnum_expired;
  @BuiltValueEnumConst(wireName: r'missing')
  static const CaptainDocumentsDtoOutputDocumentsInnerStateEnum missing =
      _$captainDocumentsDtoOutputDocumentsInnerStateEnum_missing;

  static Serializer<CaptainDocumentsDtoOutputDocumentsInnerStateEnum>
  get serializer =>
      _$captainDocumentsDtoOutputDocumentsInnerStateEnumSerializer;

  const CaptainDocumentsDtoOutputDocumentsInnerStateEnum._(String name)
    : super(name);

  static BuiltSet<CaptainDocumentsDtoOutputDocumentsInnerStateEnum>
  get values => _$captainDocumentsDtoOutputDocumentsInnerStateEnumValues;
  static CaptainDocumentsDtoOutputDocumentsInnerStateEnum valueOf(
    String name,
  ) => _$captainDocumentsDtoOutputDocumentsInnerStateEnumValueOf(name);
}
