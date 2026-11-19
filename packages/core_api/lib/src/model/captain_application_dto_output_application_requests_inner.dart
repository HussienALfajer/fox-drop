//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_application_dto_output_application_requests_inner.g.dart';

/// CaptainApplicationDtoOutputApplicationRequestsInner
///
/// Properties:
/// * [kind]
/// * [reason]
/// * [requestedAt]
@BuiltValue()
abstract class CaptainApplicationDtoOutputApplicationRequestsInner
    implements
        Built<
          CaptainApplicationDtoOutputApplicationRequestsInner,
          CaptainApplicationDtoOutputApplicationRequestsInnerBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum get kind;
  // enum kindEnum {  national_id,  personal_photo,  civil_registry,  criminal_record,  vehicle_papers,  driving_licence,  };

  @BuiltValueField(wireName: r'reason')
  String get reason;

  @BuiltValueField(wireName: r'requestedAt')
  DateTime get requestedAt;

  CaptainApplicationDtoOutputApplicationRequestsInner._();

  factory CaptainApplicationDtoOutputApplicationRequestsInner([
    void updates(CaptainApplicationDtoOutputApplicationRequestsInnerBuilder b),
  ]) = _$CaptainApplicationDtoOutputApplicationRequestsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainApplicationDtoOutputApplicationRequestsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainApplicationDtoOutputApplicationRequestsInner>
  get serializer =>
      _$CaptainApplicationDtoOutputApplicationRequestsInnerSerializer();
}

class _$CaptainApplicationDtoOutputApplicationRequestsInnerSerializer
    implements
        PrimitiveSerializer<
          CaptainApplicationDtoOutputApplicationRequestsInner
        > {
  @override
  final Iterable<Type> types = const [
    CaptainApplicationDtoOutputApplicationRequestsInner,
    _$CaptainApplicationDtoOutputApplicationRequestsInner,
  ];

  @override
  final String wireName =
      r'CaptainApplicationDtoOutputApplicationRequestsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainApplicationDtoOutputApplicationRequestsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationDtoOutputApplicationRequestsInner object, {
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
    required CaptainApplicationDtoOutputApplicationRequestsInnerBuilder result,
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
                      CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum,
                    ),
                  )
                  as CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainApplicationDtoOutputApplicationRequestsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainApplicationDtoOutputApplicationRequestsInnerBuilder();
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

class CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'national_id')
  static const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
  nationalId =
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_nationalId;
  @BuiltValueEnumConst(wireName: r'personal_photo')
  static const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
  personalPhoto =
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_personalPhoto;
  @BuiltValueEnumConst(wireName: r'civil_registry')
  static const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
  civilRegistry =
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_civilRegistry;
  @BuiltValueEnumConst(wireName: r'criminal_record')
  static const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
  criminalRecord =
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_criminalRecord;
  @BuiltValueEnumConst(wireName: r'vehicle_papers')
  static const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
  vehiclePapers =
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_vehiclePapers;
  @BuiltValueEnumConst(wireName: r'driving_licence')
  static const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum
  drivingLicence =
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnum_drivingLicence;

  static Serializer<CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum>
  get serializer =>
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnumSerializer;

  const CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum._(
    String name,
  ) : super(name);

  static BuiltSet<CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum>
  get values =>
      _$captainApplicationDtoOutputApplicationRequestsInnerKindEnumValues;
  static CaptainApplicationDtoOutputApplicationRequestsInnerKindEnum valueOf(
    String name,
  ) => _$captainApplicationDtoOutputApplicationRequestsInnerKindEnumValueOf(
    name,
  );
}
