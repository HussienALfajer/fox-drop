//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_customer.g.dart';

/// Never the phone number, the last name or the full address (RA §8.4).
///
/// Properties:
/// * [firstName] - Null while the customer has not completed the account (CU §5.3).
/// * [neighbourhood] 
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerCustomer implements Built<MerchantOrdersDtoOutputOrdersInnerCustomer, MerchantOrdersDtoOutputOrdersInnerCustomerBuilder> {
  /// Null while the customer has not completed the account (CU §5.3).
  @BuiltValueField(wireName: r'firstName')
  String? get firstName;

  @BuiltValueField(wireName: r'neighbourhood')
  String get neighbourhood;

  MerchantOrdersDtoOutputOrdersInnerCustomer._();

  factory MerchantOrdersDtoOutputOrdersInnerCustomer([void updates(MerchantOrdersDtoOutputOrdersInnerCustomerBuilder b)]) = _$MerchantOrdersDtoOutputOrdersInnerCustomer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantOrdersDtoOutputOrdersInnerCustomerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerCustomer> get serializer => _$MerchantOrdersDtoOutputOrdersInnerCustomerSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerCustomerSerializer implements PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerCustomer> {
  @override
  final Iterable<Type> types = const [MerchantOrdersDtoOutputOrdersInnerCustomer, _$MerchantOrdersDtoOutputOrdersInnerCustomer];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerCustomer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerCustomer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'firstName';
    yield object.firstName == null ? null : serializers.serialize(
      object.firstName,
      specifiedType: const FullType.nullable(String),
    );
    yield r'neighbourhood';
    yield serializers.serialize(
      object.neighbourhood,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerCustomer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MerchantOrdersDtoOutputOrdersInnerCustomerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'firstName':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.firstName = valueDes;
          break;
        case r'neighbourhood':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.neighbourhood = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerCustomer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerCustomerBuilder();
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


