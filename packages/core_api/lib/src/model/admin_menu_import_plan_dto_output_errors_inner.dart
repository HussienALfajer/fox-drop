//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_import_plan_dto_output_errors_inner.g.dart';

/// AdminMenuImportPlanDtoOutputErrorsInner
///
/// Properties:
/// * [row] - The sheet's row number, the header being 1.
/// * [column]
/// * [error]
@BuiltValue()
abstract class AdminMenuImportPlanDtoOutputErrorsInner
    implements
        Built<
          AdminMenuImportPlanDtoOutputErrorsInner,
          AdminMenuImportPlanDtoOutputErrorsInnerBuilder
        > {
  /// The sheet's row number, the header being 1.
  @BuiltValueField(wireName: r'row')
  int get row;

  @BuiltValueField(wireName: r'column')
  AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum get column;
  // enum columnEnum {  code,  category,  name,  description,  price,  groups,  };

  @BuiltValueField(wireName: r'error')
  AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum get error;
  // enum errorEnum {  required,  too_long,  invalid_price,  repeated_code,  unknown_group,  ambiguous_name,  };

  AdminMenuImportPlanDtoOutputErrorsInner._();

  factory AdminMenuImportPlanDtoOutputErrorsInner([
    void updates(AdminMenuImportPlanDtoOutputErrorsInnerBuilder b),
  ]) = _$AdminMenuImportPlanDtoOutputErrorsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuImportPlanDtoOutputErrorsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuImportPlanDtoOutputErrorsInner> get serializer =>
      _$AdminMenuImportPlanDtoOutputErrorsInnerSerializer();
}

class _$AdminMenuImportPlanDtoOutputErrorsInnerSerializer
    implements PrimitiveSerializer<AdminMenuImportPlanDtoOutputErrorsInner> {
  @override
  final Iterable<Type> types = const [
    AdminMenuImportPlanDtoOutputErrorsInner,
    _$AdminMenuImportPlanDtoOutputErrorsInner,
  ];

  @override
  final String wireName = r'AdminMenuImportPlanDtoOutputErrorsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuImportPlanDtoOutputErrorsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'row';
    yield serializers.serialize(object.row, specifiedType: const FullType(int));
    yield r'column';
    yield serializers.serialize(
      object.column,
      specifiedType: const FullType(
        AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum,
      ),
    );
    yield r'error';
    yield serializers.serialize(
      object.error,
      specifiedType: const FullType(
        AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuImportPlanDtoOutputErrorsInner object, {
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
    required AdminMenuImportPlanDtoOutputErrorsInnerBuilder result,
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
        case r'column':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum,
                    ),
                  )
                  as AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum;
          result.column = valueDes;
          break;
        case r'error':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum,
                    ),
                  )
                  as AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum;
          result.error = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuImportPlanDtoOutputErrorsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuImportPlanDtoOutputErrorsInnerBuilder();
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

class AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'code')
  static const AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum code =
      _$adminMenuImportPlanDtoOutputErrorsInnerColumnEnum_code;
  @BuiltValueEnumConst(wireName: r'category')
  static const AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum category =
      _$adminMenuImportPlanDtoOutputErrorsInnerColumnEnum_category;
  @BuiltValueEnumConst(wireName: r'name')
  static const AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum name =
      _$adminMenuImportPlanDtoOutputErrorsInnerColumnEnum_name;
  @BuiltValueEnumConst(wireName: r'description')
  static const AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum description =
      _$adminMenuImportPlanDtoOutputErrorsInnerColumnEnum_description;
  @BuiltValueEnumConst(wireName: r'price')
  static const AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum price =
      _$adminMenuImportPlanDtoOutputErrorsInnerColumnEnum_price;
  @BuiltValueEnumConst(wireName: r'groups')
  static const AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum groups =
      _$adminMenuImportPlanDtoOutputErrorsInnerColumnEnum_groups;

  static Serializer<AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum>
  get serializer =>
      _$adminMenuImportPlanDtoOutputErrorsInnerColumnEnumSerializer;

  const AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum._(String name)
    : super(name);

  static BuiltSet<AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum>
  get values => _$adminMenuImportPlanDtoOutputErrorsInnerColumnEnumValues;
  static AdminMenuImportPlanDtoOutputErrorsInnerColumnEnum valueOf(
    String name,
  ) => _$adminMenuImportPlanDtoOutputErrorsInnerColumnEnumValueOf(name);
}

class AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'required')
  static const AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum required_ =
      _$adminMenuImportPlanDtoOutputErrorsInnerErrorEnum_required_;
  @BuiltValueEnumConst(wireName: r'too_long')
  static const AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum tooLong =
      _$adminMenuImportPlanDtoOutputErrorsInnerErrorEnum_tooLong;
  @BuiltValueEnumConst(wireName: r'invalid_price')
  static const AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum invalidPrice =
      _$adminMenuImportPlanDtoOutputErrorsInnerErrorEnum_invalidPrice;
  @BuiltValueEnumConst(wireName: r'repeated_code')
  static const AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum repeatedCode =
      _$adminMenuImportPlanDtoOutputErrorsInnerErrorEnum_repeatedCode;
  @BuiltValueEnumConst(wireName: r'unknown_group')
  static const AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum unknownGroup =
      _$adminMenuImportPlanDtoOutputErrorsInnerErrorEnum_unknownGroup;
  @BuiltValueEnumConst(wireName: r'ambiguous_name')
  static const AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum ambiguousName =
      _$adminMenuImportPlanDtoOutputErrorsInnerErrorEnum_ambiguousName;

  static Serializer<AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum>
  get serializer =>
      _$adminMenuImportPlanDtoOutputErrorsInnerErrorEnumSerializer;

  const AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum._(String name)
    : super(name);

  static BuiltSet<AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum>
  get values => _$adminMenuImportPlanDtoOutputErrorsInnerErrorEnumValues;
  static AdminMenuImportPlanDtoOutputErrorsInnerErrorEnum valueOf(
    String name,
  ) => _$adminMenuImportPlanDtoOutputErrorsInnerErrorEnumValueOf(name);
}
