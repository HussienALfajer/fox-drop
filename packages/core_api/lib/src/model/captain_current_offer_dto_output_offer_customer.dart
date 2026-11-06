//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_current_offer_dto_output_offer_customer.g.dart';

/// Never the customer's name, phone or exact address before acceptance (C2).
///
/// Properties:
/// * [neighbourhood] 
/// * [tripMetres] - Restaurant to customer.
@BuiltValue()
abstract class CaptainCurrentOfferDtoOutputOfferCustomer implements Built<CaptainCurrentOfferDtoOutputOfferCustomer, CaptainCurrentOfferDtoOutputOfferCustomerBuilder> {
  @BuiltValueField(wireName: r'neighbourhood')
  String get neighbourhood;

  /// Restaurant to customer.
  @BuiltValueField(wireName: r'tripMetres')
  int get tripMetres;

  CaptainCurrentOfferDtoOutputOfferCustomer._();

  factory CaptainCurrentOfferDtoOutputOfferCustomer([void updates(CaptainCurrentOfferDtoOutputOfferCustomerBuilder b)]) = _$CaptainCurrentOfferDtoOutputOfferCustomer;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCurrentOfferDtoOutputOfferCustomerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCurrentOfferDtoOutputOfferCustomer> get serializer => _$CaptainCurrentOfferDtoOutputOfferCustomerSerializer();
}

class _$CaptainCurrentOfferDtoOutputOfferCustomerSerializer implements PrimitiveSerializer<CaptainCurrentOfferDtoOutputOfferCustomer> {
  @override
  final Iterable<Type> types = const [CaptainCurrentOfferDtoOutputOfferCustomer, _$CaptainCurrentOfferDtoOutputOfferCustomer];

  @override
  final String wireName = r'CaptainCurrentOfferDtoOutputOfferCustomer';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferCustomer object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'neighbourhood';
    yield serializers.serialize(
      object.neighbourhood,
      specifiedType: const FullType(String),
    );
    yield r'tripMetres';
    yield serializers.serialize(
      object.tripMetres,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCurrentOfferDtoOutputOfferCustomer object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainCurrentOfferDtoOutputOfferCustomerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'neighbourhood':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.neighbourhood = valueDes;
          break;
        case r'tripMetres':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.tripMetres = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCurrentOfferDtoOutputOfferCustomer deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCurrentOfferDtoOutputOfferCustomerBuilder();
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


