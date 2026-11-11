//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_pickup_currencies_dto_output_choices_inner.g.dart';

/// A currency the owner may switch on.
///
/// Properties:
/// * [currency]
/// * [name] - Its Arabic name.
@BuiltValue()
abstract class MerchantPickupCurrenciesDtoOutputChoicesInner
    implements
        Built<
          MerchantPickupCurrenciesDtoOutputChoicesInner,
          MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  /// Its Arabic name.
  @BuiltValueField(wireName: r'name')
  String get name;

  MerchantPickupCurrenciesDtoOutputChoicesInner._();

  factory MerchantPickupCurrenciesDtoOutputChoicesInner([
    void updates(MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder b),
  ]) = _$MerchantPickupCurrenciesDtoOutputChoicesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPickupCurrenciesDtoOutputChoicesInner>
  get serializer => _$MerchantPickupCurrenciesDtoOutputChoicesInnerSerializer();
}

class _$MerchantPickupCurrenciesDtoOutputChoicesInnerSerializer
    implements
        PrimitiveSerializer<MerchantPickupCurrenciesDtoOutputChoicesInner> {
  @override
  final Iterable<Type> types = const [
    MerchantPickupCurrenciesDtoOutputChoicesInner,
    _$MerchantPickupCurrenciesDtoOutputChoicesInner,
  ];

  @override
  final String wireName = r'MerchantPickupCurrenciesDtoOutputChoicesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPickupCurrenciesDtoOutputChoicesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPickupCurrenciesDtoOutputChoicesInner object, {
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
    required MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder result,
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
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPickupCurrenciesDtoOutputChoicesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPickupCurrenciesDtoOutputChoicesInnerBuilder();
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
