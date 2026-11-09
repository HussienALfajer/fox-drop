//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_content_dto_output_faq_inner.dart';
import 'package:core_api/src/model/customer_content_dto_output_reasons.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_content_dto_output.g.dart';

/// CustomerContentDtoOutput
///
/// Properties:
/// * [reasons] 
/// * [faq] 
@BuiltValue()
abstract class CustomerContentDtoOutput implements Built<CustomerContentDtoOutput, CustomerContentDtoOutputBuilder> {
  @BuiltValueField(wireName: r'reasons')
  CustomerContentDtoOutputReasons get reasons;

  @BuiltValueField(wireName: r'faq')
  BuiltList<MerchantContentDtoOutputFaqInner> get faq;

  CustomerContentDtoOutput._();

  factory CustomerContentDtoOutput([void updates(CustomerContentDtoOutputBuilder b)]) = _$CustomerContentDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerContentDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerContentDtoOutput> get serializer => _$CustomerContentDtoOutputSerializer();
}

class _$CustomerContentDtoOutputSerializer implements PrimitiveSerializer<CustomerContentDtoOutput> {
  @override
  final Iterable<Type> types = const [CustomerContentDtoOutput, _$CustomerContentDtoOutput];

  @override
  final String wireName = r'CustomerContentDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerContentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(CustomerContentDtoOutputReasons),
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
    CustomerContentDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerContentDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reasons':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(CustomerContentDtoOutputReasons),
          ) as CustomerContentDtoOutputReasons;
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
  CustomerContentDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerContentDtoOutputBuilder();
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


