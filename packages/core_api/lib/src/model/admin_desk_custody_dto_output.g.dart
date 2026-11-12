// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_desk_custody_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDeskCustodyDtoOutputStatusEnum
_$adminDeskCustodyDtoOutputStatusEnum_active =
    const AdminDeskCustodyDtoOutputStatusEnum._('active');
const AdminDeskCustodyDtoOutputStatusEnum
_$adminDeskCustodyDtoOutputStatusEnum_suspended =
    const AdminDeskCustodyDtoOutputStatusEnum._('suspended');
const AdminDeskCustodyDtoOutputStatusEnum
_$adminDeskCustodyDtoOutputStatusEnum_terminated =
    const AdminDeskCustodyDtoOutputStatusEnum._('terminated');

AdminDeskCustodyDtoOutputStatusEnum
_$adminDeskCustodyDtoOutputStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$adminDeskCustodyDtoOutputStatusEnum_active;
    case 'suspended':
      return _$adminDeskCustodyDtoOutputStatusEnum_suspended;
    case 'terminated':
      return _$adminDeskCustodyDtoOutputStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDeskCustodyDtoOutputStatusEnum>
_$adminDeskCustodyDtoOutputStatusEnumValues =
    BuiltSet<AdminDeskCustodyDtoOutputStatusEnum>(
      const <AdminDeskCustodyDtoOutputStatusEnum>[
        _$adminDeskCustodyDtoOutputStatusEnum_active,
        _$adminDeskCustodyDtoOutputStatusEnum_suspended,
        _$adminDeskCustodyDtoOutputStatusEnum_terminated,
      ],
    );

Serializer<AdminDeskCustodyDtoOutputStatusEnum>
_$adminDeskCustodyDtoOutputStatusEnumSerializer =
    _$AdminDeskCustodyDtoOutputStatusEnumSerializer();

class _$AdminDeskCustodyDtoOutputStatusEnumSerializer
    implements PrimitiveSerializer<AdminDeskCustodyDtoOutputStatusEnum> {
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
    AdminDeskCustodyDtoOutputStatusEnum,
  ];
  @override
  final String wireName = 'AdminDeskCustodyDtoOutputStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDeskCustodyDtoOutputStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDeskCustodyDtoOutputStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDeskCustodyDtoOutputStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDeskCustodyDtoOutput extends AdminDeskCustodyDtoOutput {
  @override
  final String id;
  @override
  final String name;
  @override
  final AdminDeskCustodyDtoOutputStatusEnum status;
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
  final AdminDeskCustodyDtoOutputHandInGrace? handInGrace;

  factory _$AdminDeskCustodyDtoOutput([
    void Function(AdminDeskCustodyDtoOutputBuilder)? updates,
  ]) => (AdminDeskCustodyDtoOutputBuilder()..update(updates))._build();

  _$AdminDeskCustodyDtoOutput._({
    required this.id,
    required this.name,
    required this.status,
    required this.usage,
    required this.limit,
    required this.closedDue,
    required this.lastCutoff,
    required this.currencies,
    this.handInGrace,
  }) : super._();
  @override
  AdminDeskCustodyDtoOutput rebuild(
    void Function(AdminDeskCustodyDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeskCustodyDtoOutputBuilder toBuilder() =>
      AdminDeskCustodyDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeskCustodyDtoOutput &&
        id == other.id &&
        name == other.name &&
        status == other.status &&
        usage == other.usage &&
        limit == other.limit &&
        closedDue == other.closedDue &&
        lastCutoff == other.lastCutoff &&
        currencies == other.currencies &&
        handInGrace == other.handInGrace;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, usage.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, closedDue.hashCode);
    _$hash = $jc(_$hash, lastCutoff.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jc(_$hash, handInGrace.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDeskCustodyDtoOutput')
          ..add('id', id)
          ..add('name', name)
          ..add('status', status)
          ..add('usage', usage)
          ..add('limit', limit)
          ..add('closedDue', closedDue)
          ..add('lastCutoff', lastCutoff)
          ..add('currencies', currencies)
          ..add('handInGrace', handInGrace))
        .toString();
  }
}

class AdminDeskCustodyDtoOutputBuilder
    implements
        Builder<AdminDeskCustodyDtoOutput, AdminDeskCustodyDtoOutputBuilder> {
  _$AdminDeskCustodyDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminDeskCustodyDtoOutputStatusEnum? _status;
  AdminDeskCustodyDtoOutputStatusEnum? get status => _$this._status;
  set status(AdminDeskCustodyDtoOutputStatusEnum? status) =>
      _$this._status = status;

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

  AdminDeskCustodyDtoOutputHandInGraceBuilder? _handInGrace;
  AdminDeskCustodyDtoOutputHandInGraceBuilder get handInGrace =>
      _$this._handInGrace ??= AdminDeskCustodyDtoOutputHandInGraceBuilder();
  set handInGrace(AdminDeskCustodyDtoOutputHandInGraceBuilder? handInGrace) =>
      _$this._handInGrace = handInGrace;

  AdminDeskCustodyDtoOutputBuilder() {
    AdminDeskCustodyDtoOutput._defaults(this);
  }

  AdminDeskCustodyDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _status = $v.status;
      _usage = $v.usage.toBuilder();
      _limit = $v.limit.toBuilder();
      _closedDue = $v.closedDue.toBuilder();
      _lastCutoff = $v.lastCutoff;
      _currencies = $v.currencies.toBuilder();
      _handInGrace = $v.handInGrace?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeskCustodyDtoOutput other) {
    _$v = other as _$AdminDeskCustodyDtoOutput;
  }

  @override
  void update(void Function(AdminDeskCustodyDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeskCustodyDtoOutput build() => _build();

  _$AdminDeskCustodyDtoOutput _build() {
    _$AdminDeskCustodyDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminDeskCustodyDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminDeskCustodyDtoOutput',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminDeskCustodyDtoOutput',
              'name',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminDeskCustodyDtoOutput',
              'status',
            ),
            usage: usage.build(),
            limit: limit.build(),
            closedDue: closedDue.build(),
            lastCutoff: BuiltValueNullFieldError.checkNotNull(
              lastCutoff,
              r'AdminDeskCustodyDtoOutput',
              'lastCutoff',
            ),
            currencies: currencies.build(),
            handInGrace: _handInGrace?.build(),
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
        _$failedField = 'handInGrace';
        _handInGrace?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDeskCustodyDtoOutput',
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
