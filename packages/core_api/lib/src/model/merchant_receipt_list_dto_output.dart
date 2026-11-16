//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_receipt_list_dto_output_receipts_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_receipt_list_dto_output.g.dart';

/// MerchantReceiptListDtoOutput
///
/// Properties:
/// * [receipts] - Newest first.
@BuiltValue()
abstract class MerchantReceiptListDtoOutput
    implements
        Built<
          MerchantReceiptListDtoOutput,
          MerchantReceiptListDtoOutputBuilder
        > {
  /// Newest first.
  @BuiltValueField(wireName: r'receipts')
  BuiltList<MerchantReceiptListDtoOutputReceiptsInner> get receipts;

  MerchantReceiptListDtoOutput._();

  factory MerchantReceiptListDtoOutput([
    void updates(MerchantReceiptListDtoOutputBuilder b),
  ]) = _$MerchantReceiptListDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantReceiptListDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantReceiptListDtoOutput> get serializer =>
      _$MerchantReceiptListDtoOutputSerializer();
}

class _$MerchantReceiptListDtoOutputSerializer
    implements PrimitiveSerializer<MerchantReceiptListDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantReceiptListDtoOutput,
    _$MerchantReceiptListDtoOutput,
  ];

  @override
  final String wireName = r'MerchantReceiptListDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantReceiptListDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'receipts';
    yield serializers.serialize(
      object.receipts,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantReceiptListDtoOutputReceiptsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantReceiptListDtoOutput object, {
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
    required MerchantReceiptListDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'receipts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantReceiptListDtoOutputReceiptsInner),
                    ]),
                  )
                  as BuiltList<MerchantReceiptListDtoOutputReceiptsInner>;
          result.receipts.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantReceiptListDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantReceiptListDtoOutputBuilder();
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
