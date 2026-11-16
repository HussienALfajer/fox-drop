//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_available_codes_inner.g.dart';

/// CustomerQuoteDtoOutputAvailableCodesInner
///
/// Properties:
/// * [code]
/// * [kind]
/// * [percentBp] - A percentage in basis points (2000 is 20%).
/// * [amount] - Integer minor units (AP §8.6).
/// * [maxDiscount] - Integer minor units (AP §8.6).
/// * [minOrder] - Integer minor units (AP §8.6).
/// * [validTo] - «ينتهي {التاريخ}».
/// * [discount] - Integer minor units (AP §8.6).
/// * [missing] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class CustomerQuoteDtoOutputAvailableCodesInner
    implements
        Built<
          CustomerQuoteDtoOutputAvailableCodesInner,
          CustomerQuoteDtoOutputAvailableCodesInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'kind')
  CustomerQuoteDtoOutputAvailableCodesInnerKindEnum get kind;
  // enum kindEnum {  percentage,  fixed_amount,  free_delivery,  };

  /// A percentage in basis points (2000 is 20%).
  @BuiltValueField(wireName: r'percentBp')
  int? get percentBp;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String? get amount;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'maxDiscount')
  String? get maxDiscount;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'minOrder')
  String? get minOrder;

  /// «ينتهي {التاريخ}».
  @BuiltValueField(wireName: r'validTo')
  DateTime get validTo;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'discount')
  String? get discount;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'missing')
  String? get missing;

  CustomerQuoteDtoOutputAvailableCodesInner._();

  factory CustomerQuoteDtoOutputAvailableCodesInner([
    void updates(CustomerQuoteDtoOutputAvailableCodesInnerBuilder b),
  ]) = _$CustomerQuoteDtoOutputAvailableCodesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputAvailableCodesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputAvailableCodesInner> get serializer =>
      _$CustomerQuoteDtoOutputAvailableCodesInnerSerializer();
}

class _$CustomerQuoteDtoOutputAvailableCodesInnerSerializer
    implements PrimitiveSerializer<CustomerQuoteDtoOutputAvailableCodesInner> {
  @override
  final Iterable<Type> types = const [
    CustomerQuoteDtoOutputAvailableCodesInner,
    _$CustomerQuoteDtoOutputAvailableCodesInner,
  ];

  @override
  final String wireName = r'CustomerQuoteDtoOutputAvailableCodesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputAvailableCodesInner object, {
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
      specifiedType: const FullType(
        CustomerQuoteDtoOutputAvailableCodesInnerKindEnum,
      ),
    );
    yield r'percentBp';
    yield object.percentBp == null
        ? null
        : serializers.serialize(
            object.percentBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'maxDiscount';
    yield object.maxDiscount == null
        ? null
        : serializers.serialize(
            object.maxDiscount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'minOrder';
    yield object.minOrder == null
        ? null
        : serializers.serialize(
            object.minOrder,
            specifiedType: const FullType.nullable(String),
          );
    yield r'validTo';
    yield serializers.serialize(
      object.validTo,
      specifiedType: const FullType(DateTime),
    );
    yield r'discount';
    yield object.discount == null
        ? null
        : serializers.serialize(
            object.discount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'missing';
    yield object.missing == null
        ? null
        : serializers.serialize(
            object.missing,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputAvailableCodesInner object, {
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
    required CustomerQuoteDtoOutputAvailableCodesInnerBuilder result,
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
                      CustomerQuoteDtoOutputAvailableCodesInnerKindEnum,
                    ),
                  )
                  as CustomerQuoteDtoOutputAvailableCodesInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'percentBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.percentBp = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.amount = valueDes;
          break;
        case r'maxDiscount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.maxDiscount = valueDes;
          break;
        case r'minOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.minOrder = valueDes;
          break;
        case r'validTo':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.validTo = valueDes;
          break;
        case r'discount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.discount = valueDes;
          break;
        case r'missing':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.missing = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputAvailableCodesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputAvailableCodesInnerBuilder();
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

class CustomerQuoteDtoOutputAvailableCodesInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'percentage')
  static const CustomerQuoteDtoOutputAvailableCodesInnerKindEnum percentage =
      _$customerQuoteDtoOutputAvailableCodesInnerKindEnum_percentage;
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const CustomerQuoteDtoOutputAvailableCodesInnerKindEnum fixedAmount =
      _$customerQuoteDtoOutputAvailableCodesInnerKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'free_delivery')
  static const CustomerQuoteDtoOutputAvailableCodesInnerKindEnum freeDelivery =
      _$customerQuoteDtoOutputAvailableCodesInnerKindEnum_freeDelivery;

  static Serializer<CustomerQuoteDtoOutputAvailableCodesInnerKindEnum>
  get serializer =>
      _$customerQuoteDtoOutputAvailableCodesInnerKindEnumSerializer;

  const CustomerQuoteDtoOutputAvailableCodesInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<CustomerQuoteDtoOutputAvailableCodesInnerKindEnum>
  get values => _$customerQuoteDtoOutputAvailableCodesInnerKindEnumValues;
  static CustomerQuoteDtoOutputAvailableCodesInnerKindEnum valueOf(
    String name,
  ) => _$customerQuoteDtoOutputAvailableCodesInnerKindEnumValueOf(name);
}
