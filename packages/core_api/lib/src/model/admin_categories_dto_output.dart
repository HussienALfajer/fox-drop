//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_categories_dto_output_categories_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_categories_dto_output.g.dart';

/// AdminCategoriesDtoOutput
///
/// Properties:
/// * [categories] - In their order, removed ones included.
@BuiltValue()
abstract class AdminCategoriesDtoOutput
    implements
        Built<AdminCategoriesDtoOutput, AdminCategoriesDtoOutputBuilder> {
  /// In their order, removed ones included.
  @BuiltValueField(wireName: r'categories')
  BuiltList<AdminCategoriesDtoOutputCategoriesInner> get categories;

  AdminCategoriesDtoOutput._();

  factory AdminCategoriesDtoOutput([
    void updates(AdminCategoriesDtoOutputBuilder b),
  ]) = _$AdminCategoriesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCategoriesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCategoriesDtoOutput> get serializer =>
      _$AdminCategoriesDtoOutputSerializer();
}

class _$AdminCategoriesDtoOutputSerializer
    implements PrimitiveSerializer<AdminCategoriesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCategoriesDtoOutput,
    _$AdminCategoriesDtoOutput,
  ];

  @override
  final String wireName = r'AdminCategoriesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCategoriesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCategoriesDtoOutputCategoriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCategoriesDtoOutput object, {
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
    required AdminCategoriesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categories':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCategoriesDtoOutputCategoriesInner),
                    ]),
                  )
                  as BuiltList<AdminCategoriesDtoOutputCategoriesInner>;
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
  AdminCategoriesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCategoriesDtoOutputBuilder();
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
