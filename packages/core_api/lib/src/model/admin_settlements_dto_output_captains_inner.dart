//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_desk_custody_dto_output_closed_due.dart';
import 'package:core_api/src/model/admin_order_tickets_dto_output_tickets_inner_resolution_corrected_lines_inner.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_desk_custody_dto_output_currencies_inner.dart';
import 'package:core_api/src/model/admin_captain_balances_dto_output_captains_inner_earnings.dart';
import 'package:core_api/src/model/admin_desk_custody_dto_output_hand_in_grace.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_settlements_dto_output_captains_inner.g.dart';

/// AdminSettlementsDtoOutputCaptainsInner
///
/// Properties:
/// * [captainId]
/// * [name]
/// * [status]
/// * [custodyInBase] - Every currency at the current rate: the sort.
/// * [usage]
/// * [limit]
/// * [closedDue]
/// * [lastCutoff]
/// * [currencies]
/// * [blocks] - Cash due from a closed day with no grace running, or the limit reached.
/// * [handInGrace]
/// * [earnings]
/// * [lastHandInAt]
/// * [lastPayoutAt] - The latest «صرف المستحقات» receipt (slice 2.18a).
@BuiltValue()
abstract class AdminSettlementsDtoOutputCaptainsInner
    implements
        Built<
          AdminSettlementsDtoOutputCaptainsInner,
          AdminSettlementsDtoOutputCaptainsInnerBuilder
        > {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  AdminSettlementsDtoOutputCaptainsInnerStatusEnum get status;
  // enum statusEnum {  active,  suspended,  terminated,  };

  /// Every currency at the current rate: the sort.
  @BuiltValueField(wireName: r'custodyInBase')
  String get custodyInBase;

  @BuiltValueField(wireName: r'usage')
  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner get usage;

  @BuiltValueField(wireName: r'limit')
  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner get limit;

  @BuiltValueField(wireName: r'closedDue')
  AdminDeskCustodyDtoOutputClosedDue get closedDue;

  @BuiltValueField(wireName: r'lastCutoff')
  DateTime get lastCutoff;

  @BuiltValueField(wireName: r'currencies')
  BuiltList<AdminDeskCustodyDtoOutputCurrenciesInner> get currencies;

  /// Cash due from a closed day with no grace running, or the limit reached.
  @BuiltValueField(wireName: r'blocks')
  BuiltList<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum> get blocks;
  // enum blocksEnum {  closed_due,  cash_limit,  };

  @BuiltValueField(wireName: r'handInGrace')
  AdminDeskCustodyDtoOutputHandInGrace? get handInGrace;

  @BuiltValueField(wireName: r'earnings')
  AdminCaptainBalancesDtoOutputCaptainsInnerEarnings get earnings;

  @BuiltValueField(wireName: r'lastHandInAt')
  DateTime? get lastHandInAt;

  /// The latest «صرف المستحقات» receipt (slice 2.18a).
  @BuiltValueField(wireName: r'lastPayoutAt')
  DateTime? get lastPayoutAt;

  AdminSettlementsDtoOutputCaptainsInner._();

  factory AdminSettlementsDtoOutputCaptainsInner([
    void updates(AdminSettlementsDtoOutputCaptainsInnerBuilder b),
  ]) = _$AdminSettlementsDtoOutputCaptainsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminSettlementsDtoOutputCaptainsInnerBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminSettlementsDtoOutputCaptainsInner> get serializer =>
      _$AdminSettlementsDtoOutputCaptainsInnerSerializer();
}

