//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_menu_import_plan_dto_output_changed_inner.dart';
import 'package:core_api/src/model/admin_menu_import_plan_dto_output_errors_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_menu_import_plan_dto_output_added_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_menu_import_plan_dto_output.g.dart';

/// AdminMenuImportPlanDtoOutput
///
/// Properties:
/// * [fileError] - The file cannot be read as the template (2000 rows at most).
/// * [errors] - Every row error; the import runs only without any.
/// * [categoriesAdded]
/// * [added]
/// * [changed]
/// * [unchanged]
@BuiltValue()
abstract class AdminMenuImportPlanDtoOutput
    implements
        Built<
          AdminMenuImportPlanDtoOutput,
          AdminMenuImportPlanDtoOutputBuilder
        > {
  /// The file cannot be read as the template (2000 rows at most).
  @BuiltValueField(wireName: r'fileError')
  AdminMenuImportPlanDtoOutputFileErrorEnum? get fileError;
  // enum fileErrorEnum {  missing_headers,  no_rows,  too_many_rows,  };

  /// Every row error; the import runs only without any.
  @BuiltValueField(wireName: r'errors')
  BuiltList<AdminMenuImportPlanDtoOutputErrorsInner> get errors;

  @BuiltValueField(wireName: r'categoriesAdded')
  BuiltList<String> get categoriesAdded;

  @BuiltValueField(wireName: r'added')
  BuiltList<AdminMenuImportPlanDtoOutputAddedInner> get added;

  @BuiltValueField(wireName: r'changed')
  BuiltList<AdminMenuImportPlanDtoOutputChangedInner> get changed;

  @BuiltValueField(wireName: r'unchanged')
  int get unchanged;

  AdminMenuImportPlanDtoOutput._();

  factory AdminMenuImportPlanDtoOutput([
    void updates(AdminMenuImportPlanDtoOutputBuilder b),
  ]) = _$AdminMenuImportPlanDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminMenuImportPlanDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminMenuImportPlanDtoOutput> get serializer =>
      _$AdminMenuImportPlanDtoOutputSerializer();
}

class _$AdminMenuImportPlanDtoOutputSerializer
    implements PrimitiveSerializer<AdminMenuImportPlanDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminMenuImportPlanDtoOutput,
    _$AdminMenuImportPlanDtoOutput,
  ];

  @override
  final String wireName = r'AdminMenuImportPlanDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminMenuImportPlanDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fileError';
    yield object.fileError == null
        ? null
        : serializers.serialize(
            object.fileError,
            specifiedType: const FullType.nullable(
              AdminMenuImportPlanDtoOutputFileErrorEnum,
            ),
          );
    yield r'errors';
    yield serializers.serialize(
      object.errors,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuImportPlanDtoOutputErrorsInner),
      ]),
    );
    yield r'categoriesAdded';
    yield serializers.serialize(
      object.categoriesAdded,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'added';
    yield serializers.serialize(
      object.added,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuImportPlanDtoOutputAddedInner),
      ]),
    );
    yield r'changed';
    yield serializers.serialize(
      object.changed,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminMenuImportPlanDtoOutputChangedInner),
      ]),
    );
    yield r'unchanged';
    yield serializers.serialize(
      object.unchanged,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuImportPlanDtoOutput object, {
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
    required AdminMenuImportPlanDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fileError':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminMenuImportPlanDtoOutputFileErrorEnum,
                    ),
                  )
                  as AdminMenuImportPlanDtoOutputFileErrorEnum?;
          if (valueDes == null) continue;
          result.fileError = valueDes;
          break;
        case r'errors':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMenuImportPlanDtoOutputErrorsInner),
                    ]),
                  )
                  as BuiltList<AdminMenuImportPlanDtoOutputErrorsInner>;
          result.errors.replace(valueDes);
          break;
        case r'categoriesAdded':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.categoriesAdded.replace(valueDes);
          break;
        case r'added':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMenuImportPlanDtoOutputAddedInner),
                    ]),
                  )
                  as BuiltList<AdminMenuImportPlanDtoOutputAddedInner>;
          result.added.replace(valueDes);
          break;
        case r'changed':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminMenuImportPlanDtoOutputChangedInner),
                    ]),
                  )
                  as BuiltList<AdminMenuImportPlanDtoOutputChangedInner>;
          result.changed.replace(valueDes);
          break;
        case r'unchanged':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.unchanged = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminMenuImportPlanDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminMenuImportPlanDtoOutputBuilder();
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

/// The file cannot be read as the template (2000 rows at most).
class AdminMenuImportPlanDtoOutputFileErrorEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'missing_headers')
  static const AdminMenuImportPlanDtoOutputFileErrorEnum missingHeaders =
      _$adminMenuImportPlanDtoOutputFileErrorEnum_missingHeaders;
  @BuiltValueEnumConst(wireName: r'no_rows')
  static const AdminMenuImportPlanDtoOutputFileErrorEnum noRows =
      _$adminMenuImportPlanDtoOutputFileErrorEnum_noRows;
  @BuiltValueEnumConst(wireName: r'too_many_rows')
  static const AdminMenuImportPlanDtoOutputFileErrorEnum tooManyRows =
      _$adminMenuImportPlanDtoOutputFileErrorEnum_tooManyRows;

  static Serializer<AdminMenuImportPlanDtoOutputFileErrorEnum> get serializer =>
      _$adminMenuImportPlanDtoOutputFileErrorEnumSerializer;

  const AdminMenuImportPlanDtoOutputFileErrorEnum._(String name) : super(name);

  static BuiltSet<AdminMenuImportPlanDtoOutputFileErrorEnum> get values =>
      _$adminMenuImportPlanDtoOutputFileErrorEnumValues;
  static AdminMenuImportPlanDtoOutputFileErrorEnum valueOf(String name) =>
      _$adminMenuImportPlanDtoOutputFileErrorEnumValueOf(name);
}
