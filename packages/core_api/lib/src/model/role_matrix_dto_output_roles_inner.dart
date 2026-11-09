//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'role_matrix_dto_output_roles_inner.g.dart';

/// RoleMatrixDtoOutputRolesInner
///
/// Properties:
/// * [role]
/// * [permissions]
@BuiltValue()
abstract class RoleMatrixDtoOutputRolesInner
    implements
        Built<
          RoleMatrixDtoOutputRolesInner,
          RoleMatrixDtoOutputRolesInnerBuilder
        > {
  @BuiltValueField(wireName: r'role')
  String get role;

  @BuiltValueField(wireName: r'permissions')
  BuiltList<String> get permissions;

  RoleMatrixDtoOutputRolesInner._();

  factory RoleMatrixDtoOutputRolesInner([
    void updates(RoleMatrixDtoOutputRolesInnerBuilder b),
  ]) = _$RoleMatrixDtoOutputRolesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoleMatrixDtoOutputRolesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoleMatrixDtoOutputRolesInner> get serializer =>
      _$RoleMatrixDtoOutputRolesInnerSerializer();
}

class _$RoleMatrixDtoOutputRolesInnerSerializer
    implements PrimitiveSerializer<RoleMatrixDtoOutputRolesInner> {
  @override
  final Iterable<Type> types = const [
    RoleMatrixDtoOutputRolesInner,
    _$RoleMatrixDtoOutputRolesInner,
  ];

  @override
  final String wireName = r'RoleMatrixDtoOutputRolesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoleMatrixDtoOutputRolesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'role';
    yield serializers.serialize(
      object.role,
      specifiedType: const FullType(String),
    );
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RoleMatrixDtoOutputRolesInner object, {
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
    required RoleMatrixDtoOutputRolesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'role':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.role = valueDes;
          break;
        case r'permissions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.permissions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RoleMatrixDtoOutputRolesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoleMatrixDtoOutputRolesInnerBuilder();
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
