//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_new_address_dto_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_place_order_dto_unsaved_address.g.dart';

/// «التوصيل إلى موقعي الحالي»: an address for this order only (CU §7.4), or null.
///
/// Properties:
/// * [location]
/// * [street] - «الشارع والبناء».
/// * [floor] - «الطابق والشقة», optional.
/// * [landmark] - «بالقرب من».
/// * [contactPhone] - The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
/// * [recipientName] - «اسم المستلم», needed with another contact number (Q5).
/// * [directions] - «توجيهات للكابتن», optional.
@BuiltValue()
abstract class CustomerPlaceOrderDtoUnsavedAddress
    implements
        Built<
          CustomerPlaceOrderDtoUnsavedAddress,
          CustomerPlaceOrderDtoUnsavedAddressBuilder
        > {
  @BuiltValueField(wireName: r'location')
  CustomerNewAddressDtoLocation get location;

  /// «الشارع والبناء».
  @BuiltValueField(wireName: r'street')
  String get street;

  /// «الطابق والشقة», optional.
  @BuiltValueField(wireName: r'floor')
  String? get floor;

  /// «بالقرب من».
  @BuiltValueField(wireName: r'landmark')
  String get landmark;

  /// The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
  @BuiltValueField(wireName: r'contactPhone')
  String? get contactPhone;

  /// «اسم المستلم», needed with another contact number (Q5).
  @BuiltValueField(wireName: r'recipientName')
  String? get recipientName;

  /// «توجيهات للكابتن», optional.
  @BuiltValueField(wireName: r'directions')
  String? get directions;

  CustomerPlaceOrderDtoUnsavedAddress._();

  factory CustomerPlaceOrderDtoUnsavedAddress([
    void updates(CustomerPlaceOrderDtoUnsavedAddressBuilder b),
  ]) = _$CustomerPlaceOrderDtoUnsavedAddress;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerPlaceOrderDtoUnsavedAddressBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerPlaceOrderDtoUnsavedAddress> get serializer =>
      _$CustomerPlaceOrderDtoUnsavedAddressSerializer();
}

class _$CustomerPlaceOrderDtoUnsavedAddressSerializer
    implements PrimitiveSerializer<CustomerPlaceOrderDtoUnsavedAddress> {
  @override
  final Iterable<Type> types = const [
    CustomerPlaceOrderDtoUnsavedAddress,
    _$CustomerPlaceOrderDtoUnsavedAddress,
  ];

  @override
  final String wireName = r'CustomerPlaceOrderDtoUnsavedAddress';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerPlaceOrderDtoUnsavedAddress object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(CustomerNewAddressDtoLocation),
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
    yield r'contactPhone';
    yield object.contactPhone == null
        ? null
        : serializers.serialize(
            object.contactPhone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'recipientName';
    yield object.recipientName == null
        ? null
        : serializers.serialize(
            object.recipientName,
            specifiedType: const FullType.nullable(String),
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
    CustomerPlaceOrderDtoUnsavedAddress object, {
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
    required CustomerPlaceOrderDtoUnsavedAddressBuilder result,
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
                      CustomerNewAddressDtoLocation,
                    ),
                  )
                  as CustomerNewAddressDtoLocation;
          result.location.replace(valueDes);
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
        case r'contactPhone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.contactPhone = valueDes;
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
  CustomerPlaceOrderDtoUnsavedAddress deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerPlaceOrderDtoUnsavedAddressBuilder();
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
