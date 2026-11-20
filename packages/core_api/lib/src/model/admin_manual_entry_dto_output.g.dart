// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_entry_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminManualEntryDtoOutputKindEnum
_$adminManualEntryDtoOutputKindEnum_adjustment =
    const AdminManualEntryDtoOutputKindEnum._('adjustment');
const AdminManualEntryDtoOutputKindEnum
_$adminManualEntryDtoOutputKindEnum_reversal =
    const AdminManualEntryDtoOutputKindEnum._('reversal');

AdminManualEntryDtoOutputKindEnum _$adminManualEntryDtoOutputKindEnumValueOf(
  String name,
) {
  switch (name) {
    case 'adjustment':
      return _$adminManualEntryDtoOutputKindEnum_adjustment;
    case 'reversal':
      return _$adminManualEntryDtoOutputKindEnum_reversal;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminManualEntryDtoOutputKindEnum>
_$adminManualEntryDtoOutputKindEnumValues =
    BuiltSet<AdminManualEntryDtoOutputKindEnum>(
      const <AdminManualEntryDtoOutputKindEnum>[
        _$adminManualEntryDtoOutputKindEnum_adjustment,
        _$adminManualEntryDtoOutputKindEnum_reversal,
      ],
    );

const AdminManualEntryDtoOutputPartyKindEnum
_$adminManualEntryDtoOutputPartyKindEnum_captain =
    const AdminManualEntryDtoOutputPartyKindEnum._('captain');
const AdminManualEntryDtoOutputPartyKindEnum
_$adminManualEntryDtoOutputPartyKindEnum_restaurant =
    const AdminManualEntryDtoOutputPartyKindEnum._('restaurant');
const AdminManualEntryDtoOutputPartyKindEnum
_$adminManualEntryDtoOutputPartyKindEnum_customer =
    const AdminManualEntryDtoOutputPartyKindEnum._('customer');

AdminManualEntryDtoOutputPartyKindEnum
_$adminManualEntryDtoOutputPartyKindEnumValueOf(String name) {
  switch (name) {
    case 'captain':
      return _$adminManualEntryDtoOutputPartyKindEnum_captain;
    case 'restaurant':
      return _$adminManualEntryDtoOutputPartyKindEnum_restaurant;
    case 'customer':
      return _$adminManualEntryDtoOutputPartyKindEnum_customer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminManualEntryDtoOutputPartyKindEnum>
_$adminManualEntryDtoOutputPartyKindEnumValues =
    BuiltSet<AdminManualEntryDtoOutputPartyKindEnum>(
      const <AdminManualEntryDtoOutputPartyKindEnum>[
        _$adminManualEntryDtoOutputPartyKindEnum_captain,
        _$adminManualEntryDtoOutputPartyKindEnum_restaurant,
        _$adminManualEntryDtoOutputPartyKindEnum_customer,
      ],
    );

Serializer<AdminManualEntryDtoOutputKindEnum>
_$adminManualEntryDtoOutputKindEnumSerializer =
    _$AdminManualEntryDtoOutputKindEnumSerializer();
Serializer<AdminManualEntryDtoOutputPartyKindEnum>
_$adminManualEntryDtoOutputPartyKindEnumSerializer =
    _$AdminManualEntryDtoOutputPartyKindEnumSerializer();

class _$AdminManualEntryDtoOutputKindEnumSerializer
    implements PrimitiveSerializer<AdminManualEntryDtoOutputKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'adjustment': 'adjustment',
    'reversal': 'reversal',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'adjustment': 'adjustment',
    'reversal': 'reversal',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminManualEntryDtoOutputKindEnum];
  @override
  final String wireName = 'AdminManualEntryDtoOutputKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminManualEntryDtoOutputKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminManualEntryDtoOutputKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminManualEntryDtoOutputKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminManualEntryDtoOutputPartyKindEnumSerializer
    implements PrimitiveSerializer<AdminManualEntryDtoOutputPartyKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captain': 'captain',
    'restaurant': 'restaurant',
    'customer': 'customer',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain': 'captain',
    'restaurant': 'restaurant',
    'customer': 'customer',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminManualEntryDtoOutputPartyKindEnum,
  ];
  @override
  final String wireName = 'AdminManualEntryDtoOutputPartyKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminManualEntryDtoOutputPartyKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminManualEntryDtoOutputPartyKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminManualEntryDtoOutputPartyKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminManualEntryDtoOutput extends AdminManualEntryDtoOutput {
  @override
  final String id;
  @override
  final AdminManualEntryDtoOutputKindEnum kind;
  @override
  final AdminManualEntryDtoOutputPartyKindEnum partyKind;
  @override
  final String partyId;
  @override
  final String partyName;
  @override
  final String reason;
  @override
  final String adminId;
  @override
  final String? adminName;
  @override
  final DateTime createdAt;
  @override
  final AdminManualEntriesDtoOutputEntriesInnerJournal journal;
  @override
  final AdminManualEntriesDtoOutputEntriesInnerCorrects? corrects;
  @override
  final AdminManualEntriesDtoOutputEntriesInnerReversedBy? reversedBy;
  @override
  final bool reversible;
  @override
  final String? orderId;
  @override
  final String? orderNumber;

  factory _$AdminManualEntryDtoOutput([
    void Function(AdminManualEntryDtoOutputBuilder)? updates,
  ]) => (AdminManualEntryDtoOutputBuilder()..update(updates))._build();

  _$AdminManualEntryDtoOutput._({
    required this.id,
    required this.kind,
    required this.partyKind,
    required this.partyId,
    required this.partyName,
    required this.reason,
    required this.adminId,
    this.adminName,
    required this.createdAt,
    required this.journal,
    this.corrects,
    this.reversedBy,
    required this.reversible,
    this.orderId,
    this.orderNumber,
  }) : super._();
  @override
  AdminManualEntryDtoOutput rebuild(
    void Function(AdminManualEntryDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualEntryDtoOutputBuilder toBuilder() =>
      AdminManualEntryDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualEntryDtoOutput &&
        id == other.id &&
        kind == other.kind &&
        partyKind == other.partyKind &&
        partyId == other.partyId &&
        partyName == other.partyName &&
        reason == other.reason &&
        adminId == other.adminId &&
        adminName == other.adminName &&
        createdAt == other.createdAt &&
        journal == other.journal &&
        corrects == other.corrects &&
        reversedBy == other.reversedBy &&
        reversible == other.reversible &&
        orderId == other.orderId &&
        orderNumber == other.orderNumber;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, partyKind.hashCode);
    _$hash = $jc(_$hash, partyId.hashCode);
    _$hash = $jc(_$hash, partyName.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, adminId.hashCode);
    _$hash = $jc(_$hash, adminName.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, journal.hashCode);
    _$hash = $jc(_$hash, corrects.hashCode);
    _$hash = $jc(_$hash, reversedBy.hashCode);
    _$hash = $jc(_$hash, reversible.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminManualEntryDtoOutput')
          ..add('id', id)
          ..add('kind', kind)
          ..add('partyKind', partyKind)
          ..add('partyId', partyId)
          ..add('partyName', partyName)
          ..add('reason', reason)
          ..add('adminId', adminId)
          ..add('adminName', adminName)
          ..add('createdAt', createdAt)
          ..add('journal', journal)
          ..add('corrects', corrects)
          ..add('reversedBy', reversedBy)
          ..add('reversible', reversible)
          ..add('orderId', orderId)
          ..add('orderNumber', orderNumber))
        .toString();
  }
}

class AdminManualEntryDtoOutputBuilder
    implements
        Builder<AdminManualEntryDtoOutput, AdminManualEntryDtoOutputBuilder> {
  _$AdminManualEntryDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminManualEntryDtoOutputKindEnum? _kind;
  AdminManualEntryDtoOutputKindEnum? get kind => _$this._kind;
  set kind(AdminManualEntryDtoOutputKindEnum? kind) => _$this._kind = kind;

  AdminManualEntryDtoOutputPartyKindEnum? _partyKind;
  AdminManualEntryDtoOutputPartyKindEnum? get partyKind => _$this._partyKind;
  set partyKind(AdminManualEntryDtoOutputPartyKindEnum? partyKind) =>
      _$this._partyKind = partyKind;

  String? _partyId;
  String? get partyId => _$this._partyId;
  set partyId(String? partyId) => _$this._partyId = partyId;

  String? _partyName;
  String? get partyName => _$this._partyName;
  set partyName(String? partyName) => _$this._partyName = partyName;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _adminId;
  String? get adminId => _$this._adminId;
  set adminId(String? adminId) => _$this._adminId = adminId;

  String? _adminName;
  String? get adminName => _$this._adminName;
  set adminName(String? adminName) => _$this._adminName = adminName;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  AdminManualEntriesDtoOutputEntriesInnerJournalBuilder? _journal;
  AdminManualEntriesDtoOutputEntriesInnerJournalBuilder get journal =>
      _$this._journal ??=
          AdminManualEntriesDtoOutputEntriesInnerJournalBuilder();
  set journal(AdminManualEntriesDtoOutputEntriesInnerJournalBuilder? journal) =>
      _$this._journal = journal;

  AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder? _corrects;
  AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder get corrects =>
      _$this._corrects ??=
          AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder();
  set corrects(
    AdminManualEntriesDtoOutputEntriesInnerCorrectsBuilder? corrects,
  ) => _$this._corrects = corrects;

  AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder? _reversedBy;
  AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder get reversedBy =>
      _$this._reversedBy ??=
          AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder();
  set reversedBy(
    AdminManualEntriesDtoOutputEntriesInnerReversedByBuilder? reversedBy,
  ) => _$this._reversedBy = reversedBy;

  bool? _reversible;
  bool? get reversible => _$this._reversible;
  set reversible(bool? reversible) => _$this._reversible = reversible;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  AdminManualEntryDtoOutputBuilder() {
    AdminManualEntryDtoOutput._defaults(this);
  }

  AdminManualEntryDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _kind = $v.kind;
      _partyKind = $v.partyKind;
      _partyId = $v.partyId;
      _partyName = $v.partyName;
      _reason = $v.reason;
      _adminId = $v.adminId;
      _adminName = $v.adminName;
      _createdAt = $v.createdAt;
      _journal = $v.journal.toBuilder();
      _corrects = $v.corrects?.toBuilder();
      _reversedBy = $v.reversedBy?.toBuilder();
      _reversible = $v.reversible;
      _orderId = $v.orderId;
      _orderNumber = $v.orderNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminManualEntryDtoOutput other) {
    _$v = other as _$AdminManualEntryDtoOutput;
  }

  @override
  void update(void Function(AdminManualEntryDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualEntryDtoOutput build() => _build();

  _$AdminManualEntryDtoOutput _build() {
    _$AdminManualEntryDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminManualEntryDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminManualEntryDtoOutput',
              'id',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminManualEntryDtoOutput',
              'kind',
            ),
            partyKind: BuiltValueNullFieldError.checkNotNull(
              partyKind,
              r'AdminManualEntryDtoOutput',
              'partyKind',
            ),
            partyId: BuiltValueNullFieldError.checkNotNull(
              partyId,
              r'AdminManualEntryDtoOutput',
              'partyId',
            ),
            partyName: BuiltValueNullFieldError.checkNotNull(
              partyName,
              r'AdminManualEntryDtoOutput',
              'partyName',
            ),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminManualEntryDtoOutput',
              'reason',
            ),
            adminId: BuiltValueNullFieldError.checkNotNull(
              adminId,
              r'AdminManualEntryDtoOutput',
              'adminId',
            ),
            adminName: adminName,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminManualEntryDtoOutput',
              'createdAt',
            ),
            journal: journal.build(),
            corrects: _corrects?.build(),
            reversedBy: _reversedBy?.build(),
            reversible: BuiltValueNullFieldError.checkNotNull(
              reversible,
              r'AdminManualEntryDtoOutput',
              'reversible',
            ),
            orderId: orderId,
            orderNumber: orderNumber,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'journal';
        journal.build();
        _$failedField = 'corrects';
        _corrects?.build();
        _$failedField = 'reversedBy';
        _reversedBy?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminManualEntryDtoOutput',
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
