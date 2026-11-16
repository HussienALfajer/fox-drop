//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_suggested_code.g.dart';

/// «لديك كود يوفر عليك {المبلغ}: {الكود}» with «تطبيق» (Q19): the largest discount above the applied code; never applied by itself (U11).
///
/// Properties:
/// * [code]
/// * [discount] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class CustomerQuoteDtoOutputSuggestedCode
    implements
        Built<
          CustomerQuoteDtoOutputSuggestedCode,
          CustomerQuoteDtoOutputSuggestedCodeBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'discount')
  String get discount;

  CustomerQuoteDtoOutputSuggestedCode._();

  factory CustomerQuoteDtoOutputSuggestedCode([
    void updates(CustomerQuoteDtoOutputSuggestedCodeBuilder b),
  ]) = _$CustomerQuoteDtoOutputSuggestedCode;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputSuggestedCodeBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputSuggestedCode> get serializer =>
      _$CustomerQuoteDtoOutputSuggestedCodeSerializer();
}

class _$CustomerQuoteDtoOutputSuggestedCodeSerializer
    implements PrimitiveSerializer<CustomerQuoteDtoOutputSuggestedCode> {
  @override
  final Iterable<Type> types = const [
    CustomerQuoteDtoOutputSuggestedCode,
    _$CustomerQuoteDtoOutputSuggestedCode,
  ];

  @override
  final String wireName = r'CustomerQuoteDtoOutputSuggestedCode';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputSuggestedCode object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'discount';
    yield serializers.serialize(
      object.discount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputSuggestedCode object, {
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
    required CustomerQuoteDtoOutputSuggestedCodeBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'discount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.discount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputSuggestedCode deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputSuggestedCodeBuilder();
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
