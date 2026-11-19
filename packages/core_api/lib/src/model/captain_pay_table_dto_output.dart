//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/captain_pay_table_dto_output_current.dart';
import 'package:core_api/src/model/captain_pay_table_dto_output_announced_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_pay_table_dto_output.g.dart';

/// CaptainPayTableDtoOutput
///
/// Properties:
/// * [vehicle]
/// * [waitingThresholdMin] - captain.waiting_threshold_min
/// * [current]
/// * [announced] - The tables published to start later, soonest first (AP §9.12.5: 7 days ahead).
@BuiltValue()
abstract class CaptainPayTableDtoOutput
    implements
        Built<CaptainPayTableDtoOutput, CaptainPayTableDtoOutputBuilder> {
  @BuiltValueField(wireName: r'vehicle')
  CaptainPayTableDtoOutputVehicleEnum get vehicle;
  // enum vehicleEnum {  walking,  bicycle,  motorbike,  car,  };

  /// captain.waiting_threshold_min
  @BuiltValueField(wireName: r'waitingThresholdMin')
  int get waitingThresholdMin;

  @BuiltValueField(wireName: r'current')
  CaptainPayTableDtoOutputCurrent? get current;

  /// The tables published to start later, soonest first (AP §9.12.5: 7 days ahead).
  @BuiltValueField(wireName: r'announced')
  BuiltList<CaptainPayTableDtoOutputAnnouncedInner> get announced;

  CaptainPayTableDtoOutput._();

  factory CaptainPayTableDtoOutput([
    void updates(CaptainPayTableDtoOutputBuilder b),
  ]) = _$CaptainPayTableDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPayTableDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPayTableDtoOutput> get serializer =>
      _$CaptainPayTableDtoOutputSerializer();
}

class _$CaptainPayTableDtoOutputSerializer
    implements PrimitiveSerializer<CaptainPayTableDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainPayTableDtoOutput,
    _$CaptainPayTableDtoOutput,
  ];

  @override
  final String wireName = r'CaptainPayTableDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPayTableDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'vehicle';
    yield serializers.serialize(
      object.vehicle,
      specifiedType: const FullType(CaptainPayTableDtoOutputVehicleEnum),
    );
    yield r'waitingThresholdMin';
    yield serializers.serialize(
      object.waitingThresholdMin,
      specifiedType: const FullType(int),
    );
    yield r'current';
    yield object.current == null
        ? null
        : serializers.serialize(
            object.current,
            specifiedType: const FullType.nullable(
              CaptainPayTableDtoOutputCurrent,
            ),
          );
    yield r'announced';
    yield serializers.serialize(
      object.announced,
      specifiedType: const FullType(BuiltList, [
        FullType(CaptainPayTableDtoOutputAnnouncedInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPayTableDtoOutput object, {
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
    required CaptainPayTableDtoOutputBuilder result,
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
                      CaptainPayTableDtoOutputVehicleEnum,
                    ),
                  )
                  as CaptainPayTableDtoOutputVehicleEnum;
          result.vehicle = valueDes;
          break;
        case r'waitingThresholdMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.waitingThresholdMin = valueDes;
          break;
        case r'current':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainPayTableDtoOutputCurrent,
                    ),
                  )
                  as CaptainPayTableDtoOutputCurrent?;
          if (valueDes == null) continue;
          result.current.replace(valueDes);
          break;
        case r'announced':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(CaptainPayTableDtoOutputAnnouncedInner),
                    ]),
                  )
                  as BuiltList<CaptainPayTableDtoOutputAnnouncedInner>;
          result.announced.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPayTableDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPayTableDtoOutputBuilder();
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

class CaptainPayTableDtoOutputVehicleEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'walking')
  static const CaptainPayTableDtoOutputVehicleEnum walking =
      _$captainPayTableDtoOutputVehicleEnum_walking;
  @BuiltValueEnumConst(wireName: r'bicycle')
  static const CaptainPayTableDtoOutputVehicleEnum bicycle =
      _$captainPayTableDtoOutputVehicleEnum_bicycle;
  @BuiltValueEnumConst(wireName: r'motorbike')
  static const CaptainPayTableDtoOutputVehicleEnum motorbike =
      _$captainPayTableDtoOutputVehicleEnum_motorbike;
  @BuiltValueEnumConst(wireName: r'car')
  static const CaptainPayTableDtoOutputVehicleEnum car =
      _$captainPayTableDtoOutputVehicleEnum_car;

  static Serializer<CaptainPayTableDtoOutputVehicleEnum> get serializer =>
      _$captainPayTableDtoOutputVehicleEnumSerializer;

  const CaptainPayTableDtoOutputVehicleEnum._(String name) : super(name);

  static BuiltSet<CaptainPayTableDtoOutputVehicleEnum> get values =>
      _$captainPayTableDtoOutputVehicleEnumValues;
  static CaptainPayTableDtoOutputVehicleEnum valueOf(String name) =>
      _$captainPayTableDtoOutputVehicleEnumValueOf(name);
}
