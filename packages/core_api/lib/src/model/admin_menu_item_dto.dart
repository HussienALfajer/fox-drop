//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_menu_money.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_item_dto.g.dart';

/// AdminMenuItemDto
///
/// Properties:
/// * [categoryId]
/// * [code] - Unique in the restaurant; empty or null: generated on creation, kept on edit.
/// * [name]
/// * [description]
/// * [price] - Above 0, in the city's base currency.
/// * [hidden]
/// * [badge] - «جديد», «الأكثر طلباً» or «حار».
@BuiltValue()
abstract class AdminMenuItemDto
    implements Built<AdminMenuItemDto, AdminMenuItemDtoBuilder> {
  @BuiltValueField(wireName: r'categoryId')
  String get categoryId;

  /// Unique in the restaurant; empty or null: generated on creation, kept on edit.
  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  /// Above 0, in the city's base currency.
  @BuiltValueField(wireName: r'price')
  AdminMenuMoney get price;

  @BuiltValueField(wireName: r'hidden')
  bool get hidden;

  /// «جديد», «الأكثر طلباً» or «حار».
  @BuiltValueField(wireName: r'badge')
  AdminMenuItemDtoBadgeEnum? get badge;
  // enum badgeEnum {  new,  most_ordered,  spicy,  };

  AdminMenuItemDto._();

  factory AdminMenuItemDto([void updates(AdminMenuItemDtoBuilder b)]) =
      _$AdminMenuItemDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuItemDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuItemDto> get serializer =>
      _$AdminMenuItemDtoSerializer();
}

class _$AdminMenuItemDtoSerializer
    implements PrimitiveSerializer<AdminMenuItemDto> {
  @override
  final Iterable<Type> types = const [AdminMenuItemDto, _$AdminMenuItemDto];

  @override
  final String wireName = r'AdminMenuItemDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuItemDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'categoryId';
    yield serializers.serialize(
      object.categoryId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield object.code == null
        ? null
        : serializers.serialize(
            object.code,
            specifiedType: const FullType.nullable(String),
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
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(AdminMenuMoney),
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
            specifiedType: const FullType.nullable(AdminMenuItemDtoBadgeEnum),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuItemDto object, {
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
    required AdminMenuItemDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'categoryId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.categoryId = valueDes;
          break;
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
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
        case r'price':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminMenuMoney),
                  )
                  as AdminMenuMoney;
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
                      AdminMenuItemDtoBadgeEnum,
                    ),
                  )
                  as AdminMenuItemDtoBadgeEnum?;
          if (valueDes == null) continue;
          result.badge = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuItemDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuItemDtoBuilder();
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
class AdminMenuItemDtoBadgeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'new')
  static const AdminMenuItemDtoBadgeEnum new_ =
      _$adminMenuItemDtoBadgeEnum_new_;
  @BuiltValueEnumConst(wireName: r'most_ordered')
  static const AdminMenuItemDtoBadgeEnum mostOrdered =
      _$adminMenuItemDtoBadgeEnum_mostOrdered;
  @BuiltValueEnumConst(wireName: r'spicy')
  static const AdminMenuItemDtoBadgeEnum spicy =
      _$adminMenuItemDtoBadgeEnum_spicy;

  static Serializer<AdminMenuItemDtoBadgeEnum> get serializer =>
      _$adminMenuItemDtoBadgeEnumSerializer;

  const AdminMenuItemDtoBadgeEnum._(String name) : super(name);

  static BuiltSet<AdminMenuItemDtoBadgeEnum> get values =>
      _$adminMenuItemDtoBadgeEnumValues;
  static AdminMenuItemDtoBadgeEnum valueOf(String name) =>
      _$adminMenuItemDtoBadgeEnumValueOf(name);
}
