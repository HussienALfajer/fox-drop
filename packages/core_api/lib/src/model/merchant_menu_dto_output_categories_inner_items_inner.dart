//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_switched_off.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_option_groups_inner.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_price.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_dto_output_categories_inner_items_inner.g.dart';

/// MerchantMenuDtoOutputCategoriesInnerItemsInner
///
/// Properties:
/// * [id] 
/// * [code] 
/// * [name] 
/// * [description] 
/// * [price] 
/// * [available] - Whether customers can order it: its switch, its category and its required groups (RA §9.3).
/// * [switchedOff] 
/// * [hidden] 
/// * [optionGroups] 
@BuiltValue()
abstract class MerchantMenuDtoOutputCategoriesInnerItemsInner implements Built<MerchantMenuDtoOutputCategoriesInnerItemsInner, MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'price')
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice get price;

  /// Whether customers can order it: its switch, its category and its required groups (RA §9.3).
  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'switchedOff')
  MerchantMenuDtoOutputCategoriesInnerSwitchedOff? get switchedOff;

  @BuiltValueField(wireName: r'hidden')
  bool get hidden;

  @BuiltValueField(wireName: r'optionGroups')
  BuiltList<MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner> get optionGroups;

  MerchantMenuDtoOutputCategoriesInnerItemsInner._();

  factory MerchantMenuDtoOutputCategoriesInnerItemsInner([void updates(MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder b)]) = _$MerchantMenuDtoOutputCategoriesInnerItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuDtoOutputCategoriesInnerItemsInner> get serializer => _$MerchantMenuDtoOutputCategoriesInnerItemsInnerSerializer();
}

class _$MerchantMenuDtoOutputCategoriesInnerItemsInnerSerializer implements PrimitiveSerializer<MerchantMenuDtoOutputCategoriesInnerItemsInner> {
  @override
  final Iterable<Type> types = const [MerchantMenuDtoOutputCategoriesInnerItemsInner, _$MerchantMenuDtoOutputCategoriesInnerItemsInner];

  @override
  final String wireName = r'MerchantMenuDtoOutputCategoriesInnerItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null ? null : serializers.serialize(
      object.description,
      specifiedType: const FullType.nullable(String),
    );
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'switchedOff';
    yield object.switchedOff == null ? null : serializers.serialize(
      object.switchedOff,
      specifiedType: const FullType.nullable(MerchantMenuDtoOutputCategoriesInnerSwitchedOff),
    );
    yield r'hidden';
    yield serializers.serialize(
      object.hidden,
      specifiedType: const FullType(bool),
    );
    yield r'optionGroups';
    yield serializers.serialize(
      object.optionGroups,
      specifiedType: const FullType(BuiltList, [FullType(MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerItemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice),
          ) as MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice;
          result.price.replace(valueDes);
          break;
        case r'available':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.available = valueDes;
          break;
        case r'switchedOff':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(MerchantMenuDtoOutputCategoriesInnerSwitchedOff),
          ) as MerchantMenuDtoOutputCategoriesInnerSwitchedOff?;
          if (valueDes == null) continue;
          result.switchedOff.replace(valueDes);
          break;
        case r'hidden':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.hidden = valueDes;
          break;
        case r'optionGroups':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner)]),
          ) as BuiltList<MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner>;
          result.optionGroups.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantMenuDtoOutputCategoriesInnerItemsInnerBuilder();
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


