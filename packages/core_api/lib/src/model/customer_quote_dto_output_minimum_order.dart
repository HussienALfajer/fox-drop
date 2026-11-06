//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_minimum_order.g.dart';

/// CustomerQuoteDtoOutputMinimumOrder
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
/// * [reached]
/// * [missing] - «أضف {المبلغ} لتصل إلى الحد الأدنى ({الحد})».
@BuiltValue()
abstract class CustomerQuoteDtoOutputMinimumOrder
    implements
        Built<
          CustomerQuoteDtoOutputMinimumOrder,
          CustomerQuoteDtoOutputMinimumOrderBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'reached')
  bool get reached;

  /// «أضف {المبلغ} لتصل إلى الحد الأدنى ({الحد})».
  @BuiltValueField(wireName: r'missing')
  String get missing;

  CustomerQuoteDtoOutputMinimumOrder._();

  factory CustomerQuoteDtoOutputMinimumOrder([
    void updates(CustomerQuoteDtoOutputMinimumOrderBuilder b),
  ]) = _$CustomerQuoteDtoOutputMinimumOrder;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputMinimumOrderBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputMinimumOrder> get serializer =>
      _$CustomerQuoteDtoOutputMinimumOrderSerializer();
}

class _$CustomerQuoteDtoOutputMinimumOrderSerializer
    implements PrimitiveSerializer<CustomerQuoteDtoOutputMinimumOrder> {
  @override
  final Iterable<Type> types = const [
    CustomerQuoteDtoOutputMinimumOrder,
    _$CustomerQuoteDtoOutputMinimumOrder,
  ];

  @override
  final String wireName = r'CustomerQuoteDtoOutputMinimumOrder';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputMinimumOrder object, {
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
    yield r'reached';
    yield serializers.serialize(
      object.reached,
      specifiedType: const FullType(bool),
    );
    yield r'missing';
    yield serializers.serialize(
      object.missing,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputMinimumOrder object, {
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
    required CustomerQuoteDtoOutputMinimumOrderBuilder result,
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
        case r'reached':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.reached = valueDes;
          break;
        case r'missing':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.missing = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputMinimumOrder deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputMinimumOrderBuilder();
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
