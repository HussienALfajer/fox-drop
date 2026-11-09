//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_option_groups_inner_options_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_dto_output_categories_inner_items_inner_option_groups_inner.g.dart';

/// MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner
///
/// Properties:
/// * [id]
/// * [name]
/// * [minChoices]
/// * [maxChoices]
/// * [options]
@BuiltValue()
abstract class MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner
    implements
        Built<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner,
          MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'minChoices')
  int get minChoices;

  @BuiltValueField(wireName: r'maxChoices')
  int get maxChoices;

  @BuiltValueField(wireName: r'options')
  BuiltList<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
  >
  get options;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner._();

  factory MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner([
    void updates(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder b,
    ),
  ]) = _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner
  >
  get serializer =>
      _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerSerializer();
}

class _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner,
    _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner,
  ];

  @override
  final String wireName =
      r'MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner object, {
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
    yield r'minChoices';
    yield serializers.serialize(
      object.minChoices,
      specifiedType: const FullType(int),
    );
    yield r'maxChoices';
    yield serializers.serialize(
      object.maxChoices,
      specifiedType: const FullType(int),
    );
    yield r'options';
    yield serializers.serialize(
      object.options,
      specifiedType: const FullType(BuiltList, [
        FullType(
          MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner,
        ),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner object, {
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
    required MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder
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
        case r'minChoices':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.minChoices = valueDes;
          break;
        case r'maxChoices':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.maxChoices = valueDes;
          break;
        case r'options':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
                  >;
          result.options.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder();
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
