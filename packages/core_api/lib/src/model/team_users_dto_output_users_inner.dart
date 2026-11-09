//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/team_users_dto_output_users_inner_open_sessions_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'team_users_dto_output_users_inner.g.dart';

/// TeamUsersDtoOutputUsersInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [email]
/// * [phone]
/// * [roles]
/// * [status]
/// * [totpEnrolled]
/// * [lastSignInAt]
/// * [openSessions]
@BuiltValue()
abstract class TeamUsersDtoOutputUsersInner
    implements
        Built<
          TeamUsersDtoOutputUsersInner,
          TeamUsersDtoOutputUsersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'email')
  String? get email;

  @BuiltValueField(wireName: r'phone')
  String? get phone;

  @BuiltValueField(wireName: r'roles')
  BuiltList<String> get roles;

  @BuiltValueField(wireName: r'status')
  TeamUsersDtoOutputUsersInnerStatusEnum get status;
  // enum statusEnum {  pending,  active,  totp_reset,  disabled,  };

  @BuiltValueField(wireName: r'totpEnrolled')
  bool get totpEnrolled;

  @BuiltValueField(wireName: r'lastSignInAt')
  DateTime? get lastSignInAt;

  @BuiltValueField(wireName: r'openSessions')
  BuiltList<TeamUsersDtoOutputUsersInnerOpenSessionsInner> get openSessions;

  TeamUsersDtoOutputUsersInner._();

  factory TeamUsersDtoOutputUsersInner([
    void updates(TeamUsersDtoOutputUsersInnerBuilder b),
  ]) = _$TeamUsersDtoOutputUsersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TeamUsersDtoOutputUsersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TeamUsersDtoOutputUsersInner> get serializer =>
      _$TeamUsersDtoOutputUsersInnerSerializer();
}

class _$TeamUsersDtoOutputUsersInnerSerializer
    implements PrimitiveSerializer<TeamUsersDtoOutputUsersInner> {
  @override
  final Iterable<Type> types = const [
    TeamUsersDtoOutputUsersInner,
    _$TeamUsersDtoOutputUsersInner,
  ];

  @override
  final String wireName = r'TeamUsersDtoOutputUsersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TeamUsersDtoOutputUsersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield object.name == null
        ? null
        : serializers.serialize(
            object.name,
            specifiedType: const FullType.nullable(String),
          );
    yield r'email';
    yield object.email == null
        ? null
        : serializers.serialize(
            object.email,
            specifiedType: const FullType.nullable(String),
          );
    yield r'phone';
    yield object.phone == null
        ? null
        : serializers.serialize(
            object.phone,
            specifiedType: const FullType.nullable(String),
          );
    yield r'roles';
    yield serializers.serialize(
      object.roles,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(TeamUsersDtoOutputUsersInnerStatusEnum),
    );
    yield r'totpEnrolled';
    yield serializers.serialize(
      object.totpEnrolled,
      specifiedType: const FullType(bool),
    );
    yield r'lastSignInAt';
    yield object.lastSignInAt == null
        ? null
        : serializers.serialize(
            object.lastSignInAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'openSessions';
    yield serializers.serialize(
      object.openSessions,
      specifiedType: const FullType(BuiltList, [
        FullType(TeamUsersDtoOutputUsersInnerOpenSessionsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TeamUsersDtoOutputUsersInner object, {
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
    required TeamUsersDtoOutputUsersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'email':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.email = valueDes;
          break;
        case r'phone':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.phone = valueDes;
          break;
        case r'roles':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.roles.replace(valueDes);
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      TeamUsersDtoOutputUsersInnerStatusEnum,
                    ),
                  )
                  as TeamUsersDtoOutputUsersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'totpEnrolled':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.totpEnrolled = valueDes;
          break;
        case r'lastSignInAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.lastSignInAt = valueDes;
          break;
        case r'openSessions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(TeamUsersDtoOutputUsersInnerOpenSessionsInner),
                    ]),
                  )
                  as BuiltList<TeamUsersDtoOutputUsersInnerOpenSessionsInner>;
          result.openSessions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TeamUsersDtoOutputUsersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeamUsersDtoOutputUsersInnerBuilder();
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

class TeamUsersDtoOutputUsersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const TeamUsersDtoOutputUsersInnerStatusEnum pending =
      _$teamUsersDtoOutputUsersInnerStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'active')
  static const TeamUsersDtoOutputUsersInnerStatusEnum active =
      _$teamUsersDtoOutputUsersInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'totp_reset')
  static const TeamUsersDtoOutputUsersInnerStatusEnum totpReset =
      _$teamUsersDtoOutputUsersInnerStatusEnum_totpReset;
  @BuiltValueEnumConst(wireName: r'disabled')
  static const TeamUsersDtoOutputUsersInnerStatusEnum disabled =
      _$teamUsersDtoOutputUsersInnerStatusEnum_disabled;

  static Serializer<TeamUsersDtoOutputUsersInnerStatusEnum> get serializer =>
      _$teamUsersDtoOutputUsersInnerStatusEnumSerializer;

  const TeamUsersDtoOutputUsersInnerStatusEnum._(String name) : super(name);

  static BuiltSet<TeamUsersDtoOutputUsersInnerStatusEnum> get values =>
      _$teamUsersDtoOutputUsersInnerStatusEnumValues;
  static TeamUsersDtoOutputUsersInnerStatusEnum valueOf(String name) =>
      _$teamUsersDtoOutputUsersInnerStatusEnumValueOf(name);
}
