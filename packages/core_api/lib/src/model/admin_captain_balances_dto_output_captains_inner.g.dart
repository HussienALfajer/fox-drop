// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_balances_dto_output_captains_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum
_$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_active =
    const AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum._('active');
const AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum
_$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_suspended =
    const AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum._('suspended');
const AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum
_$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_terminated =
    const AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum._('terminated');

AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum
_$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_active;
    case 'suspended':
      return _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_suspended;
    case 'terminated':
      return _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum>
_$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnumValues =
    BuiltSet<AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum>(
      const <AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum>[
        _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_active,
        _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_suspended,
        _$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnum_terminated,
      ],
    );

const AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum
_$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum_closedDue =
    const AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum._('closedDue');
const AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum
_$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum_cashLimit =
    const AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum._('cashLimit');

AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum
_$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnumValueOf(String name) {
  switch (name) {
    case 'closedDue':
      return _$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum_closedDue;
    case 'cashLimit':
      return _$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum_cashLimit;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum>
_$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnumValues =
    BuiltSet<AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum>(
      const <AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum>[
        _$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum_closedDue,
        _$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum_cashLimit,
      ],
    );

Serializer<AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum>
_$adminCaptainBalancesDtoOutputCaptainsInnerStatusEnumSerializer =
    _$AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnumSerializer();
Serializer<AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum>
_$adminCaptainBalancesDtoOutputCaptainsInnerBlocksEnumSerializer =
    _$AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnumSerializer();

class _$AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'closedDue': 'closed_due',
    'cashLimit': 'cash_limit',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'closed_due': 'closedDue',
    'cash_limit': 'cashLimit',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainBalancesDtoOutputCaptainsInner
    extends AdminCaptainBalancesDtoOutputCaptainsInner {
  @override
  final String captainId;
  @override
  final String name;
  @override
  final AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum status;
  @override
  final String custodyInBase;
  @override
  final AdminDeskCustodyDtoOutputUsage usage;
  @override
  final AdminDeskCustodyDtoOutputUsage limit;
  @override
  final AdminDeskCustodyDtoOutputClosedDue closedDue;
  @override
  final DateTime lastCutoff;
  @override
  final BuiltList<AdminDeskCustodyDtoOutputCurrenciesInner> currencies;
  @override
  final BuiltList<AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum> blocks;
  @override
  final AdminDeskCustodyDtoOutputHandInGrace? handInGrace;
  @override
  final AdminCaptainBalancesDtoOutputCaptainsInnerEarnings earnings;
  @override
  final DateTime? lastHandInAt;
  @override
  final DateTime? lastPayoutAt;

  factory _$AdminCaptainBalancesDtoOutputCaptainsInner([
    void Function(AdminCaptainBalancesDtoOutputCaptainsInnerBuilder)? updates,
  ]) => (AdminCaptainBalancesDtoOutputCaptainsInnerBuilder()..update(updates))
      ._build();

  _$AdminCaptainBalancesDtoOutputCaptainsInner._({
    required this.captainId,
    required this.name,
    required this.status,
    required this.custodyInBase,
    required this.usage,
    required this.limit,
    required this.closedDue,
    required this.lastCutoff,
    required this.currencies,
    required this.blocks,
    this.handInGrace,
    required this.earnings,
    this.lastHandInAt,
    this.lastPayoutAt,
  }) : super._();
  @override
  AdminCaptainBalancesDtoOutputCaptainsInner rebuild(
    void Function(AdminCaptainBalancesDtoOutputCaptainsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainBalancesDtoOutputCaptainsInnerBuilder toBuilder() =>
      AdminCaptainBalancesDtoOutputCaptainsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainBalancesDtoOutputCaptainsInner &&
        captainId == other.captainId &&
        name == other.name &&
        status == other.status &&
        custodyInBase == other.custodyInBase &&
        usage == other.usage &&
        limit == other.limit &&
        closedDue == other.closedDue &&
        lastCutoff == other.lastCutoff &&
        currencies == other.currencies &&
        blocks == other.blocks &&
        handInGrace == other.handInGrace &&
        earnings == other.earnings &&
        lastHandInAt == other.lastHandInAt &&
        lastPayoutAt == other.lastPayoutAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, custodyInBase.hashCode);
    _$hash = $jc(_$hash, usage.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, closedDue.hashCode);
    _$hash = $jc(_$hash, lastCutoff.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jc(_$hash, blocks.hashCode);
    _$hash = $jc(_$hash, handInGrace.hashCode);
    _$hash = $jc(_$hash, earnings.hashCode);
    _$hash = $jc(_$hash, lastHandInAt.hashCode);
    _$hash = $jc(_$hash, lastPayoutAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainBalancesDtoOutputCaptainsInner',
          )
          ..add('captainId', captainId)
          ..add('name', name)
          ..add('status', status)
          ..add('custodyInBase', custodyInBase)
          ..add('usage', usage)
          ..add('limit', limit)
          ..add('closedDue', closedDue)
          ..add('lastCutoff', lastCutoff)
          ..add('currencies', currencies)
          ..add('blocks', blocks)
          ..add('handInGrace', handInGrace)
          ..add('earnings', earnings)
          ..add('lastHandInAt', lastHandInAt)
          ..add('lastPayoutAt', lastPayoutAt))
        .toString();
  }
}

class AdminCaptainBalancesDtoOutputCaptainsInnerBuilder
    implements
        Builder<
          AdminCaptainBalancesDtoOutputCaptainsInner,
          AdminCaptainBalancesDtoOutputCaptainsInnerBuilder
        > {
  _$AdminCaptainBalancesDtoOutputCaptainsInner? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum? _status;
  AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminCaptainBalancesDtoOutputCaptainsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _custodyInBase;
  String? get custodyInBase => _$this._custodyInBase;
  set custodyInBase(String? custodyInBase) =>
      _$this._custodyInBase = custodyInBase;

  AdminDeskCustodyDtoOutputUsageBuilder? _usage;
  AdminDeskCustodyDtoOutputUsageBuilder get usage =>
      _$this._usage ??= AdminDeskCustodyDtoOutputUsageBuilder();
  set usage(AdminDeskCustodyDtoOutputUsageBuilder? usage) =>
      _$this._usage = usage;

  AdminDeskCustodyDtoOutputUsageBuilder? _limit;
  AdminDeskCustodyDtoOutputUsageBuilder get limit =>
      _$this._limit ??= AdminDeskCustodyDtoOutputUsageBuilder();
  set limit(AdminDeskCustodyDtoOutputUsageBuilder? limit) =>
      _$this._limit = limit;

  AdminDeskCustodyDtoOutputClosedDueBuilder? _closedDue;
  AdminDeskCustodyDtoOutputClosedDueBuilder get closedDue =>
      _$this._closedDue ??= AdminDeskCustodyDtoOutputClosedDueBuilder();
  set closedDue(AdminDeskCustodyDtoOutputClosedDueBuilder? closedDue) =>
      _$this._closedDue = closedDue;

  DateTime? _lastCutoff;
  DateTime? get lastCutoff => _$this._lastCutoff;
  set lastCutoff(DateTime? lastCutoff) => _$this._lastCutoff = lastCutoff;

  ListBuilder<AdminDeskCustodyDtoOutputCurrenciesInner>? _currencies;
  ListBuilder<AdminDeskCustodyDtoOutputCurrenciesInner> get currencies =>
      _$this._currencies ??=
          ListBuilder<AdminDeskCustodyDtoOutputCurrenciesInner>();
  set currencies(
    ListBuilder<AdminDeskCustodyDtoOutputCurrenciesInner>? currencies,
  ) => _$this._currencies = currencies;

  ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum>? _blocks;
  ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum>
  get blocks => _$this._blocks ??=
      ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum>();
  set blocks(
    ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInnerBlocksEnum>? blocks,
  ) => _$this._blocks = blocks;

  AdminDeskCustodyDtoOutputHandInGraceBuilder? _handInGrace;
  AdminDeskCustodyDtoOutputHandInGraceBuilder get handInGrace =>
      _$this._handInGrace ??= AdminDeskCustodyDtoOutputHandInGraceBuilder();
  set handInGrace(AdminDeskCustodyDtoOutputHandInGraceBuilder? handInGrace) =>
      _$this._handInGrace = handInGrace;

  AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder? _earnings;
  AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder get earnings =>
      _$this._earnings ??=
          AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder();
  set earnings(
    AdminCaptainBalancesDtoOutputCaptainsInnerEarningsBuilder? earnings,
  ) => _$this._earnings = earnings;

  DateTime? _lastHandInAt;
  DateTime? get lastHandInAt => _$this._lastHandInAt;
  set lastHandInAt(DateTime? lastHandInAt) =>
      _$this._lastHandInAt = lastHandInAt;

  DateTime? _lastPayoutAt;
  DateTime? get lastPayoutAt => _$this._lastPayoutAt;
  set lastPayoutAt(DateTime? lastPayoutAt) =>
      _$this._lastPayoutAt = lastPayoutAt;

  AdminCaptainBalancesDtoOutputCaptainsInnerBuilder() {
    AdminCaptainBalancesDtoOutputCaptainsInner._defaults(this);
  }

  AdminCaptainBalancesDtoOutputCaptainsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _name = $v.name;
      _status = $v.status;
      _custodyInBase = $v.custodyInBase;
      _usage = $v.usage.toBuilder();
      _limit = $v.limit.toBuilder();
      _closedDue = $v.closedDue.toBuilder();
      _lastCutoff = $v.lastCutoff;
      _currencies = $v.currencies.toBuilder();
      _blocks = $v.blocks.toBuilder();
      _handInGrace = $v.handInGrace?.toBuilder();
      _earnings = $v.earnings.toBuilder();
      _lastHandInAt = $v.lastHandInAt;
      _lastPayoutAt = $v.lastPayoutAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainBalancesDtoOutputCaptainsInner other) {
    _$v = other as _$AdminCaptainBalancesDtoOutputCaptainsInner;
  }

  @override
  void update(
    void Function(AdminCaptainBalancesDtoOutputCaptainsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainBalancesDtoOutputCaptainsInner build() => _build();

  _$AdminCaptainBalancesDtoOutputCaptainsInner _build() {
    _$AdminCaptainBalancesDtoOutputCaptainsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainBalancesDtoOutputCaptainsInner._(
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminCaptainBalancesDtoOutputCaptainsInner',
              'captainId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminCaptainBalancesDtoOutputCaptainsInner',
              'name',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminCaptainBalancesDtoOutputCaptainsInner',
              'status',
            ),
            custodyInBase: BuiltValueNullFieldError.checkNotNull(
              custodyInBase,
              r'AdminCaptainBalancesDtoOutputCaptainsInner',
              'custodyInBase',
            ),
            usage: usage.build(),
            limit: limit.build(),
            closedDue: closedDue.build(),
            lastCutoff: BuiltValueNullFieldError.checkNotNull(
              lastCutoff,
              r'AdminCaptainBalancesDtoOutputCaptainsInner',
              'lastCutoff',
            ),
            currencies: currencies.build(),
            blocks: blocks.build(),
            handInGrace: _handInGrace?.build(),
            earnings: earnings.build(),
            lastHandInAt: lastHandInAt,
            lastPayoutAt: lastPayoutAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'usage';
        usage.build();
        _$failedField = 'limit';
        limit.build();
        _$failedField = 'closedDue';
        closedDue.build();

        _$failedField = 'currencies';
        currencies.build();
        _$failedField = 'blocks';
        blocks.build();
        _$failedField = 'handInGrace';
        _handInGrace?.build();
        _$failedField = 'earnings';
        earnings.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainBalancesDtoOutputCaptainsInner',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