class _$AdminSettlementsDtoOutputCaptainsInnerSerializer
    implements PrimitiveSerializer<AdminSettlementsDtoOutputCaptainsInner> {
  @override
  final Iterable<Type> types = const [
    AdminSettlementsDtoOutputCaptainsInner,
    _$AdminSettlementsDtoOutputCaptainsInner,
  ];

  @override
  final String wireName = r'AdminSettlementsDtoOutputCaptainsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminSettlementsDtoOutputCaptainsInner object, {
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
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(
        AdminSettlementsDtoOutputCaptainsInnerStatusEnum,
      ),
    );
    yield r'custodyInBase';
    yield serializers.serialize(
      object.custodyInBase,
      specifiedType: const FullType(String),
    );
    yield r'usage';
    yield serializers.serialize(
      object.usage,
      specifiedType: const FullType(
        AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
      ),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(
        AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
      ),
    );
    yield r'closedDue';
    yield serializers.serialize(
      object.closedDue,
      specifiedType: const FullType(AdminDeskCustodyDtoOutputClosedDue),
    );
    yield r'lastCutoff';
    yield serializers.serialize(
      object.lastCutoff,
      specifiedType: const FullType(DateTime),
    );
    yield r'currencies';
    yield serializers.serialize(
      object.currencies,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminDeskCustodyDtoOutputCurrenciesInner),
      ]),
    );
    yield r'blocks';
    yield serializers.serialize(
      object.blocks,
      specifiedType: const FullType(BuiltList, [
        FullType(AdminSettlementsDtoOutputCaptainsInnerBlocksEnum),
      ]),
    );
    yield r'handInGrace';
    yield object.handInGrace == null
        ? null
        : serializers.serialize(
            object.handInGrace,
            specifiedType: const FullType.nullable(
              AdminDeskCustodyDtoOutputHandInGrace,
            ),
          );
    yield r'earnings';
    yield serializers.serialize(
      object.earnings,
      specifiedType: const FullType(
        AdminCaptainBalancesDtoOutputCaptainsInnerEarnings,
      ),
    );
    yield r'lastHandInAt';
    yield object.lastHandInAt == null
        ? null
        : serializers.serialize(
            object.lastHandInAt,
            specifiedType: const FullType.nullable(DateTime),
          );
    yield r'lastPayoutAt';
    yield object.lastPayoutAt == null
        ? null
        : serializers.serialize(
            object.lastPayoutAt,
            specifiedType: const FullType.nullable(DateTime),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementsDtoOutputCaptainsInner object, {
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
    required AdminSettlementsDtoOutputCaptainsInnerBuilder result,
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
        case r'status':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminSettlementsDtoOutputCaptainsInnerStatusEnum,
                    ),
                  )
                  as AdminSettlementsDtoOutputCaptainsInnerStatusEnum;
          result.status = valueDes;
          break;
        case r'custodyInBase':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String;
          result.custodyInBase = valueDes;
          break;
        case r'usage':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
                    ),
                  )
                  as AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner;
          result.usage.replace(valueDes);
          break;
        case r'limit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner,
                    ),
                  )
                  as AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner;
          result.limit.replace(valueDes);
          break;
        case r'closedDue':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeskCustodyDtoOutputClosedDue,
                    ),
                  )
                  as AdminDeskCustodyDtoOutputClosedDue;
          result.closedDue.replace(valueDes);
          break;
        case r'lastCutoff':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime;
          result.lastCutoff = valueDes;
          break;
        case r'currencies':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(AdminDeskCustodyDtoOutputCurrenciesInner),
                    ]),
                  )
                  as BuiltList<AdminDeskCustodyDtoOutputCurrenciesInner>;
          result.currencies.replace(valueDes);
          break;
        case r'blocks':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(BuiltList, [
                      FullType(
                        AdminSettlementsDtoOutputCaptainsInnerBlocksEnum,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminSettlementsDtoOutputCaptainsInnerBlocksEnum
                  >;
          result.blocks.replace(valueDes);
          break;
        case r'handInGrace':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(
                      AdminDeskCustodyDtoOutputHandInGrace,
                    ),
                  )
                  as AdminDeskCustodyDtoOutputHandInGrace?;
          if (valueDes == null) continue;
          result.handInGrace.replace(valueDes);
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
        case r'lastHandInAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.lastHandInAt = valueDes;
          break;
        case r'lastPayoutAt':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType.nullable(DateTime),
                  )
                  as DateTime?;
          if (valueDes == null) continue;
          result.lastPayoutAt = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AdminSettlementsDtoOutputCaptainsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminSettlementsDtoOutputCaptainsInnerBuilder();
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

class AdminSettlementsDtoOutputCaptainsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminSettlementsDtoOutputCaptainsInnerStatusEnum active =
      _$adminSettlementsDtoOutputCaptainsInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminSettlementsDtoOutputCaptainsInnerStatusEnum suspended =
      _$adminSettlementsDtoOutputCaptainsInnerStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminSettlementsDtoOutputCaptainsInnerStatusEnum terminated =
      _$adminSettlementsDtoOutputCaptainsInnerStatusEnum_terminated;

  static Serializer<AdminSettlementsDtoOutputCaptainsInnerStatusEnum>
  get serializer =>
      _$adminSettlementsDtoOutputCaptainsInnerStatusEnumSerializer;

  const AdminSettlementsDtoOutputCaptainsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminSettlementsDtoOutputCaptainsInnerStatusEnum>
  get values => _$adminSettlementsDtoOutputCaptainsInnerStatusEnumValues;
  static AdminSettlementsDtoOutputCaptainsInnerStatusEnum valueOf(
    String name,
  ) => _$adminSettlementsDtoOutputCaptainsInnerStatusEnumValueOf(name);
}

class AdminSettlementsDtoOutputCaptainsInnerBlocksEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'closed_due')
  static const AdminSettlementsDtoOutputCaptainsInnerBlocksEnum closedDue =
      _$adminSettlementsDtoOutputCaptainsInnerBlocksEnum_closedDue;
  @BuiltValueEnumConst(wireName: r'cash_limit')
  static const AdminSettlementsDtoOutputCaptainsInnerBlocksEnum cashLimit =
      _$adminSettlementsDtoOutputCaptainsInnerBlocksEnum_cashLimit;

  static Serializer<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum>
  get serializer =>
      _$adminSettlementsDtoOutputCaptainsInnerBlocksEnumSerializer;

  const AdminSettlementsDtoOutputCaptainsInnerBlocksEnum._(String name)
    : super(name);

  static BuiltSet<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum>
  get values => _$adminSettlementsDtoOutputCaptainsInnerBlocksEnumValues;
  static AdminSettlementsDtoOutputCaptainsInnerBlocksEnum valueOf(
    String name,
  ) => _$adminSettlementsDtoOutputCaptainsInnerBlocksEnumValueOf(name);
}
