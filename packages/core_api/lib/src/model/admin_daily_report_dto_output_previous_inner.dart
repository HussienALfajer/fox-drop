//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_daily_report_dto_output_restaurants.dart';
import 'package:core_api/src/model/admin_daily_report_dto_output_captain_pay.dart';
import 'package:core_api/src/model/admin_daily_report_dto_output_discounts.dart';
import 'package:core_api/src/model/admin_daily_report_dto_output_orders.dart';
import 'package:core_api/src/model/admin_daily_report_dto_output_cash_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_daily_report_dto_output_previous_inner.g.dart';

/// AdminDailyReportDtoOutputPreviousInner
///
/// Properties:
/// * [day] - A business day on the city’s clock, YYYY-MM-DD.
/// * [from] - The cutoff that starts the day.
/// * [to] - The cutoff that ends it.
/// * [currency] - The city’s base: every amount but the cash is in it.
/// * [orders]
/// * [deliveryFees]
/// * [discounts]
/// * [commission] - Earned by the platform.
/// * [captainPay]
/// * [compensation]
/// * [operatingCost]
/// * [testCost]
/// * [fxRounding] - + a gain for the platform.
/// * [adjustments] - + a gain for the platform.
/// * [withheldDeposits] - Kit deposits withheld at termination, a revenue.
/// * [margin]
/// * [cash]
/// * [restaurants]
@BuiltValue()
abstract class AdminDailyReportDtoOutputPreviousInner
    implements
        Built<
          AdminDailyReportDtoOutputPreviousInner,
          AdminDailyReportDtoOutputPreviousInnerBuilder
        > {
  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'day')
  String get day;

  /// The cutoff that starts the day.
  @BuiltValueField(wireName: r'from')
  DateTime get from;

  /// The cutoff that ends it.
  @BuiltValueField(wireName: r'to')
  DateTime get to;

  /// The city’s base: every amount but the cash is in it.
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'orders')
  AdminDailyReportDtoOutputOrders get orders;

  @BuiltValueField(wireName: r'deliveryFees')
  String get deliveryFees;

  @BuiltValueField(wireName: r'discounts')
  AdminDailyReportDtoOutputDiscounts get discounts;

  /// Earned by the platform.
  @BuiltValueField(wireName: r'commission')
  String get commission;

  @BuiltValueField(wireName: r'captainPay')
  AdminDailyReportDtoOutputCaptainPay get captainPay;

  @BuiltValueField(wireName: r'compensation')
  String get compensation;

  @BuiltValueField(wireName: r'operatingCost')
  String get operatingCost;

  @BuiltValueField(wireName: r'testCost')
  String get testCost;

  /// + a gain for the platform.
  @BuiltValueField(wireName: r'fxRounding')
  String get fxRounding;

  /// + a gain for the platform.
  @BuiltValueField(wireName: r'adjustments')
  String get adjustments;

  /// Kit deposits withheld at termination, a revenue.
  @BuiltValueField(wireName: r'withheldDeposits')
  String get withheldDeposits;

  @BuiltValueField(wireName: r'margin')
  String get margin;

  @BuiltValueField(wireName: r'cash')
  BuiltList<AdminDailyReportDtoOutputCashInner> get cash;

  @BuiltValueField(wireName: r'restaurants')
  AdminDailyReportDtoOutputRestaurants get restaurants;

  AdminDailyReportDtoOutputPreviousInner._();

  factory AdminDailyReportDtoOutputPreviousInner([
    void updates(AdminDailyReportDtoOutputPreviousInnerBuilder b),
  ]) = _$AdminDailyReportDtoOutputPreviousInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDailyReportDtoOutputPreviousInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDailyReportDtoOutputPreviousInner> get serializer =>
      _$AdminDailyReportDtoOutputPreviousInnerSerializer();
}

