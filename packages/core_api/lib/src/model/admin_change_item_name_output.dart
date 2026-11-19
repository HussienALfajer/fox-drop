//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_item_name_output.g.dart';

/// AdminChangeItemNameOutput
///
/// Properties:
/// * [id]
/// * [name]
@BuiltValue()
abstract class AdminChangeItemNameOutput
    implements
        Built<AdminChangeItemNameOutput, AdminChangeItemNameOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  AdminChangeItemNameOutput._();

  factory AdminChangeItemNameOutput([
    void updates(AdminChangeItemNameOutputBuilder b),
  ]) = _$AdminChangeItemNameOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeItemNameOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeItemNameOutput> get serializer =>
      _$AdminChangeItemNameOutputSerializer();
}

class _$AdminChangeItemNameOutputSerializer
    implements PrimitiveSerializer<AdminChangeItemNameOutput> {
  @override
  final Iterable<Type> types = const [
    AdminChangeItemNameOutput,
    _$AdminChangeItemNameOutput,
  ];

  @override
  final String wireName = r'AdminChangeItemNameOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeItemNameOutput object, {
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
    AdminChangeItemNameOutput object, {
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
    required AdminChangeItemNameOutputBuilder result,
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
  AdminChangeItemNameOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeItemNameOutputBuilder();
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
