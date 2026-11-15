//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_settle_dto_payout_rates_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settle_dto_payout.g.dart';

/// The preview's payout, null when the balance is not above zero.
///
/// Properties:
/// * [currency]
/// * [amount]
/// * [rates] - The rate version of each currency but the base, as the preview gave them.
@BuiltValue()
abstract class AdminSettleDtoPayout
    implements Built<AdminSettleDtoPayout, AdminSettleDtoPayoutBuilder> {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  /// The rate version of each currency but the base, as the preview gave them.
  @BuiltValueField(wireName: r'rates')
  BuiltList<AdminSettleDtoPayoutRatesInner> get rates;

  AdminSettleDtoPayout._();

  factory AdminSettleDtoPayout([void updates(AdminSettleDtoPayoutBuilder b)]) =
      _$AdminSettleDtoPayout;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettleDtoPayoutBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettleDtoPayout> get serializer =>
      _$AdminSettleDtoPayoutSerializer();
}

class _$AdminSettleDtoPayoutSerializer
    implements PrimitiveSerializer<AdminSettleDtoPayout> {
  @override
  final Iterable<Type> types = const [
    AdminSettleDtoPayout,
    _$AdminSettleDtoPayout,
  ];

  @override
  final String wireName = r'AdminSettleDtoPayout';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettleDtoPayout object, {
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
    AdminSettleDtoPayout object, {
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
    required AdminSettleDtoPayoutBuilder result,
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
  AdminSettleDtoPayout deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettleDtoPayoutBuilder();
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
