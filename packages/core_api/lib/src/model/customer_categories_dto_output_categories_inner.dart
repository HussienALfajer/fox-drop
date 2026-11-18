//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_categories_dto_output_categories_inner.g.dart';

/// CustomerCategoriesDtoOutputCategoriesInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [imageKey] - Its key in public-media, shown through /media/; null without one.
@BuiltValue()
abstract class CustomerCategoriesDtoOutputCategoriesInner
    implements
        Built<
          CustomerCategoriesDtoOutputCategoriesInner,
          CustomerCategoriesDtoOutputCategoriesInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  /// Its key in public-media, shown through /media/; null without one.
  @BuiltValueField(wireName: r'imageKey')
  String? get imageKey;

  CustomerCategoriesDtoOutputCategoriesInner._();

  factory CustomerCategoriesDtoOutputCategoriesInner([
    void updates(CustomerCategoriesDtoOutputCategoriesInnerBuilder b),
  ]) = _$CustomerCategoriesDtoOutputCategoriesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerCategoriesDtoOutputCategoriesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerCategoriesDtoOutputCategoriesInner>
  get serializer => _$CustomerCategoriesDtoOutputCategoriesInnerSerializer();
}

class _$CustomerCategoriesDtoOutputCategoriesInnerSerializer
    implements PrimitiveSerializer<CustomerCategoriesDtoOutputCategoriesInner> {
  @override
  final Iterable<Type> types = const [
    CustomerCategoriesDtoOutputCategoriesInner,
    _$CustomerCategoriesDtoOutputCategoriesInner,
  ];

  @override
  final String wireName = r'CustomerCategoriesDtoOutputCategoriesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerCategoriesDtoOutputCategoriesInner object, {
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
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerCategoriesDtoOutputCategoriesInner object, {
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
    required CustomerCategoriesDtoOutputCategoriesInnerBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerCategoriesDtoOutputCategoriesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerCategoriesDtoOutputCategoriesInnerBuilder();
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
