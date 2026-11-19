//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_menu_money_output.dart';
import 'package:core_api/src/model/admin_menu_switched_off_output.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_dto_output_categories_inner_items_inner.g.dart';

/// AdminMenuDtoOutputCategoriesInnerItemsInner
///
/// Properties:
/// * [id]
/// * [code]
/// * [name]
/// * [description]
/// * [photoKey] - Its key in public-media, shown through /media/; null without a photo.
/// * [price]
/// * [hidden]
/// * [badge] - «جديد», «الأكثر طلباً» or «حار».
/// * [switchedOff] - Its own switch off (RA §9.3); null while on.
/// * [optionGroupIds] - Its option groups, in order.
@BuiltValue()
abstract class AdminMenuDtoOutputCategoriesInnerItemsInner
    implements
        Built<
          AdminMenuDtoOutputCategoriesInnerItemsInner,
          AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Its key in public-media, shown through /media/; null without a photo.
  @BuiltValueField(wireName: r'photoKey')
  String? get photoKey;

  @BuiltValueField(wireName: r'price')
  AdminMenuMoneyOutput get price;

  @BuiltValueField(wireName: r'hidden')
  bool get hidden;

  /// «جديد», «الأكثر طلباً» or «حار».
  @BuiltValueField(wireName: r'badge')
  AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum? get badge;
  // enum badgeEnum {  new,  most_ordered,  spicy,  };

  /// Its own switch off (RA §9.3); null while on.
  @BuiltValueField(wireName: r'switchedOff')
  AdminMenuSwitchedOffOutput? get switchedOff;

  /// Its option groups, in order.
  @BuiltValueField(wireName: r'optionGroupIds')
  BuiltList<String> get optionGroupIds;

  AdminMenuDtoOutputCategoriesInnerItemsInner._();

  factory AdminMenuDtoOutputCategoriesInnerItemsInner([
    void updates(AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder b),
  ]) = _$AdminMenuDtoOutputCategoriesInnerItemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuDtoOutputCategoriesInnerItemsInner>
  get serializer => _$AdminMenuDtoOutputCategoriesInnerItemsInnerSerializer();
}

class _$AdminMenuDtoOutputCategoriesInnerItemsInnerSerializer
    implements
        PrimitiveSerializer<AdminMenuDtoOutputCategoriesInnerItemsInner> {
  @override
  final Iterable<Type> types = const [
    AdminMenuDtoOutputCategoriesInnerItemsInner,
    _$AdminMenuDtoOutputCategoriesInnerItemsInner,
  ];

  @override
  final String wireName = r'AdminMenuDtoOutputCategoriesInnerItemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuDtoOutputCategoriesInnerItemsInner object, {
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
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(AdminMenuMoneyOutput),
    );
    yield r'hidden';
    yield serializers.serialize(
      object.hidden,
      specifiedType: const FullType(bool),
    );
    yield r'badge';
    yield object.badge == null
        ? null
        : serializers.serialize(
            object.badge,
            specifiedType: const FullType.nullable(
              AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum,
            ),
          );
    yield r'switchedOff';
    yield object.switchedOff == null
        ? null
        : serializers.serialize(
            object.switchedOff,
            specifiedType: const FullType.nullable(AdminMenuSwitchedOffOutput),
          );
    yield r'optionGroupIds';
    yield serializers.serialize(
      object.optionGroupIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuDtoOutputCategoriesInnerItemsInner object, {
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
    required AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder result,
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
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
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
                    specifiedType: const FullType(AdminMenuMoneyOutput),
                  )
                  as AdminMenuMoneyOutput;
          result.price.replace(valueDes);
          break;
        case r'hidden':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.hidden = valueDes;
          break;
        case r'badge':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum,
                    ),
                  )
                  as AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum?;
          if (valueDes == null) continue;
          result.badge = valueDes;
          break;
        case r'switchedOff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminMenuSwitchedOffOutput,
                    ),
                  )
                  as AdminMenuSwitchedOffOutput?;
          if (valueDes == null) continue;
          result.switchedOff.replace(valueDes);
          break;
        case r'optionGroupIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.optionGroupIds.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuDtoOutputCategoriesInnerItemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder();
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

/// «جديد», «الأكثر طلباً» or «حار».
class AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'new')
  static const AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum new_ =
      _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_new_;
  @BuiltValueEnumConst(wireName: r'most_ordered')
  static const AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum
  mostOrdered =
      _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_mostOrdered;
  @BuiltValueEnumConst(wireName: r'spicy')
  static const AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum spicy =
      _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_spicy;

  static Serializer<AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum>
  get serializer =>
      _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnumSerializer;

  const AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum._(String name)
    : super(name);

  static BuiltSet<AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum>
  get values => _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnumValues;
  static AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum valueOf(
    String name,
  ) => _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnumValueOf(name);
}
