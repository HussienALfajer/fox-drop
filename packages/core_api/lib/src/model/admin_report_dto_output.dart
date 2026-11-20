//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_report_dto_output_tables_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_report_dto_output.g.dart';

/// AdminReportDtoOutput
///
/// Properties:
/// * [report]
/// * [cityId]
/// * [fromDay] - A business day on the city’s clock, YYYY-MM-DD.
/// * [toDay] - A business day on the city’s clock, YYYY-MM-DD.
/// * [from] - The cutoff that starts the first day.
/// * [to] - The cutoff that ends the last day, or now while the last day runs.
/// * [currency] - The city’s base: every money cell is in it unless its row names another.
/// * [tables]
@BuiltValue()
abstract class AdminReportDtoOutput
    implements Built<AdminReportDtoOutput, AdminReportDtoOutputBuilder> {
  @BuiltValueField(wireName: r'report')
  AdminReportDtoOutputReportEnum get report;
  // enum reportEnum {  orders,  timings,  restaurants,  captains,  customers,  lost_demand,  codes,  finance,  };

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'fromDay')
  String get fromDay;

  /// A business day on the city’s clock, YYYY-MM-DD.
  @BuiltValueField(wireName: r'toDay')
  String get toDay;

  /// The cutoff that starts the first day.
  @BuiltValueField(wireName: r'from')
  DateTime get from;

  /// The cutoff that ends the last day, or now while the last day runs.
  @BuiltValueField(wireName: r'to')
  DateTime get to;

  /// The city’s base: every money cell is in it unless its row names another.
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'tables')
  BuiltList<AdminReportDtoOutputTablesInner> get tables;

  AdminReportDtoOutput._();

  factory AdminReportDtoOutput([void updates(AdminReportDtoOutputBuilder b)]) =
      _$AdminReportDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminReportDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminReportDtoOutput> get serializer =>
      _$AdminReportDtoOutputSerializer();
}

class _$AdminReportDtoOutputSerializer
    implements PrimitiveSerializer<AdminReportDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminReportDtoOutput,
    _$AdminReportDtoOutput,
  ];

  @override
  final String wireName = r'AdminReportDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'report';
    yield serializers.serialize(
      object.report,
      specifiedType: const FullType(AdminReportDtoOutputReportEnum),
    );
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'fromDay';
    yield serializers.serialize(
      object.fromDay,
      specifiedType: const FullType(String),
    );
    yield r'toDay';
    yield serializers.serialize(
      object.toDay,
      specifiedType: const FullType(String),
    );
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(DateTime),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(DateTime),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'tables';
    yield serializers.serialize(
      object.tables,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminReportDtoOutputTablesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminReportDtoOutput object, {
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
    required AdminReportDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'report':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminReportDtoOutputReportEnum,
                    ),
                  )
                  as AdminReportDtoOutputReportEnum;
          result.report = valueDes;
          break;
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
        case r'fromDay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.fromDay = valueDes;
          break;
        case r'toDay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.toDay = valueDes;
          break;
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.from = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.to = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'tables':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminReportDtoOutputTablesInner),
                    ]),
                  )
                  as BuiltList<AdminReportDtoOutputTablesInner>;
          result.tables.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminReportDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminReportDtoOutputBuilder();
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

class AdminReportDtoOutputReportEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'orders')
  static const AdminReportDtoOutputReportEnum orders =
      _$adminReportDtoOutputReportEnum_orders;
  @BuiltValueEnumConst(wireName: r'timings')
  static const AdminReportDtoOutputReportEnum timings =
      _$adminReportDtoOutputReportEnum_timings;
  @BuiltValueEnumConst(wireName: r'restaurants')
  static const AdminReportDtoOutputReportEnum restaurants =
      _$adminReportDtoOutputReportEnum_restaurants;
  @BuiltValueEnumConst(wireName: r'captains')
  static const AdminReportDtoOutputReportEnum captains =
      _$adminReportDtoOutputReportEnum_captains;
  @BuiltValueEnumConst(wireName: r'customers')
  static const AdminReportDtoOutputReportEnum customers =
      _$adminReportDtoOutputReportEnum_customers;
  @BuiltValueEnumConst(wireName: r'lost_demand')
  static const AdminReportDtoOutputReportEnum lostDemand =
      _$adminReportDtoOutputReportEnum_lostDemand;
  @BuiltValueEnumConst(wireName: r'codes')
  static const AdminReportDtoOutputReportEnum codes =
      _$adminReportDtoOutputReportEnum_codes;
  @BuiltValueEnumConst(wireName: r'finance')
  static const AdminReportDtoOutputReportEnum finance =
      _$adminReportDtoOutputReportEnum_finance;

  static Serializer<AdminReportDtoOutputReportEnum> get serializer =>
      _$adminReportDtoOutputReportEnumSerializer;

  const AdminReportDtoOutputReportEnum._(String name) : super(name);

  static BuiltSet<AdminReportDtoOutputReportEnum> get values =>
      _$adminReportDtoOutputReportEnumValues;
  static AdminReportDtoOutputReportEnum valueOf(String name) =>
      _$adminReportDtoOutputReportEnumValueOf(name);
}
