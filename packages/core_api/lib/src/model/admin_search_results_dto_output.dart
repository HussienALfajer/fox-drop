//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_search_results_dto_output_tickets_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_search_results_dto_output_customers_inner.dart';
import 'package:core_api/src/model/admin_search_results_dto_output_orders_inner.dart';
import 'package:core_api/src/model/admin_peak_bonus_dto_output_in_force_windows_inner_zones_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_search_results_dto_output.g.dart';

/// AdminSearchResultsDtoOutput
///
/// Properties:
/// * [orders] - By number, for operations.read.
/// * [restaurants] - By a part of the name, for restaurants.read.
/// * [captains] - By a part of the name or the phone, for captains.read or captains.money.
/// * [tickets] - By number, for support.read.
/// * [customers] - By the phone, for customers.read with customers.reveal_phone (OWN, OPS, SUP).
@BuiltValue()
abstract class AdminSearchResultsDtoOutput
    implements
        Built<AdminSearchResultsDtoOutput, AdminSearchResultsDtoOutputBuilder> {
  /// By number, for operations.read.
  @BuiltValueField(wireName: r'orders')
  BuiltList<AdminSearchResultsDtoOutputOrdersInner> get orders;

  /// By a part of the name, for restaurants.read.
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?>
  get restaurants;

  /// By a part of the name or the phone, for captains.read or captains.money.
  @BuiltValueField(wireName: r'captains')
  BuiltList<AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?> get captains;

  /// By number, for support.read.
  @BuiltValueField(wireName: r'tickets')
  BuiltList<AdminSearchResultsDtoOutputTicketsInner> get tickets;

  /// By the phone, for customers.read with customers.reveal_phone (OWN, OPS, SUP).
  @BuiltValueField(wireName: r'customers')
  BuiltList<AdminSearchResultsDtoOutputCustomersInner> get customers;

  AdminSearchResultsDtoOutput._();

  factory AdminSearchResultsDtoOutput([
    void updates(AdminSearchResultsDtoOutputBuilder b),
  ]) = _$AdminSearchResultsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSearchResultsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSearchResultsDtoOutput> get serializer =>
      _$AdminSearchResultsDtoOutputSerializer();
}

class _$AdminSearchResultsDtoOutputSerializer
    implements PrimitiveSerializer<AdminSearchResultsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminSearchResultsDtoOutput,
    _$AdminSearchResultsDtoOutput,
  ];

  @override
  final String wireName = r'AdminSearchResultsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSearchResultsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSearchResultsDtoOutputOrdersInner),
      ]),
    );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner),
      ]),
    );
    yield r'captains';
    yield serializers.serialize(
      object.captains,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner),
      ]),
    );
    yield r'tickets';
    yield serializers.serialize(
      object.tickets,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSearchResultsDtoOutputTicketsInner),
      ]),
    );
    yield r'customers';
    yield serializers.serialize(
      object.customers,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSearchResultsDtoOutputCustomersInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSearchResultsDtoOutput object, {
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
    required AdminSearchResultsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'orders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSearchResultsDtoOutputOrdersInner),
                    ]),
                  )
                  as BuiltList<AdminSearchResultsDtoOutputOrdersInner>;
          result.orders.replace(valueDes);
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?
                  >;
          result.restaurants.replace(valueDes);
          break;
        case r'captains':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminPeakBonusDtoOutputInForceWindowsInnerZonesInner?
                  >;
          result.captains.replace(valueDes);
          break;
        case r'tickets':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSearchResultsDtoOutputTicketsInner),
                    ]),
                  )
                  as BuiltList<AdminSearchResultsDtoOutputTicketsInner>;
          result.tickets.replace(valueDes);
          break;
        case r'customers':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSearchResultsDtoOutputCustomersInner),
                    ]),
                  )
                  as BuiltList<AdminSearchResultsDtoOutputCustomersInner>;
          result.customers.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSearchResultsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSearchResultsDtoOutputBuilder();
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
