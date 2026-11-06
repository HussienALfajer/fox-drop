//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_estimate.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_lines_inner.dart';
import 'package:core_api/src/model/captain_availability_dto_output_custody_limit.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_restaurant.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_cancellation.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_money.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_address.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_order_dto_output_order.g.dart';

/// CustomerOrderDtoOutputOrder
///
/// Properties:
/// * [id]
/// * [number] - Shown as #10423 (AP §4.8).
/// * [status] - AP §8.1.
/// * [version] - Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).
/// * [placedAt]
/// * [promisedAt] - «يصل حوالي {الساعة}» from acceptance (CU §11.1–11.2, docs/domain/03); null while placed, when the estimate range shows.
/// * [cancellation]
/// * [restaurant]
/// * [currency]
/// * [money]
/// * [equivalents] - The total in the city's other currencies, by the order's own rates (CU §11.1).
/// * [lines]
/// * [payIn] - «سأدفع بـ»; null for «لم أحدد».
/// * [note]
/// * [estimate]
/// * [address]
@BuiltValue()
abstract class CustomerOrderDtoOutputOrder
    implements
        Built<CustomerOrderDtoOutputOrder, CustomerOrderDtoOutputOrderBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// AP §8.1.
  @BuiltValueField(wireName: r'status')
  CustomerOrderDtoOutputOrderStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  /// «يصل حوالي {الساعة}» from acceptance (CU §11.1–11.2, docs/domain/03); null while placed, when the estimate range shows.
  @BuiltValueField(wireName: r'promisedAt')
  DateTime? get promisedAt;

  @BuiltValueField(wireName: r'cancellation')
  CustomerActiveOrdersDtoOutputOrdersInnerCancellation? get cancellation;

  @BuiltValueField(wireName: r'restaurant')
  CustomerActiveOrdersDtoOutputOrdersInnerRestaurant get restaurant;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'money')
  CustomerActiveOrdersDtoOutputOrdersInnerMoney get money;

  /// The total in the city's other currencies, by the order's own rates (CU §11.1).
  @BuiltValueField(wireName: r'equivalents')
  BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> get equivalents;

  @BuiltValueField(wireName: r'lines')
  BuiltList<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner> get lines;

  /// «سأدفع بـ»; null for «لم أحدد».
  @BuiltValueField(wireName: r'payIn')
  String? get payIn;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'estimate')
  CustomerActiveOrdersDtoOutputOrdersInnerEstimate get estimate;

  @BuiltValueField(wireName: r'address')
  CustomerActiveOrdersDtoOutputOrdersInnerAddress get address;

  CustomerOrderDtoOutputOrder._();

  factory CustomerOrderDtoOutputOrder([
    void updates(CustomerOrderDtoOutputOrderBuilder b),
  ]) = _$CustomerOrderDtoOutputOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerOrderDtoOutputOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerOrderDtoOutputOrder> get serializer =>
      _$CustomerOrderDtoOutputOrderSerializer();
}

