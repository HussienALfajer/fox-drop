//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_set_pickup_currencies_dto.g.dart';

/// MerchantSetPickupCurrenciesDto
///
/// Properties:
/// * [currencies] - The other currencies to accept besides the base; empty for the base only.
@BuiltValue()
abstract class MerchantSetPickupCurrenciesDto
    implements
        Built<
          MerchantSetPickupCurrenciesDto,
          MerchantSetPickupCurrenciesDtoBuilder
        > {
  /// The other currencies to accept besides the base; empty for the base only.
  @BuiltValueField(wireName: r'currencies')
  BuiltList<String> get currencies;

  MerchantSetPickupCurrenciesDto._();

  factory MerchantSetPickupCurrenciesDto([
    void updates(MerchantSetPickupCurrenciesDtoBuilder b),
  ]) = _$MerchantSetPickupCurrenciesDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantSetPickupCurrenciesDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantSetPickupCurrenciesDto> get serializer =>
      _$MerchantSetPickupCurrenciesDtoSerializer();
}

class _$MerchantSetPickupCurrenciesDtoSerializer
    implements PrimitiveSerializer<MerchantSetPickupCurrenciesDto> {
  @override
  final Iterable<Type> types = const [
    MerchantSetPickupCurrenciesDto,
    _$MerchantSetPickupCurrenciesDto,
  ];

  @override
  final String wireName = r'MerchantSetPickupCurrenciesDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantSetPickupCurrenciesDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantSetPickupCurrenciesDto object, {
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
    required MerchantSetPickupCurrenciesDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
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
  MerchantSetPickupCurrenciesDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantSetPickupCurrenciesDtoBuilder();
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
