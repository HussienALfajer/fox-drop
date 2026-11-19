//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_pay_money_output.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_pay_table_dto_output_announced_inner.g.dart';

/// CaptainPayTableDtoOutputAnnouncedInner
///
/// Properties:
/// * [effectiveFrom]
/// * [basePay]
/// * [includedMetres] - The distance the base pay includes.
/// * [perExtraKm]
/// * [waitingPerMinute]
/// * [minimumPay]
@BuiltValue()
abstract class CaptainPayTableDtoOutputAnnouncedInner
    implements
        Built<
          CaptainPayTableDtoOutputAnnouncedInner,
          CaptainPayTableDtoOutputAnnouncedInnerBuilder
        > {
  @BuiltValueField(wireName: r'effectiveFrom')
  DateTime get effectiveFrom;

  @BuiltValueField(wireName: r'basePay')
  CaptainPayMoneyOutput get basePay;

  /// The distance the base pay includes.
  @BuiltValueField(wireName: r'includedMetres')
  int get includedMetres;

  @BuiltValueField(wireName: r'perExtraKm')
  CaptainPayMoneyOutput get perExtraKm;

  @BuiltValueField(wireName: r'waitingPerMinute')
  CaptainPayMoneyOutput get waitingPerMinute;

  @BuiltValueField(wireName: r'minimumPay')
  CaptainPayMoneyOutput get minimumPay;

  CaptainPayTableDtoOutputAnnouncedInner._();

  factory CaptainPayTableDtoOutputAnnouncedInner([
    void updates(CaptainPayTableDtoOutputAnnouncedInnerBuilder b),
  ]) = _$CaptainPayTableDtoOutputAnnouncedInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPayTableDtoOutputAnnouncedInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPayTableDtoOutputAnnouncedInner> get serializer =>
      _$CaptainPayTableDtoOutputAnnouncedInnerSerializer();
}

class _$CaptainPayTableDtoOutputAnnouncedInnerSerializer
    implements PrimitiveSerializer<CaptainPayTableDtoOutputAnnouncedInner> {
  @override
  final Iterable<Type> types = const [
    CaptainPayTableDtoOutputAnnouncedInner,
    _$CaptainPayTableDtoOutputAnnouncedInner,
  ];

  @override
  final String wireName = r'CaptainPayTableDtoOutputAnnouncedInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPayTableDtoOutputAnnouncedInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'effectiveFrom';
    yield serializers.serialize(
      object.effectiveFrom,
      specifiedType: const FullType(DateTime),
    );
    yield r'basePay';
    yield serializers.serialize(
      object.basePay,
      specifiedType: const FullType(CaptainPayMoneyOutput),
    );
    yield r'includedMetres';
    yield serializers.serialize(
      object.includedMetres,
      specifiedType: const FullType(int),
    );
    yield r'perExtraKm';
    yield serializers.serialize(
      object.perExtraKm,
      specifiedType: const FullType(CaptainPayMoneyOutput),
    );
    yield r'waitingPerMinute';
    yield serializers.serialize(
      object.waitingPerMinute,
      specifiedType: const FullType(CaptainPayMoneyOutput),
    );
    yield r'minimumPay';
    yield serializers.serialize(
      object.minimumPay,
      specifiedType: const FullType(CaptainPayMoneyOutput),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainPayTableDtoOutputAnnouncedInner object, {
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
    required CaptainPayTableDtoOutputAnnouncedInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'effectiveFrom':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.effectiveFrom = valueDes;
          break;
        case r'basePay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainPayMoneyOutput),
                  )
                  as CaptainPayMoneyOutput;
          result.basePay.replace(valueDes);
          break;
        case r'includedMetres':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.includedMetres = valueDes;
          break;
        case r'perExtraKm':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainPayMoneyOutput),
                  )
                  as CaptainPayMoneyOutput;
          result.perExtraKm.replace(valueDes);
          break;
        case r'waitingPerMinute':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainPayMoneyOutput),
                  )
                  as CaptainPayMoneyOutput;
          result.waitingPerMinute.replace(valueDes);
          break;
        case r'minimumPay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(CaptainPayMoneyOutput),
                  )
                  as CaptainPayMoneyOutput;
          result.minimumPay.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainPayTableDtoOutputAnnouncedInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPayTableDtoOutputAnnouncedInnerBuilder();
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
