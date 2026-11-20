//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_report_dto_output_tables_inner_columns_inner.dart';
import 'package:core_api/src/model/admin_report_dto_output_tables_inner_rows_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_dto_output_tables_inner.g.dart';

/// AdminReportDtoOutputTablesInner
///
/// Properties:
/// * [key] - The table, unique in its report.
/// * [rowKind]
/// * [rowCodes] - The list of `reports.code` that names the rows’ codes; null: as they are.
/// * [columns]
/// * [rows]
@BuiltValue()
abstract class AdminReportDtoOutputTablesInner
    implements
        Built<
          AdminReportDtoOutputTablesInner,
          AdminReportDtoOutputTablesInnerBuilder
        > {
  /// The table, unique in its report.
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'rowKind')
  AdminReportDtoOutputTablesInnerRowKindEnum get rowKind;
  // enum rowKindEnum {  none,  code,  name,  day,  hour,  };

  /// The list of `reports.code` that names the rows’ codes; null: as they are.
  @BuiltValueField(wireName: r'rowCodes')
  String? get rowCodes;

  @BuiltValueField(wireName: r'columns')
  BuiltList<AdminReportDtoOutputTablesInnerColumnsInner> get columns;

  @BuiltValueField(wireName: r'rows')
  BuiltList<AdminReportDtoOutputTablesInnerRowsInner> get rows;

  AdminReportDtoOutputTablesInner._();

  factory AdminReportDtoOutputTablesInner([
    void updates(AdminReportDtoOutputTablesInnerBuilder b),
  ]) = _$AdminReportDtoOutputTablesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportDtoOutputTablesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportDtoOutputTablesInner> get serializer =>
      _$AdminReportDtoOutputTablesInnerSerializer();
}

class _$AdminReportDtoOutputTablesInnerSerializer
    implements PrimitiveSerializer<AdminReportDtoOutputTablesInner> {
  @override
  final Iterable<Type> types = const [
    AdminReportDtoOutputTablesInner,
    _$AdminReportDtoOutputTablesInner,
  ];

  @override
  final String wireName = r'AdminReportDtoOutputTablesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportDtoOutputTablesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'rowKind';
    yield serializers.serialize(
      object.rowKind,
      specifiedType: const FullType(AdminReportDtoOutputTablesInnerRowKindEnum),
    );
    yield r'rowCodes';
    yield object.rowCodes == null
        ? null
        : serializers.serialize(
            object.rowCodes,
            specifiedType: const FullType.nullable(String),
          );
    yield r'columns';
    yield serializers.serialize(
      object.columns,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminReportDtoOutputTablesInnerColumnsInner),
      ]),
    );
    yield r'rows';
    yield serializers.serialize(
      object.rows,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminReportDtoOutputTablesInnerRowsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutputTablesInner object, {
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
    required AdminReportDtoOutputTablesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'key':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.key = valueDes;
          break;
        case r'rowKind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminReportDtoOutputTablesInnerRowKindEnum,
                    ),
                  )
                  as AdminReportDtoOutputTablesInnerRowKindEnum;
          result.rowKind = valueDes;
          break;
        case r'rowCodes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.rowCodes = valueDes;
          break;
        case r'columns':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminReportDtoOutputTablesInnerColumnsInner),
                    ]),
                  )
                  as BuiltList<AdminReportDtoOutputTablesInnerColumnsInner>;
          result.columns.replace(valueDes);
          break;
        case r'rows':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminReportDtoOutputTablesInnerRowsInner),
                    ]),
                  )
                  as BuiltList<AdminReportDtoOutputTablesInnerRowsInner>;
          result.rows.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReportDtoOutputTablesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportDtoOutputTablesInnerBuilder();
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

class AdminReportDtoOutputTablesInnerRowKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'none')
  static const AdminReportDtoOutputTablesInnerRowKindEnum none =
      _$adminReportDtoOutputTablesInnerRowKindEnum_none;
  @BuiltValueEnumConst(wireName: r'code')
  static const AdminReportDtoOutputTablesInnerRowKindEnum code =
      _$adminReportDtoOutputTablesInnerRowKindEnum_code;
  @BuiltValueEnumConst(wireName: r'name')
  static const AdminReportDtoOutputTablesInnerRowKindEnum name =
      _$adminReportDtoOutputTablesInnerRowKindEnum_name;
  @BuiltValueEnumConst(wireName: r'day')
  static const AdminReportDtoOutputTablesInnerRowKindEnum day =
      _$adminReportDtoOutputTablesInnerRowKindEnum_day;
  @BuiltValueEnumConst(wireName: r'hour')
  static const AdminReportDtoOutputTablesInnerRowKindEnum hour =
      _$adminReportDtoOutputTablesInnerRowKindEnum_hour;

  static Serializer<AdminReportDtoOutputTablesInnerRowKindEnum>
  get serializer => _$adminReportDtoOutputTablesInnerRowKindEnumSerializer;

  const AdminReportDtoOutputTablesInnerRowKindEnum._(String name) : super(name);

  static BuiltSet<AdminReportDtoOutputTablesInnerRowKindEnum> get values =>
      _$adminReportDtoOutputTablesInnerRowKindEnumValues;
  static AdminReportDtoOutputTablesInnerRowKindEnum valueOf(String name) =>
      _$adminReportDtoOutputTablesInnerRowKindEnumValueOf(name);
}
