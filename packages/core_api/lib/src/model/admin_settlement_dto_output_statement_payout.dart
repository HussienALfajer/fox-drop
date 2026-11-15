//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settlement_dto_output_statement_payout.g.dart';

/// AdminSettlementDtoOutputStatementPayout
///
/// Properties:
/// * [currency]
/// * [amount]
@BuiltValue()
abstract class AdminSettlementDtoOutputStatementPayout
    implements
        Built<
          AdminSettlementDtoOutputStatementPayout,
          AdminSettlementDtoOutputStatementPayoutBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  AdminSettlementDtoOutputStatementPayout._();

  factory AdminSettlementDtoOutputStatementPayout([
    void updates(AdminSettlementDtoOutputStatementPayoutBuilder b),
  ]) = _$AdminSettlementDtoOutputStatementPayout;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettlementDtoOutputStatementPayoutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettlementDtoOutputStatementPayout> get serializer =>
      _$AdminSettlementDtoOutputStatementPayoutSerializer();
}

class _$AdminSettlementDtoOutputStatementPayoutSerializer
    implements PrimitiveSerializer<AdminSettlementDtoOutputStatementPayout> {
  @override
  final Iterable<Type> types = const [
    AdminSettlementDtoOutputStatementPayout,
    _$AdminSettlementDtoOutputStatementPayout,
  ];

  @override
  final String wireName = r'AdminSettlementDtoOutputStatementPayout';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettlementDtoOutputStatementPayout object, {
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
    AdminSettlementDtoOutputStatementPayout object, {
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
    required AdminSettlementDtoOutputStatementPayoutBuilder result,
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
  AdminSettlementDtoOutputStatementPayout deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettlementDtoOutputStatementPayoutBuilder();
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
