//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_operations_dto_coverage_one_of.g.dart';

/// AdminDraftOperationsDtoCoverageOneOf
///
/// Properties:
/// * [kind]
/// * [radiusMetres]
@BuiltValue()
abstract class AdminDraftOperationsDtoCoverageOneOf
    implements
        Built<
          AdminDraftOperationsDtoCoverageOneOf,
          AdminDraftOperationsDtoCoverageOneOfBuilder
        > {
  @BuiltValueField(wireName: r'kind')
  AdminDraftOperationsDtoCoverageOneOfKindEnum get kind;
  // enum kindEnum {  radius,  };

  @BuiltValueField(wireName: r'radiusMetres')
  int get radiusMetres;

  AdminDraftOperationsDtoCoverageOneOf._();

  factory AdminDraftOperationsDtoCoverageOneOf([
    void updates(AdminDraftOperationsDtoCoverageOneOfBuilder b),
  ]) = _$AdminDraftOperationsDtoCoverageOneOf;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftOperationsDtoCoverageOneOfBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftOperationsDtoCoverageOneOf> get serializer =>
      _$AdminDraftOperationsDtoCoverageOneOfSerializer();
}

class _$AdminDraftOperationsDtoCoverageOneOfSerializer
    implements PrimitiveSerializer<AdminDraftOperationsDtoCoverageOneOf> {
  @override
  final Iterable<Type> types = const [
    AdminDraftOperationsDtoCoverageOneOf,
    _$AdminDraftOperationsDtoCoverageOneOf,
  ];

  @override
  final String wireName = r'AdminDraftOperationsDtoCoverageOneOf';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftOperationsDtoCoverageOneOf object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminDraftOperationsDtoCoverageOneOfKindEnum,
      ),
    );
    yield r'radiusMetres';
    yield serializers.serialize(
      object.radiusMetres,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftOperationsDtoCoverageOneOf object, {
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
    required AdminDraftOperationsDtoCoverageOneOfBuilder result,
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
                      AdminDraftOperationsDtoCoverageOneOfKindEnum,
                    ),
                  )
                  as AdminDraftOperationsDtoCoverageOneOfKindEnum;
          result.kind = valueDes;
          break;
        case r'radiusMetres':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.radiusMetres = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftOperationsDtoCoverageOneOf deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftOperationsDtoCoverageOneOfBuilder();
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

class AdminDraftOperationsDtoCoverageOneOfKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'radius')
  static const AdminDraftOperationsDtoCoverageOneOfKindEnum radius =
      _$adminDraftOperationsDtoCoverageOneOfKindEnum_radius;

  static Serializer<AdminDraftOperationsDtoCoverageOneOfKindEnum>
  get serializer => _$adminDraftOperationsDtoCoverageOneOfKindEnumSerializer;

  const AdminDraftOperationsDtoCoverageOneOfKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminDraftOperationsDtoCoverageOneOfKindEnum> get values =>
      _$adminDraftOperationsDtoCoverageOneOfKindEnumValues;
  static AdminDraftOperationsDtoCoverageOneOfKindEnum valueOf(String name) =>
      _$adminDraftOperationsDtoCoverageOneOfKindEnumValueOf(name);
}
