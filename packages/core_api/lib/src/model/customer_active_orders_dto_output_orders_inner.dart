//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_went_offline_dto_output_hand_in.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_estimate.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_lines_inner.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_rejection.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_restaurant.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_cancellation.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_delivery.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_captain.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_money.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_item_report.dart';
import 'package:core_api/src/model/customer_active_orders_dto_output_orders_inner_address.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner.g.dart';

/// CustomerActiveOrdersDtoOutputOrdersInner
///
/// Properties:
/// * [id]
/// * [number] - Shown as #10423 (AP §4.8).
/// * [status] - AP §8.1.
/// * [version] - Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).
/// * [placedAt]
/// * [promisedAt] - «يصل حوالي {الساعة}» from acceptance (CU §11.1–11.2, docs/domain/03); null while placed, when the estimate range shows.
/// * [itemReport]
/// * [cancellation]
/// * [rejection]
/// * [delivery]
/// * [restaurant]
/// * [captain]
/// * [currency]
/// * [money]
/// * [equivalents] - The total in the city's other currencies, by the order's own rates (CU §11.1).
/// * [lines]
/// * [payIn] - «سأدفع بـ»; null for «لم أحدد».
/// * [note]
/// * [estimate]
/// * [address]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInner
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInner,
          CustomerActiveOrdersDtoOutputOrdersInnerBuilder
        > {
  @BuiltValueField(wireName: r'id')
  String get id;

  /// Shown as #10423 (AP §4.8).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// AP §8.1.
  @BuiltValueField(wireName: r'status')
  CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum get status;
  // enum statusEnum {  placed,  accepted,  ready,  picked_up,  arrived,  delivered,  rejected,  cancelled,  failed,  };

  /// Increases with every change (architecture §5.3); ignore a real-time event not newer than the version shown (RA §4.3).
  @BuiltValueField(wireName: r'version')
  int get version;

  @BuiltValueField(wireName: r'placedAt')
  DateTime get placedAt;

  /// «يصل حوالي {الساعة}» from acceptance (CU §11.1–11.2, docs/domain/03); null while placed, when the estimate range shows.
  @BuiltValueField(wireName: r'promisedAt')
  DateTime? get promisedAt;

  @BuiltValueField(wireName: r'itemReport')
  CustomerActiveOrdersDtoOutputOrdersInnerItemReport? get itemReport;

  @BuiltValueField(wireName: r'cancellation')
  CustomerActiveOrdersDtoOutputOrdersInnerCancellation? get cancellation;

  @BuiltValueField(wireName: r'rejection')
  CustomerActiveOrdersDtoOutputOrdersInnerRejection? get rejection;

  @BuiltValueField(wireName: r'delivery')
  CustomerActiveOrdersDtoOutputOrdersInnerDelivery? get delivery;

  @BuiltValueField(wireName: r'restaurant')
  CustomerActiveOrdersDtoOutputOrdersInnerRestaurant get restaurant;

  @BuiltValueField(wireName: r'captain')
  CustomerActiveOrdersDtoOutputOrdersInnerCaptain? get captain;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'money')
  CustomerActiveOrdersDtoOutputOrdersInnerMoney get money;

  /// The total in the city's other currencies, by the order's own rates (CU §11.1).
  @BuiltValueField(wireName: r'equivalents')
  BuiltList<CaptainWentOfflineDtoOutputHandIn?> get equivalents;

  @BuiltValueField(wireName: r'lines')
  BuiltList<CustomerActiveOrdersDtoOutputOrdersInnerLinesInner> get lines;

  /// «سأدفع بـ»; null for «لم أحدد».
  @BuiltValueField(wireName: r'payIn')
  String? get payIn;

  @BuiltValueField(wireName: r'note')
  String? get note;

  @BuiltValueField(wireName: r'estimate')
  CustomerActiveOrdersDtoOutputOrdersInnerEstimate get estimate;

  @BuiltValueField(wireName: r'address')
  CustomerActiveOrdersDtoOutputOrdersInnerAddress get address;

  CustomerActiveOrdersDtoOutputOrdersInner._();

  factory CustomerActiveOrdersDtoOutputOrdersInner([
    void updates(CustomerActiveOrdersDtoOutputOrdersInnerBuilder b),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerActiveOrdersDtoOutputOrdersInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInner> get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerSerializer
    implements PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInner> {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInner,
    _$CustomerActiveOrdersDtoOutputOrdersInner,
  ];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum,
      ),
    );
    yield r'version';
    yield serializers.serialize(
      object.version,
      specifiedType: const FullType(int),
    );
    yield r'placedAt';
    yield serializers.serialize(
      object.placedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'promisedAt';
    yield object.promisedAt == null
        ? null
        : serializers.serialize(
            object.promisedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'itemReport';
    yield object.itemReport == null
        ? null
        : serializers.serialize(
            object.itemReport,
            specifiedType: const FullType.nullable(
              CustomerActiveOrdersDtoOutputOrdersInnerItemReport,
            ),
          );
    yield r'cancellation';
    yield object.cancellation == null
        ? null
        : serializers.serialize(
            object.cancellation,
            specifiedType: const FullType.nullable(
              CustomerActiveOrdersDtoOutputOrdersInnerCancellation,
            ),
          );
    yield r'rejection';
    yield object.rejection == null
        ? null
        : serializers.serialize(
            object.rejection,
            specifiedType: const FullType.nullable(
              CustomerActiveOrdersDtoOutputOrdersInnerRejection,
            ),
          );
    yield r'delivery';
    yield object.delivery == null
        ? null
        : serializers.serialize(
            object.delivery,
            specifiedType: const FullType.nullable(
              CustomerActiveOrdersDtoOutputOrdersInnerDelivery,
            ),
          );
    yield r'restaurant';
    yield serializers.serialize(
      object.restaurant,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerRestaurant,
      ),
    );
    yield r'captain';
    yield object.captain == null
        ? null
        : serializers.serialize(
            object.captain,
            specifiedType: const FullType.nullable(
              CustomerActiveOrdersDtoOutputOrdersInnerCaptain,
            ),
          );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'money';
    yield serializers.serialize(
      object.money,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerMoney,
      ),
    );
    yield r'equivalents';
    yield serializers.serialize(
      object.equivalents,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
      ]),
    );
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(CustomerActiveOrdersDtoOutputOrdersInnerLinesInner),
      ]),
    );
    yield r'payIn';
    yield object.payIn == null
        ? null
        : serializers.serialize(
            object.payIn,
            specifiedType: const FullType.nullable(String),
          );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'estimate';
    yield serializers.serialize(
      object.estimate,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerEstimate,
      ),
    );
    yield r'address';
    yield serializers.serialize(
      object.address,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerAddress,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInner object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.id = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'version':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.version = valueDes;
          break;
        case r'placedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.placedAt = valueDes;
          break;
        case r'promisedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.promisedAt = valueDes;
          break;
        case r'itemReport':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerActiveOrdersDtoOutputOrdersInnerItemReport,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerItemReport?;
          if (valueDes == null) continue;
          result.itemReport.replace(valueDes);
          break;
        case r'cancellation':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerActiveOrdersDtoOutputOrdersInnerCancellation,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerCancellation?;
          if (valueDes == null) continue;
          result.cancellation.replace(valueDes);
          break;
        case r'rejection':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerActiveOrdersDtoOutputOrdersInnerRejection,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerRejection?;
          if (valueDes == null) continue;
          result.rejection.replace(valueDes);
          break;
        case r'delivery':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerActiveOrdersDtoOutputOrdersInnerDelivery,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerDelivery?;
          if (valueDes == null) continue;
          result.delivery.replace(valueDes);
          break;
        case r'restaurant':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerRestaurant,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerRestaurant;
          result.restaurant.replace(valueDes);
          break;
        case r'captain':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerActiveOrdersDtoOutputOrdersInnerCaptain,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerCaptain?;
          if (valueDes == null) continue;
          result.captain.replace(valueDes);
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
        case r'money':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerMoney,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerMoney;
          result.money.replace(valueDes);
          break;
        case r'equivalents':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(CaptainWentOfflineDtoOutputHandIn),
                    ]),
                  )
                  as BuiltList<CaptainWentOfflineDtoOutputHandIn?>;
          result.equivalents.replace(valueDes);
          break;
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        CustomerActiveOrdersDtoOutputOrdersInnerLinesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CustomerActiveOrdersDtoOutputOrdersInnerLinesInner
                  >;
          result.lines.replace(valueDes);
          break;
        case r'payIn':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.payIn = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'estimate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerEstimate,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerEstimate;
          result.estimate.replace(valueDes);
          break;
        case r'address':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerAddress,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerAddress;
          result.address.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerBuilder();
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

