//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_import_result_dto_output.g.dart';

/// AdminMenuImportResultDtoOutput
///
/// Properties:
/// * [added]
/// * [changed]
/// * [unchanged]
/// * [categoriesAdded]
@BuiltValue()
abstract class AdminMenuImportResultDtoOutput
    implements
        Built<
          AdminMenuImportResultDtoOutput,
          AdminMenuImportResultDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'added')
  int get added;

  @BuiltValueField(wireName: r'changed')
  int get changed;

  @BuiltValueField(wireName: r'unchanged')
  int get unchanged;

  @BuiltValueField(wireName: r'categoriesAdded')
  int get categoriesAdded;

  AdminMenuImportResultDtoOutput._();

  factory AdminMenuImportResultDtoOutput([
    void updates(AdminMenuImportResultDtoOutputBuilder b),
  ]) = _$AdminMenuImportResultDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuImportResultDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuImportResultDtoOutput> get serializer =>
      _$AdminMenuImportResultDtoOutputSerializer();
}

class _$AdminMenuImportResultDtoOutputSerializer
    implements PrimitiveSerializer<AdminMenuImportResultDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminMenuImportResultDtoOutput,
    _$AdminMenuImportResultDtoOutput,
  ];

  @override
  final String wireName = r'AdminMenuImportResultDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuImportResultDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'added';
    yield serializers.serialize(
      object.added,
      specifiedType: const FullType(int),
    );
    yield r'changed';
    yield serializers.serialize(
      object.changed,
      specifiedType: const FullType(int),
    );
    yield r'unchanged';
    yield serializers.serialize(
      object.unchanged,
      specifiedType: const FullType(int),
    );
    yield r'categoriesAdded';
    yield serializers.serialize(
      object.categoriesAdded,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuImportResultDtoOutput object, {
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
    required AdminMenuImportResultDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'added':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.added = valueDes;
          break;
        case r'changed':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.changed = valueDes;
          break;
        case r'unchanged':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.unchanged = valueDes;
          break;
        case r'categoriesAdded':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.categoriesAdded = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuImportResultDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuImportResultDtoOutputBuilder();
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
