//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_set_delivery_fee_dto_rule_one_of1_bands_inner.dart';
import 'package:core_api/src/model/admin_set_delivery_fee_dto_rule_one_of.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_set_delivery_fee_dto_rule_one_of1.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'admin_set_delivery_fee_dto_rule.g.dart';

/// AdminSetDeliveryFeeDtoRule
///
/// Properties:
/// * [kind]
/// * [flatFee]
/// * [currency]
/// * [minimumFee] - A lower fee is raised to it; null for none.
/// * [freeDeliveryFrom] - An items value from which delivery is free; null for none.
/// * [bands]
@BuiltValue()
abstract class AdminSetDeliveryFeeDtoRule
    implements
        Built<AdminSetDeliveryFeeDtoRule, AdminSetDeliveryFeeDtoRuleBuilder> {
  /// One Of [AdminSetDeliveryFeeDtoRuleOneOf], [AdminSetDeliveryFeeDtoRuleOneOf1]
  OneOf get oneOf;

  AdminSetDeliveryFeeDtoRule._();

  factory AdminSetDeliveryFeeDtoRule([
    void updates(AdminSetDeliveryFeeDtoRuleBuilder b),
  ]) = _$AdminSetDeliveryFeeDtoRule;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetDeliveryFeeDtoRuleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetDeliveryFeeDtoRule> get serializer =>
      _$AdminSetDeliveryFeeDtoRuleSerializer();
}

class _$AdminSetDeliveryFeeDtoRuleSerializer
    implements PrimitiveSerializer<AdminSetDeliveryFeeDtoRule> {
  @override
  final Iterable<Type> types = const [
    AdminSetDeliveryFeeDtoRule,
    _$AdminSetDeliveryFeeDtoRule,
  ];

  @override
  final String wireName = r'AdminSetDeliveryFeeDtoRule';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetDeliveryFeeDtoRule object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    AdminSetDeliveryFeeDtoRule object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(
      oneOf.value,
      specifiedType: FullType(oneOf.valueType),
    )!;
  }

  @override
  AdminSetDeliveryFeeDtoRule deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetDeliveryFeeDtoRuleBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [
      FullType(AdminSetDeliveryFeeDtoRuleOneOf),
      FullType(AdminSetDeliveryFeeDtoRuleOneOf1),
    ]);
    oneOfDataSrc = serialized;
    result.oneOf =
        serializers.deserialize(oneOfDataSrc, specifiedType: targetType)
            as OneOf;
    return result.build();
  }
}

class AdminSetDeliveryFeeDtoRuleKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'distance_bands')
  static const AdminSetDeliveryFeeDtoRuleKindEnum distanceBands =
      _$adminSetDeliveryFeeDtoRuleKindEnum_distanceBands;

  static Serializer<AdminSetDeliveryFeeDtoRuleKindEnum> get serializer =>
      _$adminSetDeliveryFeeDtoRuleKindEnumSerializer;

  const AdminSetDeliveryFeeDtoRuleKindEnum._(String name) : super(name);

  static BuiltSet<AdminSetDeliveryFeeDtoRuleKindEnum> get values =>
      _$adminSetDeliveryFeeDtoRuleKindEnumValues;
  static AdminSetDeliveryFeeDtoRuleKindEnum valueOf(String name) =>
      _$adminSetDeliveryFeeDtoRuleKindEnumValueOf(name);
}
