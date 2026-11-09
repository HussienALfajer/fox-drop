//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_money.g.dart';

/// CustomerQuoteDtoOutputMoney
///
/// Properties:
/// * [itemsValue] - «قيمة الأصناف».
/// * [deliveryFee] - «رسوم التوصيل».
/// * [deliveryFree] - «مجاني».
/// * [discount] - «الخصم»; 0 until codes arrive.
/// * [rounding] - «تقريب», shown only when not 0.
/// * [total] - «المجموع».
@BuiltValue()
abstract class CustomerQuoteDtoOutputMoney implements Built<CustomerQuoteDtoOutputMoney, CustomerQuoteDtoOutputMoneyBuilder> {
  /// «قيمة الأصناف».
  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  /// «رسوم التوصيل».
  @BuiltValueField(wireName: r'deliveryFee')
  String get deliveryFee;

  /// «مجاني».
  @BuiltValueField(wireName: r'deliveryFree')
  bool get deliveryFree;

  /// «الخصم»; 0 until codes arrive.
  @BuiltValueField(wireName: r'discount')
  String get discount;

  /// «تقريب», shown only when not 0.
  @BuiltValueField(wireName: r'rounding')
  String get rounding;

  /// «المجموع».
  @BuiltValueField(wireName: r'total')
  String get total;

  CustomerQuoteDtoOutputMoney._();

  factory CustomerQuoteDtoOutputMoney([void updates(CustomerQuoteDtoOutputMoneyBuilder b)]) = _$CustomerQuoteDtoOutputMoney;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputMoneyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputMoney> get serializer => _$CustomerQuoteDtoOutputMoneySerializer();
}

class _$CustomerQuoteDtoOutputMoneySerializer implements PrimitiveSerializer<CustomerQuoteDtoOutputMoney> {
  @override
  final Iterable<Type> types = const [CustomerQuoteDtoOutputMoney, _$CustomerQuoteDtoOutputMoney];

  @override
  final String wireName = r'CustomerQuoteDtoOutputMoney';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputMoney object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'itemsValue';
    yield serializers.serialize(
      object.itemsValue,
      specifiedType: const FullType(String),
    );
    yield r'deliveryFee';
    yield serializers.serialize(
      object.deliveryFee,
      specifiedType: const FullType(String),
    );
    yield r'deliveryFree';
    yield serializers.serialize(
      object.deliveryFree,
      specifiedType: const FullType(bool),
    );
    yield r'discount';
    yield serializers.serialize(
      object.discount,
      specifiedType: const FullType(String),
    );
    yield r'rounding';
    yield serializers.serialize(
      object.rounding,
      specifiedType: const FullType(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputMoney object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerQuoteDtoOutputMoneyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'itemsValue':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.itemsValue = valueDes;
          break;
        case r'deliveryFee':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.deliveryFee = valueDes;
          break;
        case r'deliveryFree':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.deliveryFree = valueDes;
          break;
        case r'discount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.discount = valueDes;
          break;
        case r'rounding':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.rounding = valueDes;
          break;
        case r'total':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.total = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputMoney deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputMoneyBuilder();
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


