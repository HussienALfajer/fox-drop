//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_import_plan_dto_output_changed_inner.g.dart';

/// AdminMenuImportPlanDtoOutputChangedInner
///
/// Properties:
/// * [row]
/// * [itemId]
/// * [code]
/// * [fields]
/// * [categoryName]
/// * [name]
/// * [description]
/// * [price] - In the city's base currency.
/// * [groupIds]
/// * [oldPrice] - «مشكلة في المبلغ أو الباقي»: M, what the customer was short.
@BuiltValue()
abstract class AdminMenuImportPlanDtoOutputChangedInner
    implements
        Built<
          AdminMenuImportPlanDtoOutputChangedInner,
          AdminMenuImportPlanDtoOutputChangedInnerBuilder
        > {
  @BuiltValueField(wireName: r'row')
  int get row;

  @BuiltValueField(wireName: r'itemId')
  String get itemId;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'fields')
  BuiltList<AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum> get fields;
  // enum fieldsEnum {  category,  name,  description,  price,  groups,  };

  @BuiltValueField(wireName: r'categoryName')
  String get categoryName;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  /// In the city's base currency.
  @BuiltValueField(wireName: r'price')
  String get price;

  @BuiltValueField(wireName: r'groupIds')
  BuiltList<String> get groupIds;

  /// «مشكلة في المبلغ أو الباقي»: M, what the customer was short.
  @BuiltValueField(wireName: r'oldPrice')
  String? get oldPrice;

  AdminMenuImportPlanDtoOutputChangedInner._();

  factory AdminMenuImportPlanDtoOutputChangedInner([
    void updates(AdminMenuImportPlanDtoOutputChangedInnerBuilder b),
  ]) = _$AdminMenuImportPlanDtoOutputChangedInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuImportPlanDtoOutputChangedInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuImportPlanDtoOutputChangedInner> get serializer =>
      _$AdminMenuImportPlanDtoOutputChangedInnerSerializer();
}

class _$AdminMenuImportPlanDtoOutputChangedInnerSerializer
    implements PrimitiveSerializer<AdminMenuImportPlanDtoOutputChangedInner> {
  @override
  final Iterable<Type> types = const [
    AdminMenuImportPlanDtoOutputChangedInner,
    _$AdminMenuImportPlanDtoOutputChangedInner,
  ];

  @override
  final String wireName = r'AdminMenuImportPlanDtoOutputChangedInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuImportPlanDtoOutputChangedInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'row';
    yield serializers.serialize(object.row, specifiedType: const FullType(int));
    yield r'itemId';
    yield serializers.serialize(
      object.itemId,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'fields';
    yield serializers.serialize(
      object.fields,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum),
      ]),
    );
    yield r'categoryName';
    yield serializers.serialize(
      object.categoryName,
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
    yield r'price';
    yield serializers.serialize(
      object.price,
      specifiedType: const FullType(String),
    );
    yield r'groupIds';
    yield serializers.serialize(
      object.groupIds,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'oldPrice';
    yield object.oldPrice == null
        ? null
        : serializers.serialize(
            object.oldPrice,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuImportPlanDtoOutputChangedInner object, {
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
    required AdminMenuImportPlanDtoOutputChangedInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'row':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.row = valueDes;
          break;
        case r'itemId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.itemId = valueDes;
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
        case r'fields':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum
                  >;
          result.fields.replace(valueDes);
          break;
        case r'categoryName':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.categoryName = valueDes;
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
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.price = valueDes;
          break;
        case r'groupIds':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.groupIds.replace(valueDes);
          break;
        case r'oldPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.oldPrice = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuImportPlanDtoOutputChangedInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuImportPlanDtoOutputChangedInnerBuilder();
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

class AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'category')
  static const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum category =
      _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_category;
  @BuiltValueEnumConst(wireName: r'name')
  static const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum name =
      _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_name;
  @BuiltValueEnumConst(wireName: r'description')
  static const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum description =
      _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_description;
  @BuiltValueEnumConst(wireName: r'price')
  static const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum price =
      _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_price;
  @BuiltValueEnumConst(wireName: r'groups')
  static const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum groups =
      _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnum_groups;

  static Serializer<AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum>
  get serializer =>
      _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnumSerializer;

  const AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum._(String name)
    : super(name);

  static BuiltSet<AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum>
  get values => _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnumValues;
  static AdminMenuImportPlanDtoOutputChangedInnerFieldsEnum valueOf(
    String name,
  ) => _$adminMenuImportPlanDtoOutputChangedInnerFieldsEnumValueOf(name);
}
