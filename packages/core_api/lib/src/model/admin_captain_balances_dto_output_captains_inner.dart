//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:core_api/src/model/admin_desk_custody_dto_output_closed_due.dart';
import 'package:built_collection/built_collection.dart';
import 'package:core_api/src/model/admin_desk_custody_dto_output_currencies_inner.dart';
import 'package:core_api/src/model/admin_desk_custody_dto_output_usage.dart';
import 'package:core_api/src/model/admin_captain_balances_dto_output_captains_inner_earnings.dart';
import 'package:core_api/src/model/admin_desk_custody_dto_output_hand_in_grace.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_captain_balances_dto_output_captains_inner.g.dart';

/// AdminCaptainBalancesDtoOutputCaptainsInner
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
/// * [lastPayoutAt] - None until slice 2.18.
@BuiltValue()
abstract class AdminCaptainBalancesDtoOutputCaptainsInner
    implements
        Built<
          AdminCaptainBalancesDtoOutputCaptainsInner,
          AdminCaptainBalancesDtoOutputCaptainsInnerBuilder
        > {
  @BuiltValueField(wireName: r'captainId')
  String get captainId;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'status')
  AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum get status;
  // enum statusEnum {  active,  suspended,  terminated,  };

  /// Every currency at the current rate: the sort.
  @BuiltValueField(wireName: r'custodyInBase')
  String get custodyInBase;

  @BuiltValueField(wireName: r'usage')
  AdminDeskCustodyDtoOutputUsage get usage;

  @BuiltValueField(wireName: r'limit')
  AdminDeskCustodyDtoOutputUsage get limit;

  @BuiltValueField(wireName: r'closedDue')
  AdminDeskCustodyDtoOutputClosedDue get closedDue;

  @BuiltValueField(wireName: r'lastCutoff')
  DateTime get lastCutoff;

  @BuiltValueField(wireName: r'currencies')
  BuiltList<AdminDeskCustodyDtoOutputCurrenciesInner> get currencies;

  /// Cash due from a closed day with no grace running, or the limit reached.
  @BuiltValueField(wireName: r'blocks')
  BuiltList<AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum> get blocks;
  // enum blocksEnum {  closed_due,  cash_limit,  };

  @BuiltValueField(wireName: r'handInGrace')
  AdminDeskCustodyDtoOutputHandInGrace? get handInGrace;

  @BuiltValueField(wireName: r'earnings')
  AdminCaptainBalancesDtoOutputCaptainsInnerEarnings get earnings;

  @BuiltValueField(wireName: r'lastHandInAt')
  DateTime? get lastHandInAt;

  /// None until slice 2.18.
  @BuiltValueField(wireName: r'lastPayoutAt')
  DateTime? get lastPayoutAt;

  AdminCaptainBalancesDtoOutputCaptainsInner._();

  factory AdminCaptainBalancesDtoOutputCaptainsInner([
    void updates(AdminCaptainBalancesDtoOutputCaptainsInnerBuilder b),
  ]) = _$AdminCaptainBalancesDtoOutputCaptainsInner;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminCaptainBalancesDtoOutputCaptainsInnerBuilder b) =>
      b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminCaptainBalancesDtoOutputCaptainsInner>
  get serializer => _$AdminCaptainBalancesDtoOutputCaptainsInnerSerializer();
}

class _$AdminCaptainBalancesDtoOutputCaptainsInnerSerializer
    implements PrimitiveSerializer<AdminCaptainBalancesDtoOutputCaptainsInner> {
  @override
  final Iterable<Type> types = const [
    AdminCaptainBalancesDtoOutputCaptainsInner,
    _$AdminCaptainBalancesDtoOutputCaptainsInner,
  ];

  @override
  final String wireName = r'AdminCaptainBalancesDtoOutputCaptainsInner';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminCaptainBalancesDtoOutputCaptainsInner object, {
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
        AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum,
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
      specifiedType: const FullType(AdminDeskCustodyDtoOutputUsage),
    );
    yield r'limit';
    yield serializers.serialize(
      object.limit,
      specifiedType: const FullType(AdminDeskCustodyDtoOutputUsage),
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
        FullType(AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum),
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
    AdminCaptainBalancesDtoOutputCaptainsInner object, {
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
    required AdminCaptainBalancesDtoOutputCaptainsInnerBuilder result,
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
                      AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum,
                    ),
                  )
                  as AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum;
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
                      AdminDeskCustodyDtoOutputUsage,
                    ),
                  )
                  as AdminDeskCustodyDtoOutputUsage;
          result.usage.replace(valueDes);
          break;
        case r'limit':
          final valueDes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(
                      AdminDeskCustodyDtoOutputUsage,
                    ),
                  )
                  as AdminDeskCustodyDtoOutputUsage;
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
                        AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum,
                      ),
                    ]),
                  )
                  as BuiltList<
                    AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum
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
  AdminCaptainBalancesDtoOutputCaptainsInner deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminCaptainBalancesDtoOutputCaptainsInnerBuilder();
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

class AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'active')
  static const AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum active =
      _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_active;
  @BuiltValueEnumConst(wireName: r'suspended')
  static const AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum suspended =
      _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_suspended;
  @BuiltValueEnumConst(wireName: r'terminated')
  static const AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum terminated =
      _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_terminated;

  static Serializer<AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum>
  get serializer =>
      _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnumSerializer;

  const AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum>
  get values => _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnumValues;
  static AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum valueOf(
    String name,
  ) => _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnumValueOf(name);
}

class AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum extends EnumClass {
  @BuiltValueEnumConst(wireName: r'closed_due')
  static const AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum closedDue =
      _$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum_closedDue;
  @BuiltValueEnumConst(wireName: r'cash_limit')
  static const AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum cashLimit =
      _$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum_cashLimit;

  static Serializer<AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum>
  get serializer =>
      _$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnumSerializer;

  const AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum._(String name)
    : super(name);

  static BuiltSet<AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum>
  get values => _$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnumValues;
  static AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum valueOf(
    String name,
  ) => _$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnumValueOf(name);
}
