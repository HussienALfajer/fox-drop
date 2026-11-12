//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_hand_in_receipts_dto_output_receipts_inner_conversions_inner.g.dart';

/// AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner
///
/// Properties:
/// * [from]
/// * [amount]
/// * [to]
/// * [converted]
@BuiltValue()
abstract class AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner
    implements
        Built<
          AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner,
          AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'from')
  String get from;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'to')
  String get to;

  @BuiltValueField(wireName: r'converted')
  String get converted;

  AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner._();

  factory AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner([
    void updates(
      AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder b,
    ),
  ]) = _$AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner>
  get serializer =>
      _$AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerSerializer();
}

class _$AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner,
    _$AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner,
  ];

  @override
  final String wireName =
      r'AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(String),
    );
    yield r'converted';
    yield serializers.serialize(
      object.converted,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner object, {
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
    required AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.from = valueDes;
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
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.to = valueDes;
          break;
        case r'converted':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.converted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminHandInReceiptsDtoOutputReceiptsInnerConversionsInnerBuilder();
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
