//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_peak_bonus_dto_output_windows_inner_amount.g.dart';

/// Per delivered order.
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class CaptainPeakBonusDtoOutputWindowsInnerAmount
    implements
        Built<
          CaptainPeakBonusDtoOutputWindowsInnerAmount,
          CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder
        > {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainPeakBonusDtoOutputWindowsInnerAmount._();

  factory CaptainPeakBonusDtoOutputWindowsInnerAmount([
    void updates(CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder b),
  ]) = _$CaptainPeakBonusDtoOutputWindowsInnerAmount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPeakBonusDtoOutputWindowsInnerAmount>
  get serializer => _$CaptainPeakBonusDtoOutputWindowsInnerAmountSerializer();
}

class _$CaptainPeakBonusDtoOutputWindowsInnerAmountSerializer
    implements
        PrimitiveSerializer<CaptainPeakBonusDtoOutputWindowsInnerAmount> {
  @override
  final Iterable<Type> types = const [
    CaptainPeakBonusDtoOutputWindowsInnerAmount,
    _$CaptainPeakBonusDtoOutputWindowsInnerAmount,
  ];

  @override
  final String wireName = r'CaptainPeakBonusDtoOutputWindowsInnerAmount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPeakBonusDtoOutputWindowsInnerAmount object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'amount';
    yield serializers.serialize(
      object.amount,
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
    CaptainPeakBonusDtoOutputWindowsInnerAmount object, {
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
    required CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
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
  CaptainPeakBonusDtoOutputWindowsInnerAmount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPeakBonusDtoOutputWindowsInnerAmountBuilder();
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
