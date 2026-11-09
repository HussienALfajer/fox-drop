//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_captain.g.dart';

/// From assignment (RA §8.9); the photo and the ETA come with their slices.
///
/// Properties:
/// * [firstName] 
/// * [vehicle] 
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerCaptain implements Built<MerchantOrdersDtoOutputOrdersInnerCaptain, MerchantOrdersDtoOutputOrdersInnerCaptainBuilder> {
  @BuiltValueField(wireName: r'firstName')
  String get firstName;

  @BuiltValueField(wireName: r'vehicle')
  MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  MerchantOrdersDtoOutputOrdersInnerCaptain._();

  factory MerchantOrdersDtoOutputOrdersInnerCaptain([void updates(MerchantOrdersDtoOutputOrdersInnerCaptainBuilder b)]) = _$MerchantOrdersDtoOutputOrdersInnerCaptain;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrdersDtoOutputOrdersInnerCaptainBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerCaptain> get serializer => _$MerchantOrdersDtoOutputOrdersInnerCaptainSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerCaptainSerializer implements PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerCaptain> {
  @override
  final Iterable<Type> types = const [MerchantOrdersDtoOutputOrdersInnerCaptain, _$MerchantOrdersDtoOutputOrdersInnerCaptain];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerCaptain';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerCaptain object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'firstName';
    yield serializers.serialize(
      object.firstName,
      specifiedType: const FullType(String),
    );
    yield r'vehicle';
    yield serializers.serialize(
      object.vehicle,
      specifiedType: const FullType(MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerCaptain object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantOrdersDtoOutputOrdersInnerCaptainBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.firstName = valueDes;
          break;
        case r'vehicle':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum),
          ) as MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum;
          result.vehicle = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerCaptain deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerCaptainBuilder();
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


class MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'walking')
  static const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum walking = _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum bicycle = _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum motorbike = _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum car = _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum_car;

  static Serializer<MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum> get serializer => _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnumSerializer;

  const MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum._(String name): super(name);

  static BuiltSet<MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum> get values => _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnumValues;
  static MerchantOrdersDtoOutputOrdersInnerCaptainVehicleEnum valueOf(String name) => _$merchantOrdersDtoOutputOrdersInnerCaptainVehicleEnumValueOf(name);
}

