//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_address_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_customer_address.g.dart';

/// AdminOrderDtoOutputOrderCustomerAddress
///
/// Properties:
/// * [location]
/// * [neighbourhood]
/// * [street]
/// * [floor]
/// * [landmark]
/// * [directions]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderCustomerAddress
    implements
        Built<
          AdminOrderDtoOutputOrderCustomerAddress,
          AdminOrderDtoOutputOrderCustomerAddressBuilder
        > {
  @BuiltValueField(wireName: r'location')
  CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation get location;

  @BuiltValueField(wireName: r'neighbourhood')
  String get neighbourhood;

  @BuiltValueField(wireName: r'street')
  String get street;

  @BuiltValueField(wireName: r'floor')
  String? get floor;

  @BuiltValueField(wireName: r'landmark')
  String get landmark;

  @BuiltValueField(wireName: r'directions')
  String? get directions;

  AdminOrderDtoOutputOrderCustomerAddress._();

  factory AdminOrderDtoOutputOrderCustomerAddress([
    void updates(AdminOrderDtoOutputOrderCustomerAddressBuilder b),
  ]) = _$AdminOrderDtoOutputOrderCustomerAddress;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderCustomerAddressBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderCustomerAddress> get serializer =>
      _$AdminOrderDtoOutputOrderCustomerAddressSerializer();
}

class _$AdminOrderDtoOutputOrderCustomerAddressSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderCustomerAddress> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderCustomerAddress,
    _$AdminOrderDtoOutputOrderCustomerAddress,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderCustomerAddress';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderCustomerAddress object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation,
      ),
    );
    yield r'neighbourhood';
    yield serializers.serialize(
      object.neighbourhood,
      specifiedType: const FullType(String),
    );
    yield r'street';
    yield serializers.serialize(
      object.street,
      specifiedType: const FullType(String),
    );
    yield r'floor';
    yield object.floor == null
        ? null
        : serializers.serialize(
            object.floor,
            specifiedType: const FullType.nullable(String),
          );
    yield r'landmark';
    yield serializers.serialize(
      object.landmark,
      specifiedType: const FullType(String),
    );
    yield r'directions';
    yield object.directions == null
        ? null
        : serializers.serialize(
            object.directions,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderCustomerAddress object, {
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
    required AdminOrderDtoOutputOrderCustomerAddressBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'location':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerAddressLocation;
          result.location.replace(valueDes);
          break;
        case r'neighbourhood':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.neighbourhood = valueDes;
          break;
        case r'street':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.street = valueDes;
          break;
        case r'floor':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.floor = valueDes;
          break;
        case r'landmark':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.landmark = valueDes;
          break;
        case r'directions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.directions = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderCustomerAddress deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderCustomerAddressBuilder();
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
