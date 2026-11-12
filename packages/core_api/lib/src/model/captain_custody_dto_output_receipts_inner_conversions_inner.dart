//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_custody_dto_output_receipts_inner_conversions_inner.g.dart';

/// CaptainCustodyDtoOutputReceiptsInnerConversionsInner
///
/// Properties:
/// * [from]
/// * [amount] - Integer minor units (AP §8.6).
/// * [to]
/// * [converted] - Integer minor units (AP §8.6).
@BuiltValue()
abstract class CaptainCustodyDtoOutputReceiptsInnerConversionsInner
    implements
        Built<
          CaptainCustodyDtoOutputReceiptsInnerConversionsInner,
          CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder
        > {
  @BuiltValueField(wireName: r'from')
  String get from;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'amount')
  String get amount;

  @BuiltValueField(wireName: r'to')
  String get to;

  /// Integer minor units (AP §8.6).
  @BuiltValueField(wireName: r'converted')
  String get converted;

  CaptainCustodyDtoOutputReceiptsInnerConversionsInner._();

  factory CaptainCustodyDtoOutputReceiptsInnerConversionsInner([
    void updates(CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder b),
  ]) = _$CaptainCustodyDtoOutputReceiptsInnerConversionsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainCustodyDtoOutputReceiptsInnerConversionsInner>
  get serializer =>
      _$CaptainCustodyDtoOutputReceiptsInnerConversionsInnerSerializer();
}

class _$CaptainCustodyDtoOutputReceiptsInnerConversionsInnerSerializer
    implements
        PrimitiveSerializer<
          CaptainCustodyDtoOutputReceiptsInnerConversionsInner
        > {
  @override
  final Iterable<Type> types = const [
    CaptainCustodyDtoOutputReceiptsInnerConversionsInner,
    _$CaptainCustodyDtoOutputReceiptsInnerConversionsInner,
  ];

  @override
  final String wireName =
      r'CaptainCustodyDtoOutputReceiptsInnerConversionsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainCustodyDtoOutputReceiptsInnerConversionsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'from';
    yield serializers.serialize(
      object.from,
      specifiedType: const FullType(String),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
    yield r'to';
    yield serializers.serialize(
      object.to,
      specifiedType: const FullType(String),
    );
    yield r'converted';
    yield serializers.serialize(
      object.converted,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainCustodyDtoOutputReceiptsInnerConversionsInner object, {
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
    required CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'from':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.from = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        case r'to':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.to = valueDes;
          break;
        case r'converted':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.converted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainCustodyDtoOutputReceiptsInnerConversionsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result =
        CaptainCustodyDtoOutputReceiptsInnerConversionsInnerBuilder();
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
