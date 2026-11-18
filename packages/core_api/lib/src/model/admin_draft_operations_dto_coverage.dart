//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_draft_operations_dto_coverage_one_of1.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_draft_operations_dto_coverage_one_of.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:one_of/one_of.dart';

part 'admin_draft_operations_dto_coverage.g.dart';

/// AdminDraftOperationsDtoCoverage
///
/// Properties:
/// * [kind]
/// * [radiusMetres]
/// * [zoneIds]
@BuiltValue()
abstract class AdminDraftOperationsDtoCoverage
    implements
        Built<
          AdminDraftOperationsDtoCoverage,
          AdminDraftOperationsDtoCoverageBuilder
        > {
  /// One Of [AdminDraftOperationsDtoCoverageOneOf], [AdminDraftOperationsDtoCoverageOneOf1]
  OneOf get oneOf;

  AdminDraftOperationsDtoCoverage._();

  factory AdminDraftOperationsDtoCoverage([
    void updates(AdminDraftOperationsDtoCoverageBuilder b),
  ]) = _$AdminDraftOperationsDtoCoverage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftOperationsDtoCoverageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftOperationsDtoCoverage> get serializer =>
      _$AdminDraftOperationsDtoCoverageSerializer();
}

class _$AdminDraftOperationsDtoCoverageSerializer
    implements PrimitiveSerializer<AdminDraftOperationsDtoCoverage> {
  @override
  final Iterable<Type> types = const [
    AdminDraftOperationsDtoCoverage,
    _$AdminDraftOperationsDtoCoverage,
  ];

  @override
  final String wireName = r'AdminDraftOperationsDtoCoverage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftOperationsDtoCoverage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {}

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftOperationsDtoCoverage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final oneOf = object.oneOf;
    return serializers.serialize(
      oneOf.value,
      specifiedType: FullType(oneOf.valueType),
    )!;
  }

  @override
  AdminDraftOperationsDtoCoverage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftOperationsDtoCoverageBuilder();
    Object? oneOfDataSrc;
    final targetType = const FullType(OneOf, [
      FullType(AdminDraftOperationsDtoCoverageOneOf),
      FullType(AdminDraftOperationsDtoCoverageOneOf1),
    ]);
    oneOfDataSrc = serialized;
    result.oneOf =
        serializers.deserialize(oneOfDataSrc, specifiedType: targetType)
            as OneOf;
    return result.build();
  }
}

class AdminDraftOperationsDtoCoverageKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'zones')
  static const AdminDraftOperationsDtoCoverageKindEnum zones =
      _$adminDraftOperationsDtoCoverageKindEnum_zones;

  static Serializer<AdminDraftOperationsDtoCoverageKindEnum> get serializer =>
      _$adminDraftOperationsDtoCoverageKindEnumSerializer;

  const AdminDraftOperationsDtoCoverageKindEnum._(String name) : super(name);

  static BuiltSet<AdminDraftOperationsDtoCoverageKindEnum> get values =>
      _$adminDraftOperationsDtoCoverageKindEnumValues;
  static AdminDraftOperationsDtoCoverageKindEnum valueOf(String name) =>
      _$adminDraftOperationsDtoCoverageKindEnumValueOf(name);
}
