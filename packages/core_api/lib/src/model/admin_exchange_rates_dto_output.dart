//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_exchange_rates_dto_output_currencies_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_exchange_rates_dto_output.g.dart';

/// AdminExchangeRatesDtoOutput
///
/// Properties:
/// * [baseCurrency] - Null while the city has no base currency.
/// * [staleAlertHours] - fx.stale_alert_hours
/// * [largeChangePct] - fx.large_change_confirm_pct
/// * [currencies]
@BuiltValue()
abstract class AdminExchangeRatesDtoOutput
    implements
        Built<AdminExchangeRatesDtoOutput, AdminExchangeRatesDtoOutputBuilder> {
  /// Null while the city has no base currency.
  @BuiltValueField(wireName: r'baseCurrency')
  String? get baseCurrency;

  /// fx.stale_alert_hours
  @BuiltValueField(wireName: r'staleAlertHours')
  int get staleAlertHours;

  /// fx.large_change_confirm_pct
  @BuiltValueField(wireName: r'largeChangePct')
  num get largeChangePct;

  @BuiltValueField(wireName: r'currencies')
  BuiltList<AdminExchangeRatesDtoOutputCurrenciesInner> get currencies;

  AdminExchangeRatesDtoOutput._();

  factory AdminExchangeRatesDtoOutput([
    void updates(AdminExchangeRatesDtoOutputBuilder b),
  ]) = _$AdminExchangeRatesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminExchangeRatesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminExchangeRatesDtoOutput> get serializer =>
      _$AdminExchangeRatesDtoOutputSerializer();
}

class _$AdminExchangeRatesDtoOutputSerializer
    implements PrimitiveSerializer<AdminExchangeRatesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminExchangeRatesDtoOutput,
    _$AdminExchangeRatesDtoOutput,
  ];

  @override
  final String wireName = r'AdminExchangeRatesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminExchangeRatesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'baseCurrency';
    yield object.baseCurrency == null
        ? null
        : serializers.serialize(
            object.baseCurrency,
            specifiedType: const FullType.nullable(String),
          );
    yield r'staleAlertHours';
    yield serializers.serialize(
      object.staleAlertHours,
      specifiedType: const FullType(int),
    );
    yield r'largeChangePct';
    yield serializers.serialize(
      object.largeChangePct,
      specifiedType: const FullType(num),
    );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminExchangeRatesDtoOutputCurrenciesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminExchangeRatesDtoOutput object, {
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
    required AdminExchangeRatesDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'baseCurrency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.baseCurrency = valueDes;
          break;
        case r'staleAlertHours':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.staleAlertHours = valueDes;
          break;
        case r'largeChangePct':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(num))
                  as num;
          result.largeChangePct = valueDes;
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminExchangeRatesDtoOutputCurrenciesInner),
                    ]),
                  )
                  as BuiltList<AdminExchangeRatesDtoOutputCurrenciesInner>;
          result.currencies.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminExchangeRatesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminExchangeRatesDtoOutputBuilder();
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
