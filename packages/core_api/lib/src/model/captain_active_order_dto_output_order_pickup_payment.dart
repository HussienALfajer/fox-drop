//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_pickup_payment.g.dart';

/// «تدفع للمطعم» (D26: the items value).
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency] 
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderPickupPayment implements Built<CaptainActiveOrderDtoOutputOrderPickupPayment, CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder> {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainActiveOrderDtoOutputOrderPickupPayment._();

  factory CaptainActiveOrderDtoOutputOrderPickupPayment([void updates(CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder b)]) = _$CaptainActiveOrderDtoOutputOrderPickupPayment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderPickupPayment> get serializer => _$CaptainActiveOrderDtoOutputOrderPickupPaymentSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderPickupPaymentSerializer implements PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderPickupPayment> {
  @override
  final Iterable<Type> types = const [CaptainActiveOrderDtoOutputOrderPickupPayment, _$CaptainActiveOrderDtoOutputOrderPickupPayment];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderPickupPayment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderPickupPayment object, {
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
    CaptainActiveOrderDtoOutputOrderPickupPayment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  CaptainActiveOrderDtoOutputOrderPickupPayment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderPickupPaymentBuilder();
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


