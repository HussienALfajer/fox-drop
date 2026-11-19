//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_change_item_output.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_change_item_name_output.dart';
import 'package:core_api/src/model/admin_change_values_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_request_dto_output.g.dart';

/// AdminChangeRequestDtoOutput
///
/// Properties:
/// * [id]
/// * [restaurantId]
/// * [restaurantName]
/// * [targetType]
/// * [targetId]
/// * [field] - `created`: a new row; otherwise the field the restaurant asks to change.
/// * [targetName] - The row's name as the restaurant knows it.
/// * [createdAt] - Its age: SHOULD be reviewed within 24 hours (RA §9.5).
/// * [status]
/// * [before] - Null for a new row.
/// * [after]
/// * [parentName] - An item's category, an option's group.
/// * [item] - The item as customers see it now, for the customer preview.
/// * [itemNames]
@BuiltValue()
abstract class AdminChangeRequestDtoOutput
    implements
        Built<AdminChangeRequestDtoOutput, AdminChangeRequestDtoOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  @BuiltValueField(wireName: r'targetType')
  AdminChangeRequestDtoOutputTargetTypeEnum get targetType;
  // enum targetTypeEnum {  category,  item,  option_group,  option,  };

  @BuiltValueField(wireName: r'targetId')
  String get targetId;

  /// `created`: a new row; otherwise the field the restaurant asks to change.
  @BuiltValueField(wireName: r'field')
  AdminChangeRequestDtoOutputFieldEnum get field;
  // enum fieldEnum {  created,  rename,  description,  photo,  choices,  items,  };

  /// The row's name as the restaurant knows it.
  @BuiltValueField(wireName: r'targetName')
  String get targetName;

  /// Its age: SHOULD be reviewed within 24 hours (RA §9.5).
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'status')
  AdminChangeRequestDtoOutputStatusEnum get status;
  // enum statusEnum {  pending,  approved,  rejected,  withdrawn,  };

  /// Null for a new row.
  @BuiltValueField(wireName: r'before')
  AdminChangeValuesOutput? get before;

  @BuiltValueField(wireName: r'after')
  AdminChangeValuesOutput get after;

  /// An item's category, an option's group.
  @BuiltValueField(wireName: r'parentName')
  String? get parentName;

  /// The item as customers see it now, for the customer preview.
  @BuiltValueField(wireName: r'item')
  AdminChangeItemOutput? get item;

  @BuiltValueField(wireName: r'itemNames')
  BuiltList<AdminChangeItemNameOutput> get itemNames;

  AdminChangeRequestDtoOutput._();

  factory AdminChangeRequestDtoOutput([
    void updates(AdminChangeRequestDtoOutputBuilder b),
  ]) = _$AdminChangeRequestDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeRequestDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeRequestDtoOutput> get serializer =>
      _$AdminChangeRequestDtoOutputSerializer();
}

class _$AdminChangeRequestDtoOutputSerializer
    implements PrimitiveSerializer<AdminChangeRequestDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminChangeRequestDtoOutput,
    _$AdminChangeRequestDtoOutput,
  ];

  @override
  final String wireName = r'AdminChangeRequestDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeRequestDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'restaurantId';
    yield serializers.serialize(
      object.restaurantId,
      specifiedType: const FullType(String),
    );
    yield r'restaurantName';
    yield serializers.serialize(
      object.restaurantName,
      specifiedType: const FullType(String),
    );
    yield r'targetType';
    yield serializers.serialize(
      object.targetType,
      specifiedType: const FullType(AdminChangeRequestDtoOutputTargetTypeEnum),
    );
    yield r'targetId';
    yield serializers.serialize(
      object.targetId,
      specifiedType: const FullType(String),
    );
    yield r'field';
    yield serializers.serialize(
      object.field,
      specifiedType: const FullType(AdminChangeRequestDtoOutputFieldEnum),
    );
    yield r'targetName';
    yield serializers.serialize(
      object.targetName,
      specifiedType: const FullType(String),
    );
    yield r'createdAt';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(AdminChangeRequestDtoOutputStatusEnum),
    );
    yield r'before';
    yield object.before == null
        ? null
        : serializers.serialize(
            object.before,
            specifiedType: const FullType.nullable(AdminChangeValuesOutput),
          );
    yield r'after';
    yield serializers.serialize(
      object.after,
      specifiedType: const FullType(AdminChangeValuesOutput),
    );
    yield r'parentName';
    yield object.parentName == null
        ? null
        : serializers.serialize(
            object.parentName,
            specifiedType: const FullType.nullable(String),
          );
    yield r'item';
    yield object.item == null
        ? null
        : serializers.serialize(
            object.item,
            specifiedType: const FullType.nullable(AdminChangeItemOutput),
          );
    yield r'itemNames';
    yield serializers.serialize(
      object.itemNames,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminChangeItemNameOutput),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeRequestDtoOutput object, {
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
    required AdminChangeRequestDtoOutputBuilder result,
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
        case r'restaurantId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantId = valueDes;
          break;
        case r'restaurantName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.restaurantName = valueDes;
          break;
        case r'targetType':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminChangeRequestDtoOutputTargetTypeEnum,
                    ),
                  )
                  as AdminChangeRequestDtoOutputTargetTypeEnum;
          result.targetType = valueDes;
          break;
        case r'targetId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.targetId = valueDes;
          break;
        case r'field':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminChangeRequestDtoOutputFieldEnum,
                    ),
                  )
                  as AdminChangeRequestDtoOutputFieldEnum;
          result.field = valueDes;
          break;
        case r'targetName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.targetName = valueDes;
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
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminChangeRequestDtoOutputStatusEnum,
                    ),
                  )
                  as AdminChangeRequestDtoOutputStatusEnum;
          result.status = valueDes;
          break;
        case r'before':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminChangeValuesOutput,
                    ),
                  )
                  as AdminChangeValuesOutput?;
          if (valueDes == null) continue;
          result.before.replace(valueDes);
          break;
        case r'after':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(AdminChangeValuesOutput),
                  )
                  as AdminChangeValuesOutput;
          result.after.replace(valueDes);
          break;
        case r'parentName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.parentName = valueDes;
          break;
        case r'item':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminChangeItemOutput,
                    ),
                  )
                  as AdminChangeItemOutput?;
          if (valueDes == null) continue;
          result.item.replace(valueDes);
          break;
        case r'itemNames':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminChangeItemNameOutput),
                    ]),
                  )
                  as BuiltList<AdminChangeItemNameOutput>;
          result.itemNames.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChangeRequestDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeRequestDtoOutputBuilder();
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

class AdminChangeRequestDtoOutputTargetTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'category')
  static const AdminChangeRequestDtoOutputTargetTypeEnum category =
      _$adminChangeRequestDtoOutputTargetTypeEnum_category;
  @BuiltValueEnumConst(wireName: r'item')
  static const AdminChangeRequestDtoOutputTargetTypeEnum item =
      _$adminChangeRequestDtoOutputTargetTypeEnum_item;
  @BuiltValueEnumConst(wireName: r'option_group')
  static const AdminChangeRequestDtoOutputTargetTypeEnum optionGroup =
      _$adminChangeRequestDtoOutputTargetTypeEnum_optionGroup;
  @BuiltValueEnumConst(wireName: r'option')
  static const AdminChangeRequestDtoOutputTargetTypeEnum option =
      _$adminChangeRequestDtoOutputTargetTypeEnum_option;

  static Serializer<AdminChangeRequestDtoOutputTargetTypeEnum> get serializer =>
      _$adminChangeRequestDtoOutputTargetTypeEnumSerializer;

  const AdminChangeRequestDtoOutputTargetTypeEnum._(String name) : super(name);

  static BuiltSet<AdminChangeRequestDtoOutputTargetTypeEnum> get values =>
      _$adminChangeRequestDtoOutputTargetTypeEnumValues;
  static AdminChangeRequestDtoOutputTargetTypeEnum valueOf(String name) =>
      _$adminChangeRequestDtoOutputTargetTypeEnumValueOf(name);
}

/// `created`: a new row; otherwise the field the restaurant asks to change.
class AdminChangeRequestDtoOutputFieldEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'created')
  static const AdminChangeRequestDtoOutputFieldEnum created =
      _$adminChangeRequestDtoOutputFieldEnum_created;
  @BuiltValueEnumConst(wireName: r'rename')
  static const AdminChangeRequestDtoOutputFieldEnum rename =
      _$adminChangeRequestDtoOutputFieldEnum_rename;
  @BuiltValueEnumConst(wireName: r'description')
  static const AdminChangeRequestDtoOutputFieldEnum description =
      _$adminChangeRequestDtoOutputFieldEnum_description;
  @BuiltValueEnumConst(wireName: r'photo')
  static const AdminChangeRequestDtoOutputFieldEnum photo =
      _$adminChangeRequestDtoOutputFieldEnum_photo;
  @BuiltValueEnumConst(wireName: r'choices')
  static const AdminChangeRequestDtoOutputFieldEnum choices =
      _$adminChangeRequestDtoOutputFieldEnum_choices;
  @BuiltValueEnumConst(wireName: r'items')
  static const AdminChangeRequestDtoOutputFieldEnum items =
      _$adminChangeRequestDtoOutputFieldEnum_items;

  static Serializer<AdminChangeRequestDtoOutputFieldEnum> get serializer =>
      _$adminChangeRequestDtoOutputFieldEnumSerializer;

  const AdminChangeRequestDtoOutputFieldEnum._(String name) : super(name);

  static BuiltSet<AdminChangeRequestDtoOutputFieldEnum> get values =>
      _$adminChangeRequestDtoOutputFieldEnumValues;
  static AdminChangeRequestDtoOutputFieldEnum valueOf(String name) =>
      _$adminChangeRequestDtoOutputFieldEnumValueOf(name);
}

class AdminChangeRequestDtoOutputStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'pending')
  static const AdminChangeRequestDtoOutputStatusEnum pending =
      _$adminChangeRequestDtoOutputStatusEnum_pending;
  @BuiltValueEnumConst(wireName: r'approved')
  static const AdminChangeRequestDtoOutputStatusEnum approved =
      _$adminChangeRequestDtoOutputStatusEnum_approved;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const AdminChangeRequestDtoOutputStatusEnum rejected =
      _$adminChangeRequestDtoOutputStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'withdrawn')
  static const AdminChangeRequestDtoOutputStatusEnum withdrawn =
      _$adminChangeRequestDtoOutputStatusEnum_withdrawn;

  static Serializer<AdminChangeRequestDtoOutputStatusEnum> get serializer =>
      _$adminChangeRequestDtoOutputStatusEnumSerializer;

  const AdminChangeRequestDtoOutputStatusEnum._(String name) : super(name);

  static BuiltSet<AdminChangeRequestDtoOutputStatusEnum> get values =>
      _$adminChangeRequestDtoOutputStatusEnumValues;
  static AdminChangeRequestDtoOutputStatusEnum valueOf(String name) =>
      _$adminChangeRequestDtoOutputStatusEnumValueOf(name);
}
