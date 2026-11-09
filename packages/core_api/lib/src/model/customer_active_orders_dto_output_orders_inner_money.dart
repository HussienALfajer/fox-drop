//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_money.g.dart';

/// CustomerActiveOrdersDtoOutputOrdersInnerMoney
///
/// Properties:
/// * [itemsValue] - Integer minor units (AP §8.6).
/// * [deliveryFee] - Integer minor units (AP §8.6).
/// * [deliveryFree] 
/// * [discount] - Integer minor units (AP §8.6).
/// * [rounding] - Integer minor units (AP §8.6).
/// * [total] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerMoney implements Built<CustomerActiveOrdersDtoOutputOrdersInnerMoney, CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder> {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'deliveryFee')
  String get deliveryFee;

  @BuiltValueField(wireName: r'deliveryFree')
  bool get deliveryFree;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'discount')
  String get discount;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'rounding')
  String get rounding;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'total')
  String get total;

  CustomerActiveOrdersDtoOutputOrdersInnerMoney._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerMoney([void updates(CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder b)]) = _$CustomerActiveOrdersDtoOutputOrdersInnerMoney;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerMoney> get serializer => _$CustomerActiveOrdersDtoOutputOrdersInnerMoneySerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerMoneySerializer implements PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInnerMoney> {
  @override
  final Iterable<Type> types = const [CustomerActiveOrdersDtoOutputOrdersInnerMoney, _$CustomerActiveOrdersDtoOutputOrdersInnerMoney];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerMoney';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerMoney object, {
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
    CustomerActiveOrdersDtoOutputOrdersInnerMoney object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder result,
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
  CustomerActiveOrdersDtoOutputOrdersInnerMoney deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerMoneyBuilder();
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


