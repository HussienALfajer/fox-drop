//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_reject_dto_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_item_report_dto.g.dart';

/// MerchantItemReportDto
///
/// Properties:
/// * [items] - One or more of the order's items, each once, switched off in the menu at once.
/// * [note] - Optional: a code of Content's item_unavailable_note list (GET /v1/merchant/content); 400 unknown_reason otherwise.
@BuiltValue()
abstract class MerchantItemReportDto
    implements Built<MerchantItemReportDto, MerchantItemReportDtoBuilder> {
  /// One or more of the order's items, each once, switched off in the menu at once.
  @BuiltValueField(wireName: r'items')
  BuiltList<MerchantRejectDtoItemsInner> get items;

  /// Optional: a code of Content's item_unavailable_note list (GET /v1/merchant/content); 400 unknown_reason otherwise.
  @BuiltValueField(wireName: r'note')
  String? get note;

  MerchantItemReportDto._();

  factory MerchantItemReportDto([
    void updates(MerchantItemReportDtoBuilder b),
  ]) = _$MerchantItemReportDto;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MerchantItemReportDtoBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantItemReportDto> get serializer =>
      _$MerchantItemReportDtoSerializer();
}

class _$MerchantItemReportDtoSerializer
    implements PrimitiveSerializer<MerchantItemReportDto> {
  @override
  final Iterable<Type> types = const [
    MerchantItemReportDto,
    _$MerchantItemReportDto,
  ];

  @override
  final String wireName = r'MerchantItemReportDto';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantItemReportDto object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantRejectDtoItemsInner),
      ]),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantItemReportDto object, {
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
    required MerchantItemReportDtoBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantItemReportDto deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantItemReportDtoBuilder();
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
