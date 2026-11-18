//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_draft_dto_output_operations_coverage_one_of.dart';
import 'package:core_api/src/model/admin_restaurant_draft_dto_output_operations_coverage_one_of1.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'admin_restaurant_draft_dto_output_operations_coverage.g.dart';

/// AdminRestaurantDraftDtoOutputOperationsCoverage
///
/// Properties:
/// * [kind]
/// * [radiusMetres]
/// * [zoneIds]
@BuiltValue()
abstract class AdminRestaurantDraftDtoOutputOperationsCoverage
    implements
        Built<
          AdminRestaurantDraftDtoOutputOperationsCoverage,
          AdminRestaurantDraftDtoOutputOperationsCoverageBuilder
        > {
  /// One Of [AdminRestaurantDraftDtoOutputOperationsCoverageOneOf], [AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1]
  OneOf get oneOf;

  AdminRestaurantDraftDtoOutputOperationsCoverage._();

  factory AdminRestaurantDraftDtoOutputOperationsCoverage([
    void updates(AdminRestaurantDraftDtoOutputOperationsCoverageBuilder b),
  ]) = _$AdminRestaurantDraftDtoOutputOperationsCoverage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantDraftDtoOutputOperationsCoverageBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantDraftDtoOutputOperationsCoverage>
  get serializer =>
      _$AdminRestaurantDraftDtoOutputOperationsCoverageSerializer();
}

class _$AdminRestaurantDraftDtoOutputOperationsCoverageSerializer
    implements
        PrimitiveSerializer<AdminRestaurantDraftDtoOutputOperationsCoverage> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantDraftDtoOutputOperationsCoverage,
    _$AdminRestaurantDraftDtoOutputOperationsCoverage,
  ];

  @override
  final String wireName = r'AdminRestaurantDraftDtoOutputOperationsCoverage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsCoverage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantDraftDtoOutputOperationsCoverage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(
      oneOf.value,
      specifiedType: FullType(oneOf.valueType),
    )!;
  }

  @override
  AdminRestaurantDraftDtoOutputOperationsCoverage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantDraftDtoOutputOperationsCoverageBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [
      FullType(AdminRestaurantDraftDtoOutputOperationsCoverageOneOf),
      FullType(AdminRestaurantDraftDtoOutputOperationsCoverageOneOf1),
    ]);
    oneOfDataSrc = serialized;
    result.oneOf =
        serializers.deserialize(oneOfDataSrc, specifiedType: targetType)
            as OneOf;
    return result.build();
  }
}

class AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'zones')
  static const AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum zones =
      _$adminRestaurantDraftDtoOutputOperationsCoverageKindEnum_zones;

  static Serializer<AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum>
  get serializer =>
      _$adminRestaurantDraftDtoOutputOperationsCoverageKindEnumSerializer;

  const AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum>
  get values => _$adminRestaurantDraftDtoOutputOperationsCoverageKindEnumValues;
  static AdminRestaurantDraftDtoOutputOperationsCoverageKindEnum valueOf(
    String name,
  ) => _$adminRestaurantDraftDtoOutputOperationsCoverageKindEnumValueOf(name);
}
