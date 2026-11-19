//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_change_request_row_output.g.dart';

/// AdminChangeRequestRowOutput
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
@BuiltValue()
abstract class AdminChangeRequestRowOutput
    implements
        Built<AdminChangeRequestRowOutput, AdminChangeRequestRowOutputBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'restaurantId')
  String get restaurantId;

  @BuiltValueField(wireName: r'restaurantName')
  String get restaurantName;

  @BuiltValueField(wireName: r'targetType')
  AdminChangeRequestRowOutputTargetTypeEnum get targetType;
  // enum targetTypeEnum {  category,  item,  option_group,  option,  };

  @BuiltValueField(wireName: r'targetId')
  String get targetId;

  /// `created`: a new row; otherwise the field the restaurant asks to change.
  @BuiltValueField(wireName: r'field')
  AdminChangeRequestRowOutputFieldEnum get field;
  // enum fieldEnum {  created,  rename,  description,  photo,  choices,  items,  };

  /// The row's name as the restaurant knows it.
  @BuiltValueField(wireName: r'targetName')
  String get targetName;

  /// Its age: SHOULD be reviewed within 24 hours (RA §9.5).
  @BuiltValueField(wireName: r'createdAt')
  DateTime get createdAt;

  AdminChangeRequestRowOutput._();

  factory AdminChangeRequestRowOutput([
    void updates(AdminChangeRequestRowOutputBuilder b),
  ]) = _$AdminChangeRequestRowOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminChangeRequestRowOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminChangeRequestRowOutput> get serializer =>
      _$AdminChangeRequestRowOutputSerializer();
}

class _$AdminChangeRequestRowOutputSerializer
    implements PrimitiveSerializer<AdminChangeRequestRowOutput> {
  @override
  final Iterable<Type> types = const [
    AdminChangeRequestRowOutput,
    _$AdminChangeRequestRowOutput,
  ];

  @override
  final String wireName = r'AdminChangeRequestRowOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminChangeRequestRowOutput object, {
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
      specifiedType: const FullType(AdminChangeRequestRowOutputTargetTypeEnum),
    );
    yield r'targetId';
    yield serializers.serialize(
      object.targetId,
      specifiedType: const FullType(String),
    );
    yield r'field';
    yield serializers.serialize(
      object.field,
      specifiedType: const FullType(AdminChangeRequestRowOutputFieldEnum),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeRequestRowOutput object, {
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
    required AdminChangeRequestRowOutputBuilder result,
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
                      AdminChangeRequestRowOutputTargetTypeEnum,
                    ),
                  )
                  as AdminChangeRequestRowOutputTargetTypeEnum;
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
                      AdminChangeRequestRowOutputFieldEnum,
                    ),
                  )
                  as AdminChangeRequestRowOutputFieldEnum;
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminChangeRequestRowOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminChangeRequestRowOutputBuilder();
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

class AdminChangeRequestRowOutputTargetTypeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'category')
  static const AdminChangeRequestRowOutputTargetTypeEnum category =
      _$adminChangeRequestRowOutputTargetTypeEnum_category;
  @BuiltValueEnumConst(wireName: r'item')
  static const AdminChangeRequestRowOutputTargetTypeEnum item =
      _$adminChangeRequestRowOutputTargetTypeEnum_item;
  @BuiltValueEnumConst(wireName: r'option_group')
  static const AdminChangeRequestRowOutputTargetTypeEnum optionGroup =
      _$adminChangeRequestRowOutputTargetTypeEnum_optionGroup;
  @BuiltValueEnumConst(wireName: r'option')
  static const AdminChangeRequestRowOutputTargetTypeEnum option =
      _$adminChangeRequestRowOutputTargetTypeEnum_option;

  static Serializer<AdminChangeRequestRowOutputTargetTypeEnum> get serializer =>
      _$adminChangeRequestRowOutputTargetTypeEnumSerializer;

  const AdminChangeRequestRowOutputTargetTypeEnum._(String name) : super(name);

  static BuiltSet<AdminChangeRequestRowOutputTargetTypeEnum> get values =>
      _$adminChangeRequestRowOutputTargetTypeEnumValues;
  static AdminChangeRequestRowOutputTargetTypeEnum valueOf(String name) =>
      _$adminChangeRequestRowOutputTargetTypeEnumValueOf(name);
}

/// `created`: a new row; otherwise the field the restaurant asks to change.
class AdminChangeRequestRowOutputFieldEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'created')
  static const AdminChangeRequestRowOutputFieldEnum created =
      _$adminChangeRequestRowOutputFieldEnum_created;
  @BuiltValueEnumConst(wireName: r'rename')
  static const AdminChangeRequestRowOutputFieldEnum rename =
      _$adminChangeRequestRowOutputFieldEnum_rename;
  @BuiltValueEnumConst(wireName: r'description')
  static const AdminChangeRequestRowOutputFieldEnum description =
      _$adminChangeRequestRowOutputFieldEnum_description;
  @BuiltValueEnumConst(wireName: r'photo')
  static const AdminChangeRequestRowOutputFieldEnum photo =
      _$adminChangeRequestRowOutputFieldEnum_photo;
  @BuiltValueEnumConst(wireName: r'choices')
  static const AdminChangeRequestRowOutputFieldEnum choices =
      _$adminChangeRequestRowOutputFieldEnum_choices;
  @BuiltValueEnumConst(wireName: r'items')
  static const AdminChangeRequestRowOutputFieldEnum items =
      _$adminChangeRequestRowOutputFieldEnum_items;

  static Serializer<AdminChangeRequestRowOutputFieldEnum> get serializer =>
      _$adminChangeRequestRowOutputFieldEnumSerializer;

  const AdminChangeRequestRowOutputFieldEnum._(String name) : super(name);

  static BuiltSet<AdminChangeRequestRowOutputFieldEnum> get values =>
      _$adminChangeRequestRowOutputFieldEnumValues;
  static AdminChangeRequestRowOutputFieldEnum valueOf(String name) =>
      _$adminChangeRequestRowOutputFieldEnumValueOf(name);
}
