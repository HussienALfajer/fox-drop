//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/customer_codes_dto_output_codes_inner_ended.dart';
import 'package:core_api/src/model/customer_quote_dto_output_available_codes_inner_hours.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_codes_dto_output_codes_inner.g.dart';

/// CustomerCodesDtoOutputCodesInner
///
/// Properties:
/// * [code]
/// * [kind]
/// * [percentBp] - A percentage in basis points (2000 is 20%).
/// * [amount] - Minor units of `currency`.
/// * [maxDiscount] - Minor units of `currency`.
/// * [minOrder] - Minor units of `currency`.
/// * [restaurants] - The restaurants it works with; none: all.
/// * [zones] - The zones it works in, by name; none: all.
/// * [hours]
/// * [validTo] - «ينتهي {التاريخ}».
/// * [usesLeft] - What the customer has left; null: no limit.
/// * [ended]
@BuiltValue()
abstract class CustomerCodesDtoOutputCodesInner
    implements
        Built<
          CustomerCodesDtoOutputCodesInner,
          CustomerCodesDtoOutputCodesInnerBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'kind')
  CustomerCodesDtoOutputCodesInnerKindEnum get kind;
  // enum kindEnum {  percentage,  fixed_amount,  free_delivery,  };

  /// A percentage in basis points (2000 is 20%).
  @BuiltValueField(wireName: r'percentBp')
  int? get percentBp;

  /// Minor units of `currency`.
  @BuiltValueField(wireName: r'amount')
  String? get amount;

  /// Minor units of `currency`.
  @BuiltValueField(wireName: r'maxDiscount')
  String? get maxDiscount;

  /// Minor units of `currency`.
  @BuiltValueField(wireName: r'minOrder')
  String? get minOrder;

  /// The restaurants it works with; none: all.
  @BuiltValueField(wireName: r'restaurants')
  BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?> get restaurants;

  /// The zones it works in, by name; none: all.
  @BuiltValueField(wireName: r'zones')
  BuiltList<String> get zones;

  @BuiltValueField(wireName: r'hours')
  CustomerQuoteDtoOutputAvailableCodesInnerHours? get hours;

  /// «ينتهي {التاريخ}».
  @BuiltValueField(wireName: r'validTo')
  DateTime get validTo;

  /// What the customer has left; null: no limit.
  @BuiltValueField(wireName: r'usesLeft')
  int? get usesLeft;

  @BuiltValueField(wireName: r'ended')
  CustomerCodesDtoOutputCodesInnerEnded? get ended;

  CustomerCodesDtoOutputCodesInner._();

  factory CustomerCodesDtoOutputCodesInner([
    void updates(CustomerCodesDtoOutputCodesInnerBuilder b),
  ]) = _$CustomerCodesDtoOutputCodesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerCodesDtoOutputCodesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerCodesDtoOutputCodesInner> get serializer =>
      _$CustomerCodesDtoOutputCodesInnerSerializer();
}

