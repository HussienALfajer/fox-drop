//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_delivery_fees_dto_output_versions_inner_rule_one_of.g.dart';

/// AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf
///
/// Properties:
/// * [id]
/// * [kind]
/// * [flatFee]
/// * [currency]
/// * [minimumFee] - A lower fee is raised to it; null for none.
/// * [freeDeliveryFrom] - An items value from which delivery is free; null for none.
@BuiltValue()
abstract class AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf
    implements
        Built<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf,
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum get kind;
  // enum kindEnum {  flat,  };

  @BuiltValueField(wireName: r'flatFee')
  String get flatFee;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// A lower fee is raised to it; null for none.
  @BuiltValueField(wireName: r'minimumFee')
  String? get minimumFee;

  /// An items value from which delivery is free; null for none.
  @BuiltValueField(wireName: r'freeDeliveryFrom')
  String? get freeDeliveryFrom;

  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf._();

  factory AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf([
    void updates(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder b),
  ]) = _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf>
  get serializer =>
      _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfSerializer();
}

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfSerializer
    implements
        PrimitiveSerializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf> {
  @override
  final Iterable<Type> types = const [
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf,
    _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf,
  ];

  @override
  final String wireName = r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf object, {
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
        AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum,
      ),
    );
    yield r'flatFee';
    yield serializers.serialize(
      object.flatFee,
      specifiedType: const FullType(String),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf object, {
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
    required AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder result,
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
                      AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum,
                    ),
                  )
                  as AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum;
          result.kind = valueDes;
          break;
        case r'flatFee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfBuilder();
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

class AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'flat')
  static const AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum flat =
      _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum_flat;

  static Serializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum>
  get serializer =>
      _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnumSerializer;

  const AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum>
  get values =>
      _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnumValues;
  static AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnum valueOf(
    String name,
  ) => _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOfKindEnumValueOf(name);
}
