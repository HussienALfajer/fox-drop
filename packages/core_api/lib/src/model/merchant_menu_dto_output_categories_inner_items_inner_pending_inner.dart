//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_pending_inner_options_inner.dart';
import 'package:core_api/src/model/merchant_pending_money_output.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_menu_dto_output_categories_inner_items_inner_pending_inner.g.dart';

/// MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner
///
/// Properties:
/// * [requestId]
/// * [field] - `created`: a new row, unseen by customers until approved; otherwise the field asked.
/// * [createdAt]
/// * [name]
/// * [description]
/// * [photoKey] - A photo waiting for review, in public-media.
/// * [price] - A new item's price, a new option's delta.
/// * [categoryId]
/// * [groupId]
/// * [minChoices]
/// * [maxChoices]
/// * [itemIds]
/// * [options]
@BuiltValue()
abstract class MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner
    implements
        Built<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner,
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder
        > {
  @BuiltValueField(wireName: r'requestId')
  String get requestId;

  /// `created`: a new row, unseen by customers until approved; otherwise the field asked.
  @BuiltValueField(wireName: r'field')
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum get field;
  // enum fieldEnum {  created,  rename,  description,  photo,  choices,  items,  };

  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'name')
  String? get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  /// A photo waiting for review, in public-media.
  @BuiltValueField(wireName: r'photoKey')
  String? get photoKey;

  /// A new item's price, a new option's delta.
  @BuiltValueField(wireName: r'price')
  MerchantPendingMoneyOutput? get price;

  @BuiltValueField(wireName: r'categoryId')
  String? get categoryId;

  @BuiltValueField(wireName: r'groupId')
  String? get groupId;

  @BuiltValueField(wireName: r'minChoices')
  int? get minChoices;

  @BuiltValueField(wireName: r'maxChoices')
  int? get maxChoices;

  @BuiltValueField(wireName: r'itemIds')
  BuiltList<String>? get itemIds;

  @BuiltValueField(wireName: r'options')
  BuiltList<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
  >?
  get options;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner._();

  factory MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner([
    void updates(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder b,
    ),
  ]) = _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>
  get serializer =>
      _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerSerializer();
}

class _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner,
    _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner,
  ];

  @override
  final String wireName =
      r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'requestId';
    yield serializers.serialize(
      object.requestId,
      specifiedType: const FullType(String),
    );
    yield r'field';
    yield serializers.serialize(
      object.field,
      specifiedType: const FullType(
        MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum,
      ),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'name';
    yield object.name == null
        ? null
        : serializers.serialize(
            object.name,
            specifiedType: const FullType.nullable(String),
          );
    yield r'description';
    yield object.description == null
        ? null
        : serializers.serialize(
            object.description,
            specifiedType: const FullType.nullable(String),
          );
    yield r'photoKey';
    yield object.photoKey == null
        ? null
        : serializers.serialize(
            object.photoKey,
            specifiedType: const FullType.nullable(String),
          );
    yield r'price';
    yield object.price == null
        ? null
        : serializers.serialize(
            object.price,
            specifiedType: const FullType.nullable(MerchantPendingMoneyOutput),
          );
    yield r'categoryId';
    yield object.categoryId == null
        ? null
        : serializers.serialize(
            object.categoryId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'groupId';
    yield object.groupId == null
        ? null
        : serializers.serialize(
            object.groupId,
            specifiedType: const FullType.nullable(String),
          );
    yield r'minChoices';
    yield object.minChoices == null
        ? null
        : serializers.serialize(
            object.minChoices,
            specifiedType: const FullType.nullable(int),
          );
    yield r'maxChoices';
    yield object.maxChoices == null
        ? null
        : serializers.serialize(
            object.maxChoices,
            specifiedType: const FullType.nullable(int),
          );
    yield r'itemIds';
    yield object.itemIds == null
        ? null
        : serializers.serialize(
            object.itemIds,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(String),
            ]),
          );
    yield r'options';
    yield object.options == null
        ? null
        : serializers.serialize(
            object.options,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(
                MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner,
              ),
            ]),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner object, {
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
    required MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder
    result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'requestId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.requestId = valueDes;
          break;
        case r'field':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum,
                    ),
                  )
                  as MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum;
          result.field = valueDes;
          break;
        case r'createdAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.createdAt = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'photoKey':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.photoKey = valueDes;
          break;
        case r'price':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantPendingMoneyOutput,
                    ),
                  )
                  as MerchantPendingMoneyOutput?;
          if (valueDes == null) continue;
          result.price.replace(valueDes);
          break;
        case r'categoryId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.categoryId = valueDes;
          break;
        case r'groupId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.groupId = valueDes;
          break;
        case r'minChoices':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.minChoices = valueDes;
          break;
        case r'maxChoices':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.maxChoices = valueDes;
          break;
        case r'itemIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>?;
          if (valueDes == null) continue;
          result.itemIds.replace(valueDes);
          break;
        case r'options':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(
                        MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
                  >?;
          if (valueDes == null) continue;
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
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder();
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

/// `created`: a new row, unseen by customers until approved; otherwise the field asked.
class MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'created')
  static const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
  created =
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_created;
  @BuiltValueEnumConst(wireName: r'rename')
  static const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
  rename =
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_rename;
  @BuiltValueEnumConst(wireName: r'description')
  static const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
  description =
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_description;
  @BuiltValueEnumConst(wireName: r'photo')
  static const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
  photo =
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_photo;
  @BuiltValueEnumConst(wireName: r'choices')
  static const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
  choices =
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_choices;
  @BuiltValueEnumConst(wireName: r'items')
  static const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
  items =
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_items;

  static Serializer<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
  >
  get serializer =>
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnumSerializer;

  const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum._(
    String name,
  ) : super(name);

  static BuiltSet<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
  >
  get values =>
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnumValues;
  static MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
  valueOf(String name) =>
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnumValueOf(
        name,
      );
}
