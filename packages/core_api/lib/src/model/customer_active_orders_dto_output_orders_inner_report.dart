//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'customer_active_orders_dto_output_orders_inner_report.g.dart';

/// CU §12.2, Q17 (slice 2.24a): the customer's one report on the order; null without one.
///
/// Properties:
/// * [ticketId]
/// * [number] - «بلاغك T-{رقم}: {الحالة}» (CU §12.2).
/// * [status] - AP Appendix C: «جديدة», «قيد المعالجة», «بانتظار رد», «محلولة», «مغلقة».
/// * [message] - The resolution message, once resolved.
/// * [resolvedAt]
@BuiltValue()
abstract class CustomerActiveOrdersDtoOutputOrdersInnerReport
    implements
        Built<
          CustomerActiveOrdersDtoOutputOrdersInnerReport,
          CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder
        > {
  @BuiltValueField(wireName: r'ticketId')
  String get ticketId;

  /// «بلاغك T-{رقم}: {الحالة}» (CU §12.2).
  @BuiltValueField(wireName: r'number')
  String get number;

  /// AP Appendix C: «جديدة», «قيد المعالجة», «بانتظار رد», «محلولة», «مغلقة».
  @BuiltValueField(wireName: r'status')
  CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum get status;
  // enum statusEnum {  new,  in_progress,  waiting,  resolved,  closed,  };

  /// The resolution message, once resolved.
  @BuiltValueField(wireName: r'message')
  String? get message;

  @BuiltValueField(wireName: r'resolvedAt')
  DateTime? get resolvedAt;

  CustomerActiveOrdersDtoOutputOrdersInnerReport._();

  factory CustomerActiveOrdersDtoOutputOrdersInnerReport([
    void updates(CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder b),
  ]) = _$CustomerActiveOrdersDtoOutputOrdersInnerReport;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerReport>
  get serializer =>
      _$CustomerActiveOrdersDtoOutputOrdersInnerReportSerializer();
}

class _$CustomerActiveOrdersDtoOutputOrdersInnerReportSerializer
    implements
        PrimitiveSerializer<CustomerActiveOrdersDtoOutputOrdersInnerReport> {
  @override
  final Iterable<Type> types = const [
    CustomerActiveOrdersDtoOutputOrdersInnerReport,
    _$CustomerActiveOrdersDtoOutputOrdersInnerReport,
  ];

  @override
  final String wireName = r'CustomerActiveOrdersDtoOutputOrdersInnerReport';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerReport object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'ticketId';
    yield serializers.serialize(
      object.ticketId,
      specifiedType: const FullType(String),
    );
    yield r'number';
    yield serializers.serialize(
      object.number,
      specifiedType: const FullType(String),
    );
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum,
      ),
    );
    yield r'message';
    yield object.message == null
        ? null
        : serializers.serialize(
            object.message,
            specifiedType: const FullType.nullable(String),
          );
    yield r'resolvedAt';
    yield object.resolvedAt == null
        ? null
        : serializers.serialize(
            object.resolvedAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    CustomerActiveOrdersDtoOutputOrdersInnerReport object, {
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
    required CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'ticketId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.ticketId = valueDes;
          break;
        case r'number':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.number = valueDes;
          break;
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum,
                    ),
                  )
                  as CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum;
          result.status = valueDes;
          break;
        case r'message':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.message = valueDes;
          break;
        case r'resolvedAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.resolvedAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerReport deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = CustomerActiveOrdersDtoOutputOrdersInnerReportBuilder();
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

/// AP Appendix C: «جديدة», «قيد المعالجة», «بانتظار رد», «محلولة», «مغلقة».
class CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'new')
  static const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum new_ =
      _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_new_;
  @BuiltValueEnumConst(wireName: r'in_progress')
  static const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum
  inProgress =
      _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_inProgress;
  @BuiltValueEnumConst(wireName: r'waiting')
  static const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum
  waiting = _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_waiting;
  @BuiltValueEnumConst(wireName: r'resolved')
  static const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum
  resolved =
      _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_resolved;
  @BuiltValueEnumConst(wireName: r'closed')
  static const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum closed =
      _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnum_closed;

  static Serializer<CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum>
  get serializer =>
      _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnumSerializer;

  const CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum._(String name)
    : super(name);

  static BuiltSet<CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum>
  get values =>
      _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnumValues;
  static CustomerActiveOrdersDtoOutputOrdersInnerReportStatusEnum valueOf(
    String name,
  ) => _$customerActiveOrdersDtoOutputOrdersInnerReportStatusEnumValueOf(name);
}
