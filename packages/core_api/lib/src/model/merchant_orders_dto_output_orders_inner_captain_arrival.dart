//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_captain_arrival.g.dart';

/// Null until the captain arrives (RA §8.9).
///
/// Properties:
/// * [at] - «وصل الكابتن {الاسم} لاستلام الطلب #{رقم}»; the waiting timer counts from it.
/// * [waitingAlertAt] - Not picked up by then: every device chimes «الكابتن ينتظر الطلب #{رقم} منذ {د} دقائق» (RA §8.9).
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerCaptainArrival
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInnerCaptainArrival,
          MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder
        > {
  /// «وصل الكابتن {الاسم} لاستلام الطلب #{رقم}»; the waiting timer counts from it.
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  /// Not picked up by then: every device chimes «الكابتن ينتظر الطلب #{رقم} منذ {د} دقائق» (RA §8.9).
  @BuiltValueField(wireName: r'waitingAlertAt')
  DateTime get waitingAlertAt;

  MerchantOrdersDtoOutputOrdersInnerCaptainArrival._();

  factory MerchantOrdersDtoOutputOrdersInnerCaptainArrival([
    void updates(MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder b),
  ]) = _$MerchantOrdersDtoOutputOrdersInnerCaptainArrival;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerCaptainArrival>
  get serializer =>
      _$MerchantOrdersDtoOutputOrdersInnerCaptainArrivalSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerCaptainArrivalSerializer
    implements
        PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerCaptainArrival> {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInnerCaptainArrival,
    _$MerchantOrdersDtoOutputOrdersInnerCaptainArrival,
  ];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerCaptainArrival';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerCaptainArrival object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'waitingAlertAt';
    yield serializers.serialize(
      object.waitingAlertAt,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerCaptainArrival object, {
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
    required MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder result,
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
        case r'waitingAlertAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.waitingAlertAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerCaptainArrival deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder();
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
