// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_status_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminTicketStatusDtoStatusEnum
_$adminTicketStatusDtoStatusEnum_inProgress =
    const AdminTicketStatusDtoStatusEnum._('inProgress');
const AdminTicketStatusDtoStatusEnum _$adminTicketStatusDtoStatusEnum_waiting =
    const AdminTicketStatusDtoStatusEnum._('waiting');

AdminTicketStatusDtoStatusEnum _$adminTicketStatusDtoStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'inProgress':
      return _$adminTicketStatusDtoStatusEnum_inProgress;
    case 'waiting':
      return _$adminTicketStatusDtoStatusEnum_waiting;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminTicketStatusDtoStatusEnum>
_$adminTicketStatusDtoStatusEnumValues =
    BuiltSet<AdminTicketStatusDtoStatusEnum>(
      const <AdminTicketStatusDtoStatusEnum>[
        _$adminTicketStatusDtoStatusEnum_inProgress,
        _$adminTicketStatusDtoStatusEnum_waiting,
      ],
    );

Serializer<AdminTicketStatusDtoStatusEnum>
_$adminTicketStatusDtoStatusEnumSerializer =
    _$AdminTicketStatusDtoStatusEnumSerializer();

class _$AdminTicketStatusDtoStatusEnumSerializer
    implements PrimitiveSerializer<AdminTicketStatusDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'inProgress': 'in_progress',
    'waiting': 'waiting',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'in_progress': 'inProgress',
    'waiting': 'waiting',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminTicketStatusDtoStatusEnum];
  @override
  final String wireName = 'AdminTicketStatusDtoStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminTicketStatusDtoStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminTicketStatusDtoStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminTicketStatusDtoStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminTicketStatusDto extends AdminTicketStatusDto {
  @override
  final String cityId;
  @override
  final AdminTicketStatusDtoStatusEnum status;

  factory _$AdminTicketStatusDto([
    void Function(AdminTicketStatusDtoBuilder)? updates,
  ]) => (AdminTicketStatusDtoBuilder()..update(updates))._build();

  _$AdminTicketStatusDto._({required this.cityId, required this.status})
    : super._();
  @override
  AdminTicketStatusDto rebuild(
    void Function(AdminTicketStatusDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketStatusDtoBuilder toBuilder() =>
      AdminTicketStatusDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketStatusDto &&
        cityId == other.cityId &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketStatusDto')
          ..add('cityId', cityId)
          ..add('status', status))
        .toString();
  }
}

class AdminTicketStatusDtoBuilder
    implements Builder<AdminTicketStatusDto, AdminTicketStatusDtoBuilder> {
  _$AdminTicketStatusDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminTicketStatusDtoStatusEnum? _status;
  AdminTicketStatusDtoStatusEnum? get status => _$this._status;
  set status(AdminTicketStatusDtoStatusEnum? status) => _$this._status = status;

  AdminTicketStatusDtoBuilder() {
    AdminTicketStatusDto._defaults(this);
  }

  AdminTicketStatusDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketStatusDto other) {
    _$v = other as _$AdminTicketStatusDto;
  }

  @override
  void update(void Function(AdminTicketStatusDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketStatusDto build() => _build();

  _$AdminTicketStatusDto _build() {
    final _$result =
        _$v ??
        _$AdminTicketStatusDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminTicketStatusDto',
            'cityId',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminTicketStatusDto',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
