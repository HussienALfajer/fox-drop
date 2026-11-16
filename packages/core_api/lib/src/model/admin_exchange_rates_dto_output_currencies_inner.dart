//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_exchange_rates_dto_output_currencies_inner_rate.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_exchange_rates_dto_output_currencies_inner.g.dart';

/// AdminExchangeRatesDtoOutputCurrenciesInner
///
/// Properties:
/// * [currency]
/// * [nameAr]
/// * [symbol]
/// * [decimals]
/// * [displayOrder]
/// * [enabled]
/// * [isBase]
/// * [rate]
/// * [stale] - Enabled, with a rate older than fx.stale_alert_hours.
/// * [roundingUnitMinor] - currency.<code>.rounding_unit in minor units; null until entered.
/// * [roundingMode]
@BuiltValue()
abstract class AdminExchangeRatesDtoOutputCurrenciesInner
    implements
        Built<
          AdminExchangeRatesDtoOutputCurrenciesInner,
          AdminExchangeRatesDtoOutputCurrenciesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'nameAr')
  String get nameAr;

  @BuiltValueField(wireName: r'symbol')
  String get symbol;

  @BuiltValueField(wireName: r'decimals')
  int get decimals;

  @BuiltValueField(wireName: r'displayOrder')
  int get displayOrder;

  @BuiltValueField(wireName: r'enabled')
  bool get enabled;

  @BuiltValueField(wireName: r'isBase')
  bool get isBase;

  @BuiltValueField(wireName: r'rate')
  AdminExchangeRatesDtoOutputCurrenciesInnerRate? get rate;

  /// Enabled, with a rate older than fx.stale_alert_hours.
  @BuiltValueField(wireName: r'stale')
  bool get stale;

  /// currency.<code>.rounding_unit in minor units; null until entered.
  @BuiltValueField(wireName: r'roundingUnitMinor')
  String? get roundingUnitMinor;

  @BuiltValueField(wireName: r'roundingMode')
  AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum get roundingMode;
  // enum roundingModeEnum {  nearest,  up,  down,  };

  AdminExchangeRatesDtoOutputCurrenciesInner._();

  factory AdminExchangeRatesDtoOutputCurrenciesInner([
    void updates(AdminExchangeRatesDtoOutputCurrenciesInnerBuilder b),
  ]) = _$AdminExchangeRatesDtoOutputCurrenciesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminExchangeRatesDtoOutputCurrenciesInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminExchangeRatesDtoOutputCurrenciesInner>
  get serializer => _$AdminExchangeRatesDtoOutputCurrenciesInnerSerializer();
}

class _$AdminExchangeRatesDtoOutputCurrenciesInnerSerializer
    implements PrimitiveSerializer<AdminExchangeRatesDtoOutputCurrenciesInner> {
  @override
  final Iterable<Type> types = const [
    AdminExchangeRatesDtoOutputCurrenciesInner,
    _$AdminExchangeRatesDtoOutputCurrenciesInner,
  ];

  @override
  final String wireName = r'AdminExchangeRatesDtoOutputCurrenciesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminExchangeRatesDtoOutputCurrenciesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'nameAr';
    yield serializers.serialize(
      object.nameAr,
      specifiedType: const FullType(String),
    );
    yield r'symbol';
    yield serializers.serialize(
      object.symbol,
      specifiedType: const FullType(String),
    );
    yield r'decimals';
    yield serializers.serialize(
      object.decimals,
      specifiedType: const FullType(int),
    );
    yield r'displayOrder';
    yield serializers.serialize(
      object.displayOrder,
      specifiedType: const FullType(int),
    );
    yield r'enabled';
    yield serializers.serialize(
      object.enabled,
      specifiedType: const FullType(bool),
    );
    yield r'isBase';
    yield serializers.serialize(
      object.isBase,
      specifiedType: const FullType(bool),
    );
    yield r'rate';
    yield object.rate == null
        ? null
        : serializers.serialize(
            object.rate,
            specifiedType: const FullType.nullable(
              AdminExchangeRatesDtoOutputCurrenciesInnerRate,
            ),
          );
    yield r'stale';
    yield serializers.serialize(
      object.stale,
      specifiedType: const FullType(bool),
    );
    yield r'roundingUnitMinor';
    yield object.roundingUnitMinor == null
        ? null
        : serializers.serialize(
            object.roundingUnitMinor,
            specifiedType: const FullType.nullable(String),
          );
    yield r'roundingMode';
    yield serializers.serialize(
      object.roundingMode,
      specifiedType: const FullType(
        AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum,
      ),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminExchangeRatesDtoOutputCurrenciesInner object, {
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
    required AdminExchangeRatesDtoOutputCurrenciesInnerBuilder result,
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
        case r'nameAr':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.nameAr = valueDes;
          break;
        case r'symbol':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.symbol = valueDes;
          break;
        case r'decimals':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.decimals = valueDes;
          break;
        case r'displayOrder':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.displayOrder = valueDes;
          break;
        case r'enabled':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.enabled = valueDes;
          break;
        case r'isBase':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.isBase = valueDes;
          break;
        case r'rate':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminExchangeRatesDtoOutputCurrenciesInnerRate,
                    ),
                  )
                  as AdminExchangeRatesDtoOutputCurrenciesInnerRate?;
          if (valueDes == null) continue;
          result.rate.replace(valueDes);
          break;
        case r'stale':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.stale = valueDes;
          break;
        case r'roundingUnitMinor':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.roundingUnitMinor = valueDes;
          break;
        case r'roundingMode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum,
                    ),
                  )
                  as AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum;
          result.roundingMode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminExchangeRatesDtoOutputCurrenciesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminExchangeRatesDtoOutputCurrenciesInnerBuilder();
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

class AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'nearest')
  static const AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum
  nearest =
      _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_nearest;
  @BuiltValueEnumConst(wireName: r'up')
  static const AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum up =
      _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_up;
  @BuiltValueEnumConst(wireName: r'down')
  static const AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum down =
      _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum_down;

  static Serializer<AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum>
  get serializer =>
      _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnumSerializer;

  const AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum._(
    String name,
  ) : super(name);

  static BuiltSet<AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum>
  get values =>
      _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnumValues;
  static AdminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnum valueOf(
    String name,
  ) =>
      _$adminExchangeRatesDtoOutputCurrenciesInnerRoundingModeEnumValueOf(name);
}
