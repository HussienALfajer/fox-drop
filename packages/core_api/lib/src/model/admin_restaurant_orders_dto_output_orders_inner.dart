//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_orders_dto_output_orders_inner.g.dart';

/// AdminRestaurantOrdersDtoOutputOrdersInner
///
/// Properties:
/// * [id]
/// * [number]
/// * [placedAt]
/// * [status]
/// * [total] - The customer’s total in minor units.
/// * [currency]
/// * [testOrder]
/// * [redelivery]
@BuiltValue()
abstract class AdminRestaurantOrdersDtoOutputOrdersInner
    implements
        Built<
          AdminRestaurantOrdersDtoOutputOrdersInner,
          AdminRestaurantOrdersDtoOutputOrdersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'number')
  String get number;

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  @BuiltValueField(wireName: r'status')
  AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// The customer’s total in minor units.
  @BuiltValueField(wireName: r'total')
  String get total;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'testOrder')
  bool get testOrder;

  @BuiltValueField(wireName: r'redelivery')
  bool get redelivery;

  AdminRestaurantOrdersDtoOutputOrdersInner._();

  factory AdminRestaurantOrdersDtoOutputOrdersInner([
    void updates(AdminRestaurantOrdersDtoOutputOrdersInnerBuilder b),
  ]) = _$AdminRestaurantOrdersDtoOutputOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantOrdersDtoOutputOrdersInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantOrdersDtoOutputOrdersInner> get serializer =>
      _$AdminRestaurantOrdersDtoOutputOrdersInnerSerializer();
}

class _$AdminRestaurantOrdersDtoOutputOrdersInnerSerializer
    implements PrimitiveSerializer<AdminRestaurantOrdersDtoOutputOrdersInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantOrdersDtoOutputOrdersInner,
    _$AdminRestaurantOrdersDtoOutputOrdersInner,
  ];

  @override
  final String wireName = r'AdminRestaurantOrdersDtoOutputOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantOrdersDtoOutputOrdersInner object, {
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
    yield r'placedAt';
    yield serializers.serialize(
      object.placedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum,
      ),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'testOrder';
    yield serializers.serialize(
      object.testOrder,
      specifiedType: const FullType(bool),
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
    AdminRestaurantOrdersDtoOutputOrdersInner object, {
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
    required AdminRestaurantOrdersDtoOutputOrdersInnerBuilder result,
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
                      AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum,
                    ),
                  )
                  as AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.total = valueDes;
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
        case r'testOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.testOrder = valueDes;
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
  AdminRestaurantOrdersDtoOutputOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantOrdersDtoOutputOrdersInnerBuilder();
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

class AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum placed =
      _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum accepted =
      _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum ready =
      _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum pickedUp =
      _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum arrived =
      _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum delivered =
      _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum rejected =
      _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum cancelled =
      _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum failed =
      _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnum_failed;

  static Serializer<AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum>
  get serializer =>
      _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnumSerializer;

  const AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum>
  get values => _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnumValues;
  static AdminRestaurantOrdersDtoOutputOrdersInnerStatusEnum valueOf(
    String name,
  ) => _$adminRestaurantOrdersDtoOutputOrdersInnerStatusEnumValueOf(name);
}
