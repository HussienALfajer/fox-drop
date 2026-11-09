//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_images_dto_output_categories_inner_items_inner.g.dart';

/// AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [photoKey] - Its key in public-media, shown through /media/ (architecture §5.8); null without one.
@BuiltValue()
abstract class AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner
    implements
        Built<
          AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner,
          AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Its key in public-media, shown through /media/ (architecture §5.8); null without one.
  @BuiltValueField(wireName: r'photoKey')
  String? get photoKey;

  AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner._();

  factory AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner([
    void updates(
      AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder b,
    ),
  ]) = _$AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner>
  get serializer =>
      _$AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerSerializer();
}

class _$AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner,
    _$AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner,
  ];

  @override
  final String wireName =
      r'AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner object, {
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
    yield r'photoKey';
    yield object.photoKey == null
        ? null
        : serializers.serialize(
            object.photoKey,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner object, {
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
    required AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder
    result,
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
        case r'photoKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.photoKey = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        AdminRestaurantImagesDtoOutputCategoriesInnerItemsInnerBuilder();
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
