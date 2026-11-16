//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_current_drawer_session_dto_output_field.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_drawer_sessions_dto_output.g.dart';

/// AdminDrawerSessionsDtoOutput
///
/// Properties:
/// * [sessions]
@BuiltValue()
abstract class AdminDrawerSessionsDtoOutput
    implements
        Built<
          AdminDrawerSessionsDtoOutput,
          AdminDrawerSessionsDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'sessions')
  BuiltList<AdminCurrentDrawerSessionDtoOutputField?> get sessions;

  AdminDrawerSessionsDtoOutput._();

  factory AdminDrawerSessionsDtoOutput([
    void updates(AdminDrawerSessionsDtoOutputBuilder b),
  ]) = _$AdminDrawerSessionsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDrawerSessionsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDrawerSessionsDtoOutput> get serializer =>
      _$AdminDrawerSessionsDtoOutputSerializer();
}

class _$AdminDrawerSessionsDtoOutputSerializer
    implements PrimitiveSerializer<AdminDrawerSessionsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDrawerSessionsDtoOutput,
    _$AdminDrawerSessionsDtoOutput,
  ];

  @override
  final String wireName = r'AdminDrawerSessionsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDrawerSessionsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'sessions';
    yield serializers.serialize(
      object.sessions,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(AdminCurrentDrawerSessionDtoOutputField),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDrawerSessionsDtoOutput object, {
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
    required AdminDrawerSessionsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'sessions':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        AdminCurrentDrawerSessionDtoOutputField,
                      ),
                    ]),
                  )
                  as BuiltList<AdminCurrentDrawerSessionDtoOutputField?>;
          result.sessions.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDrawerSessionsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDrawerSessionsDtoOutputBuilder();
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
