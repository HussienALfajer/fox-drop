//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/role_matrix_dto_output_roles_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'role_matrix_dto_output.g.dart';

/// RoleMatrixDtoOutput
///
/// Properties:
/// * [roles] 
@BuiltValue()
abstract class RoleMatrixDtoOutput implements Built<RoleMatrixDtoOutput, RoleMatrixDtoOutputBuilder> {
  @BuiltValueField(wireName: r'roles')
  BuiltList<RoleMatrixDtoOutputRolesInner> get roles;

  RoleMatrixDtoOutput._();

  factory RoleMatrixDtoOutput([void updates(RoleMatrixDtoOutputBuilder b)]) = _$RoleMatrixDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RoleMatrixDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RoleMatrixDtoOutput> get serializer => _$RoleMatrixDtoOutputSerializer();
}

class _$RoleMatrixDtoOutputSerializer implements PrimitiveSerializer<RoleMatrixDtoOutput> {
  @override
  final Iterable<Type> types = const [RoleMatrixDtoOutput, _$RoleMatrixDtoOutput];

  @override
  final String wireName = r'RoleMatrixDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RoleMatrixDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'roles';
    yield serializers.serialize(
      object.roles,
      specifiedType: const FullType(BuiltList, [FullType(RoleMatrixDtoOutputRolesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    RoleMatrixDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RoleMatrixDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'roles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(RoleMatrixDtoOutputRolesInner)]),
          ) as BuiltList<RoleMatrixDtoOutputRolesInner>;
          result.roles.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RoleMatrixDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RoleMatrixDtoOutputBuilder();
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


