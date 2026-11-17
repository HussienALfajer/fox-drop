//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cost_report_dto_output_operating_reasons_inner.g.dart';

/// AdminCostReportDtoOutputOperatingReasonsInner
///
/// Properties:
/// * [reason]
/// * [orders]
/// * [amount]
@BuiltValue()
abstract class AdminCostReportDtoOutputOperatingReasonsInner
    implements
        Built<
          AdminCostReportDtoOutputOperatingReasonsInner,
          AdminCostReportDtoOutputOperatingReasonsInnerBuilder
        > {
  @BuiltValueField(wireName: r'reason')
  AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum get reason;
  // enum reasonEnum {  cancelled_prepared,  captain_compensation,  free,  fake,  damaged,  wrong_refused,  failed_other,  edit_after_pickup,  shortfall,  other,  };

  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  AdminCostReportDtoOutputOperatingReasonsInner._();

  factory AdminCostReportDtoOutputOperatingReasonsInner([
    void updates(AdminCostReportDtoOutputOperatingReasonsInnerBuilder b),
  ]) = _$AdminCostReportDtoOutputOperatingReasonsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCostReportDtoOutputOperatingReasonsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCostReportDtoOutputOperatingReasonsInner>
  get serializer => _$AdminCostReportDtoOutputOperatingReasonsInnerSerializer();
}

class _$AdminCostReportDtoOutputOperatingReasonsInnerSerializer
    implements
        PrimitiveSerializer<AdminCostReportDtoOutputOperatingReasonsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCostReportDtoOutputOperatingReasonsInner,
    _$AdminCostReportDtoOutputOperatingReasonsInner,
  ];

  @override
  final String wireName = r'AdminCostReportDtoOutputOperatingReasonsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCostReportDtoOutputOperatingReasonsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'reason';
    yield serializers.serialize(
      object.reason,
      specifiedType: const FullType(
        AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum,
      ),
    );
    yield r'orders';
    yield serializers.serialize(
      object.orders,
      specifiedType: const FullType(int),
    );
    yield r'amount';
    yield serializers.serialize(
      object.amount,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminCostReportDtoOutputOperatingReasonsInner object, {
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
    required AdminCostReportDtoOutputOperatingReasonsInnerBuilder result,
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
                    specifiedType: const FullType(
                      AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum,
                    ),
                  )
                  as AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum;
          result.reason = valueDes;
          break;
        case r'orders':
          final valueDes =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int;
          result.orders = valueDes;
          break;
        case r'amount':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.amount = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminCostReportDtoOutputOperatingReasonsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCostReportDtoOutputOperatingReasonsInnerBuilder();
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

class AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'cancelled_prepared')
  static const AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum
  cancelledPrepared =
      _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnum_cancelledPrepared;
  @BuiltValueEnumConst(wireName: r'captain_compensation')
  static const AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum
  captainCompensation =
      _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnum_captainCompensation;
  @BuiltValueEnumConst(wireName: r'free')
  static const AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum free =
      _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnum_free;
  @BuiltValueEnumConst(wireName: r'fake')
  static const AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum fake =
      _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnum_fake;
  @BuiltValueEnumConst(wireName: r'damaged')
  static const AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum damaged =
      _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnum_damaged;
  @BuiltValueEnumConst(wireName: r'wrong_refused')
  static const AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum
  wrongRefused =
      _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnum_wrongRefused;
  @BuiltValueEnumConst(wireName: r'failed_other')
  static const AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum
  failedOther =
      _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnum_failedOther;
  @BuiltValueEnumConst(wireName: r'edit_after_pickup')
  static const AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum
  editAfterPickup =
      _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnum_editAfterPickup;
  @BuiltValueEnumConst(wireName: r'shortfall')
  static const AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum
  shortfall =
      _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnum_shortfall;
  @BuiltValueEnumConst(wireName: r'other')
  static const AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum other =
      _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnum_other;

  static Serializer<AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum>
  get serializer =>
      _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnumSerializer;

  const AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum._(String name)
    : super(name);

  static BuiltSet<AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum>
  get values => _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnumValues;
  static AdminCostReportDtoOutputOperatingReasonsInnerReasonEnum valueOf(
    String name,
  ) => _$adminCostReportDtoOutputOperatingReasonsInnerReasonEnumValueOf(name);
}
