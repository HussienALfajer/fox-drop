// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_settlements_dto_output_captains_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSettlementsDtoOutputCaptainsInnerStatusEnum
_$adminSettlementsDtoOutputCaptainsInnerStatusEnum_active =
    const AdminSettlementsDtoOutputCaptainsInnerStatusEnum._('active');
const AdminSettlementsDtoOutputCaptainsInnerStatusEnum
_$adminSettlementsDtoOutputCaptainsInnerStatusEnum_suspended =
    const AdminSettlementsDtoOutputCaptainsInnerStatusEnum._('suspended');
const AdminSettlementsDtoOutputCaptainsInnerStatusEnum
_$adminSettlementsDtoOutputCaptainsInnerStatusEnum_terminated =
    const AdminSettlementsDtoOutputCaptainsInnerStatusEnum._('terminated');

AdminSettlementsDtoOutputCaptainsInnerStatusEnum
_$adminSettlementsDtoOutputCaptainsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$adminSettlementsDtoOutputCaptainsInnerStatusEnum_active;
    case 'suspended':
      return _$adminSettlementsDtoOutputCaptainsInnerStatusEnum_suspended;
    case 'terminated':
      return _$adminSettlementsDtoOutputCaptainsInnerStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSettlementsDtoOutputCaptainsInnerStatusEnum>
_$adminSettlementsDtoOutputCaptainsInnerStatusEnumValues =
    BuiltSet<AdminSettlementsDtoOutputCaptainsInnerStatusEnum>(
      const <AdminSettlementsDtoOutputCaptainsInnerStatusEnum>[
        _$adminSettlementsDtoOutputCaptainsInnerStatusEnum_active,
        _$adminSettlementsDtoOutputCaptainsInnerStatusEnum_suspended,
        _$adminSettlementsDtoOutputCaptainsInnerStatusEnum_terminated,
      ],
    );

const AdminSettlementsDtoOutputCaptainsInnerBlocksEnum
_$adminSettlementsDtoOutputCaptainsInnerBlocksEnum_closedDue =
    const AdminSettlementsDtoOutputCaptainsInnerBlocksEnum._('closedDue');
const AdminSettlementsDtoOutputCaptainsInnerBlocksEnum
_$adminSettlementsDtoOutputCaptainsInnerBlocksEnum_cashLimit =
    const AdminSettlementsDtoOutputCaptainsInnerBlocksEnum._('cashLimit');

