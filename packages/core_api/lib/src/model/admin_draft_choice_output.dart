//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_draft_choice_output.g.dart';

/// AdminDraftChoiceOutput
///
/// Properties:
/// * [id]
/// * [name]
@BuiltValue()
abstract class AdminDraftChoiceOutput
    implements Built<AdminDraftChoiceOutput, AdminDraftChoiceOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  AdminDraftChoiceOutput._();

  factory AdminDraftChoiceOutput([
    void updates(AdminDraftChoiceOutputBuilder b),
  ]) = _$AdminDraftChoiceOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminDraftChoiceOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminDraftChoiceOutput> get serializer =>
      _$AdminDraftChoiceOutputSerializer();
}

class _$AdminDraftChoiceOutputSerializer
    implements PrimitiveSerializer<AdminDraftChoiceOutput> {
  @override
  final Iterable<Type> types = const [
    AdminDraftChoiceOutput,
    _$AdminDraftChoiceOutput,
  ];

  @override
  final String wireName = r'AdminDraftChoiceOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminDraftChoiceOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminDraftChoiceOutput object, {
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
    required AdminDraftChoiceOutputBuilder result,
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
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminDraftChoiceOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminDraftChoiceOutputBuilder();
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
