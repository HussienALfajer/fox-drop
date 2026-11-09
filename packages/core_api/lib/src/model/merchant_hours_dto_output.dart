//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_hours_dto_output_coverage.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_status_dto_output_holiday.dart';
import 'package:core_api/src/model/merchant_hours_dto_output_periods_inner.dart';
import 'package:core_api/src/model/merchant_menu_dto_output_categories_inner_items_inner_price.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_hours_dto_output.g.dart';

/// MerchantHoursDtoOutput
///
/// Properties:
/// * [periods] - The weekly schedule; a weekday without a period is «مغلق طوال اليوم» (RA §10).
/// * [holiday]
/// * [defaultPrepMin]
/// * [prepFloorMin] - merchant.prep_time_floor_min.
/// * [prepCeilingMin] - merchant.prep_time_ceiling_min.
/// * [maxActiveOrders] - Off (null) or 1 to 50 (RA §7.4).
/// * [minimumOrder]
/// * [coverage]
/// * [commissionBp] - Basis points of the items value: 1500 is 15%.
/// * [settlementWeekday] - merchant.settlement_weekday, such as saturday.
@BuiltValue()
abstract class MerchantHoursDtoOutput
    implements Built<MerchantHoursDtoOutput, MerchantHoursDtoOutputBuilder> {
  /// The weekly schedule; a weekday without a period is «مغلق طوال اليوم» (RA §10).
  @BuiltValueField(wireName: r'periods')
  BuiltList<MerchantHoursDtoOutputPeriodsInner> get periods;

  @BuiltValueField(wireName: r'holiday')
  MerchantStatusDtoOutputHoliday? get holiday;

  @BuiltValueField(wireName: r'defaultPrepMin')
  int get defaultPrepMin;

  /// merchant.prep_time_floor_min.
  @BuiltValueField(wireName: r'prepFloorMin')
  int get prepFloorMin;

  /// merchant.prep_time_ceiling_min.
  @BuiltValueField(wireName: r'prepCeilingMin')
  int get prepCeilingMin;

  /// Off (null) or 1 to 50 (RA §7.4).
  @BuiltValueField(wireName: r'maxActiveOrders')
  int? get maxActiveOrders;

  @BuiltValueField(wireName: r'minimumOrder')
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice get minimumOrder;

  @BuiltValueField(wireName: r'coverage')
  MerchantHoursDtoOutputCoverage get coverage;

  /// Basis points of the items value: 1500 is 15%.
  @BuiltValueField(wireName: r'commissionBp')
  int? get commissionBp;

  /// merchant.settlement_weekday, such as saturday.
  @BuiltValueField(wireName: r'settlementWeekday')
  String get settlementWeekday;

  MerchantHoursDtoOutput._();

  factory MerchantHoursDtoOutput([
    void updates(MerchantHoursDtoOutputBuilder b),
  ]) = _$MerchantHoursDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantHoursDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantHoursDtoOutput> get serializer =>
      _$MerchantHoursDtoOutputSerializer();
}

class _$MerchantHoursDtoOutputSerializer
    implements PrimitiveSerializer<MerchantHoursDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantHoursDtoOutput,
    _$MerchantHoursDtoOutput,
  ];

  @override
  final String wireName = r'MerchantHoursDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantHoursDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'periods';
    yield serializers.serialize(
      object.periods,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantHoursDtoOutputPeriodsInner),
      ]),
    );
    yield r'holiday';
    yield object.holiday == null
        ? null
        : serializers.serialize(
            object.holiday,
            specifiedType: const FullType.nullable(
              MerchantStatusDtoOutputHoliday,
            ),
          );
    yield r'defaultPrepMin';
    yield serializers.serialize(
      object.defaultPrepMin,
      specifiedType: const FullType(int),
    );
    yield r'prepFloorMin';
    yield serializers.serialize(
      object.prepFloorMin,
      specifiedType: const FullType(int),
    );
    yield r'prepCeilingMin';
    yield serializers.serialize(
      object.prepCeilingMin,
      specifiedType: const FullType(int),
    );
    yield r'maxActiveOrders';
    yield object.maxActiveOrders == null
        ? null
        : serializers.serialize(
            object.maxActiveOrders,
            specifiedType: const FullType.nullable(int),
          );
    yield r'minimumOrder';
    yield serializers.serialize(
      object.minimumOrder,
      specifiedType: const FullType(
        MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
      ),
    );
    yield r'coverage';
    yield serializers.serialize(
      object.coverage,
      specifiedType: const FullType(MerchantHoursDtoOutputCoverage),
    );
    yield r'commissionBp';
    yield object.commissionBp == null
        ? null
        : serializers.serialize(
            object.commissionBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'settlementWeekday';
    yield serializers.serialize(
      object.settlementWeekday,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantHoursDtoOutput object, {
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
    required MerchantHoursDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'periods':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantHoursDtoOutputPeriodsInner),
                    ]),
                  )
                  as BuiltList<MerchantHoursDtoOutputPeriodsInner>;
          result.periods.replace(valueDes);
          break;
        case r'holiday':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantStatusDtoOutputHoliday,
                    ),
                  )
                  as MerchantStatusDtoOutputHoliday?;
          if (valueDes == null) continue;
          result.holiday.replace(valueDes);
          break;
        case r'defaultPrepMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.defaultPrepMin = valueDes;
          break;
        case r'prepFloorMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.prepFloorMin = valueDes;
          break;
        case r'prepCeilingMin':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.prepCeilingMin = valueDes;
          break;
        case r'maxActiveOrders':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.maxActiveOrders = valueDes;
          break;
        case r'minimumOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice,
                    ),
                  )
                  as MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice;
          result.minimumOrder.replace(valueDes);
          break;
        case r'coverage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantHoursDtoOutputCoverage,
                    ),
                  )
                  as MerchantHoursDtoOutputCoverage;
          result.coverage.replace(valueDes);
          break;
        case r'commissionBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.commissionBp = valueDes;
          break;
        case r'settlementWeekday':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.settlementWeekday = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantHoursDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantHoursDtoOutputBuilder();
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
