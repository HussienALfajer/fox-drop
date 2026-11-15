//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_earnings_dto_output_week.dart';
import 'package:core_api/src/model/captain_earnings_dto_output_orders_inner.dart';
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_earnings_dto_output_today.dart';
import 'package:core_api/src/model/captain_earnings_dto_output_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_earnings_dto_output.g.dart';

/// CaptainEarningsDtoOutput
///
/// Properties:
/// * [currency] - The city's base currency.
/// * [today]
/// * [week]
/// * [orders] - This week's orders, newest first.
/// * [lines] - This week's bonuses, charges, instalments, payouts and corrections, newest first.
/// * [balance] - «رصيدك المستحق»: + the platform owes the captain, − carried or collected by the policy.
/// * [payoutWeekday]
/// * [nextPayout] - «موعد القبض»: today on a payout day, on the city clock.
/// * [negativePolicy]
@BuiltValue()
abstract class CaptainEarningsDtoOutput
    implements
        Built<CaptainEarningsDtoOutput, CaptainEarningsDtoOutputBuilder> {
  /// The city's base currency.
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'today')
  CaptainEarningsDtoOutputToday get today;

  @BuiltValueField(wireName: r'week')
  CaptainEarningsDtoOutputWeek get week;

  /// This week's orders, newest first.
  @BuiltValueField(wireName: r'orders')
  BuiltList<CaptainEarningsDtoOutputOrdersInner> get orders;

  /// This week's bonuses, charges, instalments, payouts and corrections, newest first.
  @BuiltValueField(wireName: r'lines')
  BuiltList<CaptainEarningsDtoOutputLinesInner> get lines;

  /// «رصيدك المستحق»: + the platform owes the captain, − carried or collected by the policy.
  @BuiltValueField(wireName: r'balance')
  String get balance;

  @BuiltValueField(wireName: r'payoutWeekday')
  CaptainEarningsDtoOutputPayoutWeekdayEnum get payoutWeekday;
  // enum payoutWeekdayEnum {  saturday,  sunday,  monday,  tuesday,  wednesday,  thursday,  friday,  };

  /// «موعد القبض»: today on a payout day, on the city clock.
  @BuiltValueField(wireName: r'nextPayout')
  Date get nextPayout;

  @BuiltValueField(wireName: r'negativePolicy')
  CaptainEarningsDtoOutputNegativePolicyEnum get negativePolicy;
  // enum negativePolicyEnum {  carry_forward,  collect_at_desk,  };

  CaptainEarningsDtoOutput._();

  factory CaptainEarningsDtoOutput([
    void updates(CaptainEarningsDtoOutputBuilder b),
  ]) = _$CaptainEarningsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainEarningsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainEarningsDtoOutput> get serializer =>
      _$CaptainEarningsDtoOutputSerializer();
}

class _$CaptainEarningsDtoOutputSerializer
    implements PrimitiveSerializer<CaptainEarningsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainEarningsDtoOutput,
    _$CaptainEarningsDtoOutput,
  ];

  @override
  final String wireName = r'CaptainEarningsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainEarningsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'today';
    yield serializers.serialize(
      object.today,
      specifiedType: const FullType(CaptainEarningsDtoOutputToday),
    );
    yield r'week';
    yield serializers.serialize(
      object.week,
      specifiedType: const FullType(CaptainEarningsDtoOutputWeek),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainEarningsDtoOutputOrdersInner),
      ]),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainEarningsDtoOutputLinesInner),
      ]),
    );
    yield r'balance';
    yield serializers.serialize(
      object.balance,
      specifiedType: const FullType(String),
    );
    yield r'payoutWeekday';
    yield serializers.serialize(
      object.payoutWeekday,
      specifiedType: const FullType(CaptainEarningsDtoOutputPayoutWeekdayEnum),
    );
    yield r'nextPayout';
    yield serializers.serialize(
      object.nextPayout,
      specifiedType: const FullType(Date),
    );
    yield r'negativePolicy';
    yield serializers.serialize(
      object.negativePolicy,
      specifiedType: const FullType(CaptainEarningsDtoOutputNegativePolicyEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainEarningsDtoOutput object, {
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
    required CaptainEarningsDtoOutputBuilder result,
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
        case r'today':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainEarningsDtoOutputToday,
                    ),
                  )
                  as CaptainEarningsDtoOutputToday;
          result.today.replace(valueDes);
          break;
        case r'week':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainEarningsDtoOutputWeek),
                  )
                  as CaptainEarningsDtoOutputWeek;
          result.week.replace(valueDes);
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainEarningsDtoOutputOrdersInner),
                    ]),
                  )
                  as BuiltList<CaptainEarningsDtoOutputOrdersInner>;
          result.orders.replace(valueDes);
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainEarningsDtoOutputLinesInner),
                    ]),
                  )
                  as BuiltList<CaptainEarningsDtoOutputLinesInner>;
          result.lines.replace(valueDes);
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
        case r'payoutWeekday':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainEarningsDtoOutputPayoutWeekdayEnum,
                    ),
                  )
                  as CaptainEarningsDtoOutputPayoutWeekdayEnum;
          result.payoutWeekday = valueDes;
          break;
        case r'nextPayout':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.nextPayout = valueDes;
          break;
        case r'negativePolicy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainEarningsDtoOutputNegativePolicyEnum,
                    ),
                  )
                  as CaptainEarningsDtoOutputNegativePolicyEnum;
          result.negativePolicy = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainEarningsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainEarningsDtoOutputBuilder();
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

