//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_dto_output_status_restaurants.g.dart';

/// AdminDashboardDtoOutputStatusRestaurants
///
/// Properties:
/// * [open]
/// * [busy]
/// * [paused]
/// * [closed]
/// * [holiday]
/// * [suspended]
@BuiltValue()
abstract class AdminDashboardDtoOutputStatusRestaurants
    implements
        Built<
          AdminDashboardDtoOutputStatusRestaurants,
          AdminDashboardDtoOutputStatusRestaurantsBuilder
        > {
  @BuiltValueField(wireName: r'open')
  int get open;

  @BuiltValueField(wireName: r'busy')
  int get busy;

  @BuiltValueField(wireName: r'paused')
  int get paused;

  @BuiltValueField(wireName: r'closed')
  int get closed;

  @BuiltValueField(wireName: r'holiday')
  int get holiday;

  @BuiltValueField(wireName: r'suspended')
  int get suspended;

  AdminDashboardDtoOutputStatusRestaurants._();

  factory AdminDashboardDtoOutputStatusRestaurants([
    void updates(AdminDashboardDtoOutputStatusRestaurantsBuilder b),
  ]) = _$AdminDashboardDtoOutputStatusRestaurants;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardDtoOutputStatusRestaurantsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardDtoOutputStatusRestaurants> get serializer =>
      _$AdminDashboardDtoOutputStatusRestaurantsSerializer();
}

class _$AdminDashboardDtoOutputStatusRestaurantsSerializer
    implements PrimitiveSerializer<AdminDashboardDtoOutputStatusRestaurants> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardDtoOutputStatusRestaurants,
    _$AdminDashboardDtoOutputStatusRestaurants,
  ];

  @override
  final String wireName = r'AdminDashboardDtoOutputStatusRestaurants';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardDtoOutputStatusRestaurants object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'open';
    yield serializers.serialize(
      object.open,
      specifiedType: const FullType(int),
    );
    yield r'busy';
    yield serializers.serialize(
      object.busy,
      specifiedType: const FullType(int),
    );
    yield r'paused';
    yield serializers.serialize(
      object.paused,
      specifiedType: const FullType(int),
    );
    yield r'closed';
    yield serializers.serialize(
      object.closed,
      specifiedType: const FullType(int),
    );
    yield r'holiday';
    yield serializers.serialize(
      object.holiday,
      specifiedType: const FullType(int),
    );
    yield r'suspended';
    yield serializers.serialize(
      object.suspended,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardDtoOutputStatusRestaurants object, {
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
    required AdminDashboardDtoOutputStatusRestaurantsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'open':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.open = valueDes;
          break;
        case r'busy':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.busy = valueDes;
          break;
        case r'paused':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.paused = valueDes;
          break;
        case r'closed':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.closed = valueDes;
          break;
        case r'holiday':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.holiday = valueDes;
          break;
        case r'suspended':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.suspended = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardDtoOutputStatusRestaurants deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardDtoOutputStatusRestaurantsBuilder();
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
