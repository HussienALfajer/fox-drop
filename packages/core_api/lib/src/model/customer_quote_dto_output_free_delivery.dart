//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_free_delivery.g.dart';

/// CustomerQuoteDtoOutputFreeDelivery
///
/// Properties:
/// * [threshold] - Integer minor units (AP §8.6).
/// * [reached] - «توصيلك مجاني».
/// * [missing] - «أضف {المبلغ} لتحصل على توصيل مجاني».
@BuiltValue()
abstract class CustomerQuoteDtoOutputFreeDelivery
    implements
        Built<
          CustomerQuoteDtoOutputFreeDelivery,
          CustomerQuoteDtoOutputFreeDeliveryBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'threshold')
  String get threshold;

  /// «توصيلك مجاني».
  @BuiltValueField(wireName: r'reached')
  bool get reached;

  /// «أضف {المبلغ} لتحصل على توصيل مجاني».
  @BuiltValueField(wireName: r'missing')
  String get missing;

  CustomerQuoteDtoOutputFreeDelivery._();

  factory CustomerQuoteDtoOutputFreeDelivery([
    void updates(CustomerQuoteDtoOutputFreeDeliveryBuilder b),
  ]) = _$CustomerQuoteDtoOutputFreeDelivery;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputFreeDeliveryBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputFreeDelivery> get serializer =>
      _$CustomerQuoteDtoOutputFreeDeliverySerializer();
}

class _$CustomerQuoteDtoOutputFreeDeliverySerializer
    implements PrimitiveSerializer<CustomerQuoteDtoOutputFreeDelivery> {
  @override
  final Iterable<Type> types = const [
    CustomerQuoteDtoOutputFreeDelivery,
    _$CustomerQuoteDtoOutputFreeDelivery,
  ];

  @override
  final String wireName = r'CustomerQuoteDtoOutputFreeDelivery';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputFreeDelivery object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'threshold';
    yield serializers.serialize(
      object.threshold,
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
    CustomerQuoteDtoOutputFreeDelivery object, {
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
    required CustomerQuoteDtoOutputFreeDeliveryBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'threshold':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.threshold = valueDes;
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
  CustomerQuoteDtoOutputFreeDelivery deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputFreeDeliveryBuilder();
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
