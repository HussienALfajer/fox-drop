//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_order_dto_output_order_customer_arrival.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_customer_address.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_customer.g.dart';

/// The phone, masked and revealed with a log (AP §5.4), comes with its slice.
///
/// Properties:
/// * [name] - Null before «أكمل بياناتك» (CU §5.3).
/// * [address]
/// * [recipientName]
/// * [payIn] - «سأدفع بـ».
/// * [arrival]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderCustomer
    implements
        Built<
          AdminOrderDtoOutputOrderCustomer,
          AdminOrderDtoOutputOrderCustomerBuilder
        > {
  /// Null before «أكمل بياناتك» (CU §5.3).
  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'address')
  AdminOrderDtoOutputOrderCustomerAddress get address;

  @BuiltValueField(wireName: r'recipientName')
  String? get recipientName;

  /// «سأدفع بـ».
  @BuiltValueField(wireName: r'payIn')
  String? get payIn;

  @BuiltValueField(wireName: r'arrival')
  AdminOrderDtoOutputOrderCustomerArrival? get arrival;

  AdminOrderDtoOutputOrderCustomer._();

  factory AdminOrderDtoOutputOrderCustomer([
    void updates(AdminOrderDtoOutputOrderCustomerBuilder b),
  ]) = _$AdminOrderDtoOutputOrderCustomer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderCustomerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderCustomer> get serializer =>
      _$AdminOrderDtoOutputOrderCustomerSerializer();
}

class _$AdminOrderDtoOutputOrderCustomerSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderCustomer> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderCustomer,
    _$AdminOrderDtoOutputOrderCustomer,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderCustomer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderCustomer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield object.name == null
        ? null
        : serializers.serialize(
            object.name,
            specifiedType: const FullType.nullable(String),
          );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(AdminOrderDtoOutputOrderCustomerAddress),
    );
    yield r'recipientName';
    yield object.recipientName == null
        ? null
        : serializers.serialize(
            object.recipientName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'payIn';
    yield object.payIn == null
        ? null
        : serializers.serialize(
            object.payIn,
            specifiedType: const FullType.nullable(String),
          );
    yield r'arrival';
    yield object.arrival == null
        ? null
        : serializers.serialize(
            object.arrival,
            specifiedType: const FullType.nullable(
              AdminOrderDtoOutputOrderCustomerArrival,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderCustomer object, {
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
    required AdminOrderDtoOutputOrderCustomerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'address':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderDtoOutputOrderCustomerAddress,
                    ),
                  )
                  as AdminOrderDtoOutputOrderCustomerAddress;
          result.address.replace(valueDes);
          break;
        case r'recipientName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.recipientName = valueDes;
          break;
        case r'payIn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.payIn = valueDes;
          break;
        case r'arrival':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminOrderDtoOutputOrderCustomerArrival,
                    ),
                  )
                  as AdminOrderDtoOutputOrderCustomerArrival?;
          if (valueDes == null) continue;
          result.arrival.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderCustomer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderCustomerBuilder();
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
