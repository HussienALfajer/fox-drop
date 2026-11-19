//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_pay_money_output.g.dart';

/// CaptainPayMoneyOutput
///
/// Properties:
/// * [amount]
/// * [currency]
@BuiltValue()
abstract class CaptainPayMoneyOutput
    implements Built<CaptainPayMoneyOutput, CaptainPayMoneyOutputBuilder> {
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainPayMoneyOutput._();

  factory CaptainPayMoneyOutput([
    void updates(CaptainPayMoneyOutputBuilder b),
  ]) = _$CaptainPayMoneyOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainPayMoneyOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainPayMoneyOutput> get serializer =>
      _$CaptainPayMoneyOutputSerializer();
}

class _$CaptainPayMoneyOutputSerializer
    implements PrimitiveSerializer<CaptainPayMoneyOutput> {
  @override
  final Iterable<Type> types = const [
    CaptainPayMoneyOutput,
    _$CaptainPayMoneyOutput,
  ];

  @override
  final String wireName = r'CaptainPayMoneyOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainPayMoneyOutput object, {
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
    CaptainPayMoneyOutput object, {
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
    required CaptainPayMoneyOutputBuilder result,
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
  CaptainPayMoneyOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainPayMoneyOutputBuilder();
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
