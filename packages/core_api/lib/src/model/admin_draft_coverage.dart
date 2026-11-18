//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_coverage.g.dart';

/// AdminDraftCoverage
///
/// Properties:
/// * [kind]
/// * [radiusMetres] - With kind radius only.
/// * [zoneIds] - With kind zones only, one or more.
@BuiltValue()
abstract class AdminDraftCoverage
    implements Built<AdminDraftCoverage, AdminDraftCoverageBuilder> {
  @BuiltValueField(wireName: r'kind')
  AdminDraftCoverageKindEnum get kind;
  // enum kindEnum {  radius,  zones,  };

  /// With kind radius only.
  @BuiltValueField(wireName: r'radiusMetres')
  int? get radiusMetres;

  /// With kind zones only, one or more.
  @BuiltValueField(wireName: r'zoneIds')
  BuiltList<String> get zoneIds;

  AdminDraftCoverage._();

  factory AdminDraftCoverage([void updates(AdminDraftCoverageBuilder b)]) =
      _$AdminDraftCoverage;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftCoverageBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftCoverage> get serializer =>
      _$AdminDraftCoverageSerializer();
}

class _$AdminDraftCoverageSerializer
    implements PrimitiveSerializer<AdminDraftCoverage> {
  @override
  final Iterable<Type> types = const [AdminDraftCoverage, _$AdminDraftCoverage];

  @override
  final String wireName = r'AdminDraftCoverage';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftCoverage object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminDraftCoverageKindEnum),
    );
    yield r'radiusMetres';
    yield object.radiusMetres == null
        ? null
        : serializers.serialize(
            object.radiusMetres,
            specifiedType: const FullType.nullable(int),
          );
    yield r'zoneIds';
    yield serializers.serialize(
      object.zoneIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftCoverage object, {
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
    required AdminDraftCoverageBuilder result,
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
                    specifiedType: const FullType(AdminDraftCoverageKindEnum),
                  )
                  as AdminDraftCoverageKindEnum;
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
        case r'zoneIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.zoneIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftCoverage deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftCoverageBuilder();
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

class AdminDraftCoverageKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'radius')
  static const AdminDraftCoverageKindEnum radius =
      _$adminDraftCoverageKindEnum_radius;
  @BuiltValueEnumConst(wireName: r'zones')
  static const AdminDraftCoverageKindEnum zones =
      _$adminDraftCoverageKindEnum_zones;

  static Serializer<AdminDraftCoverageKindEnum> get serializer =>
      _$adminDraftCoverageKindEnumSerializer;

  const AdminDraftCoverageKindEnum._(String name) : super(name);

  static BuiltSet<AdminDraftCoverageKindEnum> get values =>
      _$adminDraftCoverageKindEnumValues;
  static AdminDraftCoverageKindEnum valueOf(String name) =>
      _$adminDraftCoverageKindEnumValueOf(name);
}
