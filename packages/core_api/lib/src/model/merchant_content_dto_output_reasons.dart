//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_content_dto_output_reasons_merchant_rejection_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_content_dto_output_reasons.g.dart';

/// MerchantContentDtoOutputReasons
///
/// Properties:
/// * [merchantRejection]
/// * [merchantProblem]
/// * [itemUnavailableNote]
/// * [merchantTicketType]
@BuiltValue()
abstract class MerchantContentDtoOutputReasons
    implements
        Built<
          MerchantContentDtoOutputReasons,
          MerchantContentDtoOutputReasonsBuilder
        > {
  @BuiltValueField(wireName: r'merchant_rejection')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get merchantRejection;

  @BuiltValueField(wireName: r'merchant_problem')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get merchantProblem;

  @BuiltValueField(wireName: r'item_unavailable_note')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get itemUnavailableNote;

  @BuiltValueField(wireName: r'merchant_ticket_type')
  BuiltList<MerchantContentDtoOutputReasonsMerchantRejectionInner>
  get merchantTicketType;

  MerchantContentDtoOutputReasons._();

  factory MerchantContentDtoOutputReasons([
    void updates(MerchantContentDtoOutputReasonsBuilder b),
  ]) = _$MerchantContentDtoOutputReasons;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantContentDtoOutputReasonsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantContentDtoOutputReasons> get serializer =>
      _$MerchantContentDtoOutputReasonsSerializer();
}

class _$MerchantContentDtoOutputReasonsSerializer
    implements PrimitiveSerializer<MerchantContentDtoOutputReasons> {
  @override
  final Iterable<Type> types = const [
    MerchantContentDtoOutputReasons,
    _$MerchantContentDtoOutputReasons,
  ];

  @override
  final String wireName = r'MerchantContentDtoOutputReasons';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantContentDtoOutputReasons object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'merchant_rejection';
    yield serializers.serialize(
      object.merchantRejection,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
    yield r'merchant_problem';
    yield serializers.serialize(
      object.merchantProblem,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
    yield r'item_unavailable_note';
    yield serializers.serialize(
      object.itemUnavailableNote,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
    yield r'merchant_ticket_type';
    yield serializers.serialize(
      object.merchantTicketType,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantContentDtoOutputReasonsMerchantRejectionInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantContentDtoOutputReasons object, {
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
    required MerchantContentDtoOutputReasonsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'merchant_rejection':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.merchantRejection.replace(valueDes);
          break;
        case r'merchant_problem':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.merchantProblem.replace(valueDes);
          break;
        case r'item_unavailable_note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.itemUnavailableNote.replace(valueDes);
          break;
        case r'merchant_ticket_type':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        MerchantContentDtoOutputReasonsMerchantRejectionInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantContentDtoOutputReasonsMerchantRejectionInner
                  >;
          result.merchantTicketType.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantContentDtoOutputReasons deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantContentDtoOutputReasonsBuilder();
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
