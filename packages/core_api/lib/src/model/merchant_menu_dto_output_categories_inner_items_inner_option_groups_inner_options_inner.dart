//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_switched_off.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_price.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_dto_output_categories_inner_items_inner_option_groups_inner_options_inner.g.dart';

/// MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [priceDelta]
/// * [available]
/// * [switchedOff]
@BuiltValue()
abstract class MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
    implements
        Built<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner,
          MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'priceDelta')
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice get priceDelta;

  @BuiltValueField(wireName: r'available')
  bool get available;

  @BuiltValueField(wireName: r'switchedOff')
  MerchantMenuDtoOutputCategoriesInnerSwitchedOff? get switchedOff;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner._();

  factory MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner([
    void updates(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
      b,
    ),
  ]) =
      _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
    b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
  >
  get serializer =>
      _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInnerSerializer();
}

class _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner,
    _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner,
  ];

  @override
  final String wireName =
      r'MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
    object, {
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
    yield r'priceDelta';
    yield serializers.serialize(
      object.priceDelta,
      specifiedType: const FullType(
        MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
      ),
    );
    yield r'available';
    yield serializers.serialize(
      object.available,
      specifiedType: const FullType(bool),
    );
    yield r'switchedOff';
    yield object.switchedOff == null
        ? null
        : serializers.serialize(
            object.switchedOff,
            specifiedType: const FullType.nullable(
              MerchantMenuDtoOutputCategoriesInnerSwitchedOff,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
    object, {
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
    required MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder
    result,
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
        case r'priceDelta':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
                    ),
                  )
                  as MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice;
          result.priceDelta.replace(valueDes);
          break;
        case r'available':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.available = valueDes;
          break;
        case r'switchedOff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantMenuDtoOutputCategoriesInnerSwitchedOff,
                    ),
                  )
                  as MerchantMenuDtoOutputCategoriesInnerSwitchedOff?;
          if (valueDes == null) continue;
          result.switchedOff.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
  deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInnerBuilder();
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
