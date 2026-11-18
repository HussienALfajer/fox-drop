//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customer_dto_output_addresses_inner_location.dart';
import 'package:core_api/src/model/captain_order_route_dto_output_route.dart';
import 'package:core_api/src/model/customer_order_route_dto_output_captain.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_order_route_dto_output.g.dart';

/// CustomerOrderRouteDtoOutput
///
/// Properties:
/// * [captain]
/// * [destination]
/// * [route]
@BuiltValue()
abstract class CustomerOrderRouteDtoOutput
    implements
        Built<CustomerOrderRouteDtoOutput, CustomerOrderRouteDtoOutputBuilder> {
  @BuiltValueField(wireName: r'captain')
  CustomerOrderRouteDtoOutputCaptain? get captain;

  @BuiltValueField(wireName: r'destination')
  AdminCustomerDtoOutputAddressesInnerLocation get destination;

  @BuiltValueField(wireName: r'route')
  CaptainOrderRouteDtoOutputRoute? get route;

  CustomerOrderRouteDtoOutput._();

  factory CustomerOrderRouteDtoOutput([
    void updates(CustomerOrderRouteDtoOutputBuilder b),
  ]) = _$CustomerOrderRouteDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerOrderRouteDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerOrderRouteDtoOutput> get serializer =>
      _$CustomerOrderRouteDtoOutputSerializer();
}

class _$CustomerOrderRouteDtoOutputSerializer
    implements PrimitiveSerializer<CustomerOrderRouteDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerOrderRouteDtoOutput,
    _$CustomerOrderRouteDtoOutput,
  ];

  @override
  final String wireName = r'CustomerOrderRouteDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerOrderRouteDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captain';
    yield object.captain == null
        ? null
        : serializers.serialize(
            object.captain,
            specifiedType: const FullType.nullable(
              CustomerOrderRouteDtoOutputCaptain,
            ),
          );
    yield r'destination';
    yield serializers.serialize(
      object.destination,
      specifiedType: const FullType(
        AdminCustomerDtoOutputAddressesInnerLocation,
      ),
    );
    yield r'route';
    yield object.route == null
        ? null
        : serializers.serialize(
            object.route,
            specifiedType: const FullType.nullable(
              CaptainOrderRouteDtoOutputRoute,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerOrderRouteDtoOutput object, {
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
    required CustomerOrderRouteDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captain':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerOrderRouteDtoOutputCaptain,
                    ),
                  )
                  as CustomerOrderRouteDtoOutputCaptain?;
          if (valueDes == null) continue;
          result.captain.replace(valueDes);
          break;
        case r'destination':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCustomerDtoOutputAddressesInnerLocation,
                    ),
                  )
                  as AdminCustomerDtoOutputAddressesInnerLocation;
          result.destination.replace(valueDes);
          break;
        case r'route':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainOrderRouteDtoOutputRoute,
                    ),
                  )
                  as CaptainOrderRouteDtoOutputRoute?;
          if (valueDes == null) continue;
          result.route.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerOrderRouteDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerOrderRouteDtoOutputBuilder();
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
