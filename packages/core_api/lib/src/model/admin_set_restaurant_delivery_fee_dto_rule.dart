//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_set_delivery_fee_dto_rule_bands_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_restaurant_delivery_fee_dto_rule.g.dart';

/// Null returns the restaurant to the city's rule.
///
/// Properties:
/// * [kind]
/// * [flatFee] - The fee of a flat rule; null for distance bands.
/// * [currency]
/// * [minimumFee] - A lower fee is raised to it; null for none.
/// * [freeDeliveryFrom] - An items value from which delivery is free; null for none.
/// * [bands] - The bands in order, the last without an edge; null for a flat rule.
@BuiltValue()
abstract class AdminSetRestaurantDeliveryFeeDtoRule
    implements
        Built<
          AdminSetRestaurantDeliveryFeeDtoRule,
          AdminSetRestaurantDeliveryFeeDtoRuleBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminSetRestaurantDeliveryFeeDtoRuleKindEnum get kind;
  // enum kindEnum {  flat,  distance_bands,  };

  /// The fee of a flat rule; null for distance bands.
  @BuiltValueField(wireName: r'flatFee')
  String? get flatFee;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// A lower fee is raised to it; null for none.
  @BuiltValueField(wireName: r'minimumFee')
  String? get minimumFee;

  /// An items value from which delivery is free; null for none.
  @BuiltValueField(wireName: r'freeDeliveryFrom')
  String? get freeDeliveryFrom;

  /// The bands in order, the last without an edge; null for a flat rule.
  @BuiltValueField(wireName: r'bands')
  BuiltList<AdminSetDeliveryFeeDtoRuleBandsInner>? get bands;

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
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminSetRestaurantDeliveryFeeDtoRuleKindEnum,
      ),
    );
    yield r'flatFee';
    yield object.flatFee == null
        ? null
        : serializers.serialize(
            object.flatFee,
            specifiedType: const FullType.nullable(String),
          );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'minimumFee';
    yield object.minimumFee == null
        ? null
        : serializers.serialize(
            object.minimumFee,
            specifiedType: const FullType.nullable(String),
          );
    yield r'freeDeliveryFrom';
    yield object.freeDeliveryFrom == null
        ? null
        : serializers.serialize(
            object.freeDeliveryFrom,
            specifiedType: const FullType.nullable(String),
          );
    yield r'bands';
    yield object.bands == null
        ? null
        : serializers.serialize(
            object.bands,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(AdminSetDeliveryFeeDtoRuleBandsInner),
            ]),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSetRestaurantDeliveryFeeDtoRule object, {
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
    required AdminSetRestaurantDeliveryFeeDtoRuleBuilder result,
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
                      AdminSetRestaurantDeliveryFeeDtoRuleKindEnum,
                    ),
                  )
                  as AdminSetRestaurantDeliveryFeeDtoRuleKindEnum;
          result.kind = valueDes;
          break;
        case r'flatFee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.flatFee = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'minimumFee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.minimumFee = valueDes;
          break;
        case r'freeDeliveryFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.freeDeliveryFrom = valueDes;
          break;
        case r'bands':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(AdminSetDeliveryFeeDtoRuleBandsInner),
                    ]),
                  )
                  as BuiltList<AdminSetDeliveryFeeDtoRuleBandsInner>?;
          if (valueDes == null) continue;
          result.bands.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSetRestaurantDeliveryFeeDtoRule deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetRestaurantDeliveryFeeDtoRuleBuilder();
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

class AdminSetRestaurantDeliveryFeeDtoRuleKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'flat')
  static const AdminSetRestaurantDeliveryFeeDtoRuleKindEnum flat =
      _$adminSetRestaurantDeliveryFeeDtoRuleKindEnum_flat;
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
