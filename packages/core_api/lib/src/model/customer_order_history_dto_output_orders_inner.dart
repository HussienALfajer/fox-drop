//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_restaurant.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_order_history_dto_output_orders_inner.g.dart';

/// CustomerOrderHistoryDtoOutputOrdersInner
///
/// Properties:
/// * [id]
/// * [number]
/// * [restaurant]
/// * [placedAt]
/// * [status]
/// * [active] - Placed to arrived: listed first.
/// * [total]
/// * [redelivery] - A free re-delivery (AP §9.9.3): no «اطلب مرة أخرى».
@BuiltValue()
abstract class CustomerOrderHistoryDtoOutputOrdersInner
    implements
        Built<
          CustomerOrderHistoryDtoOutputOrdersInner,
          CustomerOrderHistoryDtoOutputOrdersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'restaurant')
  CustomerActiveOrdersDtoOutputOrdersInnerRestaurant get restaurant;

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  @BuiltValueField(wireName: r'status')
  CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// Placed to arrived: listed first.
  @BuiltValueField(wireName: r'active')
  bool get active;

  @BuiltValueField(wireName: r'total')
  CaptainWentOfflineDtoOutputHandIn? get total;

  /// A free re-delivery (AP §9.9.3): no «اطلب مرة أخرى».
  @BuiltValueField(wireName: r'redelivery')
  bool get redelivery;

  CustomerOrderHistoryDtoOutputOrdersInner._();

  factory CustomerOrderHistoryDtoOutputOrdersInner([
    void updates(CustomerOrderHistoryDtoOutputOrdersInnerBuilder b),
  ]) = _$CustomerOrderHistoryDtoOutputOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerOrderHistoryDtoOutputOrdersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerOrderHistoryDtoOutputOrdersInner> get serializer =>
      _$CustomerOrderHistoryDtoOutputOrdersInnerSerializer();
}

class _$CustomerOrderHistoryDtoOutputOrdersInnerSerializer
    implements PrimitiveSerializer<CustomerOrderHistoryDtoOutputOrdersInner> {
  @override
  final Iterable<Type> types = const [
    CustomerOrderHistoryDtoOutputOrdersInner,
    _$CustomerOrderHistoryDtoOutputOrdersInner,
  ];

  @override
  final String wireName = r'CustomerOrderHistoryDtoOutputOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerOrderHistoryDtoOutputOrdersInner object, {
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
    yield r'restaurant';
    yield serializers.serialize(
      object.restaurant,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerRestaurant,
      ),
    );
    yield r'placedAt';
    yield serializers.serialize(
      object.placedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum,
      ),
    );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
    yield r'total';
    yield object.total == null
        ? null
        : serializers.serialize(
            object.total,
            specifiedType: const FullType.nullable(
              CaptainWentOfflineDtoOutputHandIn,
            ),
          );
    yield r'redelivery';
    yield serializers.serialize(
      object.redelivery,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerOrderHistoryDtoOutputOrdersInner object, {
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
    required CustomerOrderHistoryDtoOutputOrdersInnerBuilder result,
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
        case r'placedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.placedAt = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum,
                    ),
                  )
                  as CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.active = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainWentOfflineDtoOutputHandIn,
                    ),
                  )
                  as CaptainWentOfflineDtoOutputHandIn?;
          if (valueDes == null) continue;
          result.total.replace(valueDes);
          break;
        case r'redelivery':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.redelivery = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerOrderHistoryDtoOutputOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerOrderHistoryDtoOutputOrdersInnerBuilder();
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

class CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum placed =
      _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum accepted =
      _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum ready =
      _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum pickedUp =
      _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum arrived =
      _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum delivered =
      _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum rejected =
      _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum cancelled =
      _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum failed =
      _$customerOrderHistoryDtoOutputOrdersInnerStatusEnum_failed;

  static Serializer<CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum>
  get serializer =>
      _$customerOrderHistoryDtoOutputOrdersInnerStatusEnumSerializer;

  const CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum>
  get values => _$customerOrderHistoryDtoOutputOrdersInnerStatusEnumValues;
  static CustomerOrderHistoryDtoOutputOrdersInnerStatusEnum valueOf(
    String name,
  ) => _$customerOrderHistoryDtoOutputOrdersInnerStatusEnumValueOf(name);
}
