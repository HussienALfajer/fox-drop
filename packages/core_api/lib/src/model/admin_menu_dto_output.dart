//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_menu_dto_output_option_groups_inner.dart';
import 'package:core_api/src/model/admin_menu_dto_output_categories_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_dto_output.g.dart';

/// AdminMenuDtoOutput
///
/// Properties:
/// * [accountStatus]
/// * [editable] - Whether the editor edits it: any status but terminated.
/// * [pricesLocked] - Past test mode, prices need menus.edit_prices: true when this session lacks it.
/// * [nameMax]
/// * [descriptionMax]
/// * [codeMax]
/// * [categories]
/// * [optionGroups] - Every option group of the restaurant, by name.
@BuiltValue()
abstract class AdminMenuDtoOutput
    implements Built<AdminMenuDtoOutput, AdminMenuDtoOutputBuilder> {
  @BuiltValueField(wireName: r'accountStatus')
  AdminMenuDtoOutputAccountStatusEnum get accountStatus;
  // enum accountStatusEnum {  draft,  test,  active,  suspended,  terminated,  };

  /// Whether the editor edits it: any status but terminated.
  @BuiltValueField(wireName: r'editable')
  bool get editable;

  /// Past test mode, prices need menus.edit_prices: true when this session lacks it.
  @BuiltValueField(wireName: r'pricesLocked')
  bool get pricesLocked;

  @BuiltValueField(wireName: r'nameMax')
  int get nameMax;

  @BuiltValueField(wireName: r'descriptionMax')
  int get descriptionMax;

  @BuiltValueField(wireName: r'codeMax')
  int get codeMax;

  @BuiltValueField(wireName: r'categories')
  BuiltList<AdminMenuDtoOutputCategoriesInner> get categories;

  /// Every option group of the restaurant, by name.
  @BuiltValueField(wireName: r'optionGroups')
  BuiltList<AdminMenuDtoOutputOptionGroupsInner> get optionGroups;

  AdminMenuDtoOutput._();

  factory AdminMenuDtoOutput([void updates(AdminMenuDtoOutputBuilder b)]) =
      _$AdminMenuDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuDtoOutput> get serializer =>
      _$AdminMenuDtoOutputSerializer();
}

class _$AdminMenuDtoOutputSerializer
    implements PrimitiveSerializer<AdminMenuDtoOutput> {
  @override
  final Iterable<Type> types = const [AdminMenuDtoOutput, _$AdminMenuDtoOutput];

  @override
  final String wireName = r'AdminMenuDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'accountStatus';
    yield serializers.serialize(
      object.accountStatus,
      specifiedType: const FullType(AdminMenuDtoOutputAccountStatusEnum),
    );
    yield r'editable';
    yield serializers.serialize(
      object.editable,
      specifiedType: const FullType(bool),
    );
    yield r'pricesLocked';
    yield serializers.serialize(
      object.pricesLocked,
      specifiedType: const FullType(bool),
    );
    yield r'nameMax';
    yield serializers.serialize(
      object.nameMax,
      specifiedType: const FullType(int),
    );
    yield r'descriptionMax';
    yield serializers.serialize(
      object.descriptionMax,
      specifiedType: const FullType(int),
    );
    yield r'codeMax';
    yield serializers.serialize(
      object.codeMax,
      specifiedType: const FullType(int),
    );
    yield r'categories';
    yield serializers.serialize(
      object.categories,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuDtoOutputCategoriesInner),
      ]),
    );
    yield r'optionGroups';
    yield serializers.serialize(
      object.optionGroups,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuDtoOutputOptionGroupsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuDtoOutput object, {
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
    required AdminMenuDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'accountStatus':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminMenuDtoOutputAccountStatusEnum,
                    ),
                  )
                  as AdminMenuDtoOutputAccountStatusEnum;
          result.accountStatus = valueDes;
          break;
        case r'editable':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.editable = valueDes;
          break;
        case r'pricesLocked':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.pricesLocked = valueDes;
          break;
        case r'nameMax':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.nameMax = valueDes;
          break;
        case r'descriptionMax':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.descriptionMax = valueDes;
          break;
        case r'codeMax':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.codeMax = valueDes;
          break;
        case r'categories':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMenuDtoOutputCategoriesInner),
                    ]),
                  )
                  as BuiltList<AdminMenuDtoOutputCategoriesInner>;
          result.categories.replace(valueDes);
          break;
        case r'optionGroups':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMenuDtoOutputOptionGroupsInner),
                    ]),
                  )
                  as BuiltList<AdminMenuDtoOutputOptionGroupsInner>;
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
  AdminMenuDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuDtoOutputBuilder();
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

class AdminMenuDtoOutputAccountStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'draft')
  static const AdminMenuDtoOutputAccountStatusEnum draft =
      _$adminMenuDtoOutputAccountStatusEnum_draft;
  @BuiltValueEnumConst(wireName: r'test')
  static const AdminMenuDtoOutputAccountStatusEnum test =
      _$adminMenuDtoOutputAccountStatusEnum_test;
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminMenuDtoOutputAccountStatusEnum active =
      _$adminMenuDtoOutputAccountStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminMenuDtoOutputAccountStatusEnum suspended =
      _$adminMenuDtoOutputAccountStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminMenuDtoOutputAccountStatusEnum terminated =
      _$adminMenuDtoOutputAccountStatusEnum_terminated;

  static Serializer<AdminMenuDtoOutputAccountStatusEnum> get serializer =>
      _$adminMenuDtoOutputAccountStatusEnumSerializer;

  const AdminMenuDtoOutputAccountStatusEnum._(String name) : super(name);

  static BuiltSet<AdminMenuDtoOutputAccountStatusEnum> get values =>
      _$adminMenuDtoOutputAccountStatusEnumValues;
  static AdminMenuDtoOutputAccountStatusEnum valueOf(String name) =>
      _$adminMenuDtoOutputAccountStatusEnumValueOf(name);
}
