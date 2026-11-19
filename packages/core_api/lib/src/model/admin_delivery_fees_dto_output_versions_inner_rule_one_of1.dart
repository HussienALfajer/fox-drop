//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_delivery_fees_dto_output_versions_inner_rule_one_of1_bands_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_delivery_fees_dto_output_versions_inner_rule_one_of1.g.dart';

/// AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1
///
/// Properties:
/// * [id]
/// * [kind]
/// * [bands]
/// * [currency]
/// * [minimumFee] - A lower fee is raised to it; null for none.
/// * [freeDeliveryFrom] - An items value from which delivery is free; null for none.
@BuiltValue()
abstract class AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1
    implements
        Built<
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1,
          AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'kind')
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum get kind;
  // enum kindEnum {  distance_bands,  };

  @BuiltValueField(wireName: r'bands')
  BuiltList<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner>
  get bands;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// A lower fee is raised to it; null for none.
  @BuiltValueField(wireName: r'minimumFee')
  String? get minimumFee;

  /// An items value from which delivery is free; null for none.
  @BuiltValueField(wireName: r'freeDeliveryFrom')
  String? get freeDeliveryFrom;

  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1._();

  factory AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1([
    void updates(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder b),
  ]) = _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1>
  get serializer =>
      _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Serializer();
}

class _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Serializer
    implements
        PrimitiveSerializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1> {
  @override
  final Iterable<Type> types = const [
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1,
    _$AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1,
  ];

  @override
  final String wireName = r'AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1 object, {
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
        AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum,
      ),
    );
    yield r'bands';
    yield serializers.serialize(
      object.bands,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner),
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
    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1 object, {
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
    required AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder result,
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
                      AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum,
                    ),
                  )
                  as AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum;
          result.kind = valueDes;
          break;
        case r'bands':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1BandsInner
                  >;
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
  AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1 deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1Builder();
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

class AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'distance_bands')
  static const AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum
  distanceBands =
      _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum_distanceBands;

  static Serializer<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum>
  get serializer =>
      _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnumSerializer;

  const AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum._(String name)
    : super(name);

  static BuiltSet<AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum>
  get values =>
      _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnumValues;
  static AdminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnum valueOf(
    String name,
  ) => _$adminDeliveryFeesDtoOutputVersionsInnerRuleOneOf1KindEnumValueOf(name);
}
