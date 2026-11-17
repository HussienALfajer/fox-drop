//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customer_dto_output_orders_spent_inner.dart';
import 'package:core_api/src/model/admin_customer_dto_output_orders_last.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_customer_dto_output_orders.g.dart';

/// AdminCustomerDtoOutputOrders
///
/// Properties:
/// * [count] - The customer's orders in the city, re-deliveries left out.
/// * [spent] - The delivered orders’ totals per currency.
/// * [last]
@BuiltValue()
abstract class AdminCustomerDtoOutputOrders
    implements
        Built<
          AdminCustomerDtoOutputOrders,
          AdminCustomerDtoOutputOrdersBuilder
        > {
  /// The customer's orders in the city, re-deliveries left out.
  @BuiltValueField(wireName: r'count')
  int get count;

  /// The delivered orders’ totals per currency.
  @BuiltValueField(wireName: r'spent')
  BuiltList<AdminCustomerDtoOutputOrdersSpentInner> get spent;

  @BuiltValueField(wireName: r'last')
  AdminCustomerDtoOutputOrdersLast? get last;

  AdminCustomerDtoOutputOrders._();

  factory AdminCustomerDtoOutputOrders([
    void updates(AdminCustomerDtoOutputOrdersBuilder b),
  ]) = _$AdminCustomerDtoOutputOrders;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCustomerDtoOutputOrdersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCustomerDtoOutputOrders> get serializer =>
      _$AdminCustomerDtoOutputOrdersSerializer();
}

class _$AdminCustomerDtoOutputOrdersSerializer
    implements PrimitiveSerializer<AdminCustomerDtoOutputOrders> {
  @override
  final Iterable<Type> types = const [
    AdminCustomerDtoOutputOrders,
    _$AdminCustomerDtoOutputOrders,
  ];

  @override
  final String wireName = r'AdminCustomerDtoOutputOrders';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCustomerDtoOutputOrders object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'count';
    yield serializers.serialize(
      object.count,
      specifiedType: const FullType(int),
    );
    yield r'spent';
    yield serializers.serialize(
      object.spent,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCustomerDtoOutputOrdersSpentInner),
      ]),
    );
    yield r'last';
    yield object.last == null
        ? null
        : serializers.serialize(
            object.last,
            specifiedType: const FullType.nullable(
              AdminCustomerDtoOutputOrdersLast,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputOrders object, {
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
    required AdminCustomerDtoOutputOrdersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'count':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.count = valueDes;
          break;
        case r'spent':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCustomerDtoOutputOrdersSpentInner),
                    ]),
                  )
                  as BuiltList<AdminCustomerDtoOutputOrdersSpentInner>;
          result.spent.replace(valueDes);
          break;
        case r'last':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCustomerDtoOutputOrdersLast,
                    ),
                  )
                  as AdminCustomerDtoOutputOrdersLast?;
          if (valueDes == null) continue;
          result.last.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCustomerDtoOutputOrders deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCustomerDtoOutputOrdersBuilder();
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
