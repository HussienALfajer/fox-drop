//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_dashboard_dto_output_status_restaurants.dart';
import 'package:core_api/src/model/admin_dashboard_dto_output_status_captains.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_dashboard_dto_output_status.g.dart';

/// AdminDashboardDtoOutputStatus
///
/// Properties:
/// * [captains]
/// * [restaurants]
/// * [withoutDevice] - Open or busy restaurants with no receiving device now (RA §4.6).
@BuiltValue()
abstract class AdminDashboardDtoOutputStatus
    implements
        Built<
          AdminDashboardDtoOutputStatus,
          AdminDashboardDtoOutputStatusBuilder
        > {
  @BuiltValueField(wireName: r'captains')
  AdminDashboardDtoOutputStatusCaptains get captains;

  @BuiltValueField(wireName: r'restaurants')
  AdminDashboardDtoOutputStatusRestaurants get restaurants;

  /// Open or busy restaurants with no receiving device now (RA §4.6).
  @BuiltValueField(wireName: r'withoutDevice')
  int get withoutDevice;

  AdminDashboardDtoOutputStatus._();

  factory AdminDashboardDtoOutputStatus([
    void updates(AdminDashboardDtoOutputStatusBuilder b),
  ]) = _$AdminDashboardDtoOutputStatus;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDashboardDtoOutputStatusBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDashboardDtoOutputStatus> get serializer =>
      _$AdminDashboardDtoOutputStatusSerializer();
}

class _$AdminDashboardDtoOutputStatusSerializer
    implements PrimitiveSerializer<AdminDashboardDtoOutputStatus> {
  @override
  final Iterable<Type> types = const [
    AdminDashboardDtoOutputStatus,
    _$AdminDashboardDtoOutputStatus,
  ];

  @override
  final String wireName = r'AdminDashboardDtoOutputStatus';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDashboardDtoOutputStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captains';
    yield serializers.serialize(
      object.captains,
      specifiedType: const FullType(AdminDashboardDtoOutputStatusCaptains),
    );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(AdminDashboardDtoOutputStatusRestaurants),
    );
    yield r'withoutDevice';
    yield serializers.serialize(
      object.withoutDevice,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDashboardDtoOutputStatus object, {
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
    required AdminDashboardDtoOutputStatusBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captains':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDashboardDtoOutputStatusCaptains,
                    ),
                  )
                  as AdminDashboardDtoOutputStatusCaptains;
          result.captains.replace(valueDes);
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDashboardDtoOutputStatusRestaurants,
                    ),
                  )
                  as AdminDashboardDtoOutputStatusRestaurants;
          result.restaurants.replace(valueDes);
          break;
        case r'withoutDevice':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.withoutDevice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDashboardDtoOutputStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDashboardDtoOutputStatusBuilder();
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
