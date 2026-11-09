//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_restaurant_page_dto_output_schedule_inner.g.dart';

/// CustomerRestaurantPageDtoOutputScheduleInner
///
/// Properties:
/// * [weekday] - 0 Sunday to 6 Saturday.
/// * [opensAt] - Minutes after midnight on the city clock.
/// * [closesAt] - Not after opensAt: crosses midnight.
@BuiltValue()
abstract class CustomerRestaurantPageDtoOutputScheduleInner implements Built<CustomerRestaurantPageDtoOutputScheduleInner, CustomerRestaurantPageDtoOutputScheduleInnerBuilder> {
  /// 0 Sunday to 6 Saturday.
  @BuiltValueField(wireName: r'weekday')
  int get weekday;

  /// Minutes after midnight on the city clock.
  @BuiltValueField(wireName: r'opensAt')
  int get opensAt;

  /// Not after opensAt: crosses midnight.
  @BuiltValueField(wireName: r'closesAt')
  int get closesAt;

  CustomerRestaurantPageDtoOutputScheduleInner._();

  factory CustomerRestaurantPageDtoOutputScheduleInner([void updates(CustomerRestaurantPageDtoOutputScheduleInnerBuilder b)]) = _$CustomerRestaurantPageDtoOutputScheduleInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRestaurantPageDtoOutputScheduleInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRestaurantPageDtoOutputScheduleInner> get serializer => _$CustomerRestaurantPageDtoOutputScheduleInnerSerializer();
}

class _$CustomerRestaurantPageDtoOutputScheduleInnerSerializer implements PrimitiveSerializer<CustomerRestaurantPageDtoOutputScheduleInner> {
  @override
  final Iterable<Type> types = const [CustomerRestaurantPageDtoOutputScheduleInner, _$CustomerRestaurantPageDtoOutputScheduleInner];

  @override
  final String wireName = r'CustomerRestaurantPageDtoOutputScheduleInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRestaurantPageDtoOutputScheduleInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'weekday';
    yield serializers.serialize(
      object.weekday,
      specifiedType: const FullType(int),
    );
    yield r'opensAt';
    yield serializers.serialize(
      object.opensAt,
      specifiedType: const FullType(int),
    );
    yield r'closesAt';
    yield serializers.serialize(
      object.closesAt,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantPageDtoOutputScheduleInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerRestaurantPageDtoOutputScheduleInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'weekday':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.weekday = valueDes;
          break;
        case r'opensAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.opensAt = valueDes;
          break;
        case r'closesAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.closesAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRestaurantPageDtoOutputScheduleInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRestaurantPageDtoOutputScheduleInnerBuilder();
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


