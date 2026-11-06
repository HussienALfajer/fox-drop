//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_new_address_dto_location.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_address_fields_dto.g.dart';

/// CustomerAddressFieldsDto
///
/// Properties:
/// * [location]
/// * [label] - «البيت», «العمل» or «آخر».
/// * [customLabel] - The name of an «آخر» address; null otherwise.
/// * [street] - «الشارع والبناء».
/// * [floor] - «الطابق والشقة», optional.
/// * [landmark] - «بالقرب من».
/// * [contactPhone] - The mobile number in E.164: +9639xxxxxxxx or +905xxxxxxxxx.
/// * [recipientName] - «اسم المستلم», needed with another contact number (Q5).
/// * [directions] - «توجيهات للكابتن», optional.
@BuiltValue()
abstract class CustomerAddressFieldsDto
    implements
        Built<CustomerAddressFieldsDto, CustomerAddressFieldsDtoBuilder> {
  @BuiltValueField(wireName: r'location')
  CustomerNewAddressDtoLocation get location;

  /// «البيت», «العمل» or «آخر».
  @BuiltValueField(wireName: r'label')
  CustomerAddressFieldsDtoLabelEnum get label;
  // enum labelEnum {  home,  work,  other,  };

  /// The name of an «آخر» address; null otherwise.
  @BuiltValueField(wireName: r'customLabel')
  String? get customLabel;

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

  CustomerAddressFieldsDto._();

  factory CustomerAddressFieldsDto([
    void updates(CustomerAddressFieldsDtoBuilder b),
  ]) = _$CustomerAddressFieldsDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerAddressFieldsDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerAddressFieldsDto> get serializer =>
      _$CustomerAddressFieldsDtoSerializer();
}

class _$CustomerAddressFieldsDtoSerializer
    implements PrimitiveSerializer<CustomerAddressFieldsDto> {
  @override
  final Iterable<Type> types = const [
    CustomerAddressFieldsDto,
    _$CustomerAddressFieldsDto,
  ];

  @override
  final String wireName = r'CustomerAddressFieldsDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerAddressFieldsDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(CustomerNewAddressDtoLocation),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(CustomerAddressFieldsDtoLabelEnum),
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
    CustomerAddressFieldsDto object, {
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
    required CustomerAddressFieldsDtoBuilder result,
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
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerAddressFieldsDtoLabelEnum,
                    ),
                  )
                  as CustomerAddressFieldsDtoLabelEnum;
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
  CustomerAddressFieldsDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerAddressFieldsDtoBuilder();
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

/// «البيت», «العمل» or «آخر».
class CustomerAddressFieldsDtoLabelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'home')
  static const CustomerAddressFieldsDtoLabelEnum home =
      _$customerAddressFieldsDtoLabelEnum_home;
  @BuiltValueEnumConst(wireName: r'work')
  static const CustomerAddressFieldsDtoLabelEnum work =
      _$customerAddressFieldsDtoLabelEnum_work;
  @BuiltValueEnumConst(wireName: r'other')
  static const CustomerAddressFieldsDtoLabelEnum other =
      _$customerAddressFieldsDtoLabelEnum_other;

  static Serializer<CustomerAddressFieldsDtoLabelEnum> get serializer =>
      _$customerAddressFieldsDtoLabelEnumSerializer;

  const CustomerAddressFieldsDtoLabelEnum._(String name) : super(name);

  static BuiltSet<CustomerAddressFieldsDtoLabelEnum> get values =>
      _$customerAddressFieldsDtoLabelEnumValues;
  static CustomerAddressFieldsDtoLabelEnum valueOf(String name) =>
      _$customerAddressFieldsDtoLabelEnumValueOf(name);
}
