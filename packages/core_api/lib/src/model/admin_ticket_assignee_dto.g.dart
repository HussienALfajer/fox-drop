// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_assignee_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketAssigneeDto extends AdminTicketAssigneeDto {
  @override
  final String cityId;
  @override
  final String? assigneeId;

  factory _$AdminTicketAssigneeDto([
    void Function(AdminTicketAssigneeDtoBuilder)? updates,
  ]) => (AdminTicketAssigneeDtoBuilder()..update(updates))._build();

  _$AdminTicketAssigneeDto._({required this.cityId, this.assigneeId})
    : super._();
  @override
  AdminTicketAssigneeDto rebuild(
    void Function(AdminTicketAssigneeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketAssigneeDtoBuilder toBuilder() =>
      AdminTicketAssigneeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketAssigneeDto &&
        cityId == other.cityId &&
        assigneeId == other.assigneeId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, assigneeId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketAssigneeDto')
          ..add('cityId', cityId)
          ..add('assigneeId', assigneeId))
        .toString();
  }
}

class AdminTicketAssigneeDtoBuilder
    implements Builder<AdminTicketAssigneeDto, AdminTicketAssigneeDtoBuilder> {
  _$AdminTicketAssigneeDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _assigneeId;
  String? get assigneeId => _$this._assigneeId;
  set assigneeId(String? assigneeId) => _$this._assigneeId = assigneeId;

  AdminTicketAssigneeDtoBuilder() {
    AdminTicketAssigneeDto._defaults(this);
  }

  AdminTicketAssigneeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _assigneeId = $v.assigneeId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketAssigneeDto other) {
    _$v = other as _$AdminTicketAssigneeDto;
  }

  @override
  void update(void Function(AdminTicketAssigneeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketAssigneeDto build() => _build();

  _$AdminTicketAssigneeDto _build() {
    final _$result =
        _$v ??
        _$AdminTicketAssigneeDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminTicketAssigneeDto',
            'cityId',
          ),
          assigneeId: assigneeId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
