//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_contract_dto_output_kit_inner.dart';
import 'package:core_api/src/model/captain_contract_dto_output_contract.dart';
import 'package:core_api/src/model/captain_contract_dto_output_deposit.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_contract_dto_output.g.dart';

/// CaptainContractDtoOutput
///
/// Properties:
/// * [contract]
/// * [kit] - The items issued, with their labels as issued.
/// * [deposit]
@BuiltValue()
abstract class CaptainContractDtoOutput
    implements
        Built<CaptainContractDtoOutput, CaptainContractDtoOutputBuilder> {
  @BuiltValueField(wireName: r'contract')
  CaptainContractDtoOutputContract? get contract;

  /// The items issued, with their labels as issued.
  @BuiltValueField(wireName: r'kit')
  BuiltList<CaptainContractDtoOutputKitInner> get kit;

  @BuiltValueField(wireName: r'deposit')
  CaptainContractDtoOutputDeposit get deposit;

  CaptainContractDtoOutput._();

  factory CaptainContractDtoOutput([
    void updates(CaptainContractDtoOutputBuilder b),
  ]) = _$CaptainContractDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainContractDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainContractDtoOutput> get serializer =>
      _$CaptainContractDtoOutputSerializer();
}

class _$CaptainContractDtoOutputSerializer
    implements PrimitiveSerializer<CaptainContractDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainContractDtoOutput,
    _$CaptainContractDtoOutput,
  ];

  @override
  final String wireName = r'CaptainContractDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainContractDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'contract';
    yield object.contract == null
        ? null
        : serializers.serialize(
            object.contract,
            specifiedType: const FullType.nullable(
              CaptainContractDtoOutputContract,
            ),
          );
    yield r'kit';
    yield serializers.serialize(
      object.kit,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainContractDtoOutputKitInner),
      ]),
    );
    yield r'deposit';
    yield serializers.serialize(
      object.deposit,
      specifiedType: const FullType(CaptainContractDtoOutputDeposit),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainContractDtoOutput object, {
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
    required CaptainContractDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'contract':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainContractDtoOutputContract,
                    ),
                  )
                  as CaptainContractDtoOutputContract?;
          if (valueDes == null) continue;
          result.contract.replace(valueDes);
          break;
        case r'kit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainContractDtoOutputKitInner),
                    ]),
                  )
                  as BuiltList<CaptainContractDtoOutputKitInner>;
          result.kit.replace(valueDes);
          break;
        case r'deposit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainContractDtoOutputDeposit,
                    ),
                  )
                  as CaptainContractDtoOutputDeposit;
          result.deposit.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainContractDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainContractDtoOutputBuilder();
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
