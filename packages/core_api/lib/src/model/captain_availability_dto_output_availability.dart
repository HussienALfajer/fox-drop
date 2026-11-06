//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_availability_dto_output_availability_one_of2.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_availability_dto_output_availability_one_of.dart';
import 'package:core_api/src/model/captain_availability_dto_output_availability_one_of3.dart';
import 'package:core_api/src/model/captain_availability_dto_output_availability_one_of1.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'captain_availability_dto_output_availability.g.dart';

/// CA §7.1: «غير متصل», «متصل متاح», «لا تصلك عروض» with its reasons, «موقوف».
///
/// Properties:
/// * [state]
/// * [since]
/// * [reasons]
/// * [reason]
/// * [until] - Null: until further notice.
@BuiltValue()
abstract class CaptainAvailabilityDtoOutputAvailability
    implements
        Built<
          CaptainAvailabilityDtoOutputAvailability,
          CaptainAvailabilityDtoOutputAvailabilityBuilder
        > {
  /// One Of [CaptainAvailabilityDtoOutputAvailabilityOneOf], [CaptainAvailabilityDtoOutputAvailabilityOneOf1], [CaptainAvailabilityDtoOutputAvailabilityOneOf2], [CaptainAvailabilityDtoOutputAvailabilityOneOf3]
  OneOf get oneOf;

  CaptainAvailabilityDtoOutputAvailability._();

  factory CaptainAvailabilityDtoOutputAvailability([
    void updates(CaptainAvailabilityDtoOutputAvailabilityBuilder b),
  ]) = _$CaptainAvailabilityDtoOutputAvailability;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainAvailabilityDtoOutputAvailabilityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainAvailabilityDtoOutputAvailability> get serializer =>
      _$CaptainAvailabilityDtoOutputAvailabilitySerializer();
}

class _$CaptainAvailabilityDtoOutputAvailabilitySerializer
    implements PrimitiveSerializer<CaptainAvailabilityDtoOutputAvailability> {
  @override
  final Iterable<Type> types = const [
    CaptainAvailabilityDtoOutputAvailability,
    _$CaptainAvailabilityDtoOutputAvailability,
  ];

  @override
  final String wireName = r'CaptainAvailabilityDtoOutputAvailability';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    CaptainAvailabilityDtoOutputAvailability object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(
      oneOf.value,
      specifiedType: FullType(oneOf.valueType),
    )!;
  }

  @override
  CaptainAvailabilityDtoOutputAvailability deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainAvailabilityDtoOutputAvailabilityBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [
      FullType(CaptainAvailabilityDtoOutputAvailabilityOneOf),
      FullType(CaptainAvailabilityDtoOutputAvailabilityOneOf1),
      FullType(CaptainAvailabilityDtoOutputAvailabilityOneOf2),
      FullType(CaptainAvailabilityDtoOutputAvailabilityOneOf3),
    ]);
    oneOfDataSrc = serialized;
    result.oneOf =
        serializers.deserialize(oneOfDataSrc, specifiedType: targetType)
            as OneOf;
    return result.build();
  }
}

class CaptainAvailabilityDtoOutputAvailabilityStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'suspended')
  static const CaptainAvailabilityDtoOutputAvailabilityStateEnum suspended =
      _$captainAvailabilityDtoOutputAvailabilityStateEnum_suspended;

  static Serializer<CaptainAvailabilityDtoOutputAvailabilityStateEnum>
  get serializer =>
      _$captainAvailabilityDtoOutputAvailabilityStateEnumSerializer;

  const CaptainAvailabilityDtoOutputAvailabilityStateEnum._(String name)
    : super(name);

  static BuiltSet<CaptainAvailabilityDtoOutputAvailabilityStateEnum>
  get values => _$captainAvailabilityDtoOutputAvailabilityStateEnumValues;
  static CaptainAvailabilityDtoOutputAvailabilityStateEnum valueOf(
    String name,
  ) => _$captainAvailabilityDtoOutputAvailabilityStateEnumValueOf(name);
}

class CaptainAvailabilityDtoOutputAvailabilityReasonsEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'cash_limit')
  static const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum cashLimit =
      _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_cashLimit;
  @BuiltValueEnumConst(wireName: r'closed_due')
  static const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum closedDue =
      _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_closedDue;
  @BuiltValueEnumConst(wireName: r'simulated_location')
  static const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum
  simulatedLocation =
      _$captainAvailabilityDtoOutputAvailabilityReasonsEnum_simulatedLocation;

  static Serializer<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>
  get serializer =>
      _$captainAvailabilityDtoOutputAvailabilityReasonsEnumSerializer;

  const CaptainAvailabilityDtoOutputAvailabilityReasonsEnum._(String name)
    : super(name);

  static BuiltSet<CaptainAvailabilityDtoOutputAvailabilityReasonsEnum>
  get values => _$captainAvailabilityDtoOutputAvailabilityReasonsEnumValues;
  static CaptainAvailabilityDtoOutputAvailabilityReasonsEnum valueOf(
    String name,
  ) => _$captainAvailabilityDtoOutputAvailabilityReasonsEnumValueOf(name);
}
