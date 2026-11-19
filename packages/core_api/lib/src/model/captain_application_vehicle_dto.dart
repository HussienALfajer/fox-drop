//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_application_vehicle_dto.g.dart';

/// CaptainApplicationVehicleDto
///
/// Properties:
/// * [vehicle]
/// * [plate] - Required for a motorbike or a car.
@BuiltValue()
abstract class CaptainApplicationVehicleDto
    implements
        Built<
          CaptainApplicationVehicleDto,
          CaptainApplicationVehicleDtoBuilder
        > {
  @BuiltValueField(wireName: r'vehicle')
  CaptainApplicationVehicleDtoVehicleEnum get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  /// Required for a motorbike or a car.
  @BuiltValueField(wireName: r'plate')
  String? get plate;

  CaptainApplicationVehicleDto._();

  factory CaptainApplicationVehicleDto([
    void updates(CaptainApplicationVehicleDtoBuilder b),
  ]) = _$CaptainApplicationVehicleDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainApplicationVehicleDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainApplicationVehicleDto> get serializer =>
      _$CaptainApplicationVehicleDtoSerializer();
}

class _$CaptainApplicationVehicleDtoSerializer
    implements PrimitiveSerializer<CaptainApplicationVehicleDto> {
  @override
  final Iterable<Type> types = const [
    CaptainApplicationVehicleDto,
    _$CaptainApplicationVehicleDto,
  ];

  @override
  final String wireName = r'CaptainApplicationVehicleDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainApplicationVehicleDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicle';
    yield serializers.serialize(
      object.vehicle,
      specifiedType: const FullType(CaptainApplicationVehicleDtoVehicleEnum),
    );
    if (object.plate != null) {
      yield r'plate';
      yield serializers.serialize(
        object.plate,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainApplicationVehicleDto object, {
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
    required CaptainApplicationVehicleDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'vehicle':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainApplicationVehicleDtoVehicleEnum,
                    ),
                  )
                  as CaptainApplicationVehicleDtoVehicleEnum;
          result.vehicle = valueDes;
          break;
        case r'plate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.plate = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainApplicationVehicleDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainApplicationVehicleDtoBuilder();
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

class CaptainApplicationVehicleDtoVehicleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'walking')
  static const CaptainApplicationVehicleDtoVehicleEnum walking =
      _$captainApplicationVehicleDtoVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const CaptainApplicationVehicleDtoVehicleEnum bicycle =
      _$captainApplicationVehicleDtoVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const CaptainApplicationVehicleDtoVehicleEnum motorbike =
      _$captainApplicationVehicleDtoVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const CaptainApplicationVehicleDtoVehicleEnum car =
      _$captainApplicationVehicleDtoVehicleEnum_car;

  static Serializer<CaptainApplicationVehicleDtoVehicleEnum> get serializer =>
      _$captainApplicationVehicleDtoVehicleEnumSerializer;

  const CaptainApplicationVehicleDtoVehicleEnum._(String name) : super(name);

  static BuiltSet<CaptainApplicationVehicleDtoVehicleEnum> get values =>
      _$captainApplicationVehicleDtoVehicleEnumValues;
  static CaptainApplicationVehicleDtoVehicleEnum valueOf(String name) =>
      _$captainApplicationVehicleDtoVehicleEnumValueOf(name);
}