class _$CustomerCodesDtoOutputCodesInnerSerializer
    implements PrimitiveSerializer<CustomerCodesDtoOutputCodesInner> {
  @override
  final Iterable<Type> types = const [
    CustomerCodesDtoOutputCodesInner,
    _$CustomerCodesDtoOutputCodesInner,
  ];

  @override
  final String wireName = r'CustomerCodesDtoOutputCodesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerCodesDtoOutputCodesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(CustomerCodesDtoOutputCodesInnerKindEnum),
    );
    yield r'percentBp';
    yield object.percentBp == null
        ? null
        : serializers.serialize(
            object.percentBp,
            specifiedType: const FullType.nullable(int),
          );
    yield r'amount';
    yield object.amount == null
        ? null
        : serializers.serialize(
            object.amount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'maxDiscount';
    yield object.maxDiscount == null
        ? null
        : serializers.serialize(
            object.maxDiscount,
            specifiedType: const FullType.nullable(String),
          );
    yield r'minOrder';
    yield object.minOrder == null
        ? null
        : serializers.serialize(
            object.minOrder,
            specifiedType: const FullType.nullable(String),
          );
    yield r'restaurants';
    yield serializers.serialize(
      object.restaurants,
      specifiedType: const FullType(BuiltList, [
        FullType.nullable(CaptainPeakBonusDtoOutputWindowsInnerZonesInner),
      ]),
    );
    yield r'zones';
    yield serializers.serialize(
      object.zones,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'hours';
    yield object.hours == null
        ? null
        : serializers.serialize(
            object.hours,
            specifiedType: const FullType.nullable(
              CustomerQuoteDtoOutputAvailableCodesInnerHours,
            ),
          );
    yield r'validTo';
    yield serializers.serialize(
      object.validTo,
      specifiedType: const FullType(DateTime),
    );
    yield r'usesLeft';
    yield object.usesLeft == null
        ? null
        : serializers.serialize(
            object.usesLeft,
            specifiedType: const FullType.nullable(int),
          );
    yield r'ended';
    yield object.ended == null
        ? null
        : serializers.serialize(
            object.ended,
            specifiedType: const FullType.nullable(
              CustomerCodesDtoOutputCodesInnerEnded,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerCodesDtoOutputCodesInner object, {
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
    required CustomerCodesDtoOutputCodesInnerBuilder result,
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
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerCodesDtoOutputCodesInnerKindEnum,
                    ),
                  )
                  as CustomerCodesDtoOutputCodesInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'percentBp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.percentBp = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.amount = valueDes;
          break;
        case r'maxDiscount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.maxDiscount = valueDes;
          break;
        case r'minOrder':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.minOrder = valueDes;
          break;
        case r'restaurants':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType.nullable(
                        CaptainPeakBonusDtoOutputWindowsInnerZonesInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    CaptainPeakBonusDtoOutputWindowsInnerZonesInner?
                  >;
          result.restaurants.replace(valueDes);
          break;
        case r'zones':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.zones.replace(valueDes);
          break;
        case r'hours':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerQuoteDtoOutputAvailableCodesInnerHours,
                    ),
                  )
                  as CustomerQuoteDtoOutputAvailableCodesInnerHours?;
          if (valueDes == null) continue;
          result.hours.replace(valueDes);
          break;
        case r'validTo':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.validTo = valueDes;
          break;
        case r'usesLeft':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.usesLeft = valueDes;
          break;
        case r'ended':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CustomerCodesDtoOutputCodesInnerEnded,
                    ),
                  )
                  as CustomerCodesDtoOutputCodesInnerEnded?;
          if (valueDes == null) continue;
          result.ended.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerCodesDtoOutputCodesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerCodesDtoOutputCodesInnerBuilder();
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

class CustomerCodesDtoOutputCodesInnerKindEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'percentage')
  static const CustomerCodesDtoOutputCodesInnerKindEnum percentage =
      _$customerCodesDtoOutputCodesInnerKindEnum_percentage;
  @BuiltValueEnumConst(wireName: r'fixed_amount')
  static const CustomerCodesDtoOutputCodesInnerKindEnum fixedAmount =
      _$customerCodesDtoOutputCodesInnerKindEnum_fixedAmount;
  @BuiltValueEnumConst(wireName: r'free_delivery')
  static const CustomerCodesDtoOutputCodesInnerKindEnum freeDelivery =
      _$customerCodesDtoOutputCodesInnerKindEnum_freeDelivery;

  static Serializer<CustomerCodesDtoOutputCodesInnerKindEnum> get serializer =>
      _$customerCodesDtoOutputCodesInnerKindEnumSerializer;

  const CustomerCodesDtoOutputCodesInnerKindEnum._(String name) : super(name);

  static BuiltSet<CustomerCodesDtoOutputCodesInnerKindEnum> get values =>
      _$customerCodesDtoOutputCodesInnerKindEnumValues;
  static CustomerCodesDtoOutputCodesInnerKindEnum valueOf(String name) =>
      _$customerCodesDtoOutputCodesInnerKindEnumValueOf(name);
}
