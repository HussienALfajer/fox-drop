//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_item_report_note.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_order_dto_output_order_item_report_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_order_dto_output_order_item_report.g.dart';

/// RA §8.12: the open item-unavailable report, which blocks the pickup; «إغلاق بلاغ صنف نفد» closes it (POST …/item-report/close). Null otherwise.
///
/// Properties:
/// * [at]
/// * [items]
/// * [note]
@BuiltValue()
abstract class AdminOrderDtoOutputOrderItemReport
    implements
        Built<
          AdminOrderDtoOutputOrderItemReport,
          AdminOrderDtoOutputOrderItemReportBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'items')
  BuiltList<AdminOrderDtoOutputOrderItemReportItemsInner> get items;

  @BuiltValueField(wireName: r'note')
  MerchantOrdersDtoOutputOrdersInnerItemReportNote? get note;

  AdminOrderDtoOutputOrderItemReport._();

  factory AdminOrderDtoOutputOrderItemReport([
    void updates(AdminOrderDtoOutputOrderItemReportBuilder b),
  ]) = _$AdminOrderDtoOutputOrderItemReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminOrderDtoOutputOrderItemReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminOrderDtoOutputOrderItemReport> get serializer =>
      _$AdminOrderDtoOutputOrderItemReportSerializer();
}

class _$AdminOrderDtoOutputOrderItemReportSerializer
    implements PrimitiveSerializer<AdminOrderDtoOutputOrderItemReport> {
  @override
  final Iterable<Type> types = const [
    AdminOrderDtoOutputOrderItemReport,
    _$AdminOrderDtoOutputOrderItemReport,
  ];

  @override
  final String wireName = r'AdminOrderDtoOutputOrderItemReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminOrderDtoOutputOrderItemReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'at';
    yield serializers.serialize(
      object.at,
      specifiedType: const FullType(DateTime),
    );
    yield r'items';
    yield serializers.serialize(
      object.items,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminOrderDtoOutputOrderItemReportItemsInner),
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
    AdminOrderDtoOutputOrderItemReport object, {
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
    required AdminOrderDtoOutputOrderItemReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'at':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.at = valueDes;
          break;
        case r'items':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminOrderDtoOutputOrderItemReportItemsInner),
                    ]),
                  )
                  as BuiltList<AdminOrderDtoOutputOrderItemReportItemsInner>;
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
  AdminOrderDtoOutputOrderItemReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminOrderDtoOutputOrderItemReportBuilder();
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
