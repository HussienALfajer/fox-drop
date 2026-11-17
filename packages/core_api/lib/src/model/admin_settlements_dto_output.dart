//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_settlements_dto_output_captains_inner.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settlements_dto_output.g.dart';

/// AdminSettlementsDtoOutput
///
/// Properties:
/// * [payoutDay] - Today is captain.payout_weekday on the business day.
/// * [payoutWeekday]
/// * [policy] - captain.negative_earnings_policy.
/// * [captains] - Every captain with an earnings balance or open custody, highest custody first.
@BuiltValue()
abstract class AdminSettlementsDtoOutput
    implements
        Built<AdminSettlementsDtoOutput, AdminSettlementsDtoOutputBuilder> {
  /// Today is captain.payout_weekday on the business day.
  @BuiltValueField(wireName: r'payoutDay')
  bool get payoutDay;

  @BuiltValueField(wireName: r'payoutWeekday')
  AdminSettlementsDtoOutputPayoutWeekdayEnum get payoutWeekday;
  // enum payoutWeekdayEnum {  saturday,  sunday,  monday,  tuesday,  wednesday,  thursday,  friday,  };

  /// captain.negative_earnings_policy.
  @BuiltValueField(wireName: r'policy')
  AdminSettlementsDtoOutputPolicyEnum get policy;
  // enum policyEnum {  carry_forward,  collect_at_desk,  };

  /// Every captain with an earnings balance or open custody, highest custody first.
  @BuiltValueField(wireName: r'captains')
  BuiltList<AdminSettlementsDtoOutputCaptainsInner> get captains;

  AdminSettlementsDtoOutput._();

  factory AdminSettlementsDtoOutput([
    void updates(AdminSettlementsDtoOutputBuilder b),
  ]) = _$AdminSettlementsDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettlementsDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettlementsDtoOutput> get serializer =>
      _$AdminSettlementsDtoOutputSerializer();
}

class _$AdminSettlementsDtoOutputSerializer
    implements PrimitiveSerializer<AdminSettlementsDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminSettlementsDtoOutput,
    _$AdminSettlementsDtoOutput,
  ];

  @override
  final String wireName = r'AdminSettlementsDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettlementsDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'payoutDay';
    yield serializers.serialize(
      object.payoutDay,
      specifiedType: const FullType(bool),
    );
    yield r'payoutWeekday';
    yield serializers.serialize(
      object.payoutWeekday,
      specifiedType: const FullType(AdminSettlementsDtoOutputPayoutWeekdayEnum),
    );
    yield r'policy';
    yield serializers.serialize(
      object.policy,
      specifiedType: const FullType(AdminSettlementsDtoOutputPolicyEnum),
    );
    yield r'captains';
    yield serializers.serialize(
      object.captains,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSettlementsDtoOutputCaptainsInner),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementsDtoOutput object, {
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
    required AdminSettlementsDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'payoutDay':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool;
          result.payoutDay = valueDes;
          break;
        case r'payoutWeekday':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminSettlementsDtoOutputPayoutWeekdayEnum,
                    ),
                  )
                  as AdminSettlementsDtoOutputPayoutWeekdayEnum;
          result.payoutWeekday = valueDes;
          break;
        case r'policy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminSettlementsDtoOutputPolicyEnum,
                    ),
                  )
                  as AdminSettlementsDtoOutputPolicyEnum;
          result.policy = valueDes;
          break;
        case r'captains':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSettlementsDtoOutputCaptainsInner),
                    ]),
                  )
                  as BuiltList<AdminSettlementsDtoOutputCaptainsInner>;
          result.captains.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSettlementsDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettlementsDtoOutputBuilder();
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

class AdminSettlementsDtoOutputPayoutWeekdayEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'saturday')
  static const AdminSettlementsDtoOutputPayoutWeekdayEnum saturday =
      _$adminSettlementsDtoOutputPayoutWeekdayEnum_saturday;
  @BuiltValueEnumConst(wireName: r'sunday')
  static const AdminSettlementsDtoOutputPayoutWeekdayEnum sunday =
      _$adminSettlementsDtoOutputPayoutWeekdayEnum_sunday;
  @BuiltValueEnumConst(wireName: r'monday')
  static const AdminSettlementsDtoOutputPayoutWeekdayEnum monday =
      _$adminSettlementsDtoOutputPayoutWeekdayEnum_monday;
  @BuiltValueEnumConst(wireName: r'tuesday')
  static const AdminSettlementsDtoOutputPayoutWeekdayEnum tuesday =
      _$adminSettlementsDtoOutputPayoutWeekdayEnum_tuesday;
  @BuiltValueEnumConst(wireName: r'wednesday')
  static const AdminSettlementsDtoOutputPayoutWeekdayEnum wednesday =
      _$adminSettlementsDtoOutputPayoutWeekdayEnum_wednesday;
  @BuiltValueEnumConst(wireName: r'thursday')
  static const AdminSettlementsDtoOutputPayoutWeekdayEnum thursday =
      _$adminSettlementsDtoOutputPayoutWeekdayEnum_thursday;
  @BuiltValueEnumConst(wireName: r'friday')
  static const AdminSettlementsDtoOutputPayoutWeekdayEnum friday =
      _$adminSettlementsDtoOutputPayoutWeekdayEnum_friday;

  static Serializer<AdminSettlementsDtoOutputPayoutWeekdayEnum>
  get serializer => _$adminSettlementsDtoOutputPayoutWeekdayEnumSerializer;

  const AdminSettlementsDtoOutputPayoutWeekdayEnum._(String name) : super(name);

  static BuiltSet<AdminSettlementsDtoOutputPayoutWeekdayEnum> get values =>
      _$adminSettlementsDtoOutputPayoutWeekdayEnumValues;
  static AdminSettlementsDtoOutputPayoutWeekdayEnum valueOf(String name) =>
      _$adminSettlementsDtoOutputPayoutWeekdayEnumValueOf(name);
}

/// captain.negative_earnings_policy.
class AdminSettlementsDtoOutputPolicyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'carry_forward')
  static const AdminSettlementsDtoOutputPolicyEnum carryForward =
      _$adminSettlementsDtoOutputPolicyEnum_carryForward;
  @BuiltValueEnumConst(wireName: r'collect_at_desk')
  static const AdminSettlementsDtoOutputPolicyEnum collectAtDesk =
      _$adminSettlementsDtoOutputPolicyEnum_collectAtDesk;

  static Serializer<AdminSettlementsDtoOutputPolicyEnum> get serializer =>
      _$adminSettlementsDtoOutputPolicyEnumSerializer;

  const AdminSettlementsDtoOutputPolicyEnum._(String name) : super(name);

  static BuiltSet<AdminSettlementsDtoOutputPolicyEnum> get values =>
      _$adminSettlementsDtoOutputPolicyEnumValues;
  static AdminSettlementsDtoOutputPolicyEnum valueOf(String name) =>
      _$adminSettlementsDtoOutputPolicyEnumValueOf(name);
}
