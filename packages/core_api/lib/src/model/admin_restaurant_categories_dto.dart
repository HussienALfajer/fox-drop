//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_categories_dto.g.dart';

/// AdminRestaurantCategoriesDto
///
/// Properties:
/// * [categoryIds] - Active categories of «التصنيفات» (AP §9.13), once each, in the chosen order.
@BuiltValue()
abstract class AdminRestaurantCategoriesDto
    implements
        Built<
          AdminRestaurantCategoriesDto,
          AdminRestaurantCategoriesDtoBuilder
        > {
  /// Active categories of «التصنيفات» (AP §9.13), once each, in the chosen order.
  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String> get categoryIds;

  AdminRestaurantCategoriesDto._();

  factory AdminRestaurantCategoriesDto([
    void updates(AdminRestaurantCategoriesDtoBuilder b),
  ]) = _$AdminRestaurantCategoriesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantCategoriesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantCategoriesDto> get serializer =>
      _$AdminRestaurantCategoriesDtoSerializer();
}

class _$AdminRestaurantCategoriesDtoSerializer
    implements PrimitiveSerializer<AdminRestaurantCategoriesDto> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantCategoriesDto,
    _$AdminRestaurantCategoriesDto,
  ];

  @override
  final String wireName = r'AdminRestaurantCategoriesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantCategoriesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categoryIds';
    yield serializers.serialize(
      object.categoryIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantCategoriesDto object, {
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
    required AdminRestaurantCategoriesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.categoryIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantCategoriesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantCategoriesDtoBuilder();
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
