//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_performance_dto_output_violations_inner_appeal.g.dart';

/// «اعتراض»; an accepted one voids the violation.
///
/// Properties:
/// * [ticketId]
/// * [outcome]
@BuiltValue()
abstract class CaptainPerformanceDtoOutputViolationsInnerAppeal
    implements
        Built<
          CaptainPerformanceDtoOutputViolationsInnerAppeal,
          CaptainPerformanceDtoOutputViolationsInnerAppealBuilder
        > {
  @BuiltValueField(wireName: r'ticketId')
  String get ticketId;

  @BuiltValueField(wireName: r'outcome')
  CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum? get outcome;
  // enum outcomeEnum {  accepted,  rejected,  };

  CaptainPerformanceDtoOutputViolationsInnerAppeal._();

  factory CaptainPerformanceDtoOutputViolationsInnerAppeal([
    void updates(CaptainPerformanceDtoOutputViolationsInnerAppealBuilder b),
  ]) = _$CaptainPerformanceDtoOutputViolationsInnerAppeal;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainPerformanceDtoOutputViolationsInnerAppealBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPerformanceDtoOutputViolationsInnerAppeal>
  get serializer =>
      _$CaptainPerformanceDtoOutputViolationsInnerAppealSerializer();
}

class _$CaptainPerformanceDtoOutputViolationsInnerAppealSerializer
    implements
        PrimitiveSerializer<CaptainPerformanceDtoOutputViolationsInnerAppeal> {
  @override
  final Iterable<Type> types = const [
    CaptainPerformanceDtoOutputViolationsInnerAppeal,
    _$CaptainPerformanceDtoOutputViolationsInnerAppeal,
  ];

  @override
  final String wireName = r'CaptainPerformanceDtoOutputViolationsInnerAppeal';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPerformanceDtoOutputViolationsInnerAppeal object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticketId';
    yield serializers.serialize(
      object.ticketId,
      specifiedType: const FullType(String),
    );
    yield r'outcome';
    yield object.outcome == null
        ? null
        : serializers.serialize(
            object.outcome,
            specifiedType: const FullType.nullable(
              CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPerformanceDtoOutputViolationsInnerAppeal object, {
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
    required CaptainPerformanceDtoOutputViolationsInnerAppealBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticketId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.ticketId = valueDes;
          break;
        case r'outcome':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum,
                    ),
                  )
                  as CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum?;
          if (valueDes == null) continue;
          result.outcome = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPerformanceDtoOutputViolationsInnerAppeal deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPerformanceDtoOutputViolationsInnerAppealBuilder();
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

class CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum
  accepted =
      _$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum_accepted;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum
  rejected =
      _$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum_rejected;

  static Serializer<CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum>
  get serializer =>
      _$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnumSerializer;

  const CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum._(
    String name,
  ) : super(name);

  static BuiltSet<CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum>
  get values =>
      _$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnumValues;
  static CaptainPerformanceDtoOutputViolationsInnerAppealOutcomeEnum valueOf(
    String name,
  ) => _$captainPerformanceDtoOutputViolationsInnerAppealOutcomeEnumValueOf(
    name,
  );
}
