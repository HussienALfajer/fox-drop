//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_current_drawer_session_dto_output_session.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_current_drawer_session_dto_output.g.dart';

/// AdminCurrentDrawerSessionDtoOutput
///
/// Properties:
/// * [session]
/// * [currencies] - The city's enabled currencies in display order: the float's fields.
@BuiltValue()
abstract class AdminCurrentDrawerSessionDtoOutput
    implements
        Built<
          AdminCurrentDrawerSessionDtoOutput,
          AdminCurrentDrawerSessionDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'session')
  AdminCurrentDrawerSessionDtoOutputSession? get session;

  /// The city's enabled currencies in display order: the float's fields.
  @BuiltValueField(wireName: r'currencies')
  BuiltList<String> get currencies;

  AdminCurrentDrawerSessionDtoOutput._();

  factory AdminCurrentDrawerSessionDtoOutput([
    void updates(AdminCurrentDrawerSessionDtoOutputBuilder b),
  ]) = _$AdminCurrentDrawerSessionDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCurrentDrawerSessionDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCurrentDrawerSessionDtoOutput> get serializer =>
      _$AdminCurrentDrawerSessionDtoOutputSerializer();
}

class _$AdminCurrentDrawerSessionDtoOutputSerializer
    implements PrimitiveSerializer<AdminCurrentDrawerSessionDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCurrentDrawerSessionDtoOutput,
    _$AdminCurrentDrawerSessionDtoOutput,
  ];

  @override
  final String wireName = r'AdminCurrentDrawerSessionDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCurrentDrawerSessionDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'session';
    yield object.session == null
        ? null
        : serializers.serialize(
            object.session,
            specifiedType: const FullType.nullable(
              AdminCurrentDrawerSessionDtoOutputSession,
            ),
          );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCurrentDrawerSessionDtoOutput object, {
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
    required AdminCurrentDrawerSessionDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'session':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminCurrentDrawerSessionDtoOutputSession,
                    ),
                  )
                  as AdminCurrentDrawerSessionDtoOutputSession?;
          if (valueDes == null) continue;
          result.session.replace(valueDes);
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.currencies.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCurrentDrawerSessionDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCurrentDrawerSessionDtoOutputBuilder();
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
