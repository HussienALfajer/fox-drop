//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_content_dto_output_reasons_merchant_rejection_inner.g.dart';

/// MerchantContentDtoOutputReasonsMerchantRejectionInner
///
/// Properties:
/// * [code] - Stable: sent back with a choice, kept by the order.
/// * [label]
/// * [needsText] - «أخرى»: the choice needs its text, up to 200 characters.
@BuiltValue()
abstract class MerchantContentDtoOutputReasonsMerchantRejectionInner
    implements
        Built<
          MerchantContentDtoOutputReasonsMerchantRejectionInner,
          MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder
        > {
  /// Stable: sent back with a choice, kept by the order.
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  /// «أخرى»: the choice needs its text, up to 200 characters.
  @BuiltValueField(wireName: r'needsText')
  bool get needsText;

  MerchantContentDtoOutputReasonsMerchantRejectionInner._();

  factory MerchantContentDtoOutputReasonsMerchantRejectionInner([
    void updates(
      MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder b,
    ),
  ]) = _$MerchantContentDtoOutputReasonsMerchantRejectionInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get serializer =>
      _$MerchantContentDtoOutputReasonsMerchantRejectionInnerSerializer();
}

class _$MerchantContentDtoOutputReasonsMerchantRejectionInnerSerializer
    implements
        PrimitiveSerializer<
          MerchantContentDtoOutputReasonsMerchantRejectionInner
        > {
  @override
  final Iterable<Type> types = const [
    MerchantContentDtoOutputReasonsMerchantRejectionInner,
    _$MerchantContentDtoOutputReasonsMerchantRejectionInner,
  ];

  @override
  final String wireName =
      r'MerchantContentDtoOutputReasonsMerchantRejectionInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantContentDtoOutputReasonsMerchantRejectionInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
    yield r'needsText';
    yield serializers.serialize(
      object.needsText,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantContentDtoOutputReasonsMerchantRejectionInner object, {
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
    required MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder
    result,
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
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        case r'needsText':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.needsText = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantContentDtoOutputReasonsMerchantRejectionInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        MerchantContentDtoOutputReasonsMerchantRejectionInnerBuilder();
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
