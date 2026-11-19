//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_category_order_dto.g.dart';

/// MerchantMenuCategoryOrderDto
///
/// Properties:
/// * [categoryIds] - Every category once, in the new order.
@BuiltValue()
abstract class MerchantMenuCategoryOrderDto
    implements
        Built<
          MerchantMenuCategoryOrderDto,
          MerchantMenuCategoryOrderDtoBuilder
        > {
  /// Every category once, in the new order.
  @BuiltValueField(wireName: r'categoryIds')
  BuiltList<String> get categoryIds;

  MerchantMenuCategoryOrderDto._();

  factory MerchantMenuCategoryOrderDto([
    void updates(MerchantMenuCategoryOrderDtoBuilder b),
  ]) = _$MerchantMenuCategoryOrderDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuCategoryOrderDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuCategoryOrderDto> get serializer =>
      _$MerchantMenuCategoryOrderDtoSerializer();
}

class _$MerchantMenuCategoryOrderDtoSerializer
    implements PrimitiveSerializer<MerchantMenuCategoryOrderDto> {
  @override
  final Iterable<Type> types = const [
    MerchantMenuCategoryOrderDto,
    _$MerchantMenuCategoryOrderDto,
  ];

  @override
  final String wireName = r'MerchantMenuCategoryOrderDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuCategoryOrderDto object, {
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
    MerchantMenuCategoryOrderDto object, {
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
    required MerchantMenuCategoryOrderDtoBuilder result,
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
  MerchantMenuCategoryOrderDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuCategoryOrderDtoBuilder();
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
