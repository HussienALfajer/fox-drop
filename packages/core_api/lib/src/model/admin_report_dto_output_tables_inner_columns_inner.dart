//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_dto_output_tables_inner_columns_inner.g.dart';

/// AdminReportDtoOutputTablesInnerColumnsInner
///
/// Properties:
/// * [key]
/// * [kind]
@BuiltValue()
abstract class AdminReportDtoOutputTablesInnerColumnsInner
    implements
        Built<
          AdminReportDtoOutputTablesInnerColumnsInner,
          AdminReportDtoOutputTablesInnerColumnsInnerBuilder
        > {
  @BuiltValueField(wireName: r'key')
  String get key;

  @BuiltValueField(wireName: r'kind')
  AdminReportDtoOutputTablesInnerColumnsInnerKindEnum get kind;
  // enum kindEnum {  count,  bp,  minutes,  money,  stars,  code,  text,  };

  AdminReportDtoOutputTablesInnerColumnsInner._();

  factory AdminReportDtoOutputTablesInnerColumnsInner([
    void updates(AdminReportDtoOutputTablesInnerColumnsInnerBuilder b),
  ]) = _$AdminReportDtoOutputTablesInnerColumnsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportDtoOutputTablesInnerColumnsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportDtoOutputTablesInnerColumnsInner>
  get serializer => _$AdminReportDtoOutputTablesInnerColumnsInnerSerializer();
}

class _$AdminReportDtoOutputTablesInnerColumnsInnerSerializer
    implements
        PrimitiveSerializer<AdminReportDtoOutputTablesInnerColumnsInner> {
  @override
  final Iterable<Type> types = const [
    AdminReportDtoOutputTablesInnerColumnsInner,
    _$AdminReportDtoOutputTablesInnerColumnsInner,
  ];

  @override
  final String wireName = r'AdminReportDtoOutputTablesInnerColumnsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportDtoOutputTablesInnerColumnsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'key';
    yield serializers.serialize(
      object.key,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminReportDtoOutputTablesInnerColumnsInnerKindEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutputTablesInnerColumnsInner object, {
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
    required AdminReportDtoOutputTablesInnerColumnsInnerBuilder result,
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
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminReportDtoOutputTablesInnerColumnsInnerKindEnum,
                    ),
                  )
                  as AdminReportDtoOutputTablesInnerColumnsInnerKindEnum;
          result.kind = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReportDtoOutputTablesInnerColumnsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportDtoOutputTablesInnerColumnsInnerBuilder();
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

class AdminReportDtoOutputTablesInnerColumnsInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'count')
  static const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum count =
      _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_count;
  @BuiltValueEnumConst(wireName: r'bp')
  static const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum bp =
      _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_bp;
  @BuiltValueEnumConst(wireName: r'minutes')
  static const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum minutes =
      _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_minutes;
  @BuiltValueEnumConst(wireName: r'money')
  static const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum money =
      _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_money;
  @BuiltValueEnumConst(wireName: r'stars')
  static const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum stars =
      _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_stars;
  @BuiltValueEnumConst(wireName: r'code')
  static const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum code =
      _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_code;
  @BuiltValueEnumConst(wireName: r'text')
  static const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum text =
      _$adminReportDtoOutputTablesInnerColumnsInnerKindEnum_text;

  static Serializer<AdminReportDtoOutputTablesInnerColumnsInnerKindEnum>
  get serializer =>
      _$adminReportDtoOutputTablesInnerColumnsInnerKindEnumSerializer;

  const AdminReportDtoOutputTablesInnerColumnsInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminReportDtoOutputTablesInnerColumnsInnerKindEnum>
  get values => _$adminReportDtoOutputTablesInnerColumnsInnerKindEnumValues;
  static AdminReportDtoOutputTablesInnerColumnsInnerKindEnum valueOf(
    String name,
  ) => _$adminReportDtoOutputTablesInnerColumnsInnerKindEnumValueOf(name);
}
