//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_coverage_output.g.dart';

/// AdminDraftCoverageOutput
///
/// Properties:
/// * [kind]
/// * [radiusMetres] - With kind radius only.
/// * [zoneIds] - With kind zones only, one or more.
@BuiltValue()
abstract class AdminDraftCoverageOutput
    implements
        Built<AdminDraftCoverageOutput, AdminDraftCoverageOutputBuilder> {
  @BuiltValueField(wireName: r'kind')
  AdminDraftCoverageOutputKindEnum get kind;
  // enum kindEnum {  radius,  zones,  };

  /// With kind radius only.
  @BuiltValueField(wireName: r'radiusMetres')
  int? get radiusMetres;

  /// With kind zones only, one or more.
  @BuiltValueField(wireName: r'zoneIds')
  BuiltList<String> get zoneIds;

  AdminDraftCoverageOutput._();

  factory AdminDraftCoverageOutput([
    void updates(AdminDraftCoverageOutputBuilder b),
  ]) = _$AdminDraftCoverageOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftCoverageOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftCoverageOutput> get serializer =>
      _$AdminDraftCoverageOutputSerializer();
}

class _$AdminDraftCoverageOutputSerializer
    implements PrimitiveSerializer<AdminDraftCoverageOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDraftCoverageOutput,
    _$AdminDraftCoverageOutput,
  ];

  @override
  final String wireName = r'AdminDraftCoverageOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftCoverageOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(AdminDraftCoverageOutputKindEnum),
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
    AdminDraftCoverageOutput object, {
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
    required AdminDraftCoverageOutputBuilder result,
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
                      AdminDraftCoverageOutputKindEnum,
                    ),
                  )
                  as AdminDraftCoverageOutputKindEnum;
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
  AdminDraftCoverageOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftCoverageOutputBuilder();
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

class AdminDraftCoverageOutputKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'radius')
  static const AdminDraftCoverageOutputKindEnum radius =
      _$adminDraftCoverageOutputKindEnum_radius;
  @BuiltValueEnumConst(wireName: r'zones')
  static const AdminDraftCoverageOutputKindEnum zones =
      _$adminDraftCoverageOutputKindEnum_zones;

  static Serializer<AdminDraftCoverageOutputKindEnum> get serializer =>
      _$adminDraftCoverageOutputKindEnumSerializer;

  const AdminDraftCoverageOutputKindEnum._(String name) : super(name);

  static BuiltSet<AdminDraftCoverageOutputKindEnum> get values =>
      _$adminDraftCoverageOutputKindEnumValues;
  static AdminDraftCoverageOutputKindEnum valueOf(String name) =>
      _$adminDraftCoverageOutputKindEnumValueOf(name);
}
