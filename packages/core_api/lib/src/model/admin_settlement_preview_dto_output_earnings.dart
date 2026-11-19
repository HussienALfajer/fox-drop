//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settlement_preview_dto_output_earnings.g.dart';

/// + the platform owes the captain, before the instalment.
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class AdminSettlementPreviewDtoOutputEarnings
    implements
        Built<
          AdminSettlementPreviewDtoOutputEarnings,
          AdminSettlementPreviewDtoOutputEarningsBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  AdminSettlementPreviewDtoOutputEarnings._();

  factory AdminSettlementPreviewDtoOutputEarnings([
    void updates(AdminSettlementPreviewDtoOutputEarningsBuilder b),
  ]) = _$AdminSettlementPreviewDtoOutputEarnings;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettlementPreviewDtoOutputEarningsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettlementPreviewDtoOutputEarnings> get serializer =>
      _$AdminSettlementPreviewDtoOutputEarningsSerializer();
}

class _$AdminSettlementPreviewDtoOutputEarningsSerializer
    implements PrimitiveSerializer<AdminSettlementPreviewDtoOutputEarnings> {
  @override
  final Iterable<Type> types = const [
    AdminSettlementPreviewDtoOutputEarnings,
    _$AdminSettlementPreviewDtoOutputEarnings,
  ];

  @override
  final String wireName = r'AdminSettlementPreviewDtoOutputEarnings';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettlementPreviewDtoOutputEarnings object, {
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
    AdminSettlementPreviewDtoOutputEarnings object, {
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
    required AdminSettlementPreviewDtoOutputEarningsBuilder result,
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
  AdminSettlementPreviewDtoOutputEarnings deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettlementPreviewDtoOutputEarningsBuilder();
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
