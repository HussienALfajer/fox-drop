//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_pickup_dispute_dto_received_lines_inner.g.dart';

/// MerchantPickupDisputeDtoReceivedLinesInner
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class MerchantPickupDisputeDtoReceivedLinesInner
    implements
        Built<
          MerchantPickupDisputeDtoReceivedLinesInner,
          MerchantPickupDisputeDtoReceivedLinesInnerBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  MerchantPickupDisputeDtoReceivedLinesInner._();

  factory MerchantPickupDisputeDtoReceivedLinesInner([
    void updates(MerchantPickupDisputeDtoReceivedLinesInnerBuilder b),
  ]) = _$MerchantPickupDisputeDtoReceivedLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPickupDisputeDtoReceivedLinesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPickupDisputeDtoReceivedLinesInner>
  get serializer => _$MerchantPickupDisputeDtoReceivedLinesInnerSerializer();
}

class _$MerchantPickupDisputeDtoReceivedLinesInnerSerializer
    implements PrimitiveSerializer<MerchantPickupDisputeDtoReceivedLinesInner> {
  @override
  final Iterable<Type> types = const [
    MerchantPickupDisputeDtoReceivedLinesInner,
    _$MerchantPickupDisputeDtoReceivedLinesInner,
  ];

  @override
  final String wireName = r'MerchantPickupDisputeDtoReceivedLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPickupDisputeDtoReceivedLinesInner object, {
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
    MerchantPickupDisputeDtoReceivedLinesInner object, {
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
    required MerchantPickupDisputeDtoReceivedLinesInnerBuilder result,
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
  MerchantPickupDisputeDtoReceivedLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPickupDisputeDtoReceivedLinesInnerBuilder();
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
