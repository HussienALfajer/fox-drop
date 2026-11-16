//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_settle_dto_payout_rates_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_settle_dto_lines_inner.g.dart';

/// AdminRestaurantSettleDtoLinesInner
///
/// Properties:
/// * [currency]
/// * [amount]
/// * [base_]
/// * [rates] - The rate version of each currency but the base, as the quote gave it.
@BuiltValue()
abstract class AdminRestaurantSettleDtoLinesInner
    implements
        Built<
          AdminRestaurantSettleDtoLinesInner,
          AdminRestaurantSettleDtoLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'base')
  String get base_;

  /// The rate version of each currency but the base, as the quote gave it.
  @BuiltValueField(wireName: r'rates')
  BuiltList<AdminSettleDtoPayoutRatesInner> get rates;

  AdminRestaurantSettleDtoLinesInner._();

  factory AdminRestaurantSettleDtoLinesInner([
    void updates(AdminRestaurantSettleDtoLinesInnerBuilder b),
  ]) = _$AdminRestaurantSettleDtoLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminRestaurantSettleDtoLinesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantSettleDtoLinesInner> get serializer =>
      _$AdminRestaurantSettleDtoLinesInnerSerializer();
}

class _$AdminRestaurantSettleDtoLinesInnerSerializer
    implements PrimitiveSerializer<AdminRestaurantSettleDtoLinesInner> {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantSettleDtoLinesInner,
    _$AdminRestaurantSettleDtoLinesInner,
  ];

  @override
  final String wireName = r'AdminRestaurantSettleDtoLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantSettleDtoLinesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'base';
    yield serializers.serialize(
      object.base_,
      specifiedType: const FullType(String),
    );
    yield r'rates';
    yield serializers.serialize(
      object.rates,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSettleDtoPayoutRatesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantSettleDtoLinesInner object, {
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
    required AdminRestaurantSettleDtoLinesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'base':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.base_ = valueDes;
          break;
        case r'rates':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSettleDtoPayoutRatesInner),
                    ]),
                  )
                  as BuiltList<AdminSettleDtoPayoutRatesInner>;
          result.rates.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantSettleDtoLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantSettleDtoLinesInnerBuilder();
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
