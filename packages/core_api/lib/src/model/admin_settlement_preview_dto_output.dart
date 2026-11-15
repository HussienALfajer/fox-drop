//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_desk_custody_dto_output_usage.dart';
import 'package:core_api/src/model/admin_captain_balances_dto_output_captains_inner_earnings.dart';
import 'package:core_api/src/model/admin_settlement_preview_dto_output_custody_inner.dart';
import 'package:core_api/src/model/admin_settlement_preview_dto_output_payout.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settlement_preview_dto_output.g.dart';

/// AdminSettlementPreviewDtoOutput
///
/// Properties:
/// * [captainId]
/// * [name]
/// * [cityId]
/// * [payoutDay] - Today is captain.payout_weekday on the business day.
/// * [payoutWeekday]
/// * [policy] - captain.negative_earnings_policy.
/// * [custody]
/// * [earnings]
/// * [payout]
/// * [collect] - A negative balance collected (collect_at_desk).
/// * [net] - The cash per currency: + the captain gives, − the desk pays.
@BuiltValue()
abstract class AdminSettlementPreviewDtoOutput
    implements
        Built<
          AdminSettlementPreviewDtoOutput,
          AdminSettlementPreviewDtoOutputBuilder
        > {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'cityId')
  String get cityId;

  /// Today is captain.payout_weekday on the business day.
  @BuiltValueField(wireName: r'payoutDay')
  bool get payoutDay;

  @BuiltValueField(wireName: r'payoutWeekday')
  AdminSettlementPreviewDtoOutputPayoutWeekdayEnum get payoutWeekday;
  // enum payoutWeekdayEnum {  saturday,  sunday,  monday,  tuesday,  wednesday,  thursday,  friday,  };

  /// captain.negative_earnings_policy.
  @BuiltValueField(wireName: r'policy')
  AdminSettlementPreviewDtoOutputPolicyEnum get policy;
  // enum policyEnum {  carry_forward,  collect_at_desk,  };

  @BuiltValueField(wireName: r'custody')
  BuiltList<AdminSettlementPreviewDtoOutputCustodyInner> get custody;

  @BuiltValueField(wireName: r'earnings')
  AdminCaptainBalancesDtoOutputCaptainsInnerEarnings get earnings;

  @BuiltValueField(wireName: r'payout')
  AdminSettlementPreviewDtoOutputPayout? get payout;

  /// A negative balance collected (collect_at_desk).
  @BuiltValueField(wireName: r'collect')
  String? get collect;

  /// The cash per currency: + the captain gives, − the desk pays.
  @BuiltValueField(wireName: r'net')
  BuiltList<AdminDeskCustodyDtoOutputUsage> get net;

  AdminSettlementPreviewDtoOutput._();

  factory AdminSettlementPreviewDtoOutput([
    void updates(AdminSettlementPreviewDtoOutputBuilder b),
  ]) = _$AdminSettlementPreviewDtoOutput;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettlementPreviewDtoOutputBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettlementPreviewDtoOutput> get serializer =>
      _$AdminSettlementPreviewDtoOutputSerializer();
}

