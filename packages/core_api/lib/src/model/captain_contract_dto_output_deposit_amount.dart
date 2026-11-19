//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_contract_dto_output_deposit_amount.g.dart';

/// Deducted each Thursday until paid; null for none.
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class CaptainContractDtoOutputDepositAmount
    implements
        Built<
          CaptainContractDtoOutputDepositAmount,
          CaptainContractDtoOutputDepositAmountBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainContractDtoOutputDepositAmount._();

  factory CaptainContractDtoOutputDepositAmount([
    void updates(CaptainContractDtoOutputDepositAmountBuilder b),
  ]) = _$CaptainContractDtoOutputDepositAmount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainContractDtoOutputDepositAmountBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainContractDtoOutputDepositAmount> get serializer =>
      _$CaptainContractDtoOutputDepositAmountSerializer();
}

class _$CaptainContractDtoOutputDepositAmountSerializer
    implements PrimitiveSerializer<CaptainContractDtoOutputDepositAmount> {
  @override
  final Iterable<Type> types = const [
    CaptainContractDtoOutputDepositAmount,
    _$CaptainContractDtoOutputDepositAmount,
  ];

  @override
  final String wireName = r'CaptainContractDtoOutputDepositAmount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainContractDtoOutputDepositAmount object, {
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
    CaptainContractDtoOutputDepositAmount object, {
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
    required CaptainContractDtoOutputDepositAmountBuilder result,
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
  CaptainContractDtoOutputDepositAmount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainContractDtoOutputDepositAmountBuilder();
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
