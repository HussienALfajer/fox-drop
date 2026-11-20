//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_dto_output_tables_inner_rows_inner.g.dart';

/// AdminReportDtoOutputTablesInnerRowsInner
///
/// Properties:
/// * [code]
/// * [label]
/// * [currency] - The money cells’ currency, when not the report’s.
/// * [cells] - One per column, as text: counts, basis points, minutes or stars to one decimal, minor units, a code or text.
@BuiltValue()
abstract class AdminReportDtoOutputTablesInnerRowsInner
    implements
        Built<
          AdminReportDtoOutputTablesInnerRowsInner,
          AdminReportDtoOutputTablesInnerRowsInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String? get code;

  @BuiltValueField(wireName: r'label')
  String? get label;

  /// The money cells’ currency, when not the report’s.
  @BuiltValueField(wireName: r'currency')
  String? get currency;

  /// One per column, as text: counts, basis points, minutes or stars to one decimal, minor units, a code or text.
  @BuiltValueField(wireName: r'cells')
  BuiltList<String?> get cells;

  AdminReportDtoOutputTablesInnerRowsInner._();

  factory AdminReportDtoOutputTablesInnerRowsInner([
    void updates(AdminReportDtoOutputTablesInnerRowsInnerBuilder b),
  ]) = _$AdminReportDtoOutputTablesInnerRowsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportDtoOutputTablesInnerRowsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportDtoOutputTablesInnerRowsInner> get serializer =>
      _$AdminReportDtoOutputTablesInnerRowsInnerSerializer();
}

class _$AdminReportDtoOutputTablesInnerRowsInnerSerializer
    implements PrimitiveSerializer<AdminReportDtoOutputTablesInnerRowsInner> {
  @override
  final Iterable<Type> types = const [
    AdminReportDtoOutputTablesInnerRowsInner,
    _$AdminReportDtoOutputTablesInnerRowsInner,
  ];

  @override
  final String wireName = r'AdminReportDtoOutputTablesInnerRowsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportDtoOutputTablesInnerRowsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield object.code == null
        ? null
        : serializers.serialize(
            object.code,
            specifiedType: const FullType.nullable(String),
          );
    yield r'label';
    yield object.label == null
        ? null
        : serializers.serialize(
            object.label,
            specifiedType: const FullType.nullable(String),
          );
    yield r'currency';
    yield object.currency == null
        ? null
        : serializers.serialize(
            object.currency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'cells';
    yield serializers.serialize(
      object.cells,
      specifiedType: const FullType(BuiltList, [FullType.nullable(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutputTablesInnerRowsInner object, {
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
    required AdminReportDtoOutputTablesInnerRowsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.currency = valueDes;
          break;
        case r'cells':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(String),
                    ]),
                  )
                  as BuiltList<String?>;
          result.cells.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReportDtoOutputTablesInnerRowsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportDtoOutputTablesInnerRowsInnerBuilder();
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
