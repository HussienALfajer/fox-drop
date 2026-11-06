//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_problems_inner.g.dart';

/// CustomerQuoteDtoOutputProblemsInner
///
/// Properties:
/// * [code]
/// * [line] - The cart line, for a line problem.
/// * [opensAt] - platform_closed: «FOX DROP يستقبل الطلبات من الساعة {الساعة}».
@BuiltValue()
abstract class CustomerQuoteDtoOutputProblemsInner
    implements
        Built<
          CustomerQuoteDtoOutputProblemsInner,
          CustomerQuoteDtoOutputProblemsInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  CustomerQuoteDtoOutputProblemsInnerCodeEnum get code;
  // enum codeEnum {  update_required,  maintenance,  platform_closed,  outside_zones,  not_covered,  restaurant_closed,  below_minimum_order,  minimum_not_in_base_currency,  delivery_unpriced,  rates_unavailable,  captain_pay_unset,  one_order_at_a_time,  active_order_limit,  no_captain_nearby,  item_not_found,  item_unavailable,  option_not_found,  option_unavailable,  options_invalid,  price_not_in_base_currency,  price_changed,  };

  /// The cart line, for a line problem.
  @BuiltValueField(wireName: r'line')
  int? get line;

  /// platform_closed: «FOX DROP يستقبل الطلبات من الساعة {الساعة}».
  @BuiltValueField(wireName: r'opensAt')
  DateTime? get opensAt;

  CustomerQuoteDtoOutputProblemsInner._();

  factory CustomerQuoteDtoOutputProblemsInner([
    void updates(CustomerQuoteDtoOutputProblemsInnerBuilder b),
  ]) = _$CustomerQuoteDtoOutputProblemsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputProblemsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputProblemsInner> get serializer =>
      _$CustomerQuoteDtoOutputProblemsInnerSerializer();
}

class _$CustomerQuoteDtoOutputProblemsInnerSerializer
    implements PrimitiveSerializer<CustomerQuoteDtoOutputProblemsInner> {
  @override
  final Iterable<Type> types = const [
    CustomerQuoteDtoOutputProblemsInner,
    _$CustomerQuoteDtoOutputProblemsInner,
  ];

  @override
  final String wireName = r'CustomerQuoteDtoOutputProblemsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputProblemsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(
        CustomerQuoteDtoOutputProblemsInnerCodeEnum,
      ),
    );
    yield r'line';
    yield object.line == null
        ? null
        : serializers.serialize(
            object.line,
            specifiedType: const FullType.nullable(int),
          );
    yield r'opensAt';
    yield object.opensAt == null
        ? null
        : serializers.serialize(
            object.opensAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputProblemsInner object, {
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
    required CustomerQuoteDtoOutputProblemsInnerBuilder result,
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
                    specifiedType: const FullType(
                      CustomerQuoteDtoOutputProblemsInnerCodeEnum,
                    ),
                  )
                  as CustomerQuoteDtoOutputProblemsInnerCodeEnum;
          result.code = valueDes;
          break;
        case r'line':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.line = valueDes;
          break;
        case r'opensAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.opensAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputProblemsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputProblemsInnerBuilder();
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

class CustomerQuoteDtoOutputProblemsInnerCodeEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'update_required')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum updateRequired =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_updateRequired;
  @BuiltValueEnumConst(wireName: r'maintenance')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum maintenance =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_maintenance;
  @BuiltValueEnumConst(wireName: r'platform_closed')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum platformClosed =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_platformClosed;
  @BuiltValueEnumConst(wireName: r'outside_zones')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum outsideZones =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_outsideZones;
  @BuiltValueEnumConst(wireName: r'not_covered')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum notCovered =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_notCovered;
  @BuiltValueEnumConst(wireName: r'restaurant_closed')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum restaurantClosed =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_restaurantClosed;
  @BuiltValueEnumConst(wireName: r'below_minimum_order')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum belowMinimumOrder =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_belowMinimumOrder;
  @BuiltValueEnumConst(wireName: r'minimum_not_in_base_currency')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum
  minimumNotInBaseCurrency =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_minimumNotInBaseCurrency;
  @BuiltValueEnumConst(wireName: r'delivery_unpriced')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum deliveryUnpriced =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_deliveryUnpriced;
  @BuiltValueEnumConst(wireName: r'rates_unavailable')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum ratesUnavailable =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_ratesUnavailable;
  @BuiltValueEnumConst(wireName: r'captain_pay_unset')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum captainPayUnset =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_captainPayUnset;
  @BuiltValueEnumConst(wireName: r'one_order_at_a_time')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum oneOrderAtATime =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_oneOrderAtATime;
  @BuiltValueEnumConst(wireName: r'active_order_limit')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum activeOrderLimit =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_activeOrderLimit;
  @BuiltValueEnumConst(wireName: r'no_captain_nearby')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum noCaptainNearby =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_noCaptainNearby;
  @BuiltValueEnumConst(wireName: r'item_not_found')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum itemNotFound =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_itemNotFound;
  @BuiltValueEnumConst(wireName: r'item_unavailable')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum itemUnavailable =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_itemUnavailable;
  @BuiltValueEnumConst(wireName: r'option_not_found')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum optionNotFound =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_optionNotFound;
  @BuiltValueEnumConst(wireName: r'option_unavailable')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum optionUnavailable =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_optionUnavailable;
  @BuiltValueEnumConst(wireName: r'options_invalid')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum optionsInvalid =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_optionsInvalid;
  @BuiltValueEnumConst(wireName: r'price_not_in_base_currency')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum
  priceNotInBaseCurrency =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_priceNotInBaseCurrency;
  @BuiltValueEnumConst(wireName: r'price_changed')
  static const CustomerQuoteDtoOutputProblemsInnerCodeEnum priceChanged =
      _$customerQuoteDtoOutputProblemsInnerCodeEnum_priceChanged;

  static Serializer<CustomerQuoteDtoOutputProblemsInnerCodeEnum>
  get serializer => _$customerQuoteDtoOutputProblemsInnerCodeEnumSerializer;

  const CustomerQuoteDtoOutputProblemsInnerCodeEnum._(String name)
    : super(name);

  static BuiltSet<CustomerQuoteDtoOutputProblemsInnerCodeEnum> get values =>
      _$customerQuoteDtoOutputProblemsInnerCodeEnumValues;
  static CustomerQuoteDtoOutputProblemsInnerCodeEnum valueOf(String name) =>
      _$customerQuoteDtoOutputProblemsInnerCodeEnumValueOf(name);
}
