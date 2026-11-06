//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/customer_location_dto_output_zone.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_location_dto_output.g.dart';

/// CustomerLocationDtoOutput
///
/// Properties:
/// * [state] - CU §7.1: the home screen; «لا توجد مطاعم توصل إلى موقعك حالياً»; «قريباً في منطقتك» with the vote.
/// * [zone]
@BuiltValue()
abstract class CustomerLocationDtoOutput
    implements
        Built<CustomerLocationDtoOutput, CustomerLocationDtoOutputBuilder> {
  /// CU §7.1: the home screen; «لا توجد مطاعم توصل إلى موقعك حالياً»; «قريباً في منطقتك» with the vote.
  @BuiltValueField(wireName: r'state')
  CustomerLocationDtoOutputStateEnum get state;
  // enum stateEnum {  served,  no_restaurants,  outside_zones,  };

  @BuiltValueField(wireName: r'zone')
  CustomerLocationDtoOutputZone? get zone;

  CustomerLocationDtoOutput._();

  factory CustomerLocationDtoOutput([
    void updates(CustomerLocationDtoOutputBuilder b),
  ]) = _$CustomerLocationDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerLocationDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerLocationDtoOutput> get serializer =>
      _$CustomerLocationDtoOutputSerializer();
}

class _$CustomerLocationDtoOutputSerializer
    implements PrimitiveSerializer<CustomerLocationDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerLocationDtoOutput,
    _$CustomerLocationDtoOutput,
  ];

  @override
  final String wireName = r'CustomerLocationDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerLocationDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(CustomerLocationDtoOutputStateEnum),
    );
    yield r'zone';
    yield object.zone == null
        ? null
        : serializers.serialize(
            object.zone,
            specifiedType: const FullType.nullable(
              CustomerLocationDtoOutputZone,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerLocationDtoOutput object, {
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
    required CustomerLocationDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'state':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerLocationDtoOutputStateEnum,
                    ),
                  )
                  as CustomerLocationDtoOutputStateEnum;
          result.state = valueDes;
          break;
        case r'zone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerLocationDtoOutputZone,
                    ),
                  )
                  as CustomerLocationDtoOutputZone?;
          if (valueDes == null) continue;
          result.zone.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerLocationDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerLocationDtoOutputBuilder();
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

/// CU §7.1: the home screen; «لا توجد مطاعم توصل إلى موقعك حالياً»; «قريباً في منطقتك» with the vote.
class CustomerLocationDtoOutputStateEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'served')
  static const CustomerLocationDtoOutputStateEnum served =
      _$customerLocationDtoOutputStateEnum_served;
  @BuiltValueEnumConst(wireName: r'no_restaurants')
  static const CustomerLocationDtoOutputStateEnum noRestaurants =
      _$customerLocationDtoOutputStateEnum_noRestaurants;
  @BuiltValueEnumConst(wireName: r'outside_zones')
  static const CustomerLocationDtoOutputStateEnum outsideZones =
      _$customerLocationDtoOutputStateEnum_outsideZones;

  static Serializer<CustomerLocationDtoOutputStateEnum> get serializer =>
      _$customerLocationDtoOutputStateEnumSerializer;

  const CustomerLocationDtoOutputStateEnum._(String name) : super(name);

  static BuiltSet<CustomerLocationDtoOutputStateEnum> get values =>
      _$customerLocationDtoOutputStateEnumValues;
  static CustomerLocationDtoOutputStateEnum valueOf(String name) =>
      _$customerLocationDtoOutputStateEnumValueOf(name);
}
