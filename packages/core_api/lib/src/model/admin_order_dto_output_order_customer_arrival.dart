//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_dto_output_order_customer_arrival_away.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_customer_arrival.g.dart';

/// The captain at the customer (CA §9.6).
///
/// Properties:
/// * [at] 
/// * [away] 
@BuiltValue()
abstract class AdminOrderDtoOutputOrderCustomerArrival implements Built<AdminOrderDtoOutputOrderCustomerArrival, AdminOrderDtoOutputOrderCustomerArrivalBuilder> {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'away')
  AdminOrderDtoOutputOrderCustomerArrivalAway? get away;

  AdminOrderDtoOutputOrderCustomerArrival._();

  factory AdminOrderDtoOutputOrderCustomerArrival([void updates(AdminOrderDtoOutputOrderCustomerArrivalBuilder b)]) = _$AdminOrderDtoOutputOrderCustomerArrival;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderCustomerArrivalBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderCustomerArrival> get serializer => _$AdminOrderDtoOutputOrderCustomerArrivalSerializer();
}

class _$AdminOrderDtoOutputOrderCustomerArrivalSerializer implements PrimitiveSerializer<AdminOrderDtoOutputOrderCustomerArrival> {
  @override
  final Iterable<Type> types = const [AdminOrderDtoOutputOrderCustomerArrival, _$AdminOrderDtoOutputOrderCustomerArrival];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderCustomerArrival';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderCustomerArrival object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'away';
    yield object.away == null ? null : serializers.serialize(
      object.away,
      specifiedType: const FullType.nullable(AdminOrderDtoOutputOrderCustomerArrivalAway),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderCustomerArrival object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminOrderDtoOutputOrderCustomerArrivalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.at = valueDes;
          break;
        case r'away':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(AdminOrderDtoOutputOrderCustomerArrivalAway),
          ) as AdminOrderDtoOutputOrderCustomerArrivalAway?;
          if (valueDes == null) continue;
          result.away.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderCustomerArrival deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderCustomerArrivalBuilder();
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


