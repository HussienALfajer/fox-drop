// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_update_city_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminUpdateCityDtoStatusEnum _$adminUpdateCityDtoStatusEnum_active =
    const AdminUpdateCityDtoStatusEnum._('active');
const AdminUpdateCityDtoStatusEnum _$adminUpdateCityDtoStatusEnum_inactive =
    const AdminUpdateCityDtoStatusEnum._('inactive');

AdminUpdateCityDtoStatusEnum _$adminUpdateCityDtoStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'active':
      return _$adminUpdateCityDtoStatusEnum_active;
    case 'inactive':
      return _$adminUpdateCityDtoStatusEnum_inactive;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminUpdateCityDtoStatusEnum>
_$adminUpdateCityDtoStatusEnumValues = BuiltSet<AdminUpdateCityDtoStatusEnum>(
  const <AdminUpdateCityDtoStatusEnum>[
    _$adminUpdateCityDtoStatusEnum_active,
    _$adminUpdateCityDtoStatusEnum_inactive,
  ],
);

Serializer<AdminUpdateCityDtoStatusEnum>
_$adminUpdateCityDtoStatusEnumSerializer =
    _$AdminUpdateCityDtoStatusEnumSerializer();

class _$AdminUpdateCityDtoStatusEnumSerializer
    implements PrimitiveSerializer<AdminUpdateCityDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'inactive': 'inactive',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'inactive': 'inactive',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminUpdateCityDtoStatusEnum];
  @override
  final String wireName = 'AdminUpdateCityDtoStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminUpdateCityDtoStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminUpdateCityDtoStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminUpdateCityDtoStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminUpdateCityDto extends AdminUpdateCityDto {
  @override
  final String name;
  @override
  final String code;
  @override
  final String timeZone;
  @override
  final AdminUpdateCityDtoStatusEnum status;
  @override
  final String? reason;

  factory _$AdminUpdateCityDto([
    void Function(AdminUpdateCityDtoBuilder)? updates,
  ]) => (AdminUpdateCityDtoBuilder()..update(updates))._build();

  _$AdminUpdateCityDto._({
    required this.name,
    required this.code,
    required this.timeZone,
    required this.status,
    this.reason,
  }) : super._();
  @override
  AdminUpdateCityDto rebuild(
    void Function(AdminUpdateCityDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminUpdateCityDtoBuilder toBuilder() =>
      AdminUpdateCityDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUpdateCityDto &&
        name == other.name &&
        code == other.code &&
        timeZone == other.timeZone &&
        status == other.status &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, timeZone.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminUpdateCityDto')
          ..add('name', name)
          ..add('code', code)
          ..add('timeZone', timeZone)
          ..add('status', status)
          ..add('reason', reason))
        .toString();
  }
}

class AdminUpdateCityDtoBuilder
    implements Builder<AdminUpdateCityDto, AdminUpdateCityDtoBuilder> {
  _$AdminUpdateCityDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _timeZone;
  String? get timeZone => _$this._timeZone;
  set timeZone(String? timeZone) => _$this._timeZone = timeZone;

  AdminUpdateCityDtoStatusEnum? _status;
  AdminUpdateCityDtoStatusEnum? get status => _$this._status;
  set status(AdminUpdateCityDtoStatusEnum? status) => _$this._status = status;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminUpdateCityDtoBuilder() {
    AdminUpdateCityDto._defaults(this);
  }

  AdminUpdateCityDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _code = $v.code;
      _timeZone = $v.timeZone;
      _status = $v.status;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUpdateCityDto other) {
    _$v = other as _$AdminUpdateCityDto;
  }

  @override
  void update(void Function(AdminUpdateCityDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUpdateCityDto build() => _build();

  _$AdminUpdateCityDto _build() {
    final _$result =
        _$v ??
        _$AdminUpdateCityDto._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminUpdateCityDto',
            'name',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminUpdateCityDto',
            'code',
          ),
          timeZone: BuiltValueNullFieldError.checkNotNull(
            timeZone,
            r'AdminUpdateCityDto',
            'timeZone',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminUpdateCityDto',
            'status',
          ),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
