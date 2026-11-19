//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_delivery_fees_dto_output_versions_inner_rule_bands_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_delivery_fees_dto_output_versions_inner_rule.g.dart';

/// AdminDeliveryFeesDtoOutputVersionsInnerRule
///
/// Properties:
/// * [id]
/// * [kind]
/// * [flatFee] - The fee of a flat rule; null for distance bands.
/// * [currency]
/// * [minimumFee] - A lower fee is raised to it; null for none.
/// * [freeDeliveryFrom] - An items value from which delivery is free; null for none.
/// * [bands] - Null for a flat rule.
@BuiltValue()
abstract class AdminDeliveryFeesDtoOutputVersionsInnerRule
    implements
        Built<
          AdminDeliveryFeesDtoOutputVersionsInnerRule,
          AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum get kind;
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

  /// Null for a flat rule.
  @BuiltValueField(wireName: r'bands')
  BuiltList<AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner>? get bands;

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
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum,
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
              FullType(AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner),
            ]),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInnerRule object, {
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
    required AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum,
                    ),
                  )
                  as AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum;
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
                      FullType(
                        AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminDeliveryFeesDtoOutputVersionsInnerRuleBandsInner
                  >?;
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
  AdminDeliveryFeesDtoOutputVersionsInnerRule deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeliveryFeesDtoOutputVersionsInnerRuleBuilder();
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

class AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'flat')
  static const AdminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum flat =
      _$adminDeliveryFeesDtoOutputVersionsInnerRuleKindEnum_flat;
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
