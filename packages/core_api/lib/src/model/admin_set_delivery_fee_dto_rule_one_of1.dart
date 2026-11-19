//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_set_delivery_fee_dto_rule_one_of1_bands_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_set_delivery_fee_dto_rule_one_of1.g.dart';

/// AdminSetDeliveryFeeDtoRuleOneOf1
///
/// Properties:
/// * [kind]
/// * [bands]
/// * [currency]
/// * [minimumFee] - A lower fee is raised to it; null for none.
/// * [freeDeliveryFrom] - An items value from which delivery is free; null for none.
@BuiltValue()
abstract class AdminSetDeliveryFeeDtoRuleOneOf1
    implements
        Built<
          AdminSetDeliveryFeeDtoRuleOneOf1,
          AdminSetDeliveryFeeDtoRuleOneOf1Builder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminSetDeliveryFeeDtoRuleOneOf1KindEnum get kind;
  // enum kindEnum {  distance_bands,  };

  @BuiltValueField(wireName: r'bands')
  BuiltList<AdminSetDeliveryFeeDtoRuleOneOf1BandsInner> get bands;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// A lower fee is raised to it; null for none.
  @BuiltValueField(wireName: r'minimumFee')
  String? get minimumFee;

  /// An items value from which delivery is free; null for none.
  @BuiltValueField(wireName: r'freeDeliveryFrom')
  String? get freeDeliveryFrom;

  AdminSetDeliveryFeeDtoRuleOneOf1._();

  factory AdminSetDeliveryFeeDtoRuleOneOf1([
    void updates(AdminSetDeliveryFeeDtoRuleOneOf1Builder b),
  ]) = _$AdminSetDeliveryFeeDtoRuleOneOf1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSetDeliveryFeeDtoRuleOneOf1Builder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSetDeliveryFeeDtoRuleOneOf1> get serializer =>
      _$AdminSetDeliveryFeeDtoRuleOneOf1Serializer();
}

class _$AdminSetDeliveryFeeDtoRuleOneOf1Serializer
    implements PrimitiveSerializer<AdminSetDeliveryFeeDtoRuleOneOf1> {
  @override
  final Iterable<Type> types = const [
    AdminSetDeliveryFeeDtoRuleOneOf1,
    _$AdminSetDeliveryFeeDtoRuleOneOf1,
  ];

  @override
  final String wireName = r'AdminSetDeliveryFeeDtoRuleOneOf1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSetDeliveryFeeDtoRuleOneOf1 object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminSetDeliveryFeeDtoRuleOneOf1KindEnum),
    );
    yield r'bands';
    yield serializers.serialize(
      object.bands,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSetDeliveryFeeDtoRuleOneOf1BandsInner),
      ]),
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
    AdminSetDeliveryFeeDtoRuleOneOf1 object, {
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
    required AdminSetDeliveryFeeDtoRuleOneOf1Builder result,
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
                      AdminSetDeliveryFeeDtoRuleOneOf1KindEnum,
                    ),
                  )
                  as AdminSetDeliveryFeeDtoRuleOneOf1KindEnum;
          result.kind = valueDes;
          break;
        case r'bands':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSetDeliveryFeeDtoRuleOneOf1BandsInner),
                    ]),
                  )
                  as BuiltList<AdminSetDeliveryFeeDtoRuleOneOf1BandsInner>;
          result.bands.replace(valueDes);
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
  AdminSetDeliveryFeeDtoRuleOneOf1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSetDeliveryFeeDtoRuleOneOf1Builder();
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

class AdminSetDeliveryFeeDtoRuleOneOf1KindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'distance_bands')
  static const AdminSetDeliveryFeeDtoRuleOneOf1KindEnum distanceBands =
      _$adminSetDeliveryFeeDtoRuleOneOf1KindEnum_distanceBands;

  static Serializer<AdminSetDeliveryFeeDtoRuleOneOf1KindEnum> get serializer =>
      _$adminSetDeliveryFeeDtoRuleOneOf1KindEnumSerializer;

  const AdminSetDeliveryFeeDtoRuleOneOf1KindEnum._(String name) : super(name);

  static BuiltSet<AdminSetDeliveryFeeDtoRuleOneOf1KindEnum> get values =>
      _$adminSetDeliveryFeeDtoRuleOneOf1KindEnumValues;
  static AdminSetDeliveryFeeDtoRuleOneOf1KindEnum valueOf(String name) =>
      _$adminSetDeliveryFeeDtoRuleOneOf1KindEnumValueOf(name);
}
