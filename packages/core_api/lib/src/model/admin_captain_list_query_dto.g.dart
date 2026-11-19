// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_list_query_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainListQueryDtoStatusEnum
_$adminCaptainListQueryDtoStatusEnum_online =
    const AdminCaptainListQueryDtoStatusEnum._('online');
const AdminCaptainListQueryDtoStatusEnum
_$adminCaptainListQueryDtoStatusEnum_busy =
    const AdminCaptainListQueryDtoStatusEnum._('busy');
const AdminCaptainListQueryDtoStatusEnum
_$adminCaptainListQueryDtoStatusEnum_offline =
    const AdminCaptainListQueryDtoStatusEnum._('offline');
const AdminCaptainListQueryDtoStatusEnum
_$adminCaptainListQueryDtoStatusEnum_suspended =
    const AdminCaptainListQueryDtoStatusEnum._('suspended');
const AdminCaptainListQueryDtoStatusEnum
_$adminCaptainListQueryDtoStatusEnum_cashBlocked =
    const AdminCaptainListQueryDtoStatusEnum._('cashBlocked');
const AdminCaptainListQueryDtoStatusEnum
_$adminCaptainListQueryDtoStatusEnum_terminated =
    const AdminCaptainListQueryDtoStatusEnum._('terminated');

AdminCaptainListQueryDtoStatusEnum _$adminCaptainListQueryDtoStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'online':
      return _$adminCaptainListQueryDtoStatusEnum_online;
    case 'busy':
      return _$adminCaptainListQueryDtoStatusEnum_busy;
    case 'offline':
      return _$adminCaptainListQueryDtoStatusEnum_offline;
    case 'suspended':
      return _$adminCaptainListQueryDtoStatusEnum_suspended;
    case 'cashBlocked':
      return _$adminCaptainListQueryDtoStatusEnum_cashBlocked;
    case 'terminated':
      return _$adminCaptainListQueryDtoStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainListQueryDtoStatusEnum>
_$adminCaptainListQueryDtoStatusEnumValues =
    BuiltSet<AdminCaptainListQueryDtoStatusEnum>(
      const <AdminCaptainListQueryDtoStatusEnum>[
        _$adminCaptainListQueryDtoStatusEnum_online,
        _$adminCaptainListQueryDtoStatusEnum_busy,
        _$adminCaptainListQueryDtoStatusEnum_offline,
        _$adminCaptainListQueryDtoStatusEnum_suspended,
        _$adminCaptainListQueryDtoStatusEnum_cashBlocked,
        _$adminCaptainListQueryDtoStatusEnum_terminated,
      ],
    );

Serializer<AdminCaptainListQueryDtoStatusEnum>
_$adminCaptainListQueryDtoStatusEnumSerializer =
    _$AdminCaptainListQueryDtoStatusEnumSerializer();

class _$AdminCaptainListQueryDtoStatusEnumSerializer
    implements PrimitiveSerializer<AdminCaptainListQueryDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'online': 'online',
    'busy': 'busy',
    'offline': 'offline',
    'suspended': 'suspended',
    'cashBlocked': 'cash_blocked',
    'terminated': 'terminated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'online': 'online',
    'busy': 'busy',
    'offline': 'offline',
    'suspended': 'suspended',
    'cash_blocked': 'cashBlocked',
    'terminated': 'terminated',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminCaptainListQueryDtoStatusEnum];
  @override
  final String wireName = 'AdminCaptainListQueryDtoStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainListQueryDtoStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainListQueryDtoStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainListQueryDtoStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainListQueryDto extends AdminCaptainListQueryDto {
  @override
  final String cityId;
  @override
  final AdminCaptainListQueryDtoStatusEnum? status;
  @override
  final String? q;

  factory _$AdminCaptainListQueryDto([
    void Function(AdminCaptainListQueryDtoBuilder)? updates,
  ]) => (AdminCaptainListQueryDtoBuilder()..update(updates))._build();

  _$AdminCaptainListQueryDto._({required this.cityId, this.status, this.q})
    : super._();
  @override
  AdminCaptainListQueryDto rebuild(
    void Function(AdminCaptainListQueryDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainListQueryDtoBuilder toBuilder() =>
      AdminCaptainListQueryDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainListQueryDto &&
        cityId == other.cityId &&
        status == other.status &&
        q == other.q;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, q.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCaptainListQueryDto')
          ..add('cityId', cityId)
          ..add('status', status)
          ..add('q', q))
        .toString();
  }
}

class AdminCaptainListQueryDtoBuilder
    implements
        Builder<AdminCaptainListQueryDto, AdminCaptainListQueryDtoBuilder> {
  _$AdminCaptainListQueryDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminCaptainListQueryDtoStatusEnum? _status;
  AdminCaptainListQueryDtoStatusEnum? get status => _$this._status;
  set status(AdminCaptainListQueryDtoStatusEnum? status) =>
      _$this._status = status;

  String? _q;
  String? get q => _$this._q;
  set q(String? q) => _$this._q = q;

  AdminCaptainListQueryDtoBuilder() {
    AdminCaptainListQueryDto._defaults(this);
  }

  AdminCaptainListQueryDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _status = $v.status;
      _q = $v.q;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainListQueryDto other) {
    _$v = other as _$AdminCaptainListQueryDto;
  }

  @override
  void update(void Function(AdminCaptainListQueryDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainListQueryDto build() => _build();

  _$AdminCaptainListQueryDto _build() {
    final _$result =
        _$v ??
        _$AdminCaptainListQueryDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminCaptainListQueryDto',
            'cityId',
          ),
          status: status,
          q: q,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
