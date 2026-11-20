//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_dto_output_today_orders.g.dart';

/// AdminDashboardDtoOutputTodayOrders
///
/// Properties:
/// * [placed]
/// * [delivered]
/// * [inProgress] - Placed to arrived now.
/// * [cancelled]
/// * [rejected]
/// * [failed]
/// * [deliveryMinutes] - Of the delivered: placing to delivery, one decimal.
/// * [onTimeBp] - Of the delivered: at or before the promised time.
/// * [successBp] - Delivered ÷ placed.
/// * [firstOrders]
@BuiltValue()
abstract class AdminDashboardDtoOutputTodayOrders
    implements
        Built<
          AdminDashboardDtoOutputTodayOrders,
          AdminDashboardDtoOutputTodayOrdersBuilder
        > {
  @BuiltValueField(wireName: r'placed')
  int get placed;

  @BuiltValueField(wireName: r'delivered')
  int get delivered;

  /// Placed to arrived now.
  @BuiltValueField(wireName: r'inProgress')
  int get inProgress;

  @BuiltValueField(wireName: r'cancelled')
  int get cancelled;

  @BuiltValueField(wireName: r'rejected')
  int get rejected;

  @BuiltValueField(wireName: r'failed')
  int get failed;

  /// Of the delivered: placing to delivery, one decimal.
  @BuiltValueField(wireName: r'deliveryMinutes')
  num? get deliveryMinutes;

  /// Of the delivered: at or before the promised time.
  @BuiltValueField(wireName: r'onTimeBp')
  int? get onTimeBp;

  /// Delivered ÷ placed.
  @BuiltValueField(wireName: r'successBp')
  int? get successBp;

  @BuiltValueField(wireName: r'firstOrders')
  int get firstOrders;

  AdminDashboardDtoOutputTodayOrders._();

  factory AdminDashboardDtoOutputTodayOrders([
    void updates(AdminDashboardDtoOutputTodayOrdersBuilder b),
  ]) = _$AdminDashboardDtoOutputTodayOrders;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardDtoOutputTodayOrdersBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardDtoOutputTodayOrders> get serializer =>
      _$AdminDashboardDtoOutputTodayOrdersSerializer();
}

class _$AdminDashboardDtoOutputTodayOrdersSerializer
    implements PrimitiveSerializer<AdminDashboardDtoOutputTodayOrders> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardDtoOutputTodayOrders,
    _$AdminDashboardDtoOutputTodayOrders,
  ];

  @override
  final String wireName = r'AdminDashboardDtoOutputTodayOrders';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardDtoOutputTodayOrders object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'placed';
    yield serializers.serialize(
      object.placed,
      specifiedType: const FullType(int),
    );
    yield r'delivered';
    yield serializers.serialize(
      object.delivered,
      specifiedType: const FullType(int),
    );
    yield r'inProgress';
    yield serializers.serialize(
      object.inProgress,
      specifiedType: const FullType(int),
    );
    yield r'cancelled';
    yield serializers.serialize(
      object.cancelled,
      specifiedType: const FullType(int),
    );
    yield r'rejected';
    yield serializers.serialize(
      object.rejected,
      specifiedType: const FullType(int),
    );
    yield r'failed';
    yield serializers.serialize(
      object.failed,
      specifiedType: const FullType(int),
    );
    yield r'deliveryMinutes';
    yield object.deliveryMinutes == null
        ? null
        : serializers.serialize(
            object.deliveryMinutes,
            specifiedType: const FullType.nullable(num),
          );
    yield r'onTimeBp';
    yield object.onTimeBp == null
        ? null
        : serializers.serialize(
            object.onTimeBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'successBp';
    yield object.successBp == null
        ? null
        : serializers.serialize(
            object.successBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'firstOrders';
    yield serializers.serialize(
      object.firstOrders,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardDtoOutputTodayOrders object, {
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
    required AdminDashboardDtoOutputTodayOrdersBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'placed':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.placed = valueDes;
          break;
        case r'delivered':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.delivered = valueDes;
          break;
        case r'inProgress':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.inProgress = valueDes;
          break;
        case r'cancelled':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.cancelled = valueDes;
          break;
        case r'rejected':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.rejected = valueDes;
          break;
        case r'failed':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.failed = valueDes;
          break;
        case r'deliveryMinutes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.deliveryMinutes = valueDes;
          break;
        case r'onTimeBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.onTimeBp = valueDes;
          break;
        case r'successBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.successBp = valueDes;
          break;
        case r'firstOrders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.firstOrders = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardDtoOutputTodayOrders deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardDtoOutputTodayOrdersBuilder();
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
