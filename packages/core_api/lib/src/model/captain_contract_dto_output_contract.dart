//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_contract_dto_output_contract.g.dart';

/// Null for a captain who joined before the contracts.
///
/// Properties:
/// * [signedOn]
/// * [startsOn]
/// * [probationEndsOn]
/// * [commitmentStartsOn]
/// * [commitmentEndsOn]
/// * [probationConfirmed]
/// * [phase]
@BuiltValue()
abstract class CaptainContractDtoOutputContract
    implements
        Built<
          CaptainContractDtoOutputContract,
          CaptainContractDtoOutputContractBuilder
        > {
  @BuiltValueField(wireName: r'signedOn')
  Date get signedOn;

  @BuiltValueField(wireName: r'startsOn')
  Date get startsOn;

  @BuiltValueField(wireName: r'probationEndsOn')
  Date get probationEndsOn;

  @BuiltValueField(wireName: r'commitmentStartsOn')
  Date get commitmentStartsOn;

  @BuiltValueField(wireName: r'commitmentEndsOn')
  Date get commitmentEndsOn;

  @BuiltValueField(wireName: r'probationConfirmed')
  bool get probationConfirmed;

  @BuiltValueField(wireName: r'phase')
  CaptainContractDtoOutputContractPhaseEnum get phase;
  // enum phaseEnum {  probation,  commitment,  open,  };

  CaptainContractDtoOutputContract._();

  factory CaptainContractDtoOutputContract([
    void updates(CaptainContractDtoOutputContractBuilder b),
  ]) = _$CaptainContractDtoOutputContract;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainContractDtoOutputContractBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainContractDtoOutputContract> get serializer =>
      _$CaptainContractDtoOutputContractSerializer();
}

class _$CaptainContractDtoOutputContractSerializer
    implements PrimitiveSerializer<CaptainContractDtoOutputContract> {
  @override
  final Iterable<Type> types = const [
    CaptainContractDtoOutputContract,
    _$CaptainContractDtoOutputContract,
  ];

  @override
  final String wireName = r'CaptainContractDtoOutputContract';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainContractDtoOutputContract object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'signedOn';
    yield serializers.serialize(
      object.signedOn,
      specifiedType: const FullType(Date),
    );
    yield r'startsOn';
    yield serializers.serialize(
      object.startsOn,
      specifiedType: const FullType(Date),
    );
    yield r'probationEndsOn';
    yield serializers.serialize(
      object.probationEndsOn,
      specifiedType: const FullType(Date),
    );
    yield r'commitmentStartsOn';
    yield serializers.serialize(
      object.commitmentStartsOn,
      specifiedType: const FullType(Date),
    );
    yield r'commitmentEndsOn';
    yield serializers.serialize(
      object.commitmentEndsOn,
      specifiedType: const FullType(Date),
    );
    yield r'probationConfirmed';
    yield serializers.serialize(
      object.probationConfirmed,
      specifiedType: const FullType(bool),
    );
    yield r'phase';
    yield serializers.serialize(
      object.phase,
      specifiedType: const FullType(CaptainContractDtoOutputContractPhaseEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainContractDtoOutputContract object, {
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
    required CaptainContractDtoOutputContractBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'signedOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.signedOn = valueDes;
          break;
        case r'startsOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.startsOn = valueDes;
          break;
        case r'probationEndsOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.probationEndsOn = valueDes;
          break;
        case r'commitmentStartsOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.commitmentStartsOn = valueDes;
          break;
        case r'commitmentEndsOn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.commitmentEndsOn = valueDes;
          break;
        case r'probationConfirmed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.probationConfirmed = valueDes;
          break;
        case r'phase':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainContractDtoOutputContractPhaseEnum,
                    ),
                  )
                  as CaptainContractDtoOutputContractPhaseEnum;
          result.phase = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainContractDtoOutputContract deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainContractDtoOutputContractBuilder();
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

class CaptainContractDtoOutputContractPhaseEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'probation')
  static const CaptainContractDtoOutputContractPhaseEnum probation =
      _$captainContractDtoOutputContractPhaseEnum_probation;
  @BuiltValueEnumConst(wireName: r'commitment')
  static const CaptainContractDtoOutputContractPhaseEnum commitment =
      _$captainContractDtoOutputContractPhaseEnum_commitment;
  @BuiltValueEnumConst(wireName: r'open')
  static const CaptainContractDtoOutputContractPhaseEnum open =
      _$captainContractDtoOutputContractPhaseEnum_open;

  static Serializer<CaptainContractDtoOutputContractPhaseEnum> get serializer =>
      _$captainContractDtoOutputContractPhaseEnumSerializer;

  const CaptainContractDtoOutputContractPhaseEnum._(String name) : super(name);

  static BuiltSet<CaptainContractDtoOutputContractPhaseEnum> get values =>
      _$captainContractDtoOutputContractPhaseEnumValues;
  static CaptainContractDtoOutputContractPhaseEnum valueOf(String name) =>
      _$captainContractDtoOutputContractPhaseEnumValueOf(name);
}
