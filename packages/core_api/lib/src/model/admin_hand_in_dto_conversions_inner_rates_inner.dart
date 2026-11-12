//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_hand_in_dto_conversions_inner_rates_inner.g.dart';

/// AdminHandInDtoConversionsInnerRatesInner
///
/// Properties:
/// * [currency]
/// * [rateVersionId]
@BuiltValue()
abstract class AdminHandInDtoConversionsInnerRatesInner
    implements
        Built<
          AdminHandInDtoConversionsInnerRatesInner,
          AdminHandInDtoConversionsInnerRatesInnerBuilder
        > {
  @BuiltValueField(wireName: r'currency')
  String get currency;

  @BuiltValueField(wireName: r'rateVersionId')
  String get rateVersionId;

  AdminHandInDtoConversionsInnerRatesInner._();

  factory AdminHandInDtoConversionsInnerRatesInner([
    void updates(AdminHandInDtoConversionsInnerRatesInnerBuilder b),
  ]) = _$AdminHandInDtoConversionsInnerRatesInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminHandInDtoConversionsInnerRatesInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminHandInDtoConversionsInnerRatesInner> get serializer =>
      _$AdminHandInDtoConversionsInnerRatesInnerSerializer();
}

class _$AdminHandInDtoConversionsInnerRatesInnerSerializer
    implements PrimitiveSerializer<AdminHandInDtoConversionsInnerRatesInner> {
  @override
  final Iterable<Type> types = const [
    AdminHandInDtoConversionsInnerRatesInner,
    _$AdminHandInDtoConversionsInnerRatesInner,
  ];

  @override
  final String wireName = r'AdminHandInDtoConversionsInnerRatesInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminHandInDtoConversionsInnerRatesInner object, {
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
    AdminHandInDtoConversionsInnerRatesInner object, {
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
    required AdminHandInDtoConversionsInnerRatesInnerBuilder result,
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
  AdminHandInDtoConversionsInnerRatesInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminHandInDtoConversionsInnerRatesInnerBuilder();
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