class CaptainEarningsDtoOutputPayoutWeekdayEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'saturday')
  static const CaptainEarningsDtoOutputPayoutWeekdayEnum saturday =
      _$captainEarningsDtoOutputPayoutWeekdayEnum_saturday;
  @BuiltValueEnumConst(wireName: r'sunday')
  static const CaptainEarningsDtoOutputPayoutWeekdayEnum sunday =
      _$captainEarningsDtoOutputPayoutWeekdayEnum_sunday;
  @BuiltValueEnumConst(wireName: r'monday')
  static const CaptainEarningsDtoOutputPayoutWeekdayEnum monday =
      _$captainEarningsDtoOutputPayoutWeekdayEnum_monday;
  @BuiltValueEnumConst(wireName: r'tuesday')
  static const CaptainEarningsDtoOutputPayoutWeekdayEnum tuesday =
      _$captainEarningsDtoOutputPayoutWeekdayEnum_tuesday;
  @BuiltValueEnumConst(wireName: r'wednesday')
  static const CaptainEarningsDtoOutputPayoutWeekdayEnum wednesday =
      _$captainEarningsDtoOutputPayoutWeekdayEnum_wednesday;
  @BuiltValueEnumConst(wireName: r'thursday')
  static const CaptainEarningsDtoOutputPayoutWeekdayEnum thursday =
      _$captainEarningsDtoOutputPayoutWeekdayEnum_thursday;
  @BuiltValueEnumConst(wireName: r'friday')
  static const CaptainEarningsDtoOutputPayoutWeekdayEnum friday =
      _$captainEarningsDtoOutputPayoutWeekdayEnum_friday;

  static Serializer<CaptainEarningsDtoOutputPayoutWeekdayEnum> get serializer =>
      _$captainEarningsDtoOutputPayoutWeekdayEnumSerializer;

  const CaptainEarningsDtoOutputPayoutWeekdayEnum._(String name) : super(name);

  static BuiltSet<CaptainEarningsDtoOutputPayoutWeekdayEnum> get values =>
      _$captainEarningsDtoOutputPayoutWeekdayEnumValues;
  static CaptainEarningsDtoOutputPayoutWeekdayEnum valueOf(String name) =>
      _$captainEarningsDtoOutputPayoutWeekdayEnumValueOf(name);
}

class CaptainEarningsDtoOutputNegativePolicyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'carry_forward')
  static const CaptainEarningsDtoOutputNegativePolicyEnum carryForward =
      _$captainEarningsDtoOutputNegativePolicyEnum_carryForward;
  @BuiltValueEnumConst(wireName: r'collect_at_desk')
  static const CaptainEarningsDtoOutputNegativePolicyEnum collectAtDesk =
      _$captainEarningsDtoOutputNegativePolicyEnum_collectAtDesk;

  static Serializer<CaptainEarningsDtoOutputNegativePolicyEnum>
  get serializer => _$captainEarningsDtoOutputNegativePolicyEnumSerializer;

  const CaptainEarningsDtoOutputNegativePolicyEnum._(String name) : super(name);

  static BuiltSet<CaptainEarningsDtoOutputNegativePolicyEnum> get values =>
      _$captainEarningsDtoOutputNegativePolicyEnumValues;
  static CaptainEarningsDtoOutputNegativePolicyEnum valueOf(String name) =>
      _$captainEarningsDtoOutputNegativePolicyEnumValueOf(name);
}
