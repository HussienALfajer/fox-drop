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

part 'admin_set_restaurant_delivery_fee_dto_rule.g.dart';

/// Null returns the restaurant to the city's rule.
///
/// Properties:
/// * [kind]
/// * [flatFee]
/// * [currency]
/// * [minimumFee] - A lower fee is raised to it; null for none.
/// * [freeDeliveryFrom] - An items value from which delivery is free; null for none.
/// * [bands]
@BuiltValue()
abstract class AdminSetRestaurantDeliveryFeeDtoRule
    implements
        Built<
          AdminSetRestaurantDeliveryFeeDtoRule,
          AdminSetRestaurantDeliveryFeeDtoRuleBuilder
        > {
  /// One Of [AdminSetDeliveryFeeDtoRuleOneOf], [AdminSetDeliveryFeeDtoRuleOneOf1]
  OneOf get oneOf;

  AdminSetRestaurantDeliveryFeeDtoRule._();

  factory AdminSetRestaurantDeliveryFeeDtoRule([
    void updates(AdminSetRestaurantDeliveryFeeDtoRuleBuilder b),
  ]) = _$AdminSetRestaurantDeliveryFeeDtoRule;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetRestaurantDeliveryFeeDtoRuleBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetRestaurantDeliveryFeeDtoRule> get serializer =>
      _$AdminSetRestaurantDeliveryFeeDtoRuleSerializer();
}

class _$AdminSetRestaurantDeliveryFeeDtoRuleSerializer
    implements PrimitiveSerializer<AdminSetRestaurantDeliveryFeeDtoRule> {
  @override
  final Iterable<Type> types = const [
    AdminSetRestaurantDeliveryFeeDtoRule,
    _$AdminSetRestaurantDeliveryFeeDtoRule,
  ];

  @override
  final String wireName = r'AdminSetRestaurantDeliveryFeeDtoRule';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetRestaurantDeliveryFeeDtoRule object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    AdminSetRestaurantDeliveryFeeDtoRule object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(
      oneOf.value,
      specifiedType: FullType(oneOf.valueType),
    )!;
  }

  @override
  AdminSetRestaurantDeliveryFeeDtoRule deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetRestaurantDeliveryFeeDtoRuleBuilder();
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

class AdminSetRestaurantDeliveryFeeDtoRuleKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'distance_bands')
  static const AdminSetRestaurantDeliveryFeeDtoRuleKindEnum distanceBands =
      _$adminSetRestaurantDeliveryFeeDtoRuleKindEnum_distanceBands;

  static Serializer<AdminSetRestaurantDeliveryFeeDtoRuleKindEnum>
  get serializer => _$adminSetRestaurantDeliveryFeeDtoRuleKindEnumSerializer;

  const AdminSetRestaurantDeliveryFeeDtoRuleKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminSetRestaurantDeliveryFeeDtoRuleKindEnum> get values =>
      _$adminSetRestaurantDeliveryFeeDtoRuleKindEnumValues;
  static AdminSetRestaurantDeliveryFeeDtoRuleKindEnum valueOf(String name) =>
      _$adminSetRestaurantDeliveryFeeDtoRuleKindEnumValueOf(name);
}
