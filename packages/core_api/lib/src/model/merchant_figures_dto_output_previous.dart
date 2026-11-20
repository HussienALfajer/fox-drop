//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_figures_dto_output_current_pause_minutes.dart';
import 'package:core_api/src/model/merchant_figures_dto_output_current_hours_inner.dart';
import 'package:core_api/src/model/merchant_figures_dto_output_current_rating.dart';
import 'package:core_api/src/model/merchant_figures_dto_output_current_top_by_quantity_inner.dart';
import 'package:core_api/src/model/merchant_figures_dto_output_current_rejections_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_figures_dto_output_previous.g.dart';

/// The previous period of the same length, for the arrows.
///
/// Properties:
/// * [received] - Orders that reached the restaurant.
/// * [acceptedByYou]
/// * [acceptedByOperations] - Accepted on the restaurant’s behalf (RA §8.15).
/// * [rejected]
/// * [rejections]
/// * [unanswered] - Cancelled automatically for no response (RA §8.3).
/// * [acceptanceBp] - Accepted by you ÷ (received − cancelled by the customer before any answer).
/// * [delivered]
/// * [sales] - Items value of the delivered orders, after any edits.
/// * [averageOrder]
/// * [commission] - From the restaurant account’s entries of the period (RA §12).
/// * [discounts] - Restaurant-funded discounts, from the same entries.
/// * [net] - Sales less the commission and the discounts.
/// * [acceptMinutes] - Placed to accepted, by restaurant users only.
/// * [prepActualMinutes]
/// * [prepChosenMinutes]
/// * [lateBp] - Ready (or picked up) after the time chosen ÷ accepted.
/// * [readyNotPressed]
/// * [captainWaitMinutes]
/// * [rating]
/// * [topByQuantity]
/// * [topBySales]
/// * [hours]
/// * [pauseMinutes]
@BuiltValue()
abstract class MerchantFiguresDtoOutputPrevious
    implements
        Built<
          MerchantFiguresDtoOutputPrevious,
          MerchantFiguresDtoOutputPreviousBuilder
        > {
  /// Orders that reached the restaurant.
  @BuiltValueField(wireName: r'received')
  int get received;

  @BuiltValueField(wireName: r'acceptedByYou')
  int get acceptedByYou;

  /// Accepted on the restaurant’s behalf (RA §8.15).
  @BuiltValueField(wireName: r'acceptedByOperations')
  int get acceptedByOperations;

  @BuiltValueField(wireName: r'rejected')
  int get rejected;

  @BuiltValueField(wireName: r'rejections')
  BuiltList<MerchantFiguresDtoOutputCurrentRejectionsInner> get rejections;

  /// Cancelled automatically for no response (RA §8.3).
  @BuiltValueField(wireName: r'unanswered')
  int get unanswered;

  /// Accepted by you ÷ (received − cancelled by the customer before any answer).
  @BuiltValueField(wireName: r'acceptanceBp')
  int? get acceptanceBp;

  @BuiltValueField(wireName: r'delivered')
  int get delivered;

  /// Items value of the delivered orders, after any edits.
  @BuiltValueField(wireName: r'sales')
  String get sales;

  @BuiltValueField(wireName: r'averageOrder')
  String? get averageOrder;

  /// From the restaurant account’s entries of the period (RA §12).
  @BuiltValueField(wireName: r'commission')
  String get commission;

  /// Restaurant-funded discounts, from the same entries.
  @BuiltValueField(wireName: r'discounts')
  String get discounts;

  /// Sales less the commission and the discounts.
  @BuiltValueField(wireName: r'net')
  String get net;

  /// Placed to accepted, by restaurant users only.
  @BuiltValueField(wireName: r'acceptMinutes')
  num? get acceptMinutes;

  @BuiltValueField(wireName: r'prepActualMinutes')
  num? get prepActualMinutes;

  @BuiltValueField(wireName: r'prepChosenMinutes')
  num? get prepChosenMinutes;

  /// Ready (or picked up) after the time chosen ÷ accepted.
  @BuiltValueField(wireName: r'lateBp')
  int? get lateBp;

  @BuiltValueField(wireName: r'readyNotPressed')
  int get readyNotPressed;

  @BuiltValueField(wireName: r'captainWaitMinutes')
  num? get captainWaitMinutes;

  @BuiltValueField(wireName: r'rating')
  MerchantFiguresDtoOutputCurrentRating get rating;

  @BuiltValueField(wireName: r'topByQuantity')
  BuiltList<MerchantFiguresDtoOutputCurrentTopByQuantityInner>
  get topByQuantity;

  @BuiltValueField(wireName: r'topBySales')
  BuiltList<MerchantFiguresDtoOutputCurrentTopByQuantityInner> get topBySales;

  @BuiltValueField(wireName: r'hours')
  BuiltList<MerchantFiguresDtoOutputCurrentHoursInner> get hours;

  @BuiltValueField(wireName: r'pauseMinutes')
  MerchantFiguresDtoOutputCurrentPauseMinutes get pauseMinutes;

  MerchantFiguresDtoOutputPrevious._();

  factory MerchantFiguresDtoOutputPrevious([
    void updates(MerchantFiguresDtoOutputPreviousBuilder b),
  ]) = _$MerchantFiguresDtoOutputPrevious;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantFiguresDtoOutputPreviousBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantFiguresDtoOutputPrevious> get serializer =>
      _$MerchantFiguresDtoOutputPreviousSerializer();
}

