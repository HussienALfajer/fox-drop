//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_restaurant_images_dto_output_categories_inner_items_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_images_dto_output_categories_inner.g.dart';

/// AdminRestaurantImagesDtoOutputCategoriesInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [items]
@BuiltValue()
abstract class AdminRestaurantImagesDtoOutputCategoriesInner
    implements
        Built<
          AdminRestaurantImagesDtoOutputCategoriesInner,
          AdminRestaurantImagesDtoOutputCategoriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'items')
  BuiltList<AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner> get items;

  AdminRestaurantImagesDtoOutputCategoriesInner._();

  factory AdminRestaurantImagesDtoOutputCategoriesInner([
    void updates(AdminRestaurantImagesDtoOutputCategoriesInnerBuilder b),
  ]) = _$AdminRestaurantImagesDtoOutputCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantImagesDtoOutputCategoriesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantImagesDtoOutputCategoriesInner>
  get serializer => _$AdminRestaurantImagesDtoOutputCategoriesInnerSerializer();
}

class _$AdminRestaurantImagesDtoOutputCategoriesInnerSerializer
    implements
        PrimitiveSerializer<AdminRestaurantImagesDtoOutputCategoriesInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantImagesDtoOutputCategoriesInner,
    _$AdminRestaurantImagesDtoOutputCategoriesInner,
  ];

  @override
  final String wireName = r'AdminRestaurantImagesDtoOutputCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantImagesDtoOutputCategoriesInner object, {
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
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantImagesDtoOutputCategoriesInner object, {
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
    required AdminRestaurantImagesDtoOutputCategoriesInnerBuilder result,
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
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminRestaurantImagesDtoOutputCategoriesInnerItemsInner
                  >;
          result.items.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantImagesDtoOutputCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantImagesDtoOutputCategoriesInnerBuilder();
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
