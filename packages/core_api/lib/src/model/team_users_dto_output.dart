//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/team_users_dto_output_users_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'team_users_dto_output.g.dart';

/// TeamUsersDtoOutput
///
/// Properties:
/// * [users]
@BuiltValue()
abstract class TeamUsersDtoOutput
    implements Built<TeamUsersDtoOutput, TeamUsersDtoOutputBuilder> {
  @BuiltValueField(wireName: r'users')
  BuiltList<TeamUsersDtoOutputUsersInner> get users;

  TeamUsersDtoOutput._();

  factory TeamUsersDtoOutput([void updates(TeamUsersDtoOutputBuilder b)]) =
      _$TeamUsersDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(TeamUsersDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<TeamUsersDtoOutput> get serializer =>
      _$TeamUsersDtoOutputSerializer();
}

class _$TeamUsersDtoOutputSerializer
    implements PrimitiveSerializer<TeamUsersDtoOutput> {
  @override
  final Iterable<Type> types = const [TeamUsersDtoOutput, _$TeamUsersDtoOutput];

  @override
  final String wireName = r'TeamUsersDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    TeamUsersDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'users';
    yield serializers.serialize(
      object.users,
      specifiedType: const FullType(BuiltList, [
        FullType(TeamUsersDtoOutputUsersInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    TeamUsersDtoOutput object, {
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
    required TeamUsersDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'users':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(TeamUsersDtoOutputUsersInner),
                    ]),
                  )
                  as BuiltList<TeamUsersDtoOutputUsersInner>;
          result.users.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  TeamUsersDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeamUsersDtoOutputBuilder();
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
