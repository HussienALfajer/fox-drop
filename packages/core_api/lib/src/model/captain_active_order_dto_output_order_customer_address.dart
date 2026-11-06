//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_customer_address.g.dart';

/// CaptainActiveOrderDtoOutputOrderCustomerAddress
///
/// Properties:
/// * [neighbourhood] - «الحي».
/// * [label]
/// * [customLabel]
/// * [street]
/// * [floor]
/// * [landmark]
/// * [directions] - The customer's directions.
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderCustomerAddress
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderCustomerAddress,
          CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder
        > {
  /// «الحي».
  @BuiltValueField(wireName: r'neighbourhood')
  String get neighbourhood;

  @BuiltValueField(wireName: r'label')
  CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum? get label;
  // enum labelEnum {  home,  work,  other,  };

  @BuiltValueField(wireName: r'customLabel')
  String? get customLabel;

  @BuiltValueField(wireName: r'street')
  String get street;

  @BuiltValueField(wireName: r'floor')
  String? get floor;

  @BuiltValueField(wireName: r'landmark')
  String get landmark;

  /// The customer's directions.
  @BuiltValueField(wireName: r'directions')
  String? get directions;

  CaptainActiveOrderDtoOutputOrderCustomerAddress._();

  factory CaptainActiveOrderDtoOutputOrderCustomerAddress([
    void updates(CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderCustomerAddress;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderCustomerAddress>
  get serializer =>
      _$CaptainActiveOrderDtoOutputOrderCustomerAddressSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderCustomerAddressSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderCustomerAddress> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderCustomerAddress,
    _$CaptainActiveOrderDtoOutputOrderCustomerAddress,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderCustomerAddress';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderCustomerAddress object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
              CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum,
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
    CaptainActiveOrderDtoOutputOrderCustomerAddress object, {
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
    required CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
                      CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum,
                    ),
                  )
                  as CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum?;
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
  CaptainActiveOrderDtoOutputOrderCustomerAddress deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderCustomerAddressBuilder();
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

class CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'home')
  static const CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum home =
      _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_home;
  @BuiltValueEnumConst(wireName: r'work')
  static const CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum work =
      _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_work;
  @BuiltValueEnumConst(wireName: r'other')
  static const CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum other =
      _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnum_other;

  static Serializer<CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum>
  get serializer =>
      _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnumSerializer;

  const CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum._(String name)
    : super(name);

  static BuiltSet<CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum>
  get values =>
      _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnumValues;
  static CaptainActiveOrderDtoOutputOrderCustomerAddressLabelEnum valueOf(
    String name,
  ) => _$captainActiveOrderDtoOutputOrderCustomerAddressLabelEnumValueOf(name);
}