class _$MerchantFiguresDtoOutputPreviousSerializer
    implements PrimitiveSerializer<MerchantFiguresDtoOutputPrevious> {
  @override
  final Iterable<Type> types = const [
    MerchantFiguresDtoOutputPrevious,
    _$MerchantFiguresDtoOutputPrevious,
  ];

  @override
  final String wireName = r'MerchantFiguresDtoOutputPrevious';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantFiguresDtoOutputPrevious object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'received';
    yield serializers.serialize(
      object.received,
      specifiedType: const FullType(int),
    );
    yield r'acceptedByYou';
    yield serializers.serialize(
      object.acceptedByYou,
      specifiedType: const FullType(int),
    );
    yield r'acceptedByOperations';
    yield serializers.serialize(
      object.acceptedByOperations,
      specifiedType: const FullType(int),
    );
    yield r'rejected';
    yield serializers.serialize(
      object.rejected,
      specifiedType: const FullType(int),
    );
    yield r'rejections';
    yield serializers.serialize(
      object.rejections,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantFiguresDtoOutputCurrentRejectionsInner),
      ]),
    );
    yield r'unanswered';
    yield serializers.serialize(
      object.unanswered,
      specifiedType: const FullType(int),
    );
    yield r'acceptanceBp';
    yield object.acceptanceBp == null
        ? null
        : serializers.serialize(
            object.acceptanceBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'delivered';
    yield serializers.serialize(
      object.delivered,
      specifiedType: const FullType(int),
    );
    yield r'sales';
    yield serializers.serialize(
      object.sales,
      specifiedType: const FullType(String),
    );
    yield r'averageOrder';
    yield object.averageOrder == null
        ? null
        : serializers.serialize(
            object.averageOrder,
            specifiedType: const FullType.nullable(String),
          );
    yield r'commission';
    yield serializers.serialize(
      object.commission,
      specifiedType: const FullType(String),
    );
    yield r'discounts';
    yield serializers.serialize(
      object.discounts,
      specifiedType: const FullType(String),
    );
    yield r'net';
    yield serializers.serialize(
      object.net,
      specifiedType: const FullType(String),
    );
    yield r'acceptMinutes';
    yield object.acceptMinutes == null
        ? null
        : serializers.serialize(
            object.acceptMinutes,
            specifiedType: const FullType.nullable(num),
          );
    yield r'prepActualMinutes';
    yield object.prepActualMinutes == null
        ? null
        : serializers.serialize(
            object.prepActualMinutes,
            specifiedType: const FullType.nullable(num),
          );
    yield r'prepChosenMinutes';
    yield object.prepChosenMinutes == null
        ? null
        : serializers.serialize(
            object.prepChosenMinutes,
            specifiedType: const FullType.nullable(num),
          );
    yield r'lateBp';
    yield object.lateBp == null
        ? null
        : serializers.serialize(
            object.lateBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'readyNotPressed';
    yield serializers.serialize(
      object.readyNotPressed,
      specifiedType: const FullType(int),
    );
    yield r'captainWaitMinutes';
    yield object.captainWaitMinutes == null
        ? null
        : serializers.serialize(
            object.captainWaitMinutes,
            specifiedType: const FullType.nullable(num),
          );
    yield r'rating';
    yield serializers.serialize(
      object.rating,
      specifiedType: const FullType(MerchantFiguresDtoOutputCurrentRating),
    );
    yield r'topByQuantity';
    yield serializers.serialize(
      object.topByQuantity,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantFiguresDtoOutputCurrentTopByQuantityInner),
      ]),
    );
    yield r'topBySales';
    yield serializers.serialize(
      object.topBySales,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantFiguresDtoOutputCurrentTopByQuantityInner),
      ]),
    );
    yield r'hours';
    yield serializers.serialize(
      object.hours,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantFiguresDtoOutputCurrentHoursInner),
      ]),
    );
    yield r'pauseMinutes';
    yield serializers.serialize(
      object.pauseMinutes,
      specifiedType: const FullType(
        MerchantFiguresDtoOutputCurrentPauseMinutes,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantFiguresDtoOutputPrevious object, {
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
    required MerchantFiguresDtoOutputPreviousBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'received':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.received = valueDes;
          break;
        case r'acceptedByYou':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.acceptedByYou = valueDes;
          break;
        case r'acceptedByOperations':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.acceptedByOperations = valueDes;
          break;
        case r'rejected':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.rejected = valueDes;
          break;
        case r'rejections':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantFiguresDtoOutputCurrentRejectionsInner),
                    ]),
                  )
                  as BuiltList<MerchantFiguresDtoOutputCurrentRejectionsInner>;
          result.rejections.replace(valueDes);
          break;
        case r'unanswered':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.unanswered = valueDes;
          break;
        case r'acceptanceBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.acceptanceBp = valueDes;
          break;
        case r'delivered':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.delivered = valueDes;
          break;
        case r'sales':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.sales = valueDes;
          break;
        case r'averageOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.averageOrder = valueDes;
          break;
        case r'commission':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.commission = valueDes;
          break;
        case r'discounts':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.discounts = valueDes;
          break;
        case r'net':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.net = valueDes;
          break;
        case r'acceptMinutes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.acceptMinutes = valueDes;
          break;
        case r'prepActualMinutes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.prepActualMinutes = valueDes;
          break;
        case r'prepChosenMinutes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.prepChosenMinutes = valueDes;
          break;
        case r'lateBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.lateBp = valueDes;
          break;
        case r'readyNotPressed':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.readyNotPressed = valueDes;
          break;
        case r'captainWaitMinutes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(num),
                  )
                  as num?;
          if (valueDes == null) continue;
          result.captainWaitMinutes = valueDes;
          break;
        case r'rating':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantFiguresDtoOutputCurrentRating,
                    ),
                  )
                  as MerchantFiguresDtoOutputCurrentRating;
          result.rating.replace(valueDes);
          break;
        case r'topByQuantity':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantFiguresDtoOutputCurrentTopByQuantityInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantFiguresDtoOutputCurrentTopByQuantityInner
                  >;
          result.topByQuantity.replace(valueDes);
          break;
        case r'topBySales':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantFiguresDtoOutputCurrentTopByQuantityInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantFiguresDtoOutputCurrentTopByQuantityInner
                  >;
          result.topBySales.replace(valueDes);
          break;
        case r'hours':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantFiguresDtoOutputCurrentHoursInner),
                    ]),
                  )
                  as BuiltList<MerchantFiguresDtoOutputCurrentHoursInner>;
          result.hours.replace(valueDes);
          break;
        case r'pauseMinutes':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      MerchantFiguresDtoOutputCurrentPauseMinutes,
                    ),
                  )
                  as MerchantFiguresDtoOutputCurrentPauseMinutes;
          result.pauseMinutes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantFiguresDtoOutputPrevious deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantFiguresDtoOutputPreviousBuilder();
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
