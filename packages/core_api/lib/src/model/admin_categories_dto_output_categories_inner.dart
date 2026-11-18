//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_categories_dto_output_categories_inner.g.dart';

/// AdminCategoriesDtoOutputCategoriesInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [imageKey] - Its key in public-media, shown through /media/ (architecture §5.8); null without one.
/// * [active] - False once removed: off the cards and the list, kept on its restaurants.
@BuiltValue()
abstract class AdminCategoriesDtoOutputCategoriesInner
    implements
        Built<
          AdminCategoriesDtoOutputCategoriesInner,
          AdminCategoriesDtoOutputCategoriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Its key in public-media, shown through /media/ (architecture §5.8); null without one.
  @BuiltValueField(wireName: r'imageKey')
  String? get imageKey;

  /// False once removed: off the cards and the list, kept on its restaurants.
  @BuiltValueField(wireName: r'active')
  bool get active;

  AdminCategoriesDtoOutputCategoriesInner._();

  factory AdminCategoriesDtoOutputCategoriesInner([
    void updates(AdminCategoriesDtoOutputCategoriesInnerBuilder b),
  ]) = _$AdminCategoriesDtoOutputCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCategoriesDtoOutputCategoriesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCategoriesDtoOutputCategoriesInner> get serializer =>
      _$AdminCategoriesDtoOutputCategoriesInnerSerializer();
}

class _$AdminCategoriesDtoOutputCategoriesInnerSerializer
    implements PrimitiveSerializer<AdminCategoriesDtoOutputCategoriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminCategoriesDtoOutputCategoriesInner,
    _$AdminCategoriesDtoOutputCategoriesInner,
  ];

  @override
  final String wireName = r'AdminCategoriesDtoOutputCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCategoriesDtoOutputCategoriesInner object, {
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
    yield r'imageKey';
    yield object.imageKey == null
        ? null
        : serializers.serialize(
            object.imageKey,
            specifiedType: const FullType.nullable(String),
          );
    yield r'active';
    yield serializers.serialize(
      object.active,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCategoriesDtoOutputCategoriesInner object, {
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
    required AdminCategoriesDtoOutputCategoriesInnerBuilder result,
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
        case r'imageKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.imageKey = valueDes;
          break;
        case r'active':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.active = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCategoriesDtoOutputCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCategoriesDtoOutputCategoriesInnerBuilder();
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
