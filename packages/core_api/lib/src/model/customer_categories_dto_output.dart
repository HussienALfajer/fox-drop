//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_categories_dto_output_categories_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_categories_dto_output.g.dart';

/// CustomerCategoriesDtoOutput
///
/// Properties:
/// * [categories] - The active categories, in the panel’s order.
@BuiltValue()
abstract class CustomerCategoriesDtoOutput
    implements
        Built<CustomerCategoriesDtoOutput, CustomerCategoriesDtoOutputBuilder> {
  /// The active categories, in the panel’s order.
  @BuiltValueField(wireName: r'categories')
  BuiltList<CustomerCategoriesDtoOutputCategoriesInner> get categories;

  CustomerCategoriesDtoOutput._();

  factory CustomerCategoriesDtoOutput([
    void updates(CustomerCategoriesDtoOutputBuilder b),
  ]) = _$CustomerCategoriesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerCategoriesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerCategoriesDtoOutput> get serializer =>
      _$CustomerCategoriesDtoOutputSerializer();
}

class _$CustomerCategoriesDtoOutputSerializer
    implements PrimitiveSerializer<CustomerCategoriesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    CustomerCategoriesDtoOutput,
    _$CustomerCategoriesDtoOutput,
  ];

  @override
  final String wireName = r'CustomerCategoriesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerCategoriesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerCategoriesDtoOutputCategoriesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerCategoriesDtoOutput object, {
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
    required CustomerCategoriesDtoOutputBuilder result,
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
                      FullType(CustomerCategoriesDtoOutputCategoriesInner),
                    ]),
                  )
                  as BuiltList<CustomerCategoriesDtoOutputCategoriesInner>;
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
  CustomerCategoriesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerCategoriesDtoOutputBuilder();
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
