//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_reject_dto_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_reject_dto.g.dart';

/// MerchantRejectDto
///
/// Properties:
/// * [reason] - A code of Content's merchant_rejection list: item_unavailable «صنف غير متوفر», restaurant_closed «المطعم مغلق», too_busy «ضغط طلبات» (R3); 400 unknown_reason otherwise.
/// * [items] - item_unavailable: one or more of the order's items, switched off at once; empty for the other reasons.
/// * [busyExtraMin] - too_busy only: «تفعيل وضع الضغط» with one of merchant.busy_extra_options_min, or null.
/// * [pauseMin] - too_busy only: 30 for «إيقاف 30 د», or null; not with busyExtraMin (400 invalid_rejection otherwise).
@BuiltValue()
abstract class MerchantRejectDto
    implements Built<MerchantRejectDto, MerchantRejectDtoBuilder> {
  /// A code of Content's merchant_rejection list: item_unavailable «صنف غير متوفر», restaurant_closed «المطعم مغلق», too_busy «ضغط طلبات» (R3); 400 unknown_reason otherwise.
  @BuiltValueField(wireName: r'reason')
  String get reason;

  /// item_unavailable: one or more of the order's items, switched off at once; empty for the other reasons.
  @BuiltValueField(wireName: r'items')
  BuiltList<MerchantRejectDtoItemsInner> get items;

  /// too_busy only: «تفعيل وضع الضغط» with one of merchant.busy_extra_options_min, or null.
  @BuiltValueField(wireName: r'busyExtraMin')
  int? get busyExtraMin;

  /// too_busy only: 30 for «إيقاف 30 د», or null; not with busyExtraMin (400 invalid_rejection otherwise).
  @BuiltValueField(wireName: r'pauseMin')
  int? get pauseMin;

  MerchantRejectDto._();

  factory MerchantRejectDto([void updates(MerchantRejectDtoBuilder b)]) =
      _$MerchantRejectDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantRejectDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantRejectDto> get serializer =>
      _$MerchantRejectDtoSerializer();
}

class _$MerchantRejectDtoSerializer
    implements PrimitiveSerializer<MerchantRejectDto> {
  @override
  final Iterable<Type> types = const [MerchantRejectDto, _$MerchantRejectDto];

  @override
  final String wireName = r'MerchantRejectDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantRejectDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(String),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantRejectDtoItemsInner),
      ]),
    );
    yield r'busyExtraMin';
    yield object.busyExtraMin == null
        ? null
        : serializers.serialize(
            object.busyExtraMin,
            specifiedType: const FullType.nullable(int),
          );
    yield r'pauseMin';
    yield object.pauseMin == null
        ? null
        : serializers.serialize(
            object.pauseMin,
            specifiedType: const FullType.nullable(int),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantRejectDto object, {
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
    required MerchantRejectDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.reason = valueDes;
          break;
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(MerchantRejectDtoItemsInner),
                    ]),
                  )
                  as BuiltList<MerchantRejectDtoItemsInner>;
          result.items.replace(valueDes);
          break;
        case r'busyExtraMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.busyExtraMin = valueDes;
          break;
        case r'pauseMin':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(int),
                  )
                  as int?;
          if (valueDes == null) continue;
          result.pauseMin = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantRejectDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantRejectDtoBuilder();
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
