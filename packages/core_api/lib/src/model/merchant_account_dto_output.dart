//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_account_dto_output_next_commission.dart';
import 'package:core_api/src/model/merchant_account_dto_output_week_lines_inner.dart';
import 'package:core_api/src/model/merchant_account_dto_output_pickups_inner.dart';
import 'package:core_api/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_account_dto_output.g.dart';

/// MerchantAccountDtoOutput
///
/// Properties:
/// * [currency] - The city's base currency.
/// * [balance] - «المستحق عليك حتى الآن»: + the restaurant owes, − the platform owes it (AP §8.7).
/// * [settlementDate] - «موعد التسوية»: the settlement day on the city's clock, the latest statement's while it is unpaid, else the next.
/// * [commissionBp] - The current commission in basis points (1500 is 15%).
/// * [nextCommission]
/// * [todayFrom] - The business day's start (its cutoff).
/// * [pickups] - «قبضت اليوم من الكباتن»: the pickups confirmed today, newest first.
/// * [weekFrom] - The latest statement's cutoff; null before the first statement.
/// * [weekLines] - «هذا الأسبوع»: every entry since the latest statement closed, newest day first, each day's orders then its exceptions and payments in the ledger's order.
@BuiltValue()
abstract class MerchantAccountDtoOutput
    implements
        Built<MerchantAccountDtoOutput, MerchantAccountDtoOutputBuilder> {
  /// The city's base currency.
  @BuiltValueField(wireName: r'currency')
  String? get currency;

  /// «المستحق عليك حتى الآن»: + the restaurant owes, − the platform owes it (AP §8.7).
  @BuiltValueField(wireName: r'balance')
  String get balance;

  /// «موعد التسوية»: the settlement day on the city's clock, the latest statement's while it is unpaid, else the next.
  @BuiltValueField(wireName: r'settlementDate')
  Date get settlementDate;

  /// The current commission in basis points (1500 is 15%).
  @BuiltValueField(wireName: r'commissionBp')
  int? get commissionBp;

  @BuiltValueField(wireName: r'nextCommission')
  MerchantAccountDtoOutputNextCommission? get nextCommission;

  /// The business day's start (its cutoff).
  @BuiltValueField(wireName: r'todayFrom')
  DateTime get todayFrom;

  /// «قبضت اليوم من الكباتن»: the pickups confirmed today, newest first.
  @BuiltValueField(wireName: r'pickups')
  BuiltList<MerchantAccountDtoOutputPickupsInner> get pickups;

  /// The latest statement's cutoff; null before the first statement.
  @BuiltValueField(wireName: r'weekFrom')
  DateTime? get weekFrom;

  /// «هذا الأسبوع»: every entry since the latest statement closed, newest day first, each day's orders then its exceptions and payments in the ledger's order.
  @BuiltValueField(wireName: r'weekLines')
  BuiltList<MerchantAccountDtoOutputWeekLinesInner> get weekLines;

  MerchantAccountDtoOutput._();

  factory MerchantAccountDtoOutput([
    void updates(MerchantAccountDtoOutputBuilder b),
  ]) = _$MerchantAccountDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantAccountDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantAccountDtoOutput> get serializer =>
      _$MerchantAccountDtoOutputSerializer();
}

class _$MerchantAccountDtoOutputSerializer
    implements PrimitiveSerializer<MerchantAccountDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantAccountDtoOutput,
    _$MerchantAccountDtoOutput,
  ];

  @override
  final String wireName = r'MerchantAccountDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantAccountDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield object.currency == null
        ? null
        : serializers.serialize(
            object.currency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'balance';
    yield serializers.serialize(
      object.balance,
      specifiedType: const FullType(String),
    );
    yield r'settlementDate';
    yield serializers.serialize(
      object.settlementDate,
      specifiedType: const FullType(Date),
    );
    yield r'commissionBp';
    yield object.commissionBp == null
        ? null
        : serializers.serialize(
            object.commissionBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'nextCommission';
    yield object.nextCommission == null
        ? null
        : serializers.serialize(
            object.nextCommission,
            specifiedType: const FullType.nullable(
              MerchantAccountDtoOutputNextCommission,
            ),
          );
    yield r'todayFrom';
    yield serializers.serialize(
      object.todayFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'pickups';
    yield serializers.serialize(
      object.pickups,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantAccountDtoOutputPickupsInner),
      ]),
    );
    yield r'weekFrom';
    yield object.weekFrom == null
        ? null
        : serializers.serialize(
            object.weekFrom,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'weekLines';
    yield serializers.serialize(
      object.weekLines,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantAccountDtoOutputWeekLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantAccountDtoOutput object, {
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
    required MerchantAccountDtoOutputBuilder result,
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
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.currency = valueDes;
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
        case r'settlementDate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(Date),
                  )
                  as Date;
          result.settlementDate = valueDes;
          break;
        case r'commissionBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.commissionBp = valueDes;
          break;
        case r'nextCommission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantAccountDtoOutputNextCommission,
                    ),
                  )
                  as MerchantAccountDtoOutputNextCommission?;
          if (valueDes == null) continue;
          result.nextCommission.replace(valueDes);
          break;
        case r'todayFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.todayFrom = valueDes;
          break;
        case r'pickups':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantAccountDtoOutputPickupsInner),
                    ]),
                  )
                  as BuiltList<MerchantAccountDtoOutputPickupsInner>;
          result.pickups.replace(valueDes);
          break;
        case r'weekFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.weekFrom = valueDes;
          break;
        case r'weekLines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantAccountDtoOutputWeekLinesInner),
                    ]),
                  )
                  as BuiltList<MerchantAccountDtoOutputWeekLinesInner>;
          result.weekLines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantAccountDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantAccountDtoOutputBuilder();
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
