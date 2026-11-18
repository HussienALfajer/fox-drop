//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_search_dto_output_items_inner_from_price.g.dart';

/// «من {أقل سعر}» when a required group changes it.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class CustomerSearchDtoOutputItemsInnerFromPrice
    implements
        Built<
          CustomerSearchDtoOutputItemsInnerFromPrice,
          CustomerSearchDtoOutputItemsInnerFromPriceBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CustomerSearchDtoOutputItemsInnerFromPrice._();

  factory CustomerSearchDtoOutputItemsInnerFromPrice([
    void updates(CustomerSearchDtoOutputItemsInnerFromPriceBuilder b),
  ]) = _$CustomerSearchDtoOutputItemsInnerFromPrice;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerSearchDtoOutputItemsInnerFromPriceBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerSearchDtoOutputItemsInnerFromPrice>
  get serializer => _$CustomerSearchDtoOutputItemsInnerFromPriceSerializer();
}

class _$CustomerSearchDtoOutputItemsInnerFromPriceSerializer
    implements PrimitiveSerializer<CustomerSearchDtoOutputItemsInnerFromPrice> {
  @override
  final Iterable<Type> types = const [
    CustomerSearchDtoOutputItemsInnerFromPrice,
    _$CustomerSearchDtoOutputItemsInnerFromPrice,
  ];

  @override
  final String wireName = r'CustomerSearchDtoOutputItemsInnerFromPrice';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerSearchDtoOutputItemsInnerFromPrice object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerSearchDtoOutputItemsInnerFromPrice object, {
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
    required CustomerSearchDtoOutputItemsInnerFromPriceBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerSearchDtoOutputItemsInnerFromPrice deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerSearchDtoOutputItemsInnerFromPriceBuilder();
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
