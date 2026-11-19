// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_violations_dto_output_suspensions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum
_$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_active =
    const AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum._('active');
const AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum
_$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_suspended =
    const AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum._(
      'suspended',
    );
const AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum
_$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_terminated =
    const AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum._(
      'terminated',
    );

AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum
_$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'active':
      return _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_active;
    case 'suspended':
      return _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_suspended;
    case 'terminated':
      return _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum>
_$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnumValues =
    BuiltSet<AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum>(
      const <AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum>[
        _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_active,
        _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_suspended,
        _$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum_terminated,
      ],
    );

Serializer<AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum>
_$adminCaptainViolationsDtoOutputSuspensionsInnerStatusEnumSerializer =
    _$AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnumSerializer();

class _$AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum
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
    AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum,
  ];
  @override
  final String wireName =
      'AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainViolationsDtoOutputSuspensionsInner
    extends AdminCaptainViolationsDtoOutputSuspensionsInner {
  @override
  final DateTime at;
  @override
  final AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum status;
  @override
  final DateTime? until;
  @override
  final String? reason;
  @override
  final String? actorName;

  factory _$AdminCaptainViolationsDtoOutputSuspensionsInner([
    void Function(AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder)?
    updates,
  ]) =>
      (AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminCaptainViolationsDtoOutputSuspensionsInner._({
    required this.at,
    required this.status,
    this.until,
    this.reason,
    this.actorName,
  }) : super._();
  @override
  AdminCaptainViolationsDtoOutputSuspensionsInner rebuild(
    void Function(AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder toBuilder() =>
      AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainViolationsDtoOutputSuspensionsInner &&
        at == other.at &&
        status == other.status &&
        until == other.until &&
        reason == other.reason &&
        actorName == other.actorName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, actorName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainViolationsDtoOutputSuspensionsInner',
          )
          ..add('at', at)
          ..add('status', status)
          ..add('until', until)
          ..add('reason', reason)
          ..add('actorName', actorName))
        .toString();
  }
}

class AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder
    implements
        Builder<
          AdminCaptainViolationsDtoOutputSuspensionsInner,
          AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder
        > {
  _$AdminCaptainViolationsDtoOutputSuspensionsInner? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum? _status;
  AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum? get status =>
      _$this._status;
  set status(
    AdminCaptainViolationsDtoOutputSuspensionsInnerStatusEnum? status,
  ) => _$this._status = status;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _actorName;
  String? get actorName => _$this._actorName;
  set actorName(String? actorName) => _$this._actorName = actorName;

  AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder() {
    AdminCaptainViolationsDtoOutputSuspensionsInner._defaults(this);
  }

  AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _status = $v.status;
      _until = $v.until;
      _reason = $v.reason;
      _actorName = $v.actorName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainViolationsDtoOutputSuspensionsInner other) {
    _$v = other as _$AdminCaptainViolationsDtoOutputSuspensionsInner;
  }

  @override
  void update(
    void Function(AdminCaptainViolationsDtoOutputSuspensionsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainViolationsDtoOutputSuspensionsInner build() => _build();

  _$AdminCaptainViolationsDtoOutputSuspensionsInner _build() {
    final _$result =
        _$v ??
        _$AdminCaptainViolationsDtoOutputSuspensionsInner._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'AdminCaptainViolationsDtoOutputSuspensionsInner',
            'at',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminCaptainViolationsDtoOutputSuspensionsInner',
            'status',
          ),
          until: until,
          reason: reason,
          actorName: actorName,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
