//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_cost_report_dto_output_compensation_reasons_inner.g.dart';

/// AdminCostReportDtoOutputCompensationReasonsInner
///
/// Properties:
/// * [kind] - `reason`: a reason of the compensation list; `late_delivery`: the automatic late codes; `other`: the rest.
/// * [reason] - The reason’s code, for `reason` only.
/// * [label] - The reason’s label as chosen; null for the two fixed lines.
/// * [orders] - The orders the codes were used on.
/// * [amount]
@BuiltValue()
abstract class AdminCostReportDtoOutputCompensationReasonsInner
    implements
        Built<
          AdminCostReportDtoOutputCompensationReasonsInner,
          AdminCostReportDtoOutputCompensationReasonsInnerBuilder
        > {
  /// `reason`: a reason of the compensation list; `late_delivery`: the automatic late codes; `other`: the rest.
  @BuiltValueField(wireName: r'kind')
  AdminCostReportDtoOutputCompensationReasonsInnerKindEnum get kind;
  // enum kindEnum {  reason,  late_delivery,  recovered_restaurant,  recovered_captain,  other,  };

  /// The reason’s code, for `reason` only.
  @BuiltValueField(wireName: r'reason')
  String? get reason;

  /// The reason’s label as chosen; null for the two fixed lines.
  @BuiltValueField(wireName: r'label')
  String? get label;

  /// The orders the codes were used on.
  @BuiltValueField(wireName: r'orders')
  int get orders;

  @BuiltValueField(wireName: r'amount')
  String get amount;

  AdminCostReportDtoOutputCompensationReasonsInner._();

  factory AdminCostReportDtoOutputCompensationReasonsInner([
    void updates(AdminCostReportDtoOutputCompensationReasonsInnerBuilder b),
  ]) = _$AdminCostReportDtoOutputCompensationReasonsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(
    AdminCostReportDtoOutputCompensationReasonsInnerBuilder b,
  ) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCostReportDtoOutputCompensationReasonsInner>
  get serializer =>
      _$AdminCostReportDtoOutputCompensationReasonsInnerSerializer();
}

class _$AdminCostReportDtoOutputCompensationReasonsInnerSerializer
    implements
        PrimitiveSerializer<AdminCostReportDtoOutputCompensationReasonsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCostReportDtoOutputCompensationReasonsInner,
    _$AdminCostReportDtoOutputCompensationReasonsInner,
  ];

  @override
  final String wireName = r'AdminCostReportDtoOutputCompensationReasonsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCostReportDtoOutputCompensationReasonsInner object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'kind';
    yield serializers.serialize(
      object.kind,
      specifiedType: const FullType(
        AdminCostReportDtoOutputCompensationReasonsInnerKindEnum,
      ),
    );
    yield r'reason';
    yield object.reason == null
        ? null
        : serializers.serialize(
            object.reason,
            specifiedType: const FullType.nullable(String),
          );
    yield r'label';
    yield object.label == null
        ? null
        : serializers.serialize(
            object.label,
            specifiedType: const FullType.nullable(String),
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
    AdminCostReportDtoOutputCompensationReasonsInner object, {
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
    required AdminCostReportDtoOutputCompensationReasonsInnerBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'kind':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCostReportDtoOutputCompensationReasonsInnerKindEnum,
                    ),
                  )
                  as AdminCostReportDtoOutputCompensationReasonsInnerKindEnum;
          result.kind = valueDes;
          break;
        case r'reason':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.reason = valueDes;
          break;
        case r'label':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.label = valueDes;
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
  AdminCostReportDtoOutputCompensationReasonsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCostReportDtoOutputCompensationReasonsInnerBuilder();
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

/// `reason`: a reason of the compensation list; `late_delivery`: the automatic late codes; `other`: the rest.
class AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
    extends EnumClass {
  @BuiltValueEnumConst(wireName: r'reason')
  static const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum reason =
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_reason;
  @BuiltValueEnumConst(wireName: r'late_delivery')
  static const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
  lateDelivery =
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_lateDelivery;
  @BuiltValueEnumConst(wireName: r'recovered_restaurant')
  static const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
  recoveredRestaurant =
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_recoveredRestaurant;
  @BuiltValueEnumConst(wireName: r'recovered_captain')
  static const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum
  recoveredCaptain =
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_recoveredCaptain;
  @BuiltValueEnumConst(wireName: r'other')
  static const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum other =
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnum_other;

  static Serializer<AdminCostReportDtoOutputCompensationReasonsInnerKindEnum>
  get serializer =>
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnumSerializer;

  const AdminCostReportDtoOutputCompensationReasonsInnerKindEnum._(String name)
    : super(name);

  static BuiltSet<AdminCostReportDtoOutputCompensationReasonsInnerKindEnum>
  get values =>
      _$adminCostReportDtoOutputCompensationReasonsInnerKindEnumValues;
  static AdminCostReportDtoOutputCompensationReasonsInnerKindEnum valueOf(
    String name,
  ) => _$adminCostReportDtoOutputCompensationReasonsInnerKindEnumValueOf(name);
}
