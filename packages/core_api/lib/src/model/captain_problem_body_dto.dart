//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_pickup_dispute_dto_received_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'captain_problem_body_dto.g.dart';

/// CaptainProblemBodyDto
///
/// Properties:
/// * [reasonCode] - A code of Content's captain_problem list (CA Appendix C).
/// * [note] - Optional, up to 300 characters; the text of «أخرى».
/// * [paidLines] - «مشكلة في مبلغ الاستلام» (pickup_amount) only, and required with it: the lines the captain actually handed the restaurant.
@BuiltValue()
abstract class CaptainProblemBodyDto
    implements Built<CaptainProblemBodyDto, CaptainProblemBodyDtoBuilder> {
  /// A code of Content's captain_problem list (CA Appendix C).
  @BuiltValueField(wireName: r'reasonCode')
  String get reasonCode;

  /// Optional, up to 300 characters; the text of «أخرى».
  @BuiltValueField(wireName: r'note')
  String? get note;

  /// «مشكلة في مبلغ الاستلام» (pickup_amount) only, and required with it: the lines the captain actually handed the restaurant.
  @BuiltValueField(wireName: r'paidLines')
  BuiltList<MerchantPickupDisputeDtoReceivedLinesInner>? get paidLines;

  CaptainProblemBodyDto._();

  factory CaptainProblemBodyDto([
    void updates(CaptainProblemBodyDtoBuilder b),
  ]) = _$CaptainProblemBodyDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(CaptainProblemBodyDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CaptainProblemBodyDto> get serializer =>
      _$CaptainProblemBodyDtoSerializer();
}

class _$CaptainProblemBodyDtoSerializer
    implements PrimitiveSerializer<CaptainProblemBodyDto> {
  @override
  final Iterable<Type> types = const [
    CaptainProblemBodyDto,
    _$CaptainProblemBodyDto,
  ];

  @override
  final String wireName = r'CaptainProblemBodyDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CaptainProblemBodyDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reasonCode';
    yield serializers.serialize(
      object.reasonCode,
      specifiedType: const FullType(String),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
    yield r'paidLines';
    yield object.paidLines == null
        ? null
        : serializers.serialize(
            object.paidLines,
            specifiedType: const FullType.nullable(BuiltList, [
              FullType(MerchantPickupDisputeDtoReceivedLinesInner),
            ]),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CaptainProblemBodyDto object, {
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
    required CaptainProblemBodyDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reasonCode':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reasonCode = valueDes;
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.note = valueDes;
          break;
        case r'paidLines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(BuiltList, [
                      FullType(MerchantPickupDisputeDtoReceivedLinesInner),
                    ]),
                  )
                  as BuiltList<MerchantPickupDisputeDtoReceivedLinesInner>?;
          if (valueDes == null) continue;
          result.paidLines.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CaptainProblemBodyDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CaptainProblemBodyDtoBuilder();
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
