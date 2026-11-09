//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_restaurant_images_dto_output_categories_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_images_dto_output.g.dart';

/// AdminRestaurantImagesDtoOutput
///
/// Properties:
/// * [logoKey] - Its key in public-media, shown through /media/ (architecture §5.8); null without one.
/// * [coverKey] - Its key in public-media, shown through /media/ (architecture §5.8); null without one.
/// * [categories] 
@BuiltValue()
abstract class AdminRestaurantImagesDtoOutput implements Built<AdminRestaurantImagesDtoOutput, AdminRestaurantImagesDtoOutputBuilder> {
  /// Its key in public-media, shown through /media/ (architecture §5.8); null without one.
  @BuiltValueField(wireName: r'logoKey')
  String? get logoKey;

  /// Its key in public-media, shown through /media/ (architecture §5.8); null without one.
  @BuiltValueField(wireName: r'coverKey')
  String? get coverKey;

  @BuiltValueField(wireName: r'categories')
  BuiltList<AdminRestaurantImagesDtoOutputCategoriesInner> get categories;

  AdminRestaurantImagesDtoOutput._();

  factory AdminRestaurantImagesDtoOutput([void updates(AdminRestaurantImagesDtoOutputBuilder b)]) = _$AdminRestaurantImagesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantImagesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantImagesDtoOutput> get serializer => _$AdminRestaurantImagesDtoOutputSerializer();
}

class _$AdminRestaurantImagesDtoOutputSerializer implements PrimitiveSerializer<AdminRestaurantImagesDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminRestaurantImagesDtoOutput, _$AdminRestaurantImagesDtoOutput];

  @override
  final String wireName = r'AdminRestaurantImagesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantImagesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'logoKey';
    yield object.logoKey == null ? null : serializers.serialize(
      object.logoKey,
      specifiedType: const FullType.nullable(String),
    );
    yield r'coverKey';
    yield object.coverKey == null ? null : serializers.serialize(
      object.coverKey,
      specifiedType: const FullType.nullable(String),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [FullType(AdminRestaurantImagesDtoOutputCategoriesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantImagesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminRestaurantImagesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'logoKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.logoKey = valueDes;
          break;
        case r'coverKey':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.coverKey = valueDes;
          break;
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(AdminRestaurantImagesDtoOutputCategoriesInner)]),
          ) as BuiltList<AdminRestaurantImagesDtoOutputCategoriesInner>;
          result.categories.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantImagesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantImagesDtoOutputBuilder();
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


