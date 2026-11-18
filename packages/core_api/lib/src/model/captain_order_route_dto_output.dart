//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_customer_dto_output_addresses_inner_location.dart';
import 'package:core_api/src/model/captain_order_route_dto_output_route.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_order_route_dto_output.g.dart';

/// CaptainOrderRouteDtoOutput
///
/// Properties:
/// * [leg]
/// * [destination]
/// * [route]
@BuiltValue()
abstract class CaptainOrderRouteDtoOutput
    implements
        Built<CaptainOrderRouteDtoOutput, CaptainOrderRouteDtoOutputBuilder> {
  @BuiltValueField(wireName: r'leg')
  CaptainOrderRouteDtoOutputLegEnum get leg;
  // enum legEnum {  to_restaurant,  to_customer,  };

  @BuiltValueField(wireName: r'destination')
  AdminCustomerDtoOutputAddressesInnerLocation get destination;

  @BuiltValueField(wireName: r'route')
  CaptainOrderRouteDtoOutputRoute? get route;

  CaptainOrderRouteDtoOutput._();

  factory CaptainOrderRouteDtoOutput([
    void updates(CaptainOrderRouteDtoOutputBuilder b),
  ]) = _$CaptainOrderRouteDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainOrderRouteDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainOrderRouteDtoOutput> get serializer =>
      _$CaptainOrderRouteDtoOutputSerializer();
}

class _$CaptainOrderRouteDtoOutputSerializer
    implements PrimitiveSerializer<CaptainOrderRouteDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainOrderRouteDtoOutput,
    _$CaptainOrderRouteDtoOutput,
  ];

  @override
  final String wireName = r'CaptainOrderRouteDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainOrderRouteDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'leg';
    yield serializers.serialize(
      object.leg,
      specifiedType: const FullType(CaptainOrderRouteDtoOutputLegEnum),
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
    CaptainOrderRouteDtoOutput object, {
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
    required CaptainOrderRouteDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'leg':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainOrderRouteDtoOutputLegEnum,
                    ),
                  )
                  as CaptainOrderRouteDtoOutputLegEnum;
          result.leg = valueDes;
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
  CaptainOrderRouteDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainOrderRouteDtoOutputBuilder();
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

class CaptainOrderRouteDtoOutputLegEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'to_restaurant')
  static const CaptainOrderRouteDtoOutputLegEnum toRestaurant =
      _$captainOrderRouteDtoOutputLegEnum_toRestaurant;
  @BuiltValueEnumConst(wireName: r'to_customer')
  static const CaptainOrderRouteDtoOutputLegEnum toCustomer =
      _$captainOrderRouteDtoOutputLegEnum_toCustomer;

  static Serializer<CaptainOrderRouteDtoOutputLegEnum> get serializer =>
      _$captainOrderRouteDtoOutputLegEnumSerializer;

  const CaptainOrderRouteDtoOutputLegEnum._(String name) : super(name);

  static BuiltSet<CaptainOrderRouteDtoOutputLegEnum> get values =>
      _$captainOrderRouteDtoOutputLegEnumValues;
  static CaptainOrderRouteDtoOutputLegEnum valueOf(String name) =>
      _$captainOrderRouteDtoOutputLegEnumValueOf(name);
}
