//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_session_dto_output.g.dart';

/// AdminSessionDtoOutput
///
/// Properties:
/// * [accountId] 
/// * [roles] 
/// * [permissions] - The union of the roles' permissions (AP §6.1), so the panel hides what is not allowed.
/// * [signedInAt] 
/// * [expiresAt] - When the session ends unless used again before (AP §5.2).
@BuiltValue()
abstract class AdminSessionDtoOutput implements Built<AdminSessionDtoOutput, AdminSessionDtoOutputBuilder> {
  @BuiltValueField(wireName: r'accountId')
  String get accountId;

  @BuiltValueField(wireName: r'roles')
  BuiltList<String> get roles;

  /// The union of the roles' permissions (AP §6.1), so the panel hides what is not allowed.
  @BuiltValueField(wireName: r'permissions')
  BuiltList<String> get permissions;

  @BuiltValueField(wireName: r'signedInAt')
  DateTime get signedInAt;

  /// When the session ends unless used again before (AP §5.2).
  @BuiltValueField(wireName: r'expiresAt')
  DateTime get expiresAt;

  AdminSessionDtoOutput._();

  factory AdminSessionDtoOutput([void updates(AdminSessionDtoOutputBuilder b)]) = _$AdminSessionDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSessionDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSessionDtoOutput> get serializer => _$AdminSessionDtoOutputSerializer();
}

class _$AdminSessionDtoOutputSerializer implements PrimitiveSerializer<AdminSessionDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminSessionDtoOutput, _$AdminSessionDtoOutput];

  @override
  final String wireName = r'AdminSessionDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSessionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accountId';
    yield serializers.serialize(
      object.accountId,
      specifiedType: const FullType(String),
    );
    yield r'roles';
    yield serializers.serialize(
      object.roles,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'permissions';
    yield serializers.serialize(
      object.permissions,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'signedInAt';
    yield serializers.serialize(
      object.signedInAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'expiresAt';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSessionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminSessionDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accountId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.accountId = valueDes;
          break;
        case r'roles':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.roles.replace(valueDes);
          break;
        case r'permissions':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(String)]),
          ) as BuiltList<String>;
          result.permissions.replace(valueDes);
          break;
        case r'signedInAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.signedInAt = valueDes;
          break;
        case r'expiresAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSessionDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSessionDtoOutputBuilder();
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


