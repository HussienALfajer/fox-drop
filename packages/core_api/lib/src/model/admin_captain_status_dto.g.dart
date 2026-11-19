// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_status_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainStatusDtoStatusEnum
_$adminCaptainStatusDtoStatusEnum_suspended =
    const AdminCaptainStatusDtoStatusEnum._('suspended');
const AdminCaptainStatusDtoStatusEnum _$adminCaptainStatusDtoStatusEnum_active =
    const AdminCaptainStatusDtoStatusEnum._('active');

AdminCaptainStatusDtoStatusEnum _$adminCaptainStatusDtoStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'suspended':
      return _$adminCaptainStatusDtoStatusEnum_suspended;
    case 'active':
      return _$adminCaptainStatusDtoStatusEnum_active;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainStatusDtoStatusEnum>
_$adminCaptainStatusDtoStatusEnumValues =
    BuiltSet<AdminCaptainStatusDtoStatusEnum>(
      const <AdminCaptainStatusDtoStatusEnum>[
        _$adminCaptainStatusDtoStatusEnum_suspended,
        _$adminCaptainStatusDtoStatusEnum_active,
      ],
    );

Serializer<AdminCaptainStatusDtoStatusEnum>
_$adminCaptainStatusDtoStatusEnumSerializer =
    _$AdminCaptainStatusDtoStatusEnumSerializer();

class _$AdminCaptainStatusDtoStatusEnumSerializer
    implements PrimitiveSerializer<AdminCaptainStatusDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'suspended': 'suspended',
    'active': 'active',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'suspended': 'suspended',
    'active': 'active',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminCaptainStatusDtoStatusEnum];
  @override
  final String wireName = 'AdminCaptainStatusDtoStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainStatusDtoStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainStatusDtoStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainStatusDtoStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainStatusDto extends AdminCaptainStatusDto {
  @override
  final AdminCaptainStatusDtoStatusEnum status;
  @override
  final DateTime? until;
  @override
  final String reason;

  factory _$AdminCaptainStatusDto([
    void Function(AdminCaptainStatusDtoBuilder)? updates,
  ]) => (AdminCaptainStatusDtoBuilder()..update(updates))._build();

  _$AdminCaptainStatusDto._({
    required this.status,
    this.until,
    required this.reason,
  }) : super._();
  @override
  AdminCaptainStatusDto rebuild(
    void Function(AdminCaptainStatusDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainStatusDtoBuilder toBuilder() =>
      AdminCaptainStatusDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainStatusDto &&
        status == other.status &&
        until == other.until &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainStatusDto')
          ..add('status', status)
          ..add('until', until)
          ..add('reason', reason))
        .toString();
  }
}

class AdminCaptainStatusDtoBuilder
    implements Builder<AdminCaptainStatusDto, AdminCaptainStatusDtoBuilder> {
  _$AdminCaptainStatusDto? _$v;

  AdminCaptainStatusDtoStatusEnum? _status;
  AdminCaptainStatusDtoStatusEnum? get status => _$this._status;
  set status(AdminCaptainStatusDtoStatusEnum? status) =>
      _$this._status = status;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminCaptainStatusDtoBuilder() {
    AdminCaptainStatusDto._defaults(this);
  }

  AdminCaptainStatusDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _until = $v.until;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainStatusDto other) {
    _$v = other as _$AdminCaptainStatusDto;
  }

  @override
  void update(void Function(AdminCaptainStatusDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainStatusDto build() => _build();

  _$AdminCaptainStatusDto _build() {
    final _$result =
        _$v ??
        _$AdminCaptainStatusDto._(
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminCaptainStatusDto',
            'status',
          ),
          until: until,
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminCaptainStatusDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
