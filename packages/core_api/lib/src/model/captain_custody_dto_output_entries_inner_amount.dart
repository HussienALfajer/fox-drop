//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_custody_dto_output_entries_inner_amount.g.dart';

/// + adds to what the captain hands in.
///
/// Properties:
/// * [amount] - Integer minor units (AP §8.6).
/// * [currency]
@BuiltValue()
abstract class CaptainCustodyDtoOutputEntriesInnerAmount
    implements
        Built<
          CaptainCustodyDtoOutputEntriesInnerAmount,
          CaptainCustodyDtoOutputEntriesInnerAmountBuilder
        > {
  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'currency')
  String get currency;

  CaptainCustodyDtoOutputEntriesInnerAmount._();

  factory CaptainCustodyDtoOutputEntriesInnerAmount([
    void updates(CaptainCustodyDtoOutputEntriesInnerAmountBuilder b),
  ]) = _$CaptainCustodyDtoOutputEntriesInnerAmount;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainCustodyDtoOutputEntriesInnerAmountBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCustodyDtoOutputEntriesInnerAmount> get serializer =>
      _$CaptainCustodyDtoOutputEntriesInnerAmountSerializer();
}

class _$CaptainCustodyDtoOutputEntriesInnerAmountSerializer
    implements PrimitiveSerializer<CaptainCustodyDtoOutputEntriesInnerAmount> {
  @override
  final Iterable<Type> types = const [
    CaptainCustodyDtoOutputEntriesInnerAmount,
    _$CaptainCustodyDtoOutputEntriesInnerAmount,
  ];

  @override
  final String wireName = r'CaptainCustodyDtoOutputEntriesInnerAmount';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCustodyDtoOutputEntriesInnerAmount object, {
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
    CaptainCustodyDtoOutputEntriesInnerAmount object, {
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
    required CaptainCustodyDtoOutputEntriesInnerAmountBuilder result,
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
  CaptainCustodyDtoOutputEntriesInnerAmount deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainCustodyDtoOutputEntriesInnerAmountBuilder();
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