class _$AdminSettlementPreviewDtoOutputSerializer
    implements PrimitiveSerializer<AdminSettlementPreviewDtoOutput> {
  @override
  final Iterable<Type> types = const [
    AdminSettlementPreviewDtoOutput,
    _$AdminSettlementPreviewDtoOutput,
  ];

  @override
  final String wireName = r'AdminSettlementPreviewDtoOutput';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettlementPreviewDtoOutput object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'captainId';
    yield serializers.serialize(
      object.captainId,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'cityId';
    yield serializers.serialize(
      object.cityId,
      specifiedType: const FullType(String),
    );
    yield r'payoutDay';
    yield serializers.serialize(
      object.payoutDay,
      specifiedType: const FullType(bool),
    );
    yield r'payoutWeekday';
    yield serializers.serialize(
      object.payoutWeekday,
      specifiedType: const FullType(
        AdminSettlementPreviewDtoOutputPayoutWeekdayEnum,
      ),
    );
    yield r'policy';
    yield serializers.serialize(
      object.policy,
      specifiedType: const FullType(AdminSettlementPreviewDtoOutputPolicyEnum),
    );
    yield r'custody';
    yield serializers.serialize(
      object.custody,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSettlementPreviewDtoOutputCustodyInner),
      ]),
    );
    yield r'earnings';
    yield serializers.serialize(
      object.earnings,
      specifiedType: const FullType(
        AdminCaptainBalancesDtoOutputCaptainsInnerEarnings,
      ),
    );
    yield r'payout';
    yield object.payout == null
        ? null
        : serializers.serialize(
            object.payout,
            specifiedType: const FullType.nullable(
              AdminSettlementPreviewDtoOutputPayout,
            ),
          );
    yield r'collect';
    yield object.collect == null
        ? null
        : serializers.serialize(
            object.collect,
            specifiedType: const FullType.nullable(String),
          );
    yield r'net';
    yield serializers.serialize(
      object.net,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDeskCustodyDtoOutputUsage),
      ]),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementPreviewDtoOutput object, {
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
    required AdminSettlementPreviewDtoOutputBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'captainId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.captainId = valueDes;
          break;
        case r'name':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.name = valueDes;
          break;
        case r'cityId':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.cityId = valueDes;
          break;
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
                      AdminSettlementPreviewDtoOutputPayoutWeekdayEnum,
                    ),
                  )
                  as AdminSettlementPreviewDtoOutputPayoutWeekdayEnum;
          result.payoutWeekday = valueDes;
          break;
        case r'policy':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminSettlementPreviewDtoOutputPolicyEnum,
                    ),
                  )
                  as AdminSettlementPreviewDtoOutputPolicyEnum;
          result.policy = valueDes;
          break;
        case r'custody':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminSettlementPreviewDtoOutputCustodyInner),
                    ]),
                  )
                  as BuiltList<AdminSettlementPreviewDtoOutputCustodyInner>;
          result.custody.replace(valueDes);
          break;
        case r'earnings':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminCaptainBalancesDtoOutputCaptainsInnerEarnings,
                    ),
                  )
                  as AdminCaptainBalancesDtoOutputCaptainsInnerEarnings;
          result.earnings.replace(valueDes);
          break;
        case r'payout':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminSettlementPreviewDtoOutputPayout,
                    ),
                  )
                  as AdminSettlementPreviewDtoOutputPayout?;
          if (valueDes == null) continue;
          result.payout.replace(valueDes);
          break;
        case r'collect':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(String),
                  )
                  as String?;
          if (valueDes == null) continue;
          result.collect = valueDes;
          break;
        case r'net':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDeskCustodyDtoOutputUsage),
                    ]),
                  )
                  as BuiltList<AdminDeskCustodyDtoOutputUsage>;
          result.net.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSettlementPreviewDtoOutput deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettlementPreviewDtoOutputBuilder();
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

class AdminSettlementPreviewDtoOutputPayoutWeekdayEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'saturday')
  static const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum saturday =
      _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_saturday;
  @BuiltValueEnumConst(wireName: r'sunday')
  static const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum sunday =
      _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_sunday;
  @BuiltValueEnumConst(wireName: r'monday')
  static const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum monday =
      _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_monday;
  @BuiltValueEnumConst(wireName: r'tuesday')
  static const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum tuesday =
      _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_tuesday;
  @BuiltValueEnumConst(wireName: r'wednesday')
  static const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum wednesday =
      _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_wednesday;
  @BuiltValueEnumConst(wireName: r'thursday')
  static const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum thursday =
      _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_thursday;
  @BuiltValueEnumConst(wireName: r'friday')
  static const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum friday =
      _$adminSettlementPreviewDtoOutputPayoutWeekdayEnum_friday;

  static Serializer<AdminSettlementPreviewDtoOutputPayoutWeekdayEnum>
  get serializer =>
      _$adminSettlementPreviewDtoOutputPayoutWeekdayEnumSerializer;

  const AdminSettlementPreviewDtoOutputPayoutWeekdayEnum._(String name)
    : super(name);

  static BuiltSet<AdminSettlementPreviewDtoOutputPayoutWeekdayEnum>
  get values => _$adminSettlementPreviewDtoOutputPayoutWeekdayEnumValues;
  static AdminSettlementPreviewDtoOutputPayoutWeekdayEnum valueOf(
    String name,
  ) => _$adminSettlementPreviewDtoOutputPayoutWeekdayEnumValueOf(name);
}

/// captain.negative_earnings_policy.
class AdminSettlementPreviewDtoOutputPolicyEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'carry_forward')
  static const AdminSettlementPreviewDtoOutputPolicyEnum carryForward =
      _$adminSettlementPreviewDtoOutputPolicyEnum_carryForward;
  @BuiltValueEnumConst(wireName: r'collect_at_desk')
  static const AdminSettlementPreviewDtoOutputPolicyEnum collectAtDesk =
      _$adminSettlementPreviewDtoOutputPolicyEnum_collectAtDesk;

  static Serializer<AdminSettlementPreviewDtoOutputPolicyEnum> get serializer =>
      _$adminSettlementPreviewDtoOutputPolicyEnumSerializer;

  const AdminSettlementPreviewDtoOutputPolicyEnum._(String name) : super(name);

  static BuiltSet<AdminSettlementPreviewDtoOutputPolicyEnum> get values =>
      _$adminSettlementPreviewDtoOutputPolicyEnumValues;
  static AdminSettlementPreviewDtoOutputPolicyEnum valueOf(String name) =>
      _$adminSettlementPreviewDtoOutputPolicyEnumValueOf(name);
}