AdminSettlementsDtoOutputCaptainsInnerBlocksEnum
_$adminSettlementsDtoOutputCaptainsInnerBlocksEnumValueOf(String name) {
  switch (name) {
    case 'closedDue':
      return _$adminSettlementsDtoOutputCaptainsInnerBlocksEnum_closedDue;
    case 'cashLimit':
      return _$adminSettlementsDtoOutputCaptainsInnerBlocksEnum_cashLimit;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum>
_$adminSettlementsDtoOutputCaptainsInnerBlocksEnumValues =
    BuiltSet<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum>(
      const <AdminSettlementsDtoOutputCaptainsInnerBlocksEnum>[
        _$adminSettlementsDtoOutputCaptainsInnerBlocksEnum_closedDue,
        _$adminSettlementsDtoOutputCaptainsInnerBlocksEnum_cashLimit,
      ],
    );

Serializer<AdminSettlementsDtoOutputCaptainsInnerStatusEnum>
_$adminSettlementsDtoOutputCaptainsInnerStatusEnumSerializer =
    _$AdminSettlementsDtoOutputCaptainsInnerStatusEnumSerializer();
Serializer<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum>
_$adminSettlementsDtoOutputCaptainsInnerBlocksEnumSerializer =
    _$AdminSettlementsDtoOutputCaptainsInnerBlocksEnumSerializer();

class _$AdminSettlementsDtoOutputCaptainsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminSettlementsDtoOutputCaptainsInnerStatusEnum> {
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
    AdminSettlementsDtoOutputCaptainsInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminSettlementsDtoOutputCaptainsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementsDtoOutputCaptainsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSettlementsDtoOutputCaptainsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSettlementsDtoOutputCaptainsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSettlementsDtoOutputCaptainsInnerBlocksEnumSerializer
    implements
        PrimitiveSerializer<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum> {
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
    AdminSettlementsDtoOutputCaptainsInnerBlocksEnum,
  ];
  @override
  final String wireName = 'AdminSettlementsDtoOutputCaptainsInnerBlocksEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSettlementsDtoOutputCaptainsInnerBlocksEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSettlementsDtoOutputCaptainsInnerBlocksEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSettlementsDtoOutputCaptainsInnerBlocksEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSettlementsDtoOutputCaptainsInner
    extends AdminSettlementsDtoOutputCaptainsInner {
  @override
  final String captainId;
  @override
  final String name;
  @override
  final AdminSettlementsDtoOutputCaptainsInnerStatusEnum status;
  @override
  final String custodyInBase;
  @override
  final AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
  usage;
  @override
  final AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
  limit;
  @override
  final AdminDeskCustodyDtoOutputClosedDue closedDue;
  @override
  final DateTime lastCutoff;
  @override
  final BuiltList<AdminDeskCustodyDtoOutputCurrenciesInner> currencies;
  @override
  final BuiltList<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum> blocks;
  @override
  final AdminDeskCustodyDtoOutputHandInGrace? handInGrace;
  @override
  final AdminCaptainBalancesDtoOutputCaptainsInnerEarnings earnings;
  @override
  final DateTime? lastHandInAt;
  @override
  final DateTime? lastPayoutAt;

  factory _$AdminSettlementsDtoOutputCaptainsInner([
    void Function(AdminSettlementsDtoOutputCaptainsInnerBuilder)? updates,
  ]) => (AdminSettlementsDtoOutputCaptainsInnerBuilder()..update(updates))
      ._build();

  _$AdminSettlementsDtoOutputCaptainsInner._({
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
  AdminSettlementsDtoOutputCaptainsInner rebuild(
    void Function(AdminSettlementsDtoOutputCaptainsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSettlementsDtoOutputCaptainsInnerBuilder toBuilder() =>
      AdminSettlementsDtoOutputCaptainsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSettlementsDtoOutputCaptainsInner &&
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
            r'AdminSettlementsDtoOutputCaptainsInner',
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

class AdminSettlementsDtoOutputCaptainsInnerBuilder
    implements
        Builder<
          AdminSettlementsDtoOutputCaptainsInner,
          AdminSettlementsDtoOutputCaptainsInnerBuilder
        > {
  _$AdminSettlementsDtoOutputCaptainsInner? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminSettlementsDtoOutputCaptainsInnerStatusEnum? _status;
  AdminSettlementsDtoOutputCaptainsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminSettlementsDtoOutputCaptainsInnerStatusEnum? status) =>
      _$this._status = status;

  String? _custodyInBase;
  String? get custodyInBase => _$this._custodyInBase;
  set custodyInBase(String? custodyInBase) =>
      _$this._custodyInBase = custodyInBase;

  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder?
  _usage;
  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder
  get usage => _$this._usage ??=
      AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder();
  set usage(
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder?
    usage,
  ) => _$this._usage = usage;

  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder?
  _limit;
  AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder
  get limit => _$this._limit ??=
      AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder();
  set limit(
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInnerBuilder?
    limit,
  ) => _$this._limit = limit;

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

  ListBuilder<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum>? _blocks;
  ListBuilder<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum> get blocks =>
      _$this._blocks ??=
          ListBuilder<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum>();
  set blocks(
    ListBuilder<AdminSettlementsDtoOutputCaptainsInnerBlocksEnum>? blocks,
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

  AdminSettlementsDtoOutputCaptainsInnerBuilder() {
    AdminSettlementsDtoOutputCaptainsInner._defaults(this);
  }

  AdminSettlementsDtoOutputCaptainsInnerBuilder get _$this {
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
  void replace(AdminSettlementsDtoOutputCaptainsInner other) {
    _$v = other as _$AdminSettlementsDtoOutputCaptainsInner;
  }

  @override
  void update(
    void Function(AdminSettlementsDtoOutputCaptainsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSettlementsDtoOutputCaptainsInner build() => _build();

  _$AdminSettlementsDtoOutputCaptainsInner _build() {
    _$AdminSettlementsDtoOutputCaptainsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminSettlementsDtoOutputCaptainsInner._(
            captainId: BuiltValueNullFieldError.checkNotNull(
              captainId,
              r'AdminSettlementsDtoOutputCaptainsInner',
              'captainId',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminSettlementsDtoOutputCaptainsInner',
              'name',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminSettlementsDtoOutputCaptainsInner',
              'status',
            ),
            custodyInBase: BuiltValueNullFieldError.checkNotNull(
              custodyInBase,
              r'AdminSettlementsDtoOutputCaptainsInner',
              'custodyInBase',
            ),
            usage: usage.build(),
            limit: limit.build(),
            closedDue: closedDue.build(),
            lastCutoff: BuiltValueNullFieldError.checkNotNull(
              lastCutoff,
              r'AdminSettlementsDtoOutputCaptainsInner',
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
          r'AdminSettlementsDtoOutputCaptainsInner',
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
