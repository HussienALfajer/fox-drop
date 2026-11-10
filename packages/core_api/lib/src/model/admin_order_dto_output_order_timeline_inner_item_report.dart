//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_item_report_note.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_item_report_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_timeline_inner_item_report.g.dart';

/// order.item_reported: the items reported and the note.
///
/// Properties:
/// * [items]
/// * [note]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderTimelineInnerItemReport
    implements
        Built<
          AdminOrderDtoOutputOrderTimelineInnerItemReport,
          AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder
        > {
  @BuiltValueField(wireName: r'items')
  BuiltList<MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner> get items;

  @BuiltValueField(wireName: r'note')
  MerchantOrdersDtoOutputOrdersInnerItemReportNote? get note;

  AdminOrderDtoOutputOrderTimelineInnerItemReport._();

  factory AdminOrderDtoOutputOrderTimelineInnerItemReport([
    void updates(AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder b),
  ]) = _$AdminOrderDtoOutputOrderTimelineInnerItemReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderTimelineInnerItemReport>
  get serializer =>
      _$AdminOrderDtoOutputOrderTimelineInnerItemReportSerializer();
}

class _$AdminOrderDtoOutputOrderTimelineInnerItemReportSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderTimelineInnerItemReport> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderTimelineInnerItemReport,
    _$AdminOrderDtoOutputOrderTimelineInnerItemReport,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderTimelineInnerItemReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderTimelineInnerItemReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner),
      ]),
    );
    yield r'note';
    yield object.note == null
        ? null
        : serializers.serialize(
            object.note,
            specifiedType: const FullType.nullable(
              MerchantOrdersDtoOutputOrdersInnerItemReportNote,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderTimelineInnerItemReport object, {
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
    required AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder result,
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
                      FullType(
                        MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner,
                      ),
                    ]),
                  )
                  as BuiltList<
                    MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner
                  >;
          result.items.replace(valueDes);
          break;
        case r'note':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      MerchantOrdersDtoOutputOrdersInnerItemReportNote,
                    ),
                  )
                  as MerchantOrdersDtoOutputOrdersInnerItemReportNote?;
          if (valueDes == null) continue;
          result.note.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminOrderDtoOutputOrderTimelineInnerItemReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderTimelineInnerItemReportBuilder();
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
