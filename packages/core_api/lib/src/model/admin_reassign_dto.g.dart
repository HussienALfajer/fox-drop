// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reassign_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminReassignDtoCashEnum _$adminReassignDtoCashEnum_returned =
    const AdminReassignDtoCashEnum._('returned');
const AdminReassignDtoCashEnum _$adminReassignDtoCashEnum_notReturned =
    const AdminReassignDtoCashEnum._('notReturned');
const AdminReassignDtoCashEnum _$adminReassignDtoCashEnum_notPaid =
    const AdminReassignDtoCashEnum._('notPaid');

AdminReassignDtoCashEnum _$adminReassignDtoCashEnumValueOf(String name) {
  switch (name) {
    case 'returned':
      return _$adminReassignDtoCashEnum_returned;
    case 'notReturned':
      return _$adminReassignDtoCashEnum_notReturned;
    case 'notPaid':
      return _$adminReassignDtoCashEnum_notPaid;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminReassignDtoCashEnum> _$adminReassignDtoCashEnumValues =
    BuiltSet<AdminReassignDtoCashEnum>(const <AdminReassignDtoCashEnum>[
      _$adminReassignDtoCashEnum_returned,
      _$adminReassignDtoCashEnum_notReturned,
      _$adminReassignDtoCashEnum_notPaid,
    ]);

Serializer<AdminReassignDtoCashEnum> _$adminReassignDtoCashEnumSerializer =
    _$AdminReassignDtoCashEnumSerializer();

class _$AdminReassignDtoCashEnumSerializer
    implements PrimitiveSerializer<AdminReassignDtoCashEnum> {
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
  final Iterable<Type> types = const <Type>[AdminReassignDtoCashEnum];
  @override
  final String wireName = 'AdminReassignDtoCashEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminReassignDtoCashEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminReassignDtoCashEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminReassignDtoCashEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminReassignDto extends AdminReassignDto {
  @override
  final String reassignment;
  @override
  final bool captainFault;
  @override
  final AdminReassignDtoCashEnum? cash;
  @override
  final String reason;

  factory _$AdminReassignDto([
    void Function(AdminReassignDtoBuilder)? updates,
  ]) => (AdminReassignDtoBuilder()..update(updates))._build();

  _$AdminReassignDto._({
    required this.reassignment,
    required this.captainFault,
    this.cash,
    required this.reason,
  }) : super._();
  @override
  AdminReassignDto rebuild(void Function(AdminReassignDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminReassignDtoBuilder toBuilder() =>
      AdminReassignDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReassignDto &&
        reassignment == other.reassignment &&
        captainFault == other.captainFault &&
        cash == other.cash &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reassignment.hashCode);
    _$hash = $jc(_$hash, captainFault.hashCode);
    _$hash = $jc(_$hash, cash.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReassignDto')
          ..add('reassignment', reassignment)
          ..add('captainFault', captainFault)
          ..add('cash', cash)
          ..add('reason', reason))
        .toString();
  }
}

class AdminReassignDtoBuilder
    implements Builder<AdminReassignDto, AdminReassignDtoBuilder> {
  _$AdminReassignDto? _$v;

  String? _reassignment;
  String? get reassignment => _$this._reassignment;
  set reassignment(String? reassignment) => _$this._reassignment = reassignment;

  bool? _captainFault;
  bool? get captainFault => _$this._captainFault;
  set captainFault(bool? captainFault) => _$this._captainFault = captainFault;

  AdminReassignDtoCashEnum? _cash;
  AdminReassignDtoCashEnum? get cash => _$this._cash;
  set cash(AdminReassignDtoCashEnum? cash) => _$this._cash = cash;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminReassignDtoBuilder() {
    AdminReassignDto._defaults(this);
  }

  AdminReassignDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reassignment = $v.reassignment;
      _captainFault = $v.captainFault;
      _cash = $v.cash;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReassignDto other) {
    _$v = other as _$AdminReassignDto;
  }

  @override
  void update(void Function(AdminReassignDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminReassignDto build() => _build();

  _$AdminReassignDto _build() {
    final _$result =
        _$v ??
        _$AdminReassignDto._(
          reassignment: BuiltValueNullFieldError.checkNotNull(
            reassignment,
            r'AdminReassignDto',
            'reassignment',
          ),
          captainFault: BuiltValueNullFieldError.checkNotNull(
            captainFault,
            r'AdminReassignDto',
            'captainFault',
          ),
          cash: cash,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminReassignDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
