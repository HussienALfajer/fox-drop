//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_promo_code.g.dart';

/// The code that applies (CU §10.4); null without one or when refused.
///
/// Properties:
/// * [code]
/// * [kind]
/// * [discount] - Integer minor units (AP §8.6).
/// * [fixedAmountAboveItems] - «قيمة الكود أكبر من قيمة الأصناف، ولا يُستعاد الفرق» before confirming.
@BuiltValue()
abstract class CustomerQuoteDtoOutputPromoCode
    implements
        Built<
          CustomerQuoteDtoOutputPromoCode,
          CustomerQuoteDtoOutputPromoCodeBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'kind')
  CustomerQuoteDtoOutputPromoCodeKindEnum get kind;
  // enum kindEnum {  percentage,  fixed_amount,  free_delivery,  };

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'discount')
  String get discount;

  /// «قيمة الكود أكبر من قيمة الأصناف، ولا يُستعاد الفرق» before confirming.
  @BuiltValueField(wireName: r'fixedAmountAboveItems')
  bool get fixedAmountAboveItems;

  CustomerQuoteDtoOutputPromoCode._();

  factory CustomerQuoteDtoOutputPromoCode([
    void updates(CustomerQuoteDtoOutputPromoCodeBuilder b),
  ]) = _$CustomerQuoteDtoOutputPromoCode;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputPromoCodeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputPromoCode> get serializer =>
      _$CustomerQuoteDtoOutputPromoCodeSerializer();
}

class _$CustomerQuoteDtoOutputPromoCodeSerializer
    implements PrimitiveSerializer<CustomerQuoteDtoOutputPromoCode> {
  @override
  final Iterable<Type> types = const [
    CustomerQuoteDtoOutputPromoCode,
    _$CustomerQuoteDtoOutputPromoCode,
  ];

  @override
  final String wireName = r'CustomerQuoteDtoOutputPromoCode';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputPromoCode object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(CustomerQuoteDtoOutputPromoCodeKindEnum),
    );
    yield r'discount';
    yield serializers.serialize(
      object.discount,
      specifiedType: const FullType(String),
    );
    yield r'fixedAmountAboveItems';
    yield serializers.serialize(
      object.fixedAmountAboveItems,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputPromoCode object, {
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
    required CustomerQuoteDtoOutputPromoCodeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerQuoteDtoOutputPromoCodeKindEnum,
                    ),
                  )
                  as CustomerQuoteDtoOutputPromoCodeKindEnum;
          result.kind = valueDes;
          break;
        case r'discount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.discount = valueDes;
          break;
        case r'fixedAmountAboveItems':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.fixedAmountAboveItems = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputPromoCode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputPromoCodeBuilder();
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

class CustomerQuoteDtoOutputPromoCodeKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'percentage')
  static const CustomerQuoteDtoOutputPromoCodeKindEnum percentage =
      _$customerQuoteDtoOutputPromoCodeKindEnum_percentage;
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const CustomerQuoteDtoOutputPromoCodeKindEnum fixedAmount =
      _$customerQuoteDtoOutputPromoCodeKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'free_delivery')
  static const CustomerQuoteDtoOutputPromoCodeKindEnum freeDelivery =
      _$customerQuoteDtoOutputPromoCodeKindEnum_freeDelivery;

  static Serializer<CustomerQuoteDtoOutputPromoCodeKindEnum> get serializer =>
      _$customerQuoteDtoOutputPromoCodeKindEnumSerializer;

  const CustomerQuoteDtoOutputPromoCodeKindEnum._(String name) : super(name);

  static BuiltSet<CustomerQuoteDtoOutputPromoCodeKindEnum> get values =>
      _$customerQuoteDtoOutputPromoCodeKindEnumValues;
  static CustomerQuoteDtoOutputPromoCodeKindEnum valueOf(String name) =>
      _$customerQuoteDtoOutputPromoCodeKindEnumValueOf(name);
}
