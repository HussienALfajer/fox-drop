//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_quote_dto_output_estimate.g.dart';

/// «يصل خلال {fromMin}–{toMin} د».
///
/// Properties:
/// * [fromMin] 
/// * [toMin] 
@BuiltValue()
abstract class CustomerQuoteDtoOutputEstimate implements Built<CustomerQuoteDtoOutputEstimate, CustomerQuoteDtoOutputEstimateBuilder> {
  @BuiltValueField(wireName: r'fromMin')
  int get fromMin;

  @BuiltValueField(wireName: r'toMin')
  int get toMin;

  CustomerQuoteDtoOutputEstimate._();

  factory CustomerQuoteDtoOutputEstimate([void updates(CustomerQuoteDtoOutputEstimateBuilder b)]) = _$CustomerQuoteDtoOutputEstimate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerQuoteDtoOutputEstimateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerQuoteDtoOutputEstimate> get serializer => _$CustomerQuoteDtoOutputEstimateSerializer();
}

class _$CustomerQuoteDtoOutputEstimateSerializer implements PrimitiveSerializer<CustomerQuoteDtoOutputEstimate> {
  @override
  final Iterable<Type> types = const [CustomerQuoteDtoOutputEstimate, _$CustomerQuoteDtoOutputEstimate];

  @override
  final String wireName = r'CustomerQuoteDtoOutputEstimate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerQuoteDtoOutputEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'fromMin';
    yield serializers.serialize(
      object.fromMin,
      specifiedType: const FullType(int),
    );
    yield r'toMin';
    yield serializers.serialize(
      object.toMin,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerQuoteDtoOutputEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerQuoteDtoOutputEstimateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'fromMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.fromMin = valueDes;
          break;
        case r'toMin':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.toMin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerQuoteDtoOutputEstimate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerQuoteDtoOutputEstimateBuilder();
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


