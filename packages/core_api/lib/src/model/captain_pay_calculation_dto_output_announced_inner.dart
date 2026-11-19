//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_pay_money_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_pay_calculation_dto_output_announced_inner.g.dart';

/// CaptainPayCalculationDtoOutputAnnouncedInner
///
/// Properties:
/// * [base_]
/// * [distance]
/// * [topUp]
/// * [orderPay]
/// * [waiting]
/// * [total]
/// * [effectiveFrom]
@BuiltValue()
abstract class CaptainPayCalculationDtoOutputAnnouncedInner
    implements
        Built<
          CaptainPayCalculationDtoOutputAnnouncedInner,
          CaptainPayCalculationDtoOutputAnnouncedInnerBuilder
        > {
  @BuiltValueField(wireName: r'base')
  CaptainPayMoneyOutput get base_;

  @BuiltValueField(wireName: r'distance')
  CaptainPayMoneyOutput get distance;

  @BuiltValueField(wireName: r'topUp')
  CaptainPayMoneyOutput get topUp;

  @BuiltValueField(wireName: r'orderPay')
  CaptainPayMoneyOutput get orderPay;

  @BuiltValueField(wireName: r'waiting')
  CaptainPayMoneyOutput get waiting;

  @BuiltValueField(wireName: r'total')
  CaptainPayMoneyOutput get total;

  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  CaptainPayCalculationDtoOutputAnnouncedInner._();

  factory CaptainPayCalculationDtoOutputAnnouncedInner([
    void updates(CaptainPayCalculationDtoOutputAnnouncedInnerBuilder b),
  ]) = _$CaptainPayCalculationDtoOutputAnnouncedInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainPayCalculationDtoOutputAnnouncedInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPayCalculationDtoOutputAnnouncedInner>
  get serializer => _$CaptainPayCalculationDtoOutputAnnouncedInnerSerializer();
}

class _$CaptainPayCalculationDtoOutputAnnouncedInnerSerializer
    implements
        PrimitiveSerializer<CaptainPayCalculationDtoOutputAnnouncedInner> {
  @override
  final Iterable<Type> types = const [
    CaptainPayCalculationDtoOutputAnnouncedInner,
    _$CaptainPayCalculationDtoOutputAnnouncedInner,
  ];

  @override
  final String wireName = r'CaptainPayCalculationDtoOutputAnnouncedInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPayCalculationDtoOutputAnnouncedInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'base';
    yield serializers.serialize(
      object.base_,
      specifiedType: const FullType(CaptainPayMoneyOutput),
    );
    yield r'distance';
    yield serializers.serialize(
      object.distance,
      specifiedType: const FullType(CaptainPayMoneyOutput),
    );
    yield r'topUp';
    yield serializers.serialize(
      object.topUp,
      specifiedType: const FullType(CaptainPayMoneyOutput),
    );
    yield r'orderPay';
    yield serializers.serialize(
      object.orderPay,
      specifiedType: const FullType(CaptainPayMoneyOutput),
    );
    yield r'waiting';
    yield serializers.serialize(
      object.waiting,
      specifiedType: const FullType(CaptainPayMoneyOutput),
    );
    yield r'total';
    yield serializers.serialize(
      object.total,
      specifiedType: const FullType(CaptainPayMoneyOutput),
    );
    yield r'effectiveFrom';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPayCalculationDtoOutputAnnouncedInner object, {
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
    required CaptainPayCalculationDtoOutputAnnouncedInnerBuilder result,
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
                    specifiedType: const FullType(CaptainPayMoneyOutput),
                  )
                  as CaptainPayMoneyOutput;
          result.base_.replace(valueDes);
          break;
        case r'distance':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainPayMoneyOutput),
                  )
                  as CaptainPayMoneyOutput;
          result.distance.replace(valueDes);
          break;
        case r'topUp':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainPayMoneyOutput),
                  )
                  as CaptainPayMoneyOutput;
          result.topUp.replace(valueDes);
          break;
        case r'orderPay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainPayMoneyOutput),
                  )
                  as CaptainPayMoneyOutput;
          result.orderPay.replace(valueDes);
          break;
        case r'waiting':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainPayMoneyOutput),
                  )
                  as CaptainPayMoneyOutput;
          result.waiting.replace(valueDes);
          break;
        case r'total':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainPayMoneyOutput),
                  )
                  as CaptainPayMoneyOutput;
          result.total.replace(valueDes);
          break;
        case r'effectiveFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.effectiveFrom = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPayCalculationDtoOutputAnnouncedInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPayCalculationDtoOutputAnnouncedInnerBuilder();
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
