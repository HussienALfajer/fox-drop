// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_entries_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminManualEntriesDtoOutputEntriesInnerKindEnum
_$adminManualEntriesDtoOutputEntriesInnerKindEnum_adjustment =
    const AdminManualEntriesDtoOutputEntriesInnerKindEnum._('adjustment');
const AdminManualEntriesDtoOutputEntriesInnerKindEnum
_$adminManualEntriesDtoOutputEntriesInnerKindEnum_reversal =
    const AdminManualEntriesDtoOutputEntriesInnerKindEnum._('reversal');

AdminManualEntriesDtoOutputEntriesInnerKindEnum
_$adminManualEntriesDtoOutputEntriesInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'adjustment':
      return _$adminManualEntriesDtoOutputEntriesInnerKindEnum_adjustment;
    case 'reversal':
      return _$adminManualEntriesDtoOutputEntriesInnerKindEnum_reversal;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminManualEntriesDtoOutputEntriesInnerKindEnum>
_$adminManualEntriesDtoOutputEntriesInnerKindEnumValues =
    BuiltSet<AdminManualEntriesDtoOutputEntriesInnerKindEnum>(
      const <AdminManualEntriesDtoOutputEntriesInnerKindEnum>[
        _$adminManualEntriesDtoOutputEntriesInnerKindEnum_adjustment,
        _$adminManualEntriesDtoOutputEntriesInnerKindEnum_reversal,
      ],
    );

const AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum
_$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_captain =
    const AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum._('captain');
const AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum
_$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_restaurant =
    const AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum._('restaurant');
const AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum
_$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_customer =
    const AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum._('customer');

AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum
_$adminManualEntriesDtoOutputEntriesInnerPartyKindEnumValueOf(String name) {
  switch (name) {
    case 'captain':
      return _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_captain;
    case 'restaurant':
      return _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_restaurant;
    case 'customer':
      return _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_customer;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum>
_$adminManualEntriesDtoOutputEntriesInnerPartyKindEnumValues =
    BuiltSet<AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum>(
      const <AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum>[
        _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_captain,
        _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_restaurant,
        _$adminManualEntriesDtoOutputEntriesInnerPartyKindEnum_customer,
      ],
    );

Serializer<AdminManualEntriesDtoOutputEntriesInnerKindEnum>
_$adminManualEntriesDtoOutputEntriesInnerKindEnumSerializer =
    _$AdminManualEntriesDtoOutputEntriesInnerKindEnumSerializer();
Serializer<AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum>
_$adminManualEntriesDtoOutputEntriesInnerPartyKindEnumSerializer =
    _$AdminManualEntriesDtoOutputEntriesInnerPartyKindEnumSerializer();

class _$AdminManualEntriesDtoOutputEntriesInnerKindEnumSerializer
    implements
        PrimitiveSerializer<AdminManualEntriesDtoOutputEntriesInnerKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'adjustment': 'adjustment',
    'reversal': 'reversal',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'adjustment': 'adjustment',
    'reversal': 'reversal',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminManualEntriesDtoOutputEntriesInnerKindEnum,
  ];
  @override
  final String wireName = 'AdminManualEntriesDtoOutputEntriesInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminManualEntriesDtoOutputEntriesInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminManualEntriesDtoOutputEntriesInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminManualEntriesDtoOutputEntriesInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminManualEntriesDtoOutputEntriesInnerPartyKindEnumSerializer
    implements
        PrimitiveSerializer<
          AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum
        > {
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
    AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum,
  ];
  @override
  final String wireName =
      'AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminManualEntriesDtoOutputEntriesInner
    extends AdminManualEntriesDtoOutputEntriesInner {
  @override
  final String id;
  @override
  final AdminManualEntriesDtoOutputEntriesInnerKindEnum kind;
  @override
  final AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum partyKind;
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

  factory _$AdminManualEntriesDtoOutputEntriesInner([
    void Function(AdminManualEntriesDtoOutputEntriesInnerBuilder)? updates,
  ]) => (AdminManualEntriesDtoOutputEntriesInnerBuilder()..update(updates))
      ._build();

  _$AdminManualEntriesDtoOutputEntriesInner._({
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
  AdminManualEntriesDtoOutputEntriesInner rebuild(
    void Function(AdminManualEntriesDtoOutputEntriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualEntriesDtoOutputEntriesInnerBuilder toBuilder() =>
      AdminManualEntriesDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualEntriesDtoOutputEntriesInner &&
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
    return (newBuiltValueToStringHelper(
            r'AdminManualEntriesDtoOutputEntriesInner',
          )
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

class AdminManualEntriesDtoOutputEntriesInnerBuilder
    implements
        Builder<
          AdminManualEntriesDtoOutputEntriesInner,
          AdminManualEntriesDtoOutputEntriesInnerBuilder
        > {
  _$AdminManualEntriesDtoOutputEntriesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminManualEntriesDtoOutputEntriesInnerKindEnum? _kind;
  AdminManualEntriesDtoOutputEntriesInnerKindEnum? get kind => _$this._kind;
  set kind(AdminManualEntriesDtoOutputEntriesInnerKindEnum? kind) =>
      _$this._kind = kind;

  AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum? _partyKind;
  AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum? get partyKind =>
      _$this._partyKind;
  set partyKind(
    AdminManualEntriesDtoOutputEntriesInnerPartyKindEnum? partyKind,
  ) => _$this._partyKind = partyKind;

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

  AdminManualEntriesDtoOutputEntriesInnerBuilder() {
    AdminManualEntriesDtoOutputEntriesInner._defaults(this);
  }

  AdminManualEntriesDtoOutputEntriesInnerBuilder get _$this {
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
  void replace(AdminManualEntriesDtoOutputEntriesInner other) {
    _$v = other as _$AdminManualEntriesDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(AdminManualEntriesDtoOutputEntriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualEntriesDtoOutputEntriesInner build() => _build();

  _$AdminManualEntriesDtoOutputEntriesInner _build() {
    _$AdminManualEntriesDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminManualEntriesDtoOutputEntriesInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminManualEntriesDtoOutputEntriesInner',
              'id',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminManualEntriesDtoOutputEntriesInner',
              'kind',
            ),
            partyKind: BuiltValueNullFieldError.checkNotNull(
              partyKind,
              r'AdminManualEntriesDtoOutputEntriesInner',
              'partyKind',
            ),
            partyId: BuiltValueNullFieldError.checkNotNull(
              partyId,
              r'AdminManualEntriesDtoOutputEntriesInner',
              'partyId',
            ),
            partyName: BuiltValueNullFieldError.checkNotNull(
              partyName,
              r'AdminManualEntriesDtoOutputEntriesInner',
              'partyName',
            ),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminManualEntriesDtoOutputEntriesInner',
              'reason',
            ),
            adminId: BuiltValueNullFieldError.checkNotNull(
              adminId,
              r'AdminManualEntriesDtoOutputEntriesInner',
              'adminId',
            ),
            adminName: adminName,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'AdminManualEntriesDtoOutputEntriesInner',
              'createdAt',
            ),
            journal: journal.build(),
            corrects: _corrects?.build(),
            reversedBy: _reversedBy?.build(),
            reversible: BuiltValueNullFieldError.checkNotNull(
              reversible,
              r'AdminManualEntriesDtoOutputEntriesInner',
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
          r'AdminManualEntriesDtoOutputEntriesInner',
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
