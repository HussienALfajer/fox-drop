//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settlement_dto_output_receipts_inner_lines_inner.g.dart';

/// AdminSettlementDtoOutputReceiptsInnerLinesInner
///
/// Properties:
/// * [currency]
/// * [expected] - The custody before, + to hand in, − owed to the captain.
/// * [amount]
/// * [remaining] - What stays open after it.
@BuiltValue()
abstract class AdminSettlementDtoOutputReceiptsInnerLinesInner
    implements
        Built<
          AdminSettlementDtoOutputReceiptsInnerLinesInner,
          AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// The custody before, + to hand in, − owed to the captain.
  @BuiltValueField(wireName: r'expected')
  String get expected;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// What stays open after it.
  @BuiltValueField(wireName: r'remaining')
  String get remaining;

  AdminSettlementDtoOutputReceiptsInnerLinesInner._();

  factory AdminSettlementDtoOutputReceiptsInnerLinesInner([
    void updates(AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder b),
  ]) = _$AdminSettlementDtoOutputReceiptsInnerLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettlementDtoOutputReceiptsInnerLinesInner>
  get serializer =>
      _$AdminSettlementDtoOutputReceiptsInnerLinesInnerSerializer();
}

class _$AdminSettlementDtoOutputReceiptsInnerLinesInnerSerializer
    implements
        PrimitiveSerializer<AdminSettlementDtoOutputReceiptsInnerLinesInner> {
  @override
  final Iterable<Type> types = const [
    AdminSettlementDtoOutputReceiptsInnerLinesInner,
    _$AdminSettlementDtoOutputReceiptsInnerLinesInner,
  ];

  @override
  final String wireName = r'AdminSettlementDtoOutputReceiptsInnerLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettlementDtoOutputReceiptsInnerLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'expected';
    yield serializers.serialize(
      object.expected,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'remaining';
    yield serializers.serialize(
      object.remaining,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementDtoOutputReceiptsInnerLinesInner object, {
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
    required AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder result,
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
        case r'expected':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.expected = valueDes;
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
        case r'remaining':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.remaining = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSettlementDtoOutputReceiptsInnerLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettlementDtoOutputReceiptsInnerLinesInnerBuilder();
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
