//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_statement_dto_output_lines_inner_pickup_lines_inner.g.dart';

/// MerchantStatementDtoOutputLinesInnerPickupLinesInner
///
/// Properties:
/// * [currency]
/// * [amount] - Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
@BuiltValue()
abstract class MerchantStatementDtoOutputLinesInnerPickupLinesInner
    implements
        Built<
          MerchantStatementDtoOutputLinesInnerPickupLinesInner,
          MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// Integer minor units: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  MerchantStatementDtoOutputLinesInnerPickupLinesInner._();

  factory MerchantStatementDtoOutputLinesInnerPickupLinesInner([
    void updates(MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder b),
  ]) = _$MerchantStatementDtoOutputLinesInnerPickupLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantStatementDtoOutputLinesInnerPickupLinesInner>
  get serializer =>
      _$MerchantStatementDtoOutputLinesInnerPickupLinesInnerSerializer();
}

class _$MerchantStatementDtoOutputLinesInnerPickupLinesInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantStatementDtoOutputLinesInnerPickupLinesInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantStatementDtoOutputLinesInnerPickupLinesInner,
    _$MerchantStatementDtoOutputLinesInnerPickupLinesInner,
  ];

  @override
  final String wireName =
      r'MerchantStatementDtoOutputLinesInnerPickupLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantStatementDtoOutputLinesInnerPickupLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantStatementDtoOutputLinesInnerPickupLinesInner object, {
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
    required MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder result,
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
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantStatementDtoOutputLinesInnerPickupLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        MerchantStatementDtoOutputLinesInnerPickupLinesInnerBuilder();
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
