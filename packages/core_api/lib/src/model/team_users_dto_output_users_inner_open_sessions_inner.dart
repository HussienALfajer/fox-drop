//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'team_users_dto_output_users_inner_open_sessions_inner.g.dart';

/// TeamUsersDtoOutputUsersInnerOpenSessionsInner
///
/// Properties:
/// * [id] 
/// * [userAgent] 
/// * [ipAddress] 
/// * [signedInAt] 
/// * [lastActivityAt] 
@BuiltValue()
abstract class TeamUsersDtoOutputUsersInnerOpenSessionsInner implements Built<TeamUsersDtoOutputUsersInnerOpenSessionsInner, TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'userAgent')
  String? get userAgent;

  @BuiltValueField(wireName: r'ipAddress')
  String? get ipAddress;

  @BuiltValueField(wireName: r'signedInAt')
  DateTime get signedInAt;

  @BuiltValueField(wireName: r'lastActivityAt')
  DateTime get lastActivityAt;

  TeamUsersDtoOutputUsersInnerOpenSessionsInner._();

  factory TeamUsersDtoOutputUsersInnerOpenSessionsInner([void updates(TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder b)]) = _$TeamUsersDtoOutputUsersInnerOpenSessionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TeamUsersDtoOutputUsersInnerOpenSessionsInner> get serializer => _$TeamUsersDtoOutputUsersInnerOpenSessionsInnerSerializer();
}

class _$TeamUsersDtoOutputUsersInnerOpenSessionsInnerSerializer implements PrimitiveSerializer<TeamUsersDtoOutputUsersInnerOpenSessionsInner> {
  @override
  final Iterable<Type> types = const [TeamUsersDtoOutputUsersInnerOpenSessionsInner, _$TeamUsersDtoOutputUsersInnerOpenSessionsInner];

  @override
  final String wireName = r'TeamUsersDtoOutputUsersInnerOpenSessionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TeamUsersDtoOutputUsersInnerOpenSessionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'userAgent';
    yield object.userAgent == null ? null : serializers.serialize(
      object.userAgent,
      specifiedType: const FullType.nullable(String),
    );
    yield r'ipAddress';
    yield object.ipAddress == null ? null : serializers.serialize(
      object.ipAddress,
      specifiedType: const FullType.nullable(String),
    );
    yield r'signedInAt';
    yield serializers.serialize(
      object.signedInAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'lastActivityAt';
    yield serializers.serialize(
      object.lastActivityAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TeamUsersDtoOutputUsersInnerOpenSessionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'userAgent':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.userAgent = valueDes;
          break;
        case r'ipAddress':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.ipAddress = valueDes;
          break;
        case r'signedInAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.signedInAt = valueDes;
          break;
        case r'lastActivityAt':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.lastActivityAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TeamUsersDtoOutputUsersInnerOpenSessionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeamUsersDtoOutputUsersInnerOpenSessionsInnerBuilder();
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


