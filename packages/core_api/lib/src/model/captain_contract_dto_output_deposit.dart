//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_contract_dto_output_deposit_amount.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_contract_dto_output_deposit.g.dart';

/// CaptainContractDtoOutputDeposit
///
/// Properties:
/// * [amount]
/// * [paid] - Minor units in the city's base.
/// * [instalment]
@BuiltValue()
abstract class CaptainContractDtoOutputDeposit
    implements
        Built<
          CaptainContractDtoOutputDeposit,
          CaptainContractDtoOutputDepositBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  CaptainContractDtoOutputDepositAmount? get amount;

  /// Minor units in the city's base.
  @BuiltValueField(wireName: r'paid')
  String get paid;

  @BuiltValueField(wireName: r'instalment')
  CaptainContractDtoOutputDepositAmount? get instalment;

  CaptainContractDtoOutputDeposit._();

  factory CaptainContractDtoOutputDeposit([
    void updates(CaptainContractDtoOutputDepositBuilder b),
  ]) = _$CaptainContractDtoOutputDeposit;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainContractDtoOutputDepositBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainContractDtoOutputDeposit> get serializer =>
      _$CaptainContractDtoOutputDepositSerializer();
}

class _$CaptainContractDtoOutputDepositSerializer
    implements PrimitiveSerializer<CaptainContractDtoOutputDeposit> {
  @override
  final Iterable<Type> types = const [
    CaptainContractDtoOutputDeposit,
    _$CaptainContractDtoOutputDeposit,
  ];

  @override
  final String wireName = r'CaptainContractDtoOutputDeposit';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainContractDtoOutputDeposit object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(
              CaptainContractDtoOutputDepositAmount,
            ),
          );
    yield r'paid';
    yield serializers.serialize(
      object.paid,
      specifiedType: const FullType(String),
    );
    yield r'instalment';
    yield object.instalment == null
        ? null
        : serializers.serialize(
            object.instalment,
            specifiedType: const FullType.nullable(
              CaptainContractDtoOutputDepositAmount,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainContractDtoOutputDeposit object, {
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
    required CaptainContractDtoOutputDepositBuilder result,
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
                    specifiedType: const FullType.nullable(
                      CaptainContractDtoOutputDepositAmount,
                    ),
                  )
                  as CaptainContractDtoOutputDepositAmount?;
          if (valueDes == null) continue;
          result.amount.replace(valueDes);
          break;
        case r'paid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.paid = valueDes;
          break;
        case r'instalment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainContractDtoOutputDepositAmount,
                    ),
                  )
                  as CaptainContractDtoOutputDepositAmount?;
          if (valueDes == null) continue;
          result.instalment.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainContractDtoOutputDeposit deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainContractDtoOutputDepositBuilder();
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
