//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_item_report_note.g.dart';

/// A reason of Content's item_unavailable_note list, its label as chosen.
///
/// Properties:
/// * [code]
/// * [label]
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerItemReportNote
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInnerItemReportNote,
          MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder
        > {
  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'label')
  String get label;

  MerchantOrdersDtoOutputOrdersInnerItemReportNote._();

  factory MerchantOrdersDtoOutputOrdersInnerItemReportNote([
    void updates(MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder b),
  ]) = _$MerchantOrdersDtoOutputOrdersInnerItemReportNote;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerItemReportNote>
  get serializer =>
      _$MerchantOrdersDtoOutputOrdersInnerItemReportNoteSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerItemReportNoteSerializer
    implements
        PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerItemReportNote> {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInnerItemReportNote,
    _$MerchantOrdersDtoOutputOrdersInnerItemReportNote,
  ];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerItemReportNote';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerItemReportNote object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
    yield r'label';
    yield serializers.serialize(
      object.label,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerItemReportNote object, {
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
    required MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'code':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.code = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.label = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerItemReportNote deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerItemReportNoteBuilder();
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
