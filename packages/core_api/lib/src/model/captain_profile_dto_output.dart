//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_profile_dto_output.g.dart';

/// CaptainProfileDtoOutput
///
/// Properties:
/// * [foxDropId] - «رقم الهوية في FOX DROP», the id shown short.
/// * [name]
/// * [phone] - The number the captain signs in with.
/// * [neighbourhood] - The application's zone; null for a captain the seed made.
/// * [vehicle]
/// * [plateNumber]
@BuiltValue()
abstract class CaptainProfileDtoOutput
    implements Built<CaptainProfileDtoOutput, CaptainProfileDtoOutputBuilder> {
  /// «رقم الهوية في FOX DROP», the id shown short.
  @BuiltValueField(wireName: r'foxDropId')
  String get foxDropId;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// The number the captain signs in with.
  @BuiltValueField(wireName: r'phone')
  String? get phone;

  /// The application's zone; null for a captain the seed made.
  @BuiltValueField(wireName: r'neighbourhood')
  String? get neighbourhood;

  @BuiltValueField(wireName: r'vehicle')
  CaptainProfileDtoOutputVehicleEnum get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  @BuiltValueField(wireName: r'plateNumber')
  String? get plateNumber;

  CaptainProfileDtoOutput._();

  factory CaptainProfileDtoOutput([
    void updates(CaptainProfileDtoOutputBuilder b),
  ]) = _$CaptainProfileDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainProfileDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainProfileDtoOutput> get serializer =>
      _$CaptainProfileDtoOutputSerializer();
}

class _$CaptainProfileDtoOutputSerializer
    implements PrimitiveSerializer<CaptainProfileDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainProfileDtoOutput,
    _$CaptainProfileDtoOutput,
  ];

  @override
  final String wireName = r'CaptainProfileDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainProfileDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'foxDropId';
    yield serializers.serialize(
      object.foxDropId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'phone';
    yield object.phone == null
        ? null
        : serializers.serialize(
            object.phone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'neighbourhood';
    yield object.neighbourhood == null
        ? null
        : serializers.serialize(
            object.neighbourhood,
            specifiedType: const FullType.nullable(String),
          );
    yield r'vehicle';
    yield serializers.serialize(
      object.vehicle,
      specifiedType: const FullType(CaptainProfileDtoOutputVehicleEnum),
    );
    yield r'plateNumber';
    yield object.plateNumber == null
        ? null
        : serializers.serialize(
            object.plateNumber,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainProfileDtoOutput object, {
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
    required CaptainProfileDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'foxDropId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.foxDropId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'neighbourhood':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.neighbourhood = valueDes;
          break;
        case r'vehicle':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CaptainProfileDtoOutputVehicleEnum,
                    ),
                  )
                  as CaptainProfileDtoOutputVehicleEnum;
          result.vehicle = valueDes;
          break;
        case r'plateNumber':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.plateNumber = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainProfileDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainProfileDtoOutputBuilder();
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

class CaptainProfileDtoOutputVehicleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'walking')
  static const CaptainProfileDtoOutputVehicleEnum walking =
      _$captainProfileDtoOutputVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const CaptainProfileDtoOutputVehicleEnum bicycle =
      _$captainProfileDtoOutputVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const CaptainProfileDtoOutputVehicleEnum motorbike =
      _$captainProfileDtoOutputVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const CaptainProfileDtoOutputVehicleEnum car =
      _$captainProfileDtoOutputVehicleEnum_car;

  static Serializer<CaptainProfileDtoOutputVehicleEnum> get serializer =>
      _$captainProfileDtoOutputVehicleEnumSerializer;

  const CaptainProfileDtoOutputVehicleEnum._(String name) : super(name);

  static BuiltSet<CaptainProfileDtoOutputVehicleEnum> get values =>
      _$captainProfileDtoOutputVehicleEnumValues;
  static CaptainProfileDtoOutputVehicleEnum valueOf(String name) =>
      _$captainProfileDtoOutputVehicleEnumValueOf(name);
}
