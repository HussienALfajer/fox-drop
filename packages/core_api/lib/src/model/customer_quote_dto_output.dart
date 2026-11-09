//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/customer_quote_dto_output_problems_inner.dart';
import 'package:core_api/src/model/customer_quote_dto_output_restaurant.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_quote_dto_output_money.dart';
import 'package:core_api/src/model/customer_quote_dto_output_minimum_order.dart';
import 'package:core_api/src/model/customer_quote_dto_output_estimate.dart';
import 'package:core_api/src/model/customer_quote_dto_output_lines_inner.dart';
import 'package:core_api/src/model/customer_quote_dto_output_rates_inner.dart';
import 'package:core_api/src/model/customer_quote_dto_output_free_delivery.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output.g.dart';

/// CustomerQuoteDtoOutput
///
/// Properties:
/// * [version] - Changes only with a money line, an equivalent, the rates or a blocking problem; the order command carries it.
/// * [restaurant]
/// * [lines]
/// * [currency] - The base currency of every money line.
/// * [money]
/// * [equivalents] - «أو {المبلغ} $ · {المبلغ} ل.س»: each other accepted currency, by its rounding.
/// * [payIn]
/// * [estimate]
/// * [minimumOrder]
/// * [freeDelivery]
/// * [rates] - The exchange-rate version: null for the base currency.
/// * [problems] - CU §10.6: every one blocks ordering; the texts are in Appendix C.
@BuiltValue()
abstract class CustomerQuoteDtoOutput
    implements Built<CustomerQuoteDtoOutput, CustomerQuoteDtoOutputBuilder> {
  /// Changes only with a money line, an equivalent, the rates or a blocking problem; the order command carries it.
  @BuiltValueField(wireName: r'version')
  String get version;

  @BuiltValueField(wireName: r'restaurant')
  CustomerQuoteDtoOutputRestaurant get restaurant;

  @BuiltValueField(wireName: r'lines')
  BuiltList<CustomerQuoteDtoOutputLinesInner> get lines;

  /// The base currency of every money line.
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'money')
  CustomerQuoteDtoOutputMoney get money;

  /// «أو {المبلغ} $ · {المبلغ} ل.س»: each other accepted currency, by its rounding.
  @BuiltValueField(wireName: r'equivalents')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get equivalents;

  @BuiltValueField(wireName: r'payIn')
  CaptainWentOfflineDtoOutputHandIn? get payIn;

  @BuiltValueField(wireName: r'estimate')
  CustomerQuoteDtoOutputEstimate get estimate;

  @BuiltValueField(wireName: r'minimumOrder')
  CustomerQuoteDtoOutputMinimumOrder get minimumOrder;

  @BuiltValueField(wireName: r'freeDelivery')
  CustomerQuoteDtoOutputFreeDelivery? get freeDelivery;

  /// The exchange-rate version: null for the base currency.
  @BuiltValueField(wireName: r'rates')
  BuiltList<CustomerQuoteDtoOutputRatesInner> get rates;

  /// CU §10.6: every one blocks ordering; the texts are in Appendix C.
  @BuiltValueField(wireName: r'problems')
  BuiltList<CustomerQuoteDtoOutputProblemsInner> get problems;

  CustomerQuoteDtoOutput._();

  factory CustomerQuoteDtoOutput([
    void updates(CustomerQuoteDtoOutputBuilder b),
  ]) = _$CustomerQuoteDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutput> get serializer =>
      _$CustomerQuoteDtoOutputSerializer();
}

class _$CustomerQuoteDtoOutputSerializer
    implements PrimitiveSerializer<CustomerQuoteDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerQuoteDtoOutput,
    _$CustomerQuoteDtoOutput,
  ];

  @override
  final String wireName = r'CustomerQuoteDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(String),
    );
    yield r'restaurant';
    yield serializers.serialize(
      object.restaurant,
      specifiedType: const FullType(CustomerQuoteDtoOutputRestaurant),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerQuoteDtoOutputLinesInner),
      ]),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'money';
    yield serializers.serialize(
      object.money,
      specifiedType: const FullType(CustomerQuoteDtoOutputMoney),
    );
    yield r'equivalents';
    yield serializers.serialize(
      object.equivalents,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
      ]),
    );
    yield r'payIn';
    yield object.payIn == null
        ? null
        : serializers.serialize(
            object.payIn,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'estimate';
    yield serializers.serialize(
      object.estimate,
      specifiedType: const FullType(CustomerQuoteDtoOutputEstimate),
    );
    yield r'minimumOrder';
    yield serializers.serialize(
      object.minimumOrder,
      specifiedType: const FullType(CustomerQuoteDtoOutputMinimumOrder),
    );
    yield r'freeDelivery';
    yield object.freeDelivery == null
        ? null
        : serializers.serialize(
            object.freeDelivery,
            specifiedType: const FullType.nullable(
              CustomerQuoteDtoOutputFreeDelivery,
            ),
          );
    yield r'rates';
    yield serializers.serialize(
      object.rates,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerQuoteDtoOutputRatesInner),
      ]),
    );
    yield r'problems';
    yield serializers.serialize(
      object.problems,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerQuoteDtoOutputProblemsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutput object, {
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
    required CustomerQuoteDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'version':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.version = valueDes;
          break;
        case r'restaurant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerQuoteDtoOutputRestaurant,
                    ),
                  )
                  as CustomerQuoteDtoOutputRestaurant;
          result.restaurant.replace(valueDes);
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerQuoteDtoOutputLinesInner),
                    ]),
                  )
                  as BuiltList<CustomerQuoteDtoOutputLinesInner>;
          result.lines.replace(valueDes);
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
        case r'money':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CustomerQuoteDtoOutputMoney),
                  )
                  as CustomerQuoteDtoOutputMoney;
          result.money.replace(valueDes);
          break;
        case r'equivalents':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
                    ]),
                  )
                  as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
          result.equivalents.replace(valueDes);
          break;
        case r'payIn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.payIn.replace(valueDes);
          break;
        case r'estimate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerQuoteDtoOutputEstimate,
                    ),
                  )
                  as CustomerQuoteDtoOutputEstimate;
          result.estimate.replace(valueDes);
          break;
        case r'minimumOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerQuoteDtoOutputMinimumOrder,
                    ),
                  )
                  as CustomerQuoteDtoOutputMinimumOrder;
          result.minimumOrder.replace(valueDes);
          break;
        case r'freeDelivery':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerQuoteDtoOutputFreeDelivery,
                    ),
                  )
                  as CustomerQuoteDtoOutputFreeDelivery?;
          if (valueDes == null) continue;
          result.freeDelivery.replace(valueDes);
          break;
        case r'rates':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerQuoteDtoOutputRatesInner),
                    ]),
                  )
                  as BuiltList<CustomerQuoteDtoOutputRatesInner>;
          result.rates.replace(valueDes);
          break;
        case r'problems':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerQuoteDtoOutputProblemsInner),
                    ]),
                  )
                  as BuiltList<CustomerQuoteDtoOutputProblemsInner>;
          result.problems.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputBuilder();
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
