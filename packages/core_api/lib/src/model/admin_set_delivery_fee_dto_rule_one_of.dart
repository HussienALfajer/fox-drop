//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_delivery_fee_dto_rule_one_of.g.dart';

/// AdminSetDeliveryFeeDtoRuleOneOf
///
/// Properties:
/// * [kind]
/// * [flatFee]
/// * [currency]
/// * [minimumFee] - A lower fee is raised to it; null for none.
/// * [freeDeliveryFrom] - An items value from which delivery is free; null for none.
@BuiltValue()
abstract class AdminSetDeliveryFeeDtoRuleOneOf
    implements
        Built<
          AdminSetDeliveryFeeDtoRuleOneOf,
          AdminSetDeliveryFeeDtoRuleOneOfBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminSetDeliveryFeeDtoRuleOneOfKindEnum get kind;
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

  AdminSetDeliveryFeeDtoRuleOneOf._();

  factory AdminSetDeliveryFeeDtoRuleOneOf([
    void updates(AdminSetDeliveryFeeDtoRuleOneOfBuilder b),
  ]) = _$AdminSetDeliveryFeeDtoRuleOneOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetDeliveryFeeDtoRuleOneOfBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetDeliveryFeeDtoRuleOneOf> get serializer =>
      _$AdminSetDeliveryFeeDtoRuleOneOfSerializer();
}

class _$AdminSetDeliveryFeeDtoRuleOneOfSerializer
    implements PrimitiveSerializer<AdminSetDeliveryFeeDtoRuleOneOf> {
  @override
  final Iterable<Type> types = const [
    AdminSetDeliveryFeeDtoRuleOneOf,
    _$AdminSetDeliveryFeeDtoRuleOneOf,
  ];

  @override
  final String wireName = r'AdminSetDeliveryFeeDtoRuleOneOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetDeliveryFeeDtoRuleOneOf object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminSetDeliveryFeeDtoRuleOneOfKindEnum),
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
    AdminSetDeliveryFeeDtoRuleOneOf object, {
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
    required AdminSetDeliveryFeeDtoRuleOneOfBuilder result,
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
                      AdminSetDeliveryFeeDtoRuleOneOfKindEnum,
                    ),
                  )
                  as AdminSetDeliveryFeeDtoRuleOneOfKindEnum;
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
  AdminSetDeliveryFeeDtoRuleOneOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetDeliveryFeeDtoRuleOneOfBuilder();
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

class AdminSetDeliveryFeeDtoRuleOneOfKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'flat')
  static const AdminSetDeliveryFeeDtoRuleOneOfKindEnum flat =
      _$adminSetDeliveryFeeDtoRuleOneOfKindEnum_flat;

  static Serializer<AdminSetDeliveryFeeDtoRuleOneOfKindEnum> get serializer =>
      _$adminSetDeliveryFeeDtoRuleOneOfKindEnumSerializer;

  const AdminSetDeliveryFeeDtoRuleOneOfKindEnum._(String name) : super(name);

  static BuiltSet<AdminSetDeliveryFeeDtoRuleOneOfKindEnum> get values =>
      _$adminSetDeliveryFeeDtoRuleOneOfKindEnumValues;
  static AdminSetDeliveryFeeDtoRuleOneOfKindEnum valueOf(String name) =>
      _$adminSetDeliveryFeeDtoRuleOneOfKindEnumValueOf(name);
}
