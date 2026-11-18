//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_late_code_max_discount.dart';
import 'package:core_api/src/model/admin_restaurant_overview_dto_output_rejection_reasons_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_overview_dto_output.g.dart';

/// AdminRestaurantOverviewDtoOutput
///
/// Properties:
/// * [from] - The period’s first business-day cutoff.
/// * [orders] - Placed in the period, test orders left out.
/// * [sales] - The items value of the orders delivered, in minor units per currency.
/// * [acceptanceBp] - Accepted of those answered or timed out (as «المطاعم»), in basis points.
/// * [rejectionBp] - Rejected of the same, in basis points.
/// * [rejectionReasons] - The rejections by their reason’s label as chosen, most first.
/// * [unanswered] - Cancelled because the restaurant never answered.
/// * [prepActualMin] - Of the orders marked ready: the average minutes from acceptance to ready.
/// * [prepChosenMin] - Their average prep time chosen.
/// * [lateBp] - Of the same, the share ready after the prep time chosen.
/// * [ratingCount]
/// * [ratingAverage] - The period’s ratings; null with none.
@BuiltValue()
abstract class AdminRestaurantOverviewDtoOutput
    implements
        Built<
          AdminRestaurantOverviewDtoOutput,
          AdminRestaurantOverviewDtoOutputBuilder
        > {
  /// The period’s first business-day cutoff.
  @BuiltValueField(wireName: r'from')
  DateTime get from;

  /// Placed in the period, test orders left out.
  @BuiltValueField(wireName: r'orders')
  int get orders;

  /// The items value of the orders delivered, in minor units per currency.
  @BuiltValueField(wireName: r'sales')
  BuiltList<CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount?>
  get sales;

  /// Accepted of those answered or timed out (as «المطاعم»), in basis points.
  @BuiltValueField(wireName: r'acceptanceBp')
  int? get acceptanceBp;

  /// Rejected of the same, in basis points.
  @BuiltValueField(wireName: r'rejectionBp')
  int? get rejectionBp;

  /// The rejections by their reason’s label as chosen, most first.
  @BuiltValueField(wireName: r'rejectionReasons')
  BuiltList<AdminRestaurantOverviewDtoOutputRejectionReasonsInner>
  get rejectionReasons;

  /// Cancelled because the restaurant never answered.
  @BuiltValueField(wireName: r'unanswered')
  int get unanswered;

  /// Of the orders marked ready: the average minutes from acceptance to ready.
  @BuiltValueField(wireName: r'prepActualMin')
  num? get prepActualMin;

  /// Their average prep time chosen.
  @BuiltValueField(wireName: r'prepChosenMin')
  num? get prepChosenMin;

  /// Of the same, the share ready after the prep time chosen.
  @BuiltValueField(wireName: r'lateBp')
  int? get lateBp;

  @BuiltValueField(wireName: r'ratingCount')
  int get ratingCount;

  /// The period’s ratings; null with none.
  @BuiltValueField(wireName: r'ratingAverage')
  num? get ratingAverage;

  AdminRestaurantOverviewDtoOutput._();

  factory AdminRestaurantOverviewDtoOutput([
    void updates(AdminRestaurantOverviewDtoOutputBuilder b),
  ]) = _$AdminRestaurantOverviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantOverviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantOverviewDtoOutput> get serializer =>
      _$AdminRestaurantOverviewDtoOutputSerializer();
}

class _$AdminRestaurantOverviewDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantOverviewDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantOverviewDtoOutput,
    _$AdminRestaurantOverviewDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantOverviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantOverviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(DateTime),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'sales';
    yield serializers.serialize(
      object.sales,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(
          CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount,
        ),
      ]),
    );
    yield r'acceptanceBp';
    yield object.acceptanceBp == null
        ? null
        : serializers.serialize(
            object.acceptanceBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'rejectionBp';
    yield object.rejectionBp == null
        ? null
        : serializers.serialize(
            object.rejectionBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'rejectionReasons';
    yield serializers.serialize(
      object.rejectionReasons,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantOverviewDtoOutputRejectionReasonsInner),
      ]),
    );
    yield r'unanswered';
    yield serializers.serialize(
      object.unanswered,
      specifiedType: const FullType(int),
    );
    yield r'prepActualMin';
    yield object.prepActualMin == null
        ? null
        : serializers.serialize(
            object.prepActualMin,
            specifiedType: const FullType.nullable(num),
          );
    yield r'prepChosenMin';
    yield object.prepChosenMin == null
        ? null
        : serializers.serialize(
            object.prepChosenMin,
            specifiedType: const FullType.nullable(num),
          );
    yield r'lateBp';
    yield object.lateBp == null
        ? null
        : serializers.serialize(
            object.lateBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'ratingCount';
    yield serializers.serialize(
      object.ratingCount,
      specifiedType: const FullType(int),
    );
    yield r'ratingAverage';
    yield object.ratingAverage == null
        ? null
        : serializers.serialize(
            object.ratingAverage,
            specifiedType: const FullType.nullable(num),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantOverviewDtoOutput object, {
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
    required AdminRestaurantOverviewDtoOutputBuilder result,
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
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.from = valueDes;
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.orders = valueDes;
          break;
        case r'sales':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CustomerActiveOrdersDtoOutputOrdersInnerLateCodeMaxDiscount?
                  >;
          result.sales.replace(valueDes);
          break;
        case r'acceptanceBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.acceptanceBp = valueDes;
          break;
        case r'rejectionBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.rejectionBp = valueDes;
          break;
        case r'rejectionReasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRestaurantOverviewDtoOutputRejectionReasonsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRestaurantOverviewDtoOutputRejectionReasonsInner
                  >;
          result.rejectionReasons.replace(valueDes);
          break;
        case r'unanswered':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.unanswered = valueDes;
          break;
        case r'prepActualMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.prepActualMin = valueDes;
          break;
        case r'prepChosenMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.prepChosenMin = valueDes;
          break;
        case r'lateBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.lateBp = valueDes;
          break;
        case r'ratingCount':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.ratingCount = valueDes;
          break;
        case r'ratingAverage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.ratingAverage = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantOverviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantOverviewDtoOutputBuilder();
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
