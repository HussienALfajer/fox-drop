//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_edit_dto_keep_inner.g.dart';

/// AdminEditDtoKeepInner
///
/// Properties:
/// * [position] - A current line's position (the detail's lines).
/// * [quantity]
@BuiltValue()
abstract class AdminEditDtoKeepInner
    implements Built<AdminEditDtoKeepInner, AdminEditDtoKeepInnerBuilder> {
  /// A current line's position (the detail's lines).
  @BuiltValueField(wireName: r'position')
  int get position;

  @BuiltValueField(wireName: r'quantity')
  int get quantity;

  AdminEditDtoKeepInner._();

  factory AdminEditDtoKeepInner([
    void updates(AdminEditDtoKeepInnerBuilder b),
  ]) = _$AdminEditDtoKeepInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminEditDtoKeepInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminEditDtoKeepInner> get serializer =>
      _$AdminEditDtoKeepInnerSerializer();
}

class _$AdminEditDtoKeepInnerSerializer
    implements PrimitiveSerializer<AdminEditDtoKeepInner> {
  @override
  final Iterable<Type> types = const [
    AdminEditDtoKeepInner,
    _$AdminEditDtoKeepInner,
  ];

  @override
  final String wireName = r'AdminEditDtoKeepInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminEditDtoKeepInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'position';
    yield serializers.serialize(
      object.position,
      specifiedType: const FullType(int),
    );
    yield r'quantity';
    yield serializers.serialize(
      object.quantity,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminEditDtoKeepInner object, {
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
    required AdminEditDtoKeepInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'position':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.position = valueDes;
          break;
        case r'quantity':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.quantity = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminEditDtoKeepInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminEditDtoKeepInnerBuilder();
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
