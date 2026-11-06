//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_delivery_summary_dto_output_summary_pay.g.dart';

/// The peak bonus comes with the peak windows.
///
/// Properties:
/// * [base_] - Integer minor units (AP §8.6).
/// * [distance] - Integer minor units (AP §8.6).
/// * [topUp] - «إكمال للحد الأدنى», shown when above 0.
/// * [waiting] - Integer minor units (AP §8.6).
/// * [total] - «ربحت من هذا الطلب: {الأجر}».
/// * [currency]
@BuiltValue()
abstract class CaptainDeliverySummaryDtoOutputSummaryPay
    implements
        Built<
          CaptainDeliverySummaryDtoOutputSummaryPay,
          CaptainDeliverySummaryDtoOutputSummaryPayBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'base')
  String get base_;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'distance')
  String get distance;

  /// «إكمال للحد الأدنى», shown when above 0.
  @BuiltValueField(wireName: r'topUp')
  String get topUp;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'waiting')
  String get waiting;

  /// «ربحت من هذا الطلب: {الأجر}».
  @BuiltValueField(wireName: r'total')
  String get total;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainDeliverySummaryDtoOutputSummaryPay._();

  factory CaptainDeliverySummaryDtoOutputSummaryPay([
    void updates(CaptainDeliverySummaryDtoOutputSummaryPayBuilder b),
  ]) = _$CaptainDeliverySummaryDtoOutputSummaryPay;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainDeliverySummaryDtoOutputSummaryPayBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainDeliverySummaryDtoOutputSummaryPay> get serializer =>
      _$CaptainDeliverySummaryDtoOutputSummaryPaySerializer();
}

class _$CaptainDeliverySummaryDtoOutputSummaryPaySerializer
    implements PrimitiveSerializer<CaptainDeliverySummaryDtoOutputSummaryPay> {
  @override
  final Iterable<Type> types = const [
    CaptainDeliverySummaryDtoOutputSummaryPay,
    _$CaptainDeliverySummaryDtoOutputSummaryPay,
  ];

  @override
  final String wireName = r'CaptainDeliverySummaryDtoOutputSummaryPay';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainDeliverySummaryDtoOutputSummaryPay object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'base';
    yield serializers.serialize(
      object.base_,
      specifiedType: const FullType(String),
    );
    yield r'distance';
    yield serializers.serialize(
      object.distance,
      specifiedType: const FullType(String),
    );
    yield r'topUp';
    yield serializers.serialize(
      object.topUp,
      specifiedType: const FullType(String),
    );
    yield r'waiting';
    yield serializers.serialize(
      object.waiting,
      specifiedType: const FullType(String),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(String),
    );
    yield r'currency';
    yield serializers.serialize(
      object.currency,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainDeliverySummaryDtoOutputSummaryPay object, {
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
    required CaptainDeliverySummaryDtoOutputSummaryPayBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'base':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.base_ = valueDes;
          break;
        case r'distance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.distance = valueDes;
          break;
        case r'topUp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.topUp = valueDes;
          break;
        case r'waiting':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.waiting = valueDes;
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.total = valueDes;
          break;
        case r'currency':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.currency = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainDeliverySummaryDtoOutputSummaryPay deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainDeliverySummaryDtoOutputSummaryPayBuilder();
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
