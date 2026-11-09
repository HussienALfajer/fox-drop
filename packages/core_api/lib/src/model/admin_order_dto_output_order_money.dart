//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_money.g.dart';

/// AdminOrderDtoOutputOrderMoney
///
/// Properties:
/// * [currency]
/// * [itemsValue] - Integer minor units (AP §8.6).
/// * [deliveryFee] - Integer minor units (AP §8.6).
/// * [discount] - Integer minor units (AP §8.6).
/// * [rounding]
/// * [total] - Integer minor units (AP §8.6).
/// * [pickupPayment] - Paid by the captain at pickup (D26: the items value).
@BuiltValue()
abstract class AdminOrderDtoOutputOrderMoney
    implements
        Built<
          AdminOrderDtoOutputOrderMoney,
          AdminOrderDtoOutputOrderMoneyBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'itemsValue')
  String get itemsValue;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'deliveryFee')
  String get deliveryFee;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'discount')
  String get discount;

  @BuiltValueField(wireName: r'rounding')
  String get rounding;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'total')
  String get total;

  /// Paid by the captain at pickup (D26: the items value).
  @BuiltValueField(wireName: r'pickupPayment')
  String get pickupPayment;

  AdminOrderDtoOutputOrderMoney._();

  factory AdminOrderDtoOutputOrderMoney([
    void updates(AdminOrderDtoOutputOrderMoneyBuilder b),
  ]) = _$AdminOrderDtoOutputOrderMoney;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderMoneyBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderMoney> get serializer =>
      _$AdminOrderDtoOutputOrderMoneySerializer();
}

class _$AdminOrderDtoOutputOrderMoneySerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderMoney> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderMoney,
    _$AdminOrderDtoOutputOrderMoney,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderMoney';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderMoney object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
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
    yield r'pickupPayment';
    yield serializers.serialize(
      object.pickupPayment,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderMoney object, {
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
    required AdminOrderDtoOutputOrderMoneyBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'itemsValue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemsValue = valueDes;
          break;
        case r'deliveryFee':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.deliveryFee = valueDes;
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
        case r'rounding':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.rounding = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.total = valueDes;
          break;
        case r'pickupPayment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.pickupPayment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderMoney deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderMoneyBuilder();
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
