//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_import_plan_dto_output_added_inner.g.dart';

/// AdminMenuImportPlanDtoOutputAddedInner
///
/// Properties:
/// * [row]
/// * [code] - null: generated.
/// * [categoryName]
/// * [name]
/// * [description]
/// * [price] - In the city's base currency.
/// * [groupIds]
@BuiltValue()
abstract class AdminMenuImportPlanDtoOutputAddedInner
    implements
        Built<
          AdminMenuImportPlanDtoOutputAddedInner,
          AdminMenuImportPlanDtoOutputAddedInnerBuilder
        > {
  @BuiltValueField(wireName: r'row')
  int get row;

  /// null: generated.
  @BuiltValueField(wireName: r'code')
  String? get code;

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

  AdminMenuImportPlanDtoOutputAddedInner._();

  factory AdminMenuImportPlanDtoOutputAddedInner([
    void updates(AdminMenuImportPlanDtoOutputAddedInnerBuilder b),
  ]) = _$AdminMenuImportPlanDtoOutputAddedInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuImportPlanDtoOutputAddedInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuImportPlanDtoOutputAddedInner> get serializer =>
      _$AdminMenuImportPlanDtoOutputAddedInnerSerializer();
}

class _$AdminMenuImportPlanDtoOutputAddedInnerSerializer
    implements PrimitiveSerializer<AdminMenuImportPlanDtoOutputAddedInner> {
  @override
  final Iterable<Type> types = const [
    AdminMenuImportPlanDtoOutputAddedInner,
    _$AdminMenuImportPlanDtoOutputAddedInner,
  ];

  @override
  final String wireName = r'AdminMenuImportPlanDtoOutputAddedInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuImportPlanDtoOutputAddedInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'row';
    yield serializers.serialize(object.row, specifiedType: const FullType(int));
    yield r'code';
    yield object.code == null
        ? null
        : serializers.serialize(
            object.code,
            specifiedType: const FullType.nullable(String),
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
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuImportPlanDtoOutputAddedInner object, {
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
    required AdminMenuImportPlanDtoOutputAddedInnerBuilder result,
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuImportPlanDtoOutputAddedInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuImportPlanDtoOutputAddedInnerBuilder();
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
