//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_statement_list_dto_output_statements_inner_payout.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_statement_dto_output.g.dart';

/// CaptainStatementDtoOutput
///
/// Properties:
/// * [id]
/// * [captainName]
/// * [periodFrom] - The previous payout, null for the first.
/// * [createdAt]
/// * [currency] - The city's base currency.
/// * [orders]
/// * [basePay] - With the minimum top-up and the pay of orders not delivered.
/// * [distancePay] - Integer minor units (AP §8.6).
/// * [waitingPay] - Integer minor units (AP §8.6).
/// * [peakBonus] - Integer minor units (AP §8.6).
/// * [bonuses] - Integer minor units (AP §8.6).
/// * [charges] - Taken off the balance.
/// * [instalments] - Taken off the balance.
/// * [adjustments] - Integer minor units (AP §8.6).
/// * [carriedIn] - The balance the period started from.
/// * [balance] - Before the payout.
/// * [paid] - In the base.
/// * [payout]
/// * [collected] - A negative balance collected at the desk.
/// * [carriedOut] - Carried to the next week.
@BuiltValue()
abstract class CaptainStatementDtoOutput
    implements
        Built<CaptainStatementDtoOutput, CaptainStatementDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'captainName')
  String get captainName;

  /// The previous payout, null for the first.
  @BuiltValueField(wireName: r'periodFrom')
  DateTime? get periodFrom;

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  /// The city's base currency.
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'orders')
  int get orders;

  /// With the minimum top-up and the pay of orders not delivered.
  @BuiltValueField(wireName: r'basePay')
  String get basePay;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'distancePay')
  String get distancePay;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'waitingPay')
  String get waitingPay;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'peakBonus')
  String get peakBonus;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'bonuses')
  String get bonuses;

  /// Taken off the balance.
  @BuiltValueField(wireName: r'charges')
  String get charges;

  /// Taken off the balance.
  @BuiltValueField(wireName: r'instalments')
  String get instalments;

  /// Integer minor units (AP §8.6).
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
  CaptainStatementListDtoOutputStatementsInnerPayout? get payout;

  /// A negative balance collected at the desk.
  @BuiltValueField(wireName: r'collected')
  String get collected;

  /// Carried to the next week.
  @BuiltValueField(wireName: r'carriedOut')
  String get carriedOut;

  CaptainStatementDtoOutput._();

  factory CaptainStatementDtoOutput([
    void updates(CaptainStatementDtoOutputBuilder b),
  ]) = _$CaptainStatementDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainStatementDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainStatementDtoOutput> get serializer =>
      _$CaptainStatementDtoOutputSerializer();
}

class _$CaptainStatementDtoOutputSerializer
    implements PrimitiveSerializer<CaptainStatementDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainStatementDtoOutput,
    _$CaptainStatementDtoOutput,
  ];

  @override
  final String wireName = r'CaptainStatementDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainStatementDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'captainName';
    yield serializers.serialize(
      object.captainName,
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
              CaptainStatementListDtoOutputStatementsInnerPayout,
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
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainStatementDtoOutput object, {
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
    required CaptainStatementDtoOutputBuilder result,
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
        case r'captainName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainName = valueDes;
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
                      CaptainStatementListDtoOutputStatementsInnerPayout,
                    ),
                  )
                  as CaptainStatementListDtoOutputStatementsInnerPayout?;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainStatementDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainStatementDtoOutputBuilder();
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
