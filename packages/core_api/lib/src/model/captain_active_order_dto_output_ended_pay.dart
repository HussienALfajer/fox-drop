//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_ended_pay.g.dart';

/// The pay the order still brings (CA §9.12).
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputEndedPay
    implements
        Built<
          CaptainActiveOrderDtoOutputEndedPay,
          CaptainActiveOrderDtoOutputEndedPayBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainActiveOrderDtoOutputEndedPay._();

  factory CaptainActiveOrderDtoOutputEndedPay([
    void updates(CaptainActiveOrderDtoOutputEndedPayBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputEndedPay;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainActiveOrderDtoOutputEndedPayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputEndedPay> get serializer =>
      _$CaptainActiveOrderDtoOutputEndedPaySerializer();
}

class _$CaptainActiveOrderDtoOutputEndedPaySerializer
    implements PrimitiveSerializer<CaptainActiveOrderDtoOutputEndedPay> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputEndedPay,
    _$CaptainActiveOrderDtoOutputEndedPay,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputEndedPay';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputEndedPay object, {
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
    CaptainActiveOrderDtoOutputEndedPay object, {
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
    required CaptainActiveOrderDtoOutputEndedPayBuilder result,
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
  CaptainActiveOrderDtoOutputEndedPay deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputEndedPayBuilder();
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
