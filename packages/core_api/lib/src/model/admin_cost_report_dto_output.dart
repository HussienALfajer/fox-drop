//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_cost_report_dto_output_compensation_reasons_inner.dart';
import 'package:core_api/src/model/admin_cost_report_dto_output_operating_reasons_inner.dart';
import 'package:core_api/src/model/admin_cost_report_dto_output_codes_inner.dart';
import 'package:core_api/src/model/admin_cost_report_dto_output_totals.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_cost_report_dto_output_restaurants_inner.dart';
import 'package:core_api/src/model/admin_cost_report_dto_output_parties_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cost_report_dto_output.g.dart';

/// AdminCostReportDtoOutput
///
/// Properties:
/// * [cityId]
/// * [fromDay] - A business day on the city’s clock, YYYY-MM-DD.
/// * [toDay] - A business day on the city’s clock, YYYY-MM-DD.
/// * [from] - The cutoff that starts the first day.
/// * [to] - The cutoff that ends the last day.
/// * [currency] - The city’s base: every amount is in it, + a cost.
/// * [totals]
/// * [compensationReasons]
/// * [operatingReasons]
/// * [codes]
/// * [parties]
/// * [restaurants]
@BuiltValue()
abstract class AdminCostReportDtoOutput
    implements
        Built<AdminCostReportDtoOutput, AdminCostReportDtoOutputBuilder> {
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

  /// The cutoff that ends the last day.
  @BuiltValueField(wireName: r'to')
  DateTime get to;

  /// The city’s base: every amount is in it, + a cost.
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'totals')
  AdminCostReportDtoOutputTotals get totals;

  @BuiltValueField(wireName: r'compensationReasons')
  BuiltList<AdminCostReportDtoOutputCompensationReasonsInner>
  get compensationReasons;

  @BuiltValueField(wireName: r'operatingReasons')
  BuiltList<AdminCostReportDtoOutputOperatingReasonsInner> get operatingReasons;

  @BuiltValueField(wireName: r'codes')
  BuiltList<AdminCostReportDtoOutputCodesInner> get codes;

  @BuiltValueField(wireName: r'parties')
  BuiltList<AdminCostReportDtoOutputPartiesInner> get parties;

  @BuiltValueField(wireName: r'restaurants')
  BuiltList<AdminCostReportDtoOutputRestaurantsInner> get restaurants;

  AdminCostReportDtoOutput._();

  factory AdminCostReportDtoOutput([
    void updates(AdminCostReportDtoOutputBuilder b),
  ]) = _$AdminCostReportDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCostReportDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCostReportDtoOutput> get serializer =>
      _$AdminCostReportDtoOutputSerializer();
}

class _$AdminCostReportDtoOutputSerializer
    implements PrimitiveSerializer<AdminCostReportDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminCostReportDtoOutput,
    _$AdminCostReportDtoOutput,
  ];

  @override
  final String wireName = r'AdminCostReportDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCostReportDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
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
    yield r'totals';
    yield serializers.serialize(
      object.totals,
      specifiedType: const FullType(AdminCostReportDtoOutputTotals),
    );
    yield r'compensationReasons';
    yield serializers.serialize(
      object.compensationReasons,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCostReportDtoOutputCompensationReasonsInner),
      ]),
    );
    yield r'operatingReasons';
    yield serializers.serialize(
      object.operatingReasons,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCostReportDtoOutputOperatingReasonsInner),
      ]),
    );
    yield r'codes';
    yield serializers.serialize(
      object.codes,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCostReportDtoOutputCodesInner),
      ]),
    );
    yield r'parties';
    yield serializers.serialize(
      object.parties,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCostReportDtoOutputPartiesInner),
      ]),
    );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminCostReportDtoOutputRestaurantsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCostReportDtoOutput object, {
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
    required AdminCostReportDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        case r'totals':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCostReportDtoOutputTotals,
                    ),
                  )
                  as AdminCostReportDtoOutputTotals;
          result.totals.replace(valueDes);
          break;
        case r'compensationReasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminCostReportDtoOutputCompensationReasonsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCostReportDtoOutputCompensationReasonsInner
                  >;
          result.compensationReasons.replace(valueDes);
          break;
        case r'operatingReasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCostReportDtoOutputOperatingReasonsInner),
                    ]),
                  )
                  as BuiltList<AdminCostReportDtoOutputOperatingReasonsInner>;
          result.operatingReasons.replace(valueDes);
          break;
        case r'codes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCostReportDtoOutputCodesInner),
                    ]),
                  )
                  as BuiltList<AdminCostReportDtoOutputCodesInner>;
          result.codes.replace(valueDes);
          break;
        case r'parties':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCostReportDtoOutputPartiesInner),
                    ]),
                  )
                  as BuiltList<AdminCostReportDtoOutputPartiesInner>;
          result.parties.replace(valueDes);
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminCostReportDtoOutputRestaurantsInner),
                    ]),
                  )
                  as BuiltList<AdminCostReportDtoOutputRestaurantsInner>;
          result.restaurants.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCostReportDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCostReportDtoOutputBuilder();
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
