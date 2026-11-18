//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_categories_dto_output.g.dart';

/// AdminRestaurantCategoriesDtoOutput
///
/// Properties:
/// * [categoryIds] - Active categories of «التصنيفات» (AP §9.13), once each, in the chosen order.
@BuiltValue()
abstract class AdminRestaurantCategoriesDtoOutput
    implements
        Built<
          AdminRestaurantCategoriesDtoOutput,
          AdminRestaurantCategoriesDtoOutputBuilder
        > {
  /// Active categories of «التصنيفات» (AP §9.13), once each, in the chosen order.
  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String> get categoryIds;

  AdminRestaurantCategoriesDtoOutput._();

  factory AdminRestaurantCategoriesDtoOutput([
    void updates(AdminRestaurantCategoriesDtoOutputBuilder b),
  ]) = _$AdminRestaurantCategoriesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantCategoriesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantCategoriesDtoOutput> get serializer =>
      _$AdminRestaurantCategoriesDtoOutputSerializer();
}

class _$AdminRestaurantCategoriesDtoOutputSerializer
    implements PrimitiveSerializer<AdminRestaurantCategoriesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantCategoriesDtoOutput,
    _$AdminRestaurantCategoriesDtoOutput,
  ];

  @override
  final String wireName = r'AdminRestaurantCategoriesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantCategoriesDtoOutput object, {
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
    AdminRestaurantCategoriesDtoOutput object, {
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
    required AdminRestaurantCategoriesDtoOutputBuilder result,
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
  AdminRestaurantCategoriesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantCategoriesDtoOutputBuilder();
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
