//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_placed_order_dto_output_order_lines_inner.dart';
import 'package:core_api/src/model/customer_placed_order_dto_output_order_estimate.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_placed_order_dto_output_order_address.dart';
import 'package:core_api/src/model/customer_placed_order_dto_output_order_money.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_placed_order_dto_output_order.g.dart';

/// CustomerPlacedOrderDtoOutputOrder
///
/// Properties:
/// * [id]
/// * [number] - Shown as #10423 (AP §4.8).
/// * [status] - AP §8.1; placed when it was placed.
/// * [placedAt]
/// * [restaurantId]
/// * [currency]
/// * [money]
/// * [lines]
/// * [payIn] - «سأدفع بـ»; null for «لم أحدد».
/// * [note]
/// * [estimate]
/// * [address]
@BuiltValue()
abstract class CustomerPlacedOrderDtoOutputOrder
    implements
        Built<
          CustomerPlacedOrderDtoOutputOrder,
          CustomerPlacedOrderDtoOutputOrderBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// AP §8.1; placed when it was placed.
  @BuiltValueField(wireName: r'status')
  CustomerPlacedOrderDtoOutputOrderStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'money')
  CustomerPlacedOrderDtoOutputOrderMoney get money;

  @BuiltValueField(wireName: r'lines')
  BuiltList<CustomerPlacedOrderDtoOutputOrderLinesInner> get lines;

  /// «سأدفع بـ»; null for «لم أحدد».
  @BuiltValueField(wireName: r'payIn')
  String? get payIn;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'estimate')
  CustomerPlacedOrderDtoOutputOrderEstimate get estimate;

  @BuiltValueField(wireName: r'address')
  CustomerPlacedOrderDtoOutputOrderAddress get address;

  CustomerPlacedOrderDtoOutputOrder._();

  factory CustomerPlacedOrderDtoOutputOrder([
    void updates(CustomerPlacedOrderDtoOutputOrderBuilder b),
  ]) = _$CustomerPlacedOrderDtoOutputOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerPlacedOrderDtoOutputOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerPlacedOrderDtoOutputOrder> get serializer =>
      _$CustomerPlacedOrderDtoOutputOrderSerializer();
}

class _$CustomerPlacedOrderDtoOutputOrderSerializer
    implements PrimitiveSerializer<CustomerPlacedOrderDtoOutputOrder> {
  @override
  final Iterable<Type> types = const [
    CustomerPlacedOrderDtoOutputOrder,
    _$CustomerPlacedOrderDtoOutputOrder,
  ];

  @override
  final String wireName = r'CustomerPlacedOrderDtoOutputOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerPlacedOrderDtoOutputOrder object, {
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
      specifiedType: const FullType(
        CustomerPlacedOrderDtoOutputOrderStatusEnum,
      ),
    );
    yield r'placedAt';
    yield serializers.serialize(
      object.placedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'money';
    yield serializers.serialize(
      object.money,
      specifiedType: const FullType(CustomerPlacedOrderDtoOutputOrderMoney),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerPlacedOrderDtoOutputOrderLinesInner),
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
      specifiedType: const FullType(CustomerPlacedOrderDtoOutputOrderEstimate),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(CustomerPlacedOrderDtoOutputOrderAddress),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerPlacedOrderDtoOutputOrder object, {
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
    required CustomerPlacedOrderDtoOutputOrderBuilder result,
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
                      CustomerPlacedOrderDtoOutputOrderStatusEnum,
                    ),
                  )
                  as CustomerPlacedOrderDtoOutputOrderStatusEnum;
          result.status = valueDes;
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
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
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
                      CustomerPlacedOrderDtoOutputOrderMoney,
                    ),
                  )
                  as CustomerPlacedOrderDtoOutputOrderMoney;
          result.money.replace(valueDes);
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CustomerPlacedOrderDtoOutputOrderLinesInner),
                    ]),
                  )
                  as BuiltList<CustomerPlacedOrderDtoOutputOrderLinesInner>;
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
                      CustomerPlacedOrderDtoOutputOrderEstimate,
                    ),
                  )
                  as CustomerPlacedOrderDtoOutputOrderEstimate;
          result.estimate.replace(valueDes);
          break;
        case r'address':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerPlacedOrderDtoOutputOrderAddress,
                    ),
                  )
                  as CustomerPlacedOrderDtoOutputOrderAddress;
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
  CustomerPlacedOrderDtoOutputOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerPlacedOrderDtoOutputOrderBuilder();
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

/// AP §8.1; placed when it was placed.
class CustomerPlacedOrderDtoOutputOrderStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const CustomerPlacedOrderDtoOutputOrderStatusEnum placed =
      _$customerPlacedOrderDtoOutputOrderStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CustomerPlacedOrderDtoOutputOrderStatusEnum accepted =
      _$customerPlacedOrderDtoOutputOrderStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const CustomerPlacedOrderDtoOutputOrderStatusEnum ready =
      _$customerPlacedOrderDtoOutputOrderStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const CustomerPlacedOrderDtoOutputOrderStatusEnum pickedUp =
      _$customerPlacedOrderDtoOutputOrderStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const CustomerPlacedOrderDtoOutputOrderStatusEnum arrived =
      _$customerPlacedOrderDtoOutputOrderStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const CustomerPlacedOrderDtoOutputOrderStatusEnum delivered =
      _$customerPlacedOrderDtoOutputOrderStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CustomerPlacedOrderDtoOutputOrderStatusEnum rejected =
      _$customerPlacedOrderDtoOutputOrderStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CustomerPlacedOrderDtoOutputOrderStatusEnum cancelled =
      _$customerPlacedOrderDtoOutputOrderStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CustomerPlacedOrderDtoOutputOrderStatusEnum failed =
      _$customerPlacedOrderDtoOutputOrderStatusEnum_failed;

  static Serializer<CustomerPlacedOrderDtoOutputOrderStatusEnum>
  get serializer => _$customerPlacedOrderDtoOutputOrderStatusEnumSerializer;

  const CustomerPlacedOrderDtoOutputOrderStatusEnum._(String name)
    : super(name);

  static BuiltSet<CustomerPlacedOrderDtoOutputOrderStatusEnum> get values =>
      _$customerPlacedOrderDtoOutputOrderStatusEnumValues;
  static CustomerPlacedOrderDtoOutputOrderStatusEnum valueOf(String name) =>
      _$customerPlacedOrderDtoOutputOrderStatusEnumValueOf(name);
}
