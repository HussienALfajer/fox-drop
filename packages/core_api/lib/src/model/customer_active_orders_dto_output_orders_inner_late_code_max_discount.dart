//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_late_code_max_discount.g.dart';

/// A percentage's maximum; null for the late code's without one.
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount,
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount([
    void updates(
      CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder b,
    ),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountSerializer
    implements
        PrimitiveSerializer<
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount
        > {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount,
    _$CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount,
  ];

  @override
  final String wireName =
      r'CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscountBuilder();
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