class _$AdminDailyReportDtoOutputPreviousInnerSerializer
    implements PrimitiveSerializer<AdminDailyReportDtoOutputPreviousInner> {
  @override
  final Iterable<Type> types = const [
    AdminDailyReportDtoOutputPreviousInner,
    _$AdminDailyReportDtoOutputPreviousInner,
  ];

  @override
  final String wireName = r'AdminDailyReportDtoOutputPreviousInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDailyReportDtoOutputPreviousInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'day';
    yield serializers.serialize(
      object.day,
      specifiedType: const FullType(String),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(DateTime),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
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
      specifiedType: const FullType(AdminDailyReportDtoOutputOrders),
    );
    yield r'deliveryFees';
    yield serializers.serialize(
      object.deliveryFees,
      specifiedType: const FullType(String),
    );
    yield r'discounts';
    yield serializers.serialize(
      object.discounts,
      specifiedType: const FullType(AdminDailyReportDtoOutputDiscounts),
    );
    yield r'commission';
    yield serializers.serialize(
      object.commission,
      specifiedType: const FullType(String),
    );
    yield r'captainPay';
    yield serializers.serialize(
      object.captainPay,
      specifiedType: const FullType(AdminDailyReportDtoOutputCaptainPay),
    );
    yield r'compensation';
    yield serializers.serialize(
      object.compensation,
      specifiedType: const FullType(String),
    );
    yield r'operatingCost';
    yield serializers.serialize(
      object.operatingCost,
      specifiedType: const FullType(String),
    );
    yield r'testCost';
    yield serializers.serialize(
      object.testCost,
      specifiedType: const FullType(String),
    );
    yield r'fxRounding';
    yield serializers.serialize(
      object.fxRounding,
      specifiedType: const FullType(String),
    );
    yield r'adjustments';
    yield serializers.serialize(
      object.adjustments,
      specifiedType: const FullType(String),
    );
    yield r'withheldDeposits';
    yield serializers.serialize(
      object.withheldDeposits,
      specifiedType: const FullType(String),
    );
    yield r'margin';
    yield serializers.serialize(
      object.margin,
      specifiedType: const FullType(String),
    );
    yield r'cash';
    yield serializers.serialize(
      object.cash,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDailyReportDtoOutputCashInner),
      ]),
    );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(AdminDailyReportDtoOutputRestaurants),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDailyReportDtoOutputPreviousInner object, {
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
    required AdminDailyReportDtoOutputPreviousInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'day':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.day = valueDes;
          break;
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.to = valueDes;
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
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDailyReportDtoOutputOrders,
                    ),
                  )
                  as AdminDailyReportDtoOutputOrders;
          result.orders.replace(valueDes);
          break;
        case r'deliveryFees':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.deliveryFees = valueDes;
          break;
        case r'discounts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDailyReportDtoOutputDiscounts,
                    ),
                  )
                  as AdminDailyReportDtoOutputDiscounts;
          result.discounts.replace(valueDes);
          break;
        case r'commission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.commission = valueDes;
          break;
        case r'captainPay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDailyReportDtoOutputCaptainPay,
                    ),
                  )
                  as AdminDailyReportDtoOutputCaptainPay;
          result.captainPay.replace(valueDes);
          break;
        case r'compensation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.compensation = valueDes;
          break;
        case r'operatingCost':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.operatingCost = valueDes;
          break;
        case r'testCost':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.testCost = valueDes;
          break;
        case r'fxRounding':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fxRounding = valueDes;
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
        case r'withheldDeposits':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.withheldDeposits = valueDes;
          break;
        case r'margin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.margin = valueDes;
          break;
        case r'cash':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDailyReportDtoOutputCashInner),
                    ]),
                  )
                  as BuiltList<AdminDailyReportDtoOutputCashInner>;
          result.cash.replace(valueDes);
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDailyReportDtoOutputRestaurants,
                    ),
                  )
                  as AdminDailyReportDtoOutputRestaurants;
          result.restaurants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDailyReportDtoOutputPreviousInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDailyReportDtoOutputPreviousInnerBuilder();
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
