//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_dashboard_dto_output_today_orders.dart';
import 'package:core_api/src/model/admin_dashboard_dto_output_today_money.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_dto_output_today.g.dart';

/// AdminDashboardDtoOutputToday
///
/// Properties:
/// * [from] - The business day’s cutoff.
/// * [until] - Today: now; last week: the same moment of its day.
/// * [orders]
/// * [money]
/// * [newCustomers] - Accounts registered, every city’s.
@BuiltValue()
abstract class AdminDashboardDtoOutputToday
    implements
        Built<
          AdminDashboardDtoOutputToday,
          AdminDashboardDtoOutputTodayBuilder
        > {
  /// The business day’s cutoff.
  @BuiltValueField(wireName: r'from')
  DateTime get from;

  /// Today: now; last week: the same moment of its day.
  @BuiltValueField(wireName: r'until')
  DateTime get until;

  @BuiltValueField(wireName: r'orders')
  AdminDashboardDtoOutputTodayOrders get orders;

  @BuiltValueField(wireName: r'money')
  AdminDashboardDtoOutputTodayMoney? get money;

  /// Accounts registered, every city’s.
  @BuiltValueField(wireName: r'newCustomers')
  int get newCustomers;

  AdminDashboardDtoOutputToday._();

  factory AdminDashboardDtoOutputToday([
    void updates(AdminDashboardDtoOutputTodayBuilder b),
  ]) = _$AdminDashboardDtoOutputToday;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardDtoOutputTodayBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardDtoOutputToday> get serializer =>
      _$AdminDashboardDtoOutputTodaySerializer();
}

class _$AdminDashboardDtoOutputTodaySerializer
    implements PrimitiveSerializer<AdminDashboardDtoOutputToday> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardDtoOutputToday,
    _$AdminDashboardDtoOutputToday,
  ];

  @override
  final String wireName = r'AdminDashboardDtoOutputToday';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardDtoOutputToday object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(DateTime),
    );
    yield r'until';
    yield serializers.serialize(
      object.until,
      specifiedType: const FullType(DateTime),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(AdminDashboardDtoOutputTodayOrders),
    );
    yield r'money';
    yield object.money == null
        ? null
        : serializers.serialize(
            object.money,
            specifiedType: const FullType.nullable(
              AdminDashboardDtoOutputTodayMoney,
            ),
          );
    yield r'newCustomers';
    yield serializers.serialize(
      object.newCustomers,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardDtoOutputToday object, {
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
    required AdminDashboardDtoOutputTodayBuilder result,
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
        case r'until':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.until = valueDes;
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDashboardDtoOutputTodayOrders,
                    ),
                  )
                  as AdminDashboardDtoOutputTodayOrders;
          result.orders.replace(valueDes);
          break;
        case r'money':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminDashboardDtoOutputTodayMoney,
                    ),
                  )
                  as AdminDashboardDtoOutputTodayMoney?;
          if (valueDes == null) continue;
          result.money.replace(valueDes);
          break;
        case r'newCustomers':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.newCustomers = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardDtoOutputToday deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardDtoOutputTodayBuilder();
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
