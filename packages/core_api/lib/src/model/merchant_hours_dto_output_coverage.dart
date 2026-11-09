//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_hours_dto_output_coverage.g.dart';

/// MerchantHoursDtoOutputCoverage
///
/// Properties:
/// * [kind]
/// * [radiusMetres]
/// * [zoneCount]
@BuiltValue()
abstract class MerchantHoursDtoOutputCoverage
    implements
        Built<
          MerchantHoursDtoOutputCoverage,
          MerchantHoursDtoOutputCoverageBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  MerchantHoursDtoOutputCoverageKindEnum get kind;
  // enum kindEnum {  radius,  zones,  };

  @BuiltValueField(wireName: r'radiusMetres')
  int? get radiusMetres;

  @BuiltValueField(wireName: r'zoneCount')
  int? get zoneCount;

  MerchantHoursDtoOutputCoverage._();

  factory MerchantHoursDtoOutputCoverage([
    void updates(MerchantHoursDtoOutputCoverageBuilder b),
  ]) = _$MerchantHoursDtoOutputCoverage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantHoursDtoOutputCoverageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantHoursDtoOutputCoverage> get serializer =>
      _$MerchantHoursDtoOutputCoverageSerializer();
}

class _$MerchantHoursDtoOutputCoverageSerializer
    implements PrimitiveSerializer<MerchantHoursDtoOutputCoverage> {
  @override
  final Iterable<Type> types = const [
    MerchantHoursDtoOutputCoverage,
    _$MerchantHoursDtoOutputCoverage,
  ];

  @override
  final String wireName = r'MerchantHoursDtoOutputCoverage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantHoursDtoOutputCoverage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(MerchantHoursDtoOutputCoverageKindEnum),
    );
    yield r'radiusMetres';
    yield object.radiusMetres == null
        ? null
        : serializers.serialize(
            object.radiusMetres,
            specifiedType: const FullType.nullable(int),
          );
    yield r'zoneCount';
    yield object.zoneCount == null
        ? null
        : serializers.serialize(
            object.zoneCount,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantHoursDtoOutputCoverage object, {
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
    required MerchantHoursDtoOutputCoverageBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantHoursDtoOutputCoverageKindEnum,
                    ),
                  )
                  as MerchantHoursDtoOutputCoverageKindEnum;
          result.kind = valueDes;
          break;
        case r'radiusMetres':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.radiusMetres = valueDes;
          break;
        case r'zoneCount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.zoneCount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantHoursDtoOutputCoverage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantHoursDtoOutputCoverageBuilder();
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

class MerchantHoursDtoOutputCoverageKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'radius')
  static const MerchantHoursDtoOutputCoverageKindEnum radius =
      _$merchantHoursDtoOutputCoverageKindEnum_radius;
  @BuiltValueEnumConst(wireName: r'zones')
  static const MerchantHoursDtoOutputCoverageKindEnum zones =
      _$merchantHoursDtoOutputCoverageKindEnum_zones;

  static Serializer<MerchantHoursDtoOutputCoverageKindEnum> get serializer =>
      _$merchantHoursDtoOutputCoverageKindEnumSerializer;

  const MerchantHoursDtoOutputCoverageKindEnum._(String name) : super(name);

  static BuiltSet<MerchantHoursDtoOutputCoverageKindEnum> get values =>
      _$merchantHoursDtoOutputCoverageKindEnumValues;
  static MerchantHoursDtoOutputCoverageKindEnum valueOf(String name) =>
      _$merchantHoursDtoOutputCoverageKindEnumValueOf(name);
}
