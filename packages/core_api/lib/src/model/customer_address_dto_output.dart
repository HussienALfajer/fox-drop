//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_address_list_dto_output_addresses_inner_location.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_address_dto_output.g.dart';

/// CustomerAddressDtoOutput
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
/// * [id]
/// * [isDefault]
/// * [neighbourhood] - «الحي», the zone name; null is «خارج منطقة التوصيل حالياً» (Q6).
@BuiltValue()
abstract class CustomerAddressDtoOutput
    implements
        Built<CustomerAddressDtoOutput, CustomerAddressDtoOutputBuilder> {
  @BuiltValueField(wireName: r'location')
  CustomerAddressListDtoOutputAddressesInnerLocation get location;

  /// «البيت», «العمل» or «آخر».
  @BuiltValueField(wireName: r'label')
  CustomerAddressDtoOutputLabelEnum get label;
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

  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'isDefault')
  bool get isDefault;

  /// «الحي», the zone name; null is «خارج منطقة التوصيل حالياً» (Q6).
  @BuiltValueField(wireName: r'neighbourhood')
  BuiltList<String> get neighbourhood;

  CustomerAddressDtoOutput._();

  factory CustomerAddressDtoOutput([
    void updates(CustomerAddressDtoOutputBuilder b),
  ]) = _$CustomerAddressDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerAddressDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerAddressDtoOutput> get serializer =>
      _$CustomerAddressDtoOutputSerializer();
}

class _$CustomerAddressDtoOutputSerializer
    implements PrimitiveSerializer<CustomerAddressDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerAddressDtoOutput,
    _$CustomerAddressDtoOutput,
  ];

  @override
  final String wireName = r'CustomerAddressDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerAddressDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'location';
    yield serializers.serialize(
      object.location,
      specifiedType: const FullType(
        CustomerAddressListDtoOutputAddressesInnerLocation,
      ),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(CustomerAddressDtoOutputLabelEnum),
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
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'isDefault';
    yield serializers.serialize(
      object.isDefault,
      specifiedType: const FullType(bool),
    );
    yield r'neighbourhood';
    yield serializers.serialize(
      object.neighbourhood,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerAddressDtoOutput object, {
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
    required CustomerAddressDtoOutputBuilder result,
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
                      CustomerAddressListDtoOutputAddressesInnerLocation,
                    ),
                  )
                  as CustomerAddressListDtoOutputAddressesInnerLocation;
          result.location.replace(valueDes);
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerAddressDtoOutputLabelEnum,
                    ),
                  )
                  as CustomerAddressDtoOutputLabelEnum;
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
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'isDefault':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.isDefault = valueDes;
          break;
        case r'neighbourhood':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.neighbourhood.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerAddressDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerAddressDtoOutputBuilder();
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
class CustomerAddressDtoOutputLabelEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'home')
  static const CustomerAddressDtoOutputLabelEnum home =
      _$customerAddressDtoOutputLabelEnum_home;
  @BuiltValueEnumConst(wireName: r'work')
  static const CustomerAddressDtoOutputLabelEnum work =
      _$customerAddressDtoOutputLabelEnum_work;
  @BuiltValueEnumConst(wireName: r'other')
  static const CustomerAddressDtoOutputLabelEnum other =
      _$customerAddressDtoOutputLabelEnum_other;

  static Serializer<CustomerAddressDtoOutputLabelEnum> get serializer =>
      _$customerAddressDtoOutputLabelEnumSerializer;

  const CustomerAddressDtoOutputLabelEnum._(String name) : super(name);

  static BuiltSet<CustomerAddressDtoOutputLabelEnum> get values =>
      _$customerAddressDtoOutputLabelEnumValues;
  static CustomerAddressDtoOutputLabelEnum valueOf(String name) =>
      _$customerAddressDtoOutputLabelEnumValueOf(name);
}
