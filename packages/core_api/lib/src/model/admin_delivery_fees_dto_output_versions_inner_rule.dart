//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_delivery_fees_dto_output_versions_inner_rule_one_of.dart';
import 'package:core_api/src/model/admin_delivery_fees_dto_output_versions_inner_rule_one_of1.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_delivery_fees_dto_output_versions_inner_rule_one_of1_bands_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'admin_delivery_fees_dto_output_versions_inner_rule.g.dart';

/// AdminDeliveryFeesDtoOutputVersionsInnerRule
///
/// Properties:
/// * [id]
/// * [kind]
/// * [flatFee]
/// * [currency]
/// * [minimumFee] - A lower fee is raised to it; null for none.
/// * [freeDeliveryFrom] - An items value from which delivery is free; null for none.
/// * [bands]
@BuiltValue()
abstract class AdminDeliveryFeesDtoOutputVersionsInnerRule
    implements
        Built<
          AdminDeliveryFeesDtoOutputVersionsInnerRule,
          AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder
        > {
  /// One Of [AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf], [AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1]
  OneOf get oneOf;

  AdminDeliveryFeesDtoOutputVersionsInnerRule._();

  factory AdminDeliveryFeesDtoOutputVersionsInnerRule([
    void updates(AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder b),
  ]) = _$AdminDeliveryFeesDtoOutputVersionsInnerRule;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeliveryFeesDtoOutputVersionsInnerRule>
  get serializer => _$AdminDeliveryFeesDtoOutputVersionsInnerRuleSerializer();
}

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleSerializer
    implements
        PrimitiveSerializer<AdminDeliveryFeesDtoOutputVersionsInnerRule> {
  @override
  final Iterable<Type> types = const [
    AdminDeliveryFeesDtoOutputVersionsInnerRule,
    _$AdminDeliveryFeesDtoOutputVersionsInnerRule,
  ];

  @override
  final String wireName = r'AdminDeliveryFeesDtoOutputVersionsInnerRule';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInnerRule object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInnerRule object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(
      oneOf.value,
      specifiedType: FullType(oneOf.valueType),
    )!;
  }

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRule deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [
      FullType(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf),
      FullType(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1),
    ]);
    oneOfDataSrc = serialized;
    result.oneOf =
        serializers.deserialize(oneOfDataSrc, specifiedType: targetType)
            as OneOf;
    return result.build();
  }
}

class AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'distance_bands')
  static const AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum
  distanceBands =
      _$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum_distanceBands;

  static Serializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum>
  get serializer =>
      _$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumSerializer;

  const AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum>
  get values => _$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumValues;
  static AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum valueOf(
    String name,
  ) => _$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnumValueOf(name);
}
