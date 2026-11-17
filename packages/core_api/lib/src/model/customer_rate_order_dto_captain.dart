//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_rate_order_dto_captain.g.dart';

/// «قيّم الكابتن», or null to skip it.
///
/// Properties:
/// * [stars]
/// * [reasons] - Codes of Content's list for the stars: restaurant_rating_low (1–2), _mid (3), _high (4–5), or captain_rating_* for the captain.
/// * [comment] - Up to 300 characters; null without one.
@BuiltValue()
abstract class CustomerRateOrderDtoCaptain
    implements
        Built<CustomerRateOrderDtoCaptain, CustomerRateOrderDtoCaptainBuilder> {
  @BuiltValueField(wireName: r'stars')
  int get stars;

  /// Codes of Content's list for the stars: restaurant_rating_low (1–2), _mid (3), _high (4–5), or captain_rating_* for the captain.
  @BuiltValueField(wireName: r'reasons')
  BuiltList<String> get reasons;

  /// Up to 300 characters; null without one.
  @BuiltValueField(wireName: r'comment')
  String? get comment;

  CustomerRateOrderDtoCaptain._();

  factory CustomerRateOrderDtoCaptain([
    void updates(CustomerRateOrderDtoCaptainBuilder b),
  ]) = _$CustomerRateOrderDtoCaptain;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CustomerRateOrderDtoCaptainBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerRateOrderDtoCaptain> get serializer =>
      _$CustomerRateOrderDtoCaptainSerializer();
}

class _$CustomerRateOrderDtoCaptainSerializer
    implements PrimitiveSerializer<CustomerRateOrderDtoCaptain> {
  @override
  final Iterable<Type> types = const [
    CustomerRateOrderDtoCaptain,
    _$CustomerRateOrderDtoCaptain,
  ];

  @override
  final String wireName = r'CustomerRateOrderDtoCaptain';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerRateOrderDtoCaptain object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'stars';
    yield serializers.serialize(
      object.stars,
      specifiedType: const FullType(int),
    );
    yield r'reasons';
    yield serializers.serialize(
      object.reasons,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'comment';
    yield object.comment == null
        ? null
        : serializers.serialize(
            object.comment,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerRateOrderDtoCaptain object, {
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
    required CustomerRateOrderDtoCaptainBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'stars':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.stars = valueDes;
          break;
        case r'reasons':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.reasons.replace(valueDes);
          break;
        case r'comment':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.comment = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerRateOrderDtoCaptain deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerRateOrderDtoCaptainBuilder();
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
