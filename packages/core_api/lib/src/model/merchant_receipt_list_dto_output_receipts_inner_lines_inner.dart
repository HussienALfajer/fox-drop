//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_receipt_list_dto_output_receipts_inner_lines_inner.g.dart';

/// MerchantReceiptListDtoOutputReceiptsInnerLinesInner
///
/// Properties:
/// * [currency]
/// * [amount] - Integer minor units (AP §8.6).
/// * [base_] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class MerchantReceiptListDtoOutputReceiptsInnerLinesInner
    implements
        Built<
          MerchantReceiptListDtoOutputReceiptsInnerLinesInner,
          MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'base')
  String get base_;

  MerchantReceiptListDtoOutputReceiptsInnerLinesInner._();

  factory MerchantReceiptListDtoOutputReceiptsInnerLinesInner([
    void updates(MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder b),
  ]) = _$MerchantReceiptListDtoOutputReceiptsInnerLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantReceiptListDtoOutputReceiptsInnerLinesInner>
  get serializer =>
      _$MerchantReceiptListDtoOutputReceiptsInnerLinesInnerSerializer();
}

class _$MerchantReceiptListDtoOutputReceiptsInnerLinesInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantReceiptListDtoOutputReceiptsInnerLinesInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantReceiptListDtoOutputReceiptsInnerLinesInner,
    _$MerchantReceiptListDtoOutputReceiptsInnerLinesInner,
  ];

  @override
  final String wireName =
      r'MerchantReceiptListDtoOutputReceiptsInnerLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantReceiptListDtoOutputReceiptsInnerLinesInner object, {
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
    yield r'base';
    yield serializers.serialize(
      object.base_,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantReceiptListDtoOutputReceiptsInnerLinesInner object, {
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
    required MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder result,
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
        case r'base':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.base_ = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantReceiptListDtoOutputReceiptsInnerLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantReceiptListDtoOutputReceiptsInnerLinesInnerBuilder();
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
