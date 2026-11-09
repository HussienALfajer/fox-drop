//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_went_offline_dto_output_hand_in.g.dart';

/// CA §7.5: the cash to hand in, above captain.remit_tolerance, or null.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency] 
@BuiltValue()
abstract class CaptainWentOfflineDtoOutputHandIn implements Built<CaptainWentOfflineDtoOutputHandIn, CaptainWentOfflineDtoOutputHandInBuilder> {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainWentOfflineDtoOutputHandIn._();

  factory CaptainWentOfflineDtoOutputHandIn([void updates(CaptainWentOfflineDtoOutputHandInBuilder b)]) = _$CaptainWentOfflineDtoOutputHandIn;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainWentOfflineDtoOutputHandInBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainWentOfflineDtoOutputHandIn> get serializer => _$CaptainWentOfflineDtoOutputHandInSerializer();
}

class _$CaptainWentOfflineDtoOutputHandInSerializer implements PrimitiveSerializer<CaptainWentOfflineDtoOutputHandIn> {
  @override
  final Iterable<Type> types = const [CaptainWentOfflineDtoOutputHandIn, _$CaptainWentOfflineDtoOutputHandIn];

  @override
  final String wireName = r'CaptainWentOfflineDtoOutputHandIn';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainWentOfflineDtoOutputHandIn object, {
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
    CaptainWentOfflineDtoOutputHandIn object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required CaptainWentOfflineDtoOutputHandInBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'amount':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.amount = valueDes;
          break;
        case r'currency':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
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
  CaptainWentOfflineDtoOutputHandIn deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainWentOfflineDtoOutputHandInBuilder();
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


