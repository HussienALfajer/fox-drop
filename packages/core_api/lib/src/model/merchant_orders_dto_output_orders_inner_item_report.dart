//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_item_report_note.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/merchant_orders_dto_output_orders_inner_item_report_items_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'merchant_orders_dto_output_orders_inner_item_report.g.dart';

/// RA §8.12: the open item-unavailable report: the badge «صنف نفد — بانتظار العمليات», the line «العمليات تتواصل مع الزبون» and «تراجع — الصنف متوفر» (POST …/item-report/withdraw); pickup requests wait until it closes (RA §8.10). Null otherwise.
///
/// Properties:
/// * [at]
/// * [items]
/// * [note]
@BuiltValue()
abstract class MerchantOrdersDtoOutputOrdersInnerItemReport
    implements
        Built<
          MerchantOrdersDtoOutputOrdersInnerItemReport,
          MerchantOrdersDtoOutputOrdersInnerItemReportBuilder
        > {
  @BuiltValueField(wireName: r'at')
  DateTime get at;

  @BuiltValueField(wireName: r'items')
  BuiltList<MerchantOrdersDtoOutputOrdersInnerItemReportItemsInner> get items;

  @BuiltValueField(wireName: r'note')
  MerchantOrdersDtoOutputOrdersInnerItemReportNote? get note;

  MerchantOrdersDtoOutputOrdersInnerItemReport._();

  factory MerchantOrdersDtoOutputOrdersInnerItemReport([
    void updates(MerchantOrdersDtoOutputOrdersInnerItemReportBuilder b),
  ]) = _$MerchantOrdersDtoOutputOrdersInnerItemReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    MerchantOrdersDtoOutputOrdersInnerItemReportBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MerchantOrdersDtoOutputOrdersInnerItemReport>
  get serializer => _$MerchantOrdersDtoOutputOrdersInnerItemReportSerializer();
}

class _$MerchantOrdersDtoOutputOrdersInnerItemReportSerializer
    implements
        PrimitiveSerializer<MerchantOrdersDtoOutputOrdersInnerItemReport> {
  @override
  final Iterable<Type> types = const [
    MerchantOrdersDtoOutputOrdersInnerItemReport,
    _$MerchantOrdersDtoOutputOrdersInnerItemReport,
  ];

  @override
  final String wireName = r'MerchantOrdersDtoOutputOrdersInnerItemReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MerchantOrdersDtoOutputOrdersInnerItemReport object, {
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
    MerchantOrdersDtoOutputOrdersInnerItemReport object, {
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
    required MerchantOrdersDtoOutputOrdersInnerItemReportBuilder result,
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
  MerchantOrdersDtoOutputOrdersInnerItemReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MerchantOrdersDtoOutputOrdersInnerItemReportBuilder();
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
