// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_reassignments_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderReassignmentsInnerCashEnum
_$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_returned =
    const AdminOrderDtoOutputOrderReassignmentsInnerCashEnum._('returned');
const AdminOrderDtoOutputOrderReassignmentsInnerCashEnum
_$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_notReturned =
    const AdminOrderDtoOutputOrderReassignmentsInnerCashEnum._('notReturned');
const AdminOrderDtoOutputOrderReassignmentsInnerCashEnum
_$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_notPaid =
    const AdminOrderDtoOutputOrderReassignmentsInnerCashEnum._('notPaid');

AdminOrderDtoOutputOrderReassignmentsInnerCashEnum
_$adminOrderDtoOutputOrderReassignmentsInnerCashEnumValueOf(String name) {
  switch (name) {
    case 'returned':
      return _$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_returned;
    case 'notReturned':
      return _$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_notReturned;
    case 'notPaid':
      return _$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_notPaid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderReassignmentsInnerCashEnum>
_$adminOrderDtoOutputOrderReassignmentsInnerCashEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderReassignmentsInnerCashEnum>(
      const <AdminOrderDtoOutputOrderReassignmentsInnerCashEnum>[
        _$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_returned,
        _$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_notReturned,
        _$adminOrderDtoOutputOrderReassignmentsInnerCashEnum_notPaid,
      ],
    );

Serializer<AdminOrderDtoOutputOrderReassignmentsInnerCashEnum>
_$adminOrderDtoOutputOrderReassignmentsInnerCashEnumSerializer =
    _$AdminOrderDtoOutputOrderReassignmentsInnerCashEnumSerializer();

class _$AdminOrderDtoOutputOrderReassignmentsInnerCashEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderReassignmentsInnerCashEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'returned': 'returned',
    'notReturned': 'not_returned',
    'notPaid': 'not_paid',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'returned': 'returned',
    'not_returned': 'notReturned',
    'not_paid': 'notPaid',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderReassignmentsInnerCashEnum,
  ];
  @override
  final String wireName = 'AdminOrderDtoOutputOrderReassignmentsInnerCashEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderReassignmentsInnerCashEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderReassignmentsInnerCashEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderReassignmentsInnerCashEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderReassignmentsInner
    extends AdminOrderDtoOutputOrderReassignmentsInner {
  @override
  final DateTime at;
  @override
  final String captainId;
  @override
  final String? captainName;
  @override
  final String reason;
  @override
  final String label;
  @override
  final bool captainFault;
  @override
  final AdminOrderDtoOutputOrderReassignmentsInnerCashEnum? cash;
  @override
  final String note;
  @override
  final String adminId;
  @override
  final DateTime? captainSeenAt;

  factory _$AdminOrderDtoOutputOrderReassignmentsInner([
    void Function(AdminOrderDtoOutputOrderReassignmentsInnerBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderReassignmentsInnerBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderReassignmentsInner._({
    required this.at,
    required this.captainId,
    this.captainName,
    required this.reason,
    required this.label,
    required this.captainFault,
    this.cash,
    required this.note,
    required this.adminId,
    this.captainSeenAt,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderReassignmentsInner rebuild(
    void Function(AdminOrderDtoOutputOrderReassignmentsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderReassignmentsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderReassignmentsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderReassignmentsInner &&
        at == other.at &&
        captainId == other.captainId &&
        captainName == other.captainName &&
        reason == other.reason &&
        label == other.label &&
        captainFault == other.captainFault &&
        cash == other.cash &&
        note == other.note &&
        adminId == other.adminId &&
        captainSeenAt == other.captainSeenAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, captainName.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, label.hashCode);
    _$hash = $jc(_$hash, captainFault.hashCode);
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, adminId.hashCode);
    _$hash = $jc(_$hash, captainSeenAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderReassignmentsInner',
          )
          ..add('at', at)
          ..add('captainId', captainId)
          ..add('captainName', captainName)
          ..add('reason', reason)
          ..add('label', label)
          ..add('captainFault', captainFault)
          ..add('cash', cash)
          ..add('note', note)
          ..add('adminId', adminId)
          ..add('captainSeenAt', captainSeenAt))
        .toString();
  }
}

class AdminOrderDtoOutputOrderReassignmentsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderReassignmentsInner,
          AdminOrderDtoOutputOrderReassignmentsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderReassignmentsInner? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  String? _captainName;
  String? get captainName => _$this._captainName;
  set captainName(String? captainName) => _$this._captainName = captainName;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _label;
  String? get label => _$this._label;
  set label(String? label) => _$this._label = label;

  bool? _captainFault;
  bool? get captainFault => _$this._captainFault;
  set captainFault(bool? captainFault) => _$this._captainFault = captainFault;

  AdminOrderDtoOutputOrderReassignmentsInnerCashEnum? _cash;
  AdminOrderDtoOutputOrderReassignmentsInnerCashEnum? get cash => _$this._cash;
  set cash(AdminOrderDtoOutputOrderReassignmentsInnerCashEnum? cash) =>
      _$this._cash = cash;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _adminId;
  String? get adminId => _$this._adminId;
  set adminId(String? adminId) => _$this._adminId = adminId;

  DateTime? _captainSeenAt;
  DateTime? get captainSeenAt => _$this._captainSeenAt;
  set captainSeenAt(DateTime? captainSeenAt) =>
      _$this._captainSeenAt = captainSeenAt;

  AdminOrderDtoOutputOrderReassignmentsInnerBuilder() {
    AdminOrderDtoOutputOrderReassignmentsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderReassignmentsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _captainId = $v.captainId;
      _captainName = $v.captainName;
      _reason = $v.reason;
      _label = $v.label;
      _captainFault = $v.captainFault;
      _cash = $v.cash;
      _note = $v.note;
      _adminId = $v.adminId;
      _captainSeenAt = $v.captainSeenAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderReassignmentsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderReassignmentsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderReassignmentsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderReassignmentsInner build() => _build();

  _$AdminOrderDtoOutputOrderReassignmentsInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderReassignmentsInner._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminOrderDtoOutputOrderReassignmentsInner',
            'at',
          ),
          captainId: BuiltValueNullFieldError.checkNotNull(
            captainId,
            r'AdminOrderDtoOutputOrderReassignmentsInner',
            'captainId',
          ),
          captainName: captainName,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminOrderDtoOutputOrderReassignmentsInner',
            'reason',
          ),
          label: BuiltValueNullFieldError.checkNotNull(
            label,
            r'AdminOrderDtoOutputOrderReassignmentsInner',
            'label',
          ),
          captainFault: BuiltValueNullFieldError.checkNotNull(
            captainFault,
            r'AdminOrderDtoOutputOrderReassignmentsInner',
            'captainFault',
          ),
          cash: cash,
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminOrderDtoOutputOrderReassignmentsInner',
            'note',
          ),
          adminId: BuiltValueNullFieldError.checkNotNull(
            adminId,
            r'AdminOrderDtoOutputOrderReassignmentsInner',
            'adminId',
          ),
          captainSeenAt: captainSeenAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
