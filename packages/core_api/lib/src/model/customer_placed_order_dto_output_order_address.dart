//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_placed_order_dto_output_order_address_location.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_placed_order_dto_output_order_address.g.dart';

/// CustomerPlacedOrderDtoOutputOrderAddress
///
/// Properties:
/// * [location]
/// * [neighbourhood] - «الحي» at placing.
/// * [label] - Null for an unsaved one.
/// * [customLabel]
/// * [street]
/// * [floor]
/// * [landmark]
/// * [recipientName]
/// * [directions]
@BuiltValue()
abstract class CustomerPlacedOrderDtoOutputOrderAddress
    implements
        Built<
          CustomerPlacedOrderDtoOutputOrderAddress,
          CustomerPlacedOrderDtoOutputOrderAddressBuilder
        > {
  @BuiltValueField(wireName: r'location')
  CustomerPlacedOrderDtoOutputOrderAddressLocation get location;

  /// «الحي» at placing.
  @BuiltValueField(wireName: r'neighbourhood')
  String get neighbourhood;

  /// Null for an unsaved one.
  @BuiltValueField(wireName: r'label')
  CustomerPlacedOrderDtoOutputOrderAddressLabelEnum? get label;
  // enum labelEnum {  home,  work,  other,  };

  @BuiltValueField(wireName: r'customLabel')
  String? get customLabel;

  @BuiltValueField(wireName: r'street')
  String get street;

  @BuiltValueField(wireName: r'floor')
  String? get floor;

  @BuiltValueField(wireName: r'landmark')
  String get landmark;

  @BuiltValueField(wireName: r'recipientName')
  String? get recipientName;

  @BuiltValueField(wireName: r'directions')
  String? get directions;

  CustomerPlacedOrderDtoOutputOrderAddress._();

  factory CustomerPlacedOrderDtoOutputOrderAddress([
    void updates(CustomerPlacedOrderDtoOutputOrderAddressBuilder b),
  ]) = _$CustomerPlacedOrderDtoOutputOrderAddress;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerPlacedOrderDtoOutputOrderAddressBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerPlacedOrderDtoOutputOrderAddress> get serializer =>
      _$CustomerPlacedOrderDtoOutputOrderAddressSerializer();
}

class _$CustomerPlacedOrderDtoOutputOrderAddressSerializer
    implements PrimitiveSerializer<CustomerPlacedOrderDtoOutputOrderAddress> {
  @override
  final Iterable<Type> types = const [
    CustomerPlacedOrderDtoOutputOrderAddress,
    _$CustomerPlacedOrderDtoOutputOrderAddress,
  ];

  @override
  final String wireName = r'CustomerPlacedOrderDtoOutputOrderAddress';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerPlacedOrderDtoOutputOrderAddress object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(
        CustomerPlacedOrderDtoOutputOrderAddressLocation,
      ),
    );
    yield r'neighbourhood';
    yield serializers.serialize(
      object.neighbourhood,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield object.label == null
        ? null
        : serializers.serialize(
            object.label,
            specifiedType: const FullType.nullable(
              CustomerPlacedOrderDtoOutputOrderAddressLabelEnum,
            ),
          );
    yield r'customLabel';
    yield object.customLabel == null
        ? null
        : serializers.serialize(
            object.customLabel,
            specifiedType: const FullType.nullable(String),
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
    CustomerPlacedOrderDtoOutputOrderAddress object, {
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
    required CustomerPlacedOrderDtoOutputOrderAddressBuilder result,
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
                      CustomerPlacedOrderDtoOutputOrderAddressLocation,
                    ),
                  )
                  as CustomerPlacedOrderDtoOutputOrderAddressLocation;
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
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerPlacedOrderDtoOutputOrderAddressLabelEnum,
                    ),
                  )
                  as CustomerPlacedOrderDtoOutputOrderAddressLabelEnum?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'customLabel':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.customLabel = valueDes;
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
  CustomerPlacedOrderDtoOutputOrderAddress deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerPlacedOrderDtoOutputOrderAddressBuilder();
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

/// Null for an unsaved one.
class CustomerPlacedOrderDtoOutputOrderAddressLabelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'home')
  static const CustomerPlacedOrderDtoOutputOrderAddressLabelEnum home =
      _$customerPlacedOrderDtoOutputOrderAddressLabelEnum_home;
  @BuiltValueEnumConst(wireName: r'work')
  static const CustomerPlacedOrderDtoOutputOrderAddressLabelEnum work =
      _$customerPlacedOrderDtoOutputOrderAddressLabelEnum_work;
  @BuiltValueEnumConst(wireName: r'other')
  static const CustomerPlacedOrderDtoOutputOrderAddressLabelEnum other =
      _$customerPlacedOrderDtoOutputOrderAddressLabelEnum_other;

  static Serializer<CustomerPlacedOrderDtoOutputOrderAddressLabelEnum>
  get serializer =>
      _$customerPlacedOrderDtoOutputOrderAddressLabelEnumSerializer;

  const CustomerPlacedOrderDtoOutputOrderAddressLabelEnum._(String name)
    : super(name);

  static BuiltSet<CustomerPlacedOrderDtoOutputOrderAddressLabelEnum>
  get values => _$customerPlacedOrderDtoOutputOrderAddressLabelEnumValues;
  static CustomerPlacedOrderDtoOutputOrderAddressLabelEnum valueOf(
    String name,
  ) => _$customerPlacedOrderDtoOutputOrderAddressLabelEnumValueOf(name);
}
