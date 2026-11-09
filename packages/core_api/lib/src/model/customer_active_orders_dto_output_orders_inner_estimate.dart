//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_estimate.g.dart';

/// The range shown while placed (CU §11.1).
///
/// Properties:
/// * [fromMin] 
/// * [toMin] 
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerEstimate implements Built<CustomerActiveOrdersDtoOutputOrdersInnerEstimate, CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder> {
  @BuiltValueField(wireName: r'fromMin')
  int get fromMin;

  @BuiltValueField(wireName: r'toMin')
  int get toMin;

  CustomerActiveOrdersDtoOutputOrdersInnerEstimate._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerEstimate([void updates(CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder b)]) = _$CustomerActiveOrdersDtoOutputOrdersInnerEstimate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerEstimate> get serializer => _$CustomerActiveOrdersDtoOutputOrdersInnerEstimateSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerEstimateSerializer implements PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInnerEstimate> {
  @override
  final Iterable<Type> types = const [CustomerActiveOrdersDtoOutputOrdersInnerEstimate, _$CustomerActiveOrdersDtoOutputOrdersInnerEstimate];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerEstimate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerEstimate object, {
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
    CustomerActiveOrdersDtoOutputOrdersInnerEstimate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder result,
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
  CustomerActiveOrdersDtoOutputOrdersInnerEstimate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerEstimateBuilder();
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


