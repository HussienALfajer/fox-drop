//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_rates_inner.g.dart';

/// CustomerQuoteDtoOutputRatesInner
///
/// Properties:
/// * [currency] 
/// * [rateVersionId] 
@BuiltValue()
abstract class CustomerQuoteDtoOutputRatesInner implements Built<CustomerQuoteDtoOutputRatesInner, CustomerQuoteDtoOutputRatesInnerBuilder> {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'rateVersionId')
  String? get rateVersionId;

  CustomerQuoteDtoOutputRatesInner._();

  factory CustomerQuoteDtoOutputRatesInner([void updates(CustomerQuoteDtoOutputRatesInnerBuilder b)]) = _$CustomerQuoteDtoOutputRatesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputRatesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputRatesInner> get serializer => _$CustomerQuoteDtoOutputRatesInnerSerializer();
}

class _$CustomerQuoteDtoOutputRatesInnerSerializer implements PrimitiveSerializer<CustomerQuoteDtoOutputRatesInner> {
  @override
  final Iterable<Type> types = const [CustomerQuoteDtoOutputRatesInner, _$CustomerQuoteDtoOutputRatesInner];

  @override
  final String wireName = r'CustomerQuoteDtoOutputRatesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputRatesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'rateVersionId';
    yield object.rateVersionId == null ? null : serializers.serialize(
      object.rateVersionId,
      specifiedType: const FullType.nullable(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputRatesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerQuoteDtoOutputRatesInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.currency = valueDes;
          break;
        case r'rateVersionId':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rateVersionId = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputRatesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputRatesInnerBuilder();
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


