//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_content_dto_output_faq_inner.dart';
import 'package:core_api/src/model/merchant_content_dto_output_reasons.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_content_dto_output.g.dart';

/// MerchantContentDtoOutput
///
/// Properties:
/// * [reasons] 
/// * [faq] 
@BuiltValue()
abstract class MerchantContentDtoOutput implements Built<MerchantContentDtoOutput, MerchantContentDtoOutputBuilder> {
  @BuiltValueField(wireName: r'reasons')
  MerchantContentDtoOutputReasons get reasons;

  @BuiltValueField(wireName: r'faq')
  BuiltList<MerchantContentDtoOutputFaqInner> get faq;

  MerchantContentDtoOutput._();

  factory MerchantContentDtoOutput([void updates(MerchantContentDtoOutputBuilder b)]) = _$MerchantContentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantContentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantContentDtoOutput> get serializer => _$MerchantContentDtoOutputSerializer();
}

class _$MerchantContentDtoOutputSerializer implements PrimitiveSerializer<MerchantContentDtoOutput> {
  @override
  final Iterable<Type> types = const [MerchantContentDtoOutput, _$MerchantContentDtoOutput];

  @override
  final String wireName = r'MerchantContentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantContentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(MerchantContentDtoOutputReasons),
    );
    yield r'faq';
    yield serializers.serialize(
      object.faq,
      specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputFaqInner)]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantContentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantContentDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MerchantContentDtoOutputReasons),
          ) as MerchantContentDtoOutputReasons;
          result.reasons.replace(valueDes);
          break;
        case r'faq':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuiltList, [FullType(MerchantContentDtoOutputFaqInner)]),
          ) as BuiltList<MerchantContentDtoOutputFaqInner>;
          result.faq.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantContentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantContentDtoOutputBuilder();
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


