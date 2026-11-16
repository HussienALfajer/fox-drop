//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_settlement_preview_dto_output_payout_unit.dart';
import 'package:core_api/src/model/admin_settlement_preview_dto_output_payout_rates_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_restaurant_settlement_preview_dto_output_lines_inner.g.dart';

/// AdminRestaurantSettlementPreviewDtoOutputLinesInner
///
/// Properties:
/// * [currency]
/// * [amount]
/// * [base_] - The value in the base at the current rate.
/// * [rates] - The rate version of each currency but the base, as the quote gave it.
/// * [unit]
@BuiltValue()
abstract class AdminRestaurantSettlementPreviewDtoOutputLinesInner
    implements
        Built<
          AdminRestaurantSettlementPreviewDtoOutputLinesInner,
          AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// The value in the base at the current rate.
  @BuiltValueField(wireName: r'base')
  String get base_;

  /// The rate version of each currency but the base, as the quote gave it.
  @BuiltValueField(wireName: r'rates')
  BuiltList<AdminSettlementPreviewDtoOutputPayoutRatesInner> get rates;

  @BuiltValueField(wireName: r'unit')
  AdminSettlementPreviewDtoOutputPayoutUnit? get unit;

  AdminRestaurantSettlementPreviewDtoOutputLinesInner._();

  factory AdminRestaurantSettlementPreviewDtoOutputLinesInner([
    void updates(AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder b),
  ]) = _$AdminRestaurantSettlementPreviewDtoOutputLinesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminRestaurantSettlementPreviewDtoOutputLinesInner>
  get serializer =>
      _$AdminRestaurantSettlementPreviewDtoOutputLinesInnerSerializer();
}

class _$AdminRestaurantSettlementPreviewDtoOutputLinesInnerSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantSettlementPreviewDtoOutputLinesInner
        > {
  @override
  final Iterable<Type> types = const [
    AdminRestaurantSettlementPreviewDtoOutputLinesInner,
    _$AdminRestaurantSettlementPreviewDtoOutputLinesInner,
  ];

  @override
  final String wireName =
      r'AdminRestaurantSettlementPreviewDtoOutputLinesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminRestaurantSettlementPreviewDtoOutputLinesInner object, {
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
        FullType(AdminSettlementPreviewDtoOutputPayoutRatesInner),
      ]),
    );
    yield r'unit';
    yield object.unit == null
        ? null
        : serializers.serialize(
            object.unit,
            specifiedType: const FullType.nullable(
              AdminSettlementPreviewDtoOutputPayoutUnit,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantSettlementPreviewDtoOutputLinesInner object, {
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
    required AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder result,
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
                      FullType(AdminSettlementPreviewDtoOutputPayoutRatesInner),
                    ]),
                  )
                  as BuiltList<AdminSettlementPreviewDtoOutputPayoutRatesInner>;
          result.rates.replace(valueDes);
          break;
        case r'unit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminSettlementPreviewDtoOutputPayoutUnit,
                    ),
                  )
                  as AdminSettlementPreviewDtoOutputPayoutUnit?;
          if (valueDes == null) continue;
          result.unit.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminRestaurantSettlementPreviewDtoOutputLinesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminRestaurantSettlementPreviewDtoOutputLinesInnerBuilder();
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
