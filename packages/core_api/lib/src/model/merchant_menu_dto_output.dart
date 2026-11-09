//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_dto_output.g.dart';

/// MerchantMenuDtoOutput
///
/// Properties:
/// * [categories] 
@BuiltValue()
abstract class MerchantMenuDtoOutput implements Built<MerchantMenuDtoOutput, MerchantMenuDtoOutputBuilder> {
  @BuiltValueField(wireName: r'categories')
  BuiltList<MerchantMenuDtoOutputCategoriesInner> get categories;

  MerchantMenuDtoOutput._();

  factory MerchantMenuDtoOutput([void updates(MerchantMenuDtoOutputBuilder b)]) = _$MerchantMenuDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuDtoOutput> get serializer => _$MerchantMenuDtoOutputSerializer();
}

class _$MerchantMenuDtoOutputSerializer implements PrimitiveSerializer<MerchantMenuDtoOutput> {
  @override
  final Iterable<Type> types = const [MerchantMenuDtoOutput, _$MerchantMenuDtoOutput];

  @override
  final String wireName = r'MerchantMenuDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [FullType(MerchantMenuDtoOutputCategoriesInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantMenuDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categories':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantMenuDtoOutputCategoriesInner)]),
          ) as BuiltList<MerchantMenuDtoOutputCategoriesInner>;
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
  MerchantMenuDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuDtoOutputBuilder();
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


