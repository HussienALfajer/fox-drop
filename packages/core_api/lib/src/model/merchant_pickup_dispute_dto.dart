//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_pickup_dispute_dto_received_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_pickup_dispute_dto.g.dart';

/// MerchantPickupDisputeDto
///
/// Properties:
/// * [receivedLines] - What the restaurant actually received, prefilled with the captain's lines.
@BuiltValue()
abstract class MerchantPickupDisputeDto
    implements
        Built<MerchantPickupDisputeDto, MerchantPickupDisputeDtoBuilder> {
  /// What the restaurant actually received, prefilled with the captain's lines.
  @BuiltValueField(wireName: r'receivedLines')
  BuiltList<MerchantPickupDisputeDtoReceivedLinesInner> get receivedLines;

  MerchantPickupDisputeDto._();

  factory MerchantPickupDisputeDto([
    void updates(MerchantPickupDisputeDtoBuilder b),
  ]) = _$MerchantPickupDisputeDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantPickupDisputeDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantPickupDisputeDto> get serializer =>
      _$MerchantPickupDisputeDtoSerializer();
}

class _$MerchantPickupDisputeDtoSerializer
    implements PrimitiveSerializer<MerchantPickupDisputeDto> {
  @override
  final Iterable<Type> types = const [
    MerchantPickupDisputeDto,
    _$MerchantPickupDisputeDto,
  ];

  @override
  final String wireName = r'MerchantPickupDisputeDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantPickupDisputeDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'receivedLines';
    yield serializers.serialize(
      object.receivedLines,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantPickupDisputeDtoReceivedLinesInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantPickupDisputeDto object, {
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
    required MerchantPickupDisputeDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'receivedLines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantPickupDisputeDtoReceivedLinesInner),
                    ]),
                  )
                  as BuiltList<MerchantPickupDisputeDtoReceivedLinesInner>;
          result.receivedLines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantPickupDisputeDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantPickupDisputeDtoBuilder();
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
