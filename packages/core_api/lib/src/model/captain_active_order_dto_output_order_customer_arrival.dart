//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_active_order_dto_output_order_customer_arrival.g.dart';

/// Null until «وصلت» at the customer (CA §9.6).
///
/// Properties:
/// * [at]
/// * [awayReason] - The reason given away from the pin; it covers the delivery too (K4).
@BuiltValue()
abstract class CaptainActiveOrderDtoOutputOrderCustomerArrival
    implements
        Built<
          CaptainActiveOrderDtoOutputOrderCustomerArrival,
          CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// The reason given away from the pin; it covers the delivery too (K4).
  @BuiltValueField(wireName: r'awayReason')
  String? get awayReason;

  CaptainActiveOrderDtoOutputOrderCustomerArrival._();

  factory CaptainActiveOrderDtoOutputOrderCustomerArrival([
    void updates(CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder b),
  ]) = _$CaptainActiveOrderDtoOutputOrderCustomerArrival;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainActiveOrderDtoOutputOrderCustomerArrival>
  get serializer =>
      _$CaptainActiveOrderDtoOutputOrderCustomerArrivalSerializer();
}

class _$CaptainActiveOrderDtoOutputOrderCustomerArrivalSerializer
    implements
        PrimitiveSerializer<CaptainActiveOrderDtoOutputOrderCustomerArrival> {
  @override
  final Iterable<Type> types = const [
    CaptainActiveOrderDtoOutputOrderCustomerArrival,
    _$CaptainActiveOrderDtoOutputOrderCustomerArrival,
  ];

  @override
  final String wireName = r'CaptainActiveOrderDtoOutputOrderCustomerArrival';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderCustomerArrival object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'awayReason';
    yield object.awayReason == null
        ? null
        : serializers.serialize(
            object.awayReason,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainActiveOrderDtoOutputOrderCustomerArrival object, {
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
    required CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'awayReason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.awayReason = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainActiveOrderDtoOutputOrderCustomerArrival deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder();
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
