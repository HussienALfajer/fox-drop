//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_settlement_dto_output_statement_payout.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_statement_dto_output.g.dart';

/// AdminStatementDtoOutput
///
/// Properties:
/// * [id]
/// * [cityId]
/// * [captainId]
/// * [captainName]
/// * [sessionId]
/// * [cashierId]
/// * [periodFrom] - The previous statement, null for the first.
/// * [createdAt]
/// * [currency]
/// * [orders]
/// * [basePay] - With the minimum top-up and the pay of orders not delivered.
/// * [distancePay]
/// * [waitingPay]
/// * [peakBonus]
/// * [bonuses]
/// * [charges]
/// * [instalments]
/// * [adjustments]
/// * [carriedIn] - The balance the period started from.
/// * [balance] - Before the payout.
/// * [paid] - In the base.
/// * [payout]
/// * [collected]
/// * [carriedOut] - Carried to the next week.
/// * [offCycle]
/// * [reason]
/// * [receiptIds]
@BuiltValue()
abstract class AdminStatementDtoOutput
    implements Built<AdminStatementDtoOutput, AdminStatementDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'captainName')
  String get captainName;

  @BuiltValueField(wireName: r'sessionId')
  String get sessionId;

  @BuiltValueField(wireName: r'cashierId')
  String get cashierId;

  /// The previous statement, null for the first.
  @BuiltValueField(wireName: r'periodFrom')
  DateTime? get periodFrom;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  /// With the minimum top-up and the pay of orders not delivered.
  @BuiltValueField(wireName: r'basePay')
  String get basePay;

  @BuiltValueField(wireName: r'distancePay')
  String get distancePay;

  @BuiltValueField(wireName: r'waitingPay')
  String get waitingPay;

  @BuiltValueField(wireName: r'peakBonus')
  String get peakBonus;

  @BuiltValueField(wireName: r'bonuses')
  String get bonuses;

  @BuiltValueField(wireName: r'charges')
  String get charges;

  @BuiltValueField(wireName: r'instalments')
  String get instalments;

  @BuiltValueField(wireName: r'adjustments')
  String get adjustments;

  /// The balance the period started from.
  @BuiltValueField(wireName: r'carriedIn')
  String get carriedIn;

  /// Before the payout.
  @BuiltValueField(wireName: r'balance')
  String get balance;

  /// In the base.
  @BuiltValueField(wireName: r'paid')
  String get paid;

  @BuiltValueField(wireName: r'payout')
  AdminSettlementDtoOutputStatementPayout? get payout;

  @BuiltValueField(wireName: r'collected')
  String get collected;

  /// Carried to the next week.
  @BuiltValueField(wireName: r'carriedOut')
  String get carriedOut;

  @BuiltValueField(wireName: r'offCycle')
  bool get offCycle;

  @BuiltValueField(wireName: r'reason')
  String? get reason;

  @BuiltValueField(wireName: r'receiptIds')
  BuiltList<String> get receiptIds;

  AdminStatementDtoOutput._();

  factory AdminStatementDtoOutput([
    void updates(AdminStatementDtoOutputBuilder b),
  ]) = _$AdminStatementDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminStatementDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminStatementDtoOutput> get serializer =>
      _$AdminStatementDtoOutputSerializer();
}

class _$AdminStatementDtoOutputSerializer
    implements PrimitiveSerializer<AdminStatementDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminStatementDtoOutput,
    _$AdminStatementDtoOutput,
  ];

  @override
  final String wireName = r'AdminStatementDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminStatementDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'captainName';
    yield serializers.serialize(
      object.captainName,
      specifiedType: const FullType(String),
    );
    yield r'sessionId';
    yield serializers.serialize(
      object.sessionId,
      specifiedType: const FullType(String),
    );
    yield r'cashierId';
    yield serializers.serialize(
      object.cashierId,
      specifiedType: const FullType(String),
    );
    yield r'periodFrom';
    yield object.periodFrom == null
        ? null
        : serializers.serialize(
            object.periodFrom,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'basePay';
    yield serializers.serialize(
      object.basePay,
      specifiedType: const FullType(String),
    );
    yield r'distancePay';
    yield serializers.serialize(
      object.distancePay,
      specifiedType: const FullType(String),
    );
    yield r'waitingPay';
    yield serializers.serialize(
      object.waitingPay,
      specifiedType: const FullType(String),
    );
    yield r'peakBonus';
    yield serializers.serialize(
      object.peakBonus,
      specifiedType: const FullType(String),
    );
    yield r'bonuses';
    yield serializers.serialize(
      object.bonuses,
      specifiedType: const FullType(String),
    );
    yield r'charges';
    yield serializers.serialize(
      object.charges,
      specifiedType: const FullType(String),
    );
    yield r'instalments';
    yield serializers.serialize(
      object.instalments,
      specifiedType: const FullType(String),
    );
    yield r'adjustments';
    yield serializers.serialize(
      object.adjustments,
      specifiedType: const FullType(String),
    );
    yield r'carriedIn';
    yield serializers.serialize(
      object.carriedIn,
      specifiedType: const FullType(String),
    );
    yield r'balance';
    yield serializers.serialize(
      object.balance,
      specifiedType: const FullType(String),
    );
    yield r'paid';
    yield serializers.serialize(
      object.paid,
      specifiedType: const FullType(String),
    );
    yield r'payout';
    yield object.payout == null
        ? null
        : serializers.serialize(
            object.payout,
            specifiedType: const FullType.nullable(
              AdminSettlementDtoOutputStatementPayout,
            ),
          );
    yield r'collected';
    yield serializers.serialize(
      object.collected,
      specifiedType: const FullType(String),
    );
    yield r'carriedOut';
    yield serializers.serialize(
      object.carriedOut,
      specifiedType: const FullType(String),
    );
    yield r'offCycle';
    yield serializers.serialize(
      object.offCycle,
      specifiedType: const FullType(bool),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'receiptIds';
    yield serializers.serialize(
      object.receiptIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminStatementDtoOutput object, {
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
    required AdminStatementDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'captainName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainName = valueDes;
          break;
        case r'sessionId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.sessionId = valueDes;
          break;
        case r'cashierId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cashierId = valueDes;
          break;
        case r'periodFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.periodFrom = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
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
        case r'orders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.orders = valueDes;
          break;
        case r'basePay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.basePay = valueDes;
          break;
        case r'distancePay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.distancePay = valueDes;
          break;
        case r'waitingPay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.waitingPay = valueDes;
          break;
        case r'peakBonus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.peakBonus = valueDes;
          break;
        case r'bonuses':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.bonuses = valueDes;
          break;
        case r'charges':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.charges = valueDes;
          break;
        case r'instalments':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.instalments = valueDes;
          break;
        case r'adjustments':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.adjustments = valueDes;
          break;
        case r'carriedIn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.carriedIn = valueDes;
          break;
        case r'balance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.balance = valueDes;
          break;
        case r'paid':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.paid = valueDes;
          break;
        case r'payout':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminSettlementDtoOutputStatementPayout,
                    ),
                  )
                  as AdminSettlementDtoOutputStatementPayout?;
          if (valueDes == null) continue;
          result.payout.replace(valueDes);
          break;
        case r'collected':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.collected = valueDes;
          break;
        case r'carriedOut':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.carriedOut = valueDes;
          break;
        case r'offCycle':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.offCycle = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'receiptIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.receiptIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminStatementDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminStatementDtoOutputBuilder();
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