class _$CustomerOrderDtoOutputOrderSerializer
    implements PrimitiveSerializer<CustomerOrderDtoOutputOrder> {
  @override
  final Iterable<Type> types = const [
    CustomerOrderDtoOutputOrder,
    _$CustomerOrderDtoOutputOrder,
  ];

  @override
  final String wireName = r'CustomerOrderDtoOutputOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerOrderDtoOutputOrder object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(CustomerOrderDtoOutputOrderStatusEnum),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'placedAt';
    yield serializers.serialize(
      object.placedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'promisedAt';
    yield object.promisedAt == null
        ? null
        : serializers.serialize(
            object.promisedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'cancellation';
    yield object.cancellation == null
        ? null
        : serializers.serialize(
            object.cancellation,
            specifiedType: const FullType.nullable(
              CustomerActiveOrdersDtoOutputOrdersInnerCancellation,
            ),
          );
    yield r'restaurant';
    yield serializers.serialize(
      object.restaurant,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerRestaurant,
      ),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'money';
    yield serializers.serialize(
      object.money,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerMoney,
      ),
    );
    yield r'equivalents';
    yield serializers.serialize(
      object.equivalents,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainAvailabilityDtoOutputCustodyLimit),
      ]),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerActiveOrdersDtoOutputOrdersInnerLinesInner),
      ]),
    );
    yield r'payIn';
    yield object.payIn == null
        ? null
        : serializers.serialize(
            object.payIn,
            specifiedType: const FullType.nullable(String),
          );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'estimate';
    yield serializers.serialize(
      object.estimate,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerEstimate,
      ),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerAddress,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerOrderDtoOutputOrder object, {
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
    required CustomerOrderDtoOutputOrderBuilder result,
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
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerOrderDtoOutputOrderStatusEnum,
                    ),
                  )
                  as CustomerOrderDtoOutputOrderStatusEnum;
          result.status = valueDes;
          break;
        case r'version':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.version = valueDes;
          break;
        case r'placedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.placedAt = valueDes;
          break;
        case r'promisedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.promisedAt = valueDes;
          break;
        case r'cancellation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerActiveOrdersDtoOutputOrdersInnerCancellation,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerCancellation?;
          if (valueDes == null) continue;
          result.cancellation.replace(valueDes);
          break;
        case r'restaurant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerRestaurant,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerRestaurant;
          result.restaurant.replace(valueDes);
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
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerMoney,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerMoney;
          result.money.replace(valueDes);
          break;
        case r'equivalents':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainAvailabilityDtoOutputCustodyLimit),
                    ]),
                  )
                  as BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>;
          result.equivalents.replace(valueDes);
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CustomerActiveOrdersDtoOutputOrdersInnerLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CustomerActiveOrdersDtoOutputOrdersInnerLinesInner
                  >;
          result.lines.replace(valueDes);
          break;
        case r'payIn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.payIn = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'estimate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerEstimate,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerEstimate;
          result.estimate.replace(valueDes);
          break;
        case r'address':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerAddress,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerAddress;
          result.address.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerOrderDtoOutputOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerOrderDtoOutputOrderBuilder();
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

/// AP §8.1.
class CustomerOrderDtoOutputOrderStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const CustomerOrderDtoOutputOrderStatusEnum placed =
      _$customerOrderDtoOutputOrderStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CustomerOrderDtoOutputOrderStatusEnum accepted =
      _$customerOrderDtoOutputOrderStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const CustomerOrderDtoOutputOrderStatusEnum ready =
      _$customerOrderDtoOutputOrderStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const CustomerOrderDtoOutputOrderStatusEnum pickedUp =
      _$customerOrderDtoOutputOrderStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const CustomerOrderDtoOutputOrderStatusEnum arrived =
      _$customerOrderDtoOutputOrderStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const CustomerOrderDtoOutputOrderStatusEnum delivered =
      _$customerOrderDtoOutputOrderStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CustomerOrderDtoOutputOrderStatusEnum rejected =
      _$customerOrderDtoOutputOrderStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CustomerOrderDtoOutputOrderStatusEnum cancelled =
      _$customerOrderDtoOutputOrderStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CustomerOrderDtoOutputOrderStatusEnum failed =
      _$customerOrderDtoOutputOrderStatusEnum_failed;

  static Serializer<CustomerOrderDtoOutputOrderStatusEnum> get serializer =>
      _$customerOrderDtoOutputOrderStatusEnumSerializer;

  const CustomerOrderDtoOutputOrderStatusEnum._(String name) : super(name);

  static BuiltSet<CustomerOrderDtoOutputOrderStatusEnum> get values =>
      _$customerOrderDtoOutputOrderStatusEnumValues;
  static CustomerOrderDtoOutputOrderStatusEnum valueOf(String name) =>
      _$customerOrderDtoOutputOrderStatusEnumValueOf(name);
}
