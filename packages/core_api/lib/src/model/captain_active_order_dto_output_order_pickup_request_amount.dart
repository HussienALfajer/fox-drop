//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_pickup_request_amount.g.dart';

/// The pickup payment of the request.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderPickupRequestAmount
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderPickupRequestAmount,
          CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainActiveOrderDtoOutputOrderPickupRequestAmount._();

  factory CaptainActiveOrderDtoOutputOrderPickupRequestAmount([
    void updates(CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderPickupRequestAmount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderPickupRequestAmount>
  get serializer =>
      _$CaptainActiveOrderDtoOutputOrderPickupRequestAmountSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderPickupRequestAmountSerializer
    implements
        PrimitiveSerializer<
          CaptainActiveOrderDtoOutputOrderPickupRequestAmount
        > {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderPickupRequestAmount,
    _$CaptainActiveOrderDtoOutputOrderPickupRequestAmount,
  ];

  @override
  final String wireName =
      r'CaptainActiveOrderDtoOutputOrderPickupRequestAmount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderPickupRequestAmount object, {
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
    CaptainActiveOrderDtoOutputOrderPickupRequestAmount object, {
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
    required CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder result,
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
  CaptainActiveOrderDtoOutputOrderPickupRequestAmount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderPickupRequestAmountBuilder();
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
