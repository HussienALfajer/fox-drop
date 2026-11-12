//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_conversion_quote_dto_output_rates_inner.g.dart';

/// AdminConversionQuoteDtoOutputRatesInner
///
/// Properties:
/// * [currency]
/// * [rateVersionId]
@BuiltValue()
abstract class AdminConversionQuoteDtoOutputRatesInner
    implements
        Built<
          AdminConversionQuoteDtoOutputRatesInner,
          AdminConversionQuoteDtoOutputRatesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'rateVersionId')
  String get rateVersionId;

  AdminConversionQuoteDtoOutputRatesInner._();

  factory AdminConversionQuoteDtoOutputRatesInner([
    void updates(AdminConversionQuoteDtoOutputRatesInnerBuilder b),
  ]) = _$AdminConversionQuoteDtoOutputRatesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminConversionQuoteDtoOutputRatesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminConversionQuoteDtoOutputRatesInner> get serializer =>
      _$AdminConversionQuoteDtoOutputRatesInnerSerializer();
}

class _$AdminConversionQuoteDtoOutputRatesInnerSerializer
    implements PrimitiveSerializer<AdminConversionQuoteDtoOutputRatesInner> {
  @override
  final Iterable<Type> types = const [
    AdminConversionQuoteDtoOutputRatesInner,
    _$AdminConversionQuoteDtoOutputRatesInner,
  ];

  @override
  final String wireName = r'AdminConversionQuoteDtoOutputRatesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminConversionQuoteDtoOutputRatesInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
    yield r'rateVersionId';
    yield serializers.serialize(
      object.rateVersionId,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminConversionQuoteDtoOutputRatesInner object, {
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
    required AdminConversionQuoteDtoOutputRatesInnerBuilder result,
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
        case r'rateVersionId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
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
  AdminConversionQuoteDtoOutputRatesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminConversionQuoteDtoOutputRatesInnerBuilder();
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
