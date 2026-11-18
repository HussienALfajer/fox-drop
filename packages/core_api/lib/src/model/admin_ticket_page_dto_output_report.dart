//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/captain_peak_bonus_dto_output_windows_inner_zones_inner.dart';
import 'package:core_api/src/model/admin_ticket_page_dto_output_pickup_dispute_pickup_payment.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_ticket_page_dto_output_report_lines_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_ticket_page_dto_output_report.g.dart';

/// A report from the customer app (source customer_report or price_report).
///
/// Properties:
/// * [lines] - The items the customer named (CU §12.2).
/// * [photoUrls] - Signed links to the photos, valid 10 minutes: read the page again for new ones.
/// * [item]
/// * [shopPrice]
/// * [subject] - «طلب تعديل بيانات» from the restaurant app (RA §15): min_order, coverage, owners, owner_phone.
@BuiltValue()
abstract class AdminTicketPageDtoOutputReport
    implements
        Built<
          AdminTicketPageDtoOutputReport,
          AdminTicketPageDtoOutputReportBuilder
        > {
  /// The items the customer named (CU §12.2).
  @BuiltValueField(wireName: r'lines')
  BuiltList<AdminTicketPageDtoOutputReportLinesInner> get lines;

  /// Signed links to the photos, valid 10 minutes: read the page again for new ones.
  @BuiltValueField(wireName: r'photoUrls')
  BuiltList<String> get photoUrls;

  @BuiltValueField(wireName: r'item')
  CaptainPeakBonusDtoOutputWindowsInnerZonesInner? get item;

  @BuiltValueField(wireName: r'shopPrice')
  AdminTicketPageDtoOutputPickupDisputePickupPayment? get shopPrice;

  /// «طلب تعديل بيانات» from the restaurant app (RA §15): min_order, coverage, owners, owner_phone.
  @BuiltValueField(wireName: r'subject')
  AdminTicketPageDtoOutputReportSubjectEnum? get subject;
  // enum subjectEnum {  min_order,  coverage,  owners,  owner_phone,  };

  AdminTicketPageDtoOutputReport._();

  factory AdminTicketPageDtoOutputReport([
    void updates(AdminTicketPageDtoOutputReportBuilder b),
  ]) = _$AdminTicketPageDtoOutputReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminTicketPageDtoOutputReportBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminTicketPageDtoOutputReport> get serializer =>
      _$AdminTicketPageDtoOutputReportSerializer();
}

class _$AdminTicketPageDtoOutputReportSerializer
    implements PrimitiveSerializer<AdminTicketPageDtoOutputReport> {
  @override
  final Iterable<Type> types = const [
    AdminTicketPageDtoOutputReport,
    _$AdminTicketPageDtoOutputReport,
  ];

  @override
  final String wireName = r'AdminTicketPageDtoOutputReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminTicketPageDtoOutputReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'lines';
    yield serializers.serialize(
      object.lines,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminTicketPageDtoOutputReportLinesInner),
      ]),
    );
    yield r'photoUrls';
    yield serializers.serialize(
      object.photoUrls,
      specifiedType: const FullType(BuiltList, [FullType(String)]),
    );
    yield r'item';
    yield object.item == null
        ? null
        : serializers.serialize(
            object.item,
            specifiedType: const FullType.nullable(
              CaptainPeakBonusDtoOutputWindowsInnerZonesInner,
            ),
          );
    yield r'shopPrice';
    yield object.shopPrice == null
        ? null
        : serializers.serialize(
            object.shopPrice,
            specifiedType: const FullType.nullable(
              AdminTicketPageDtoOutputPickupDisputePickupPayment,
            ),
          );
    yield r'subject';
    yield object.subject == null
        ? null
        : serializers.serialize(
            object.subject,
            specifiedType: const FullType.nullable(
              AdminTicketPageDtoOutputReportSubjectEnum,
            ),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketPageDtoOutputReport object, {
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
    required AdminTicketPageDtoOutputReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'lines':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminTicketPageDtoOutputReportLinesInner),
                    ]),
                  )
                  as BuiltList<AdminTicketPageDtoOutputReportLinesInner>;
          result.lines.replace(valueDes);
          break;
        case r'photoUrls':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(String),
                    ]),
                  )
                  as BuiltList<String>;
          result.photoUrls.replace(valueDes);
          break;
        case r'item':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      CaptainPeakBonusDtoOutputWindowsInnerZonesInner,
                    ),
                  )
                  as CaptainPeakBonusDtoOutputWindowsInnerZonesInner?;
          if (valueDes == null) continue;
          result.item.replace(valueDes);
          break;
        case r'shopPrice':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminTicketPageDtoOutputPickupDisputePickupPayment,
                    ),
                  )
                  as AdminTicketPageDtoOutputPickupDisputePickupPayment?;
          if (valueDes == null) continue;
          result.shopPrice.replace(valueDes);
          break;
        case r'subject':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminTicketPageDtoOutputReportSubjectEnum,
                    ),
                  )
                  as AdminTicketPageDtoOutputReportSubjectEnum?;
          if (valueDes == null) continue;
          result.subject = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminTicketPageDtoOutputReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminTicketPageDtoOutputReportBuilder();
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

/// «طلب تعديل بيانات» from the restaurant app (RA §15): min_order, coverage, owners, owner_phone.
class AdminTicketPageDtoOutputReportSubjectEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'min_order')
  static const AdminTicketPageDtoOutputReportSubjectEnum minOrder =
      _$adminTicketPageDtoOutputReportSubjectEnum_minOrder;
  @BuiltValueEnumConst(wireName: r'coverage')
  static const AdminTicketPageDtoOutputReportSubjectEnum coverage =
      _$adminTicketPageDtoOutputReportSubjectEnum_coverage;
  @BuiltValueEnumConst(wireName: r'owners')
  static const AdminTicketPageDtoOutputReportSubjectEnum owners =
      _$adminTicketPageDtoOutputReportSubjectEnum_owners;
  @BuiltValueEnumConst(wireName: r'owner_phone')
  static const AdminTicketPageDtoOutputReportSubjectEnum ownerPhone =
      _$adminTicketPageDtoOutputReportSubjectEnum_ownerPhone;

  static Serializer<AdminTicketPageDtoOutputReportSubjectEnum> get serializer =>
      _$adminTicketPageDtoOutputReportSubjectEnumSerializer;

  const AdminTicketPageDtoOutputReportSubjectEnum._(String name) : super(name);

  static BuiltSet<AdminTicketPageDtoOutputReportSubjectEnum> get values =>
      _$adminTicketPageDtoOutputReportSubjectEnumValues;
  static AdminTicketPageDtoOutputReportSubjectEnum valueOf(String name) =>
      _$adminTicketPageDtoOutputReportSubjectEnumValueOf(name);
}
