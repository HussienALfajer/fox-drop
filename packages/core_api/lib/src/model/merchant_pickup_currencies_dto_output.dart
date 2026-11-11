//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_pickup_currencies_dto_output_base_currency.dart';
import 'package:core_api/src/model/merchant_pickup_currencies_dto_output_choices_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_pickup_currencies_dto_output.g.dart';

/// MerchantPickupCurrenciesDtoOutput
///
/// Properties:
/// * [baseCurrency]
/// * [accepted] - The other currencies switched on, in the city’s display order.
/// * [choices] - Every other currency the city has enabled, in its display order.
@BuiltValue()
abstract class MerchantPickupCurrenciesDtoOutput
    implements
        Built<
          MerchantPickupCurrenciesDtoOutput,
          MerchantPickupCurrenciesDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'baseCurrency')
  MerchantPickupCurrenciesDtoOutputBaseCurrency? get baseCurrency;

  /// The other currencies switched on, in the city’s display order.
  @BuiltValueField(wireName: r'accepted')
  BuiltList<String> get accepted;

  /// Every other currency the city has enabled, in its display order.
  @BuiltValueField(wireName: r'choices')
  BuiltList<MerchantPickupCurrenciesDtoOutputChoicesInner> get choices;

  MerchantPickupCurrenciesDtoOutput._();

  factory MerchantPickupCurrenciesDtoOutput([
    void updates(MerchantPickupCurrenciesDtoOutputBuilder b),
  ]) = _$MerchantPickupCurrenciesDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPickupCurrenciesDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPickupCurrenciesDtoOutput> get serializer =>
      _$MerchantPickupCurrenciesDtoOutputSerializer();
}

class _$MerchantPickupCurrenciesDtoOutputSerializer
    implements PrimitiveSerializer<MerchantPickupCurrenciesDtoOutput> {
  @override
  final Iterable<Type> types = const [
    MerchantPickupCurrenciesDtoOutput,
    _$MerchantPickupCurrenciesDtoOutput,
  ];

  @override
  final String wireName = r'MerchantPickupCurrenciesDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPickupCurrenciesDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'baseCurrency';
    yield object.baseCurrency == null
        ? null
        : serializers.serialize(
            object.baseCurrency,
            specifiedType: const FullType.nullable(
              MerchantPickupCurrenciesDtoOutputBaseCurrency,
            ),
          );
    yield r'accepted';
    yield serializers.serialize(
      object.accepted,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'choices';
    yield serializers.serialize(
      object.choices,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantPickupCurrenciesDtoOutputChoicesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPickupCurrenciesDtoOutput object, {
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
    required MerchantPickupCurrenciesDtoOutputBuilder result,
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
                    specifiedType: const FullType.nullable(
                      MerchantPickupCurrenciesDtoOutputBaseCurrency,
                    ),
                  )
                  as MerchantPickupCurrenciesDtoOutputBaseCurrency?;
          if (valueDes == null) continue;
          result.baseCurrency.replace(valueDes);
          break;
        case r'accepted':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.accepted.replace(valueDes);
          break;
        case r'choices':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantPickupCurrenciesDtoOutputChoicesInner),
                    ]),
                  )
                  as BuiltList<MerchantPickupCurrenciesDtoOutputChoicesInner>;
          result.choices.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPickupCurrenciesDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPickupCurrenciesDtoOutputBuilder();
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
