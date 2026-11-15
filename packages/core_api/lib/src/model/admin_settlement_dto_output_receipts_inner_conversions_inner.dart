//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settlement_dto_output_receipts_inner_conversions_inner.g.dart';

/// AdminSettlementDtoOutputReceiptsInnerConversionsInner
///
/// Properties:
/// * [from]
/// * [amount]
/// * [to]
/// * [converted]
@BuiltValue()
abstract class AdminSettlementDtoOutputReceiptsInnerConversionsInner
    implements
        Built<
          AdminSettlementDtoOutputReceiptsInnerConversionsInner,
          AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'from')
  String get from;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'to')
  String get to;

  @BuiltValueField(wireName: r'converted')
  String get converted;

  AdminSettlementDtoOutputReceiptsInnerConversionsInner._();

  factory AdminSettlementDtoOutputReceiptsInnerConversionsInner([
    void updates(
      AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder b,
    ),
  ]) = _$AdminSettlementDtoOutputReceiptsInnerConversionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettlementDtoOutputReceiptsInnerConversionsInner>
  get serializer =>
      _$AdminSettlementDtoOutputReceiptsInnerConversionsInnerSerializer();
}

class _$AdminSettlementDtoOutputReceiptsInnerConversionsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminSettlementDtoOutputReceiptsInnerConversionsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminSettlementDtoOutputReceiptsInnerConversionsInner,
    _$AdminSettlementDtoOutputReceiptsInnerConversionsInner,
  ];

  @override
  final String wireName =
      r'AdminSettlementDtoOutputReceiptsInnerConversionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettlementDtoOutputReceiptsInnerConversionsInner object, {
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
    AdminSettlementDtoOutputReceiptsInnerConversionsInner object, {
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
    required AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder
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
  AdminSettlementDtoOutputReceiptsInnerConversionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminSettlementDtoOutputReceiptsInnerConversionsInnerBuilder();
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