/// AP §8.1.
class CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'placed')
  static const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum placed =
      _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_placed;
  @BuiltValueEnumConst(wireName: r'accepted')
  static const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum accepted =
      _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_accepted;
  @BuiltValueEnumConst(wireName: r'ready')
  static const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum ready =
      _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_ready;
  @BuiltValueEnumConst(wireName: r'picked_up')
  static const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum pickedUp =
      _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_pickedUp;
  @BuiltValueEnumConst(wireName: r'arrived')
  static const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum arrived =
      _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_arrived;
  @BuiltValueEnumConst(wireName: r'delivered')
  static const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum delivered =
      _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_delivered;
  @BuiltValueEnumConst(wireName: r'rejected')
  static const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum rejected =
      _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_rejected;
  @BuiltValueEnumConst(wireName: r'cancelled')
  static const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum cancelled =
      _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_cancelled;
  @BuiltValueEnumConst(wireName: r'failed')
  static const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum failed =
      _$customerActiveOrdersDtoOutputOrdersInnerStatusEnum_failed;

  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum>
  get serializer =>
      _$customerActiveOrdersDtoOutputOrdersInnerStatusEnumSerializer;

  const CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum>
  get values => _$customerActiveOrdersDtoOutputOrdersInnerStatusEnumValues;
  static CustomerActiveOrdersDtoOutputOrdersInnerStatusEnum valueOf(
    String name,
  ) => _$customerActiveOrdersDtoOutputOrdersInnerStatusEnumValueOf(name);
}
