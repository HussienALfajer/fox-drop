// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_close_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketCloseDto extends AdminTicketCloseDto {
  @override
  final String cityId;
  @override
  final String reason;

  factory _$AdminTicketCloseDto([
    void Function(AdminTicketCloseDtoBuilder)? updates,
  ]) => (AdminTicketCloseDtoBuilder()..update(updates))._build();

  _$AdminTicketCloseDto._({required this.cityId, required this.reason})
    : super._();
  @override
  AdminTicketCloseDto rebuild(
    void Function(AdminTicketCloseDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketCloseDtoBuilder toBuilder() =>
      AdminTicketCloseDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketCloseDto &&
        cityId == other.cityId &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketCloseDto')
          ..add('cityId', cityId)
          ..add('reason', reason))
        .toString();
  }
}

class AdminTicketCloseDtoBuilder
    implements Builder<AdminTicketCloseDto, AdminTicketCloseDtoBuilder> {
  _$AdminTicketCloseDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminTicketCloseDtoBuilder() {
    AdminTicketCloseDto._defaults(this);
  }

  AdminTicketCloseDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketCloseDto other) {
    _$v = other as _$AdminTicketCloseDto;
  }

  @override
  void update(void Function(AdminTicketCloseDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketCloseDto build() => _build();

  _$AdminTicketCloseDto _build() {
    final _$result =
        _$v ??
        _$AdminTicketCloseDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminTicketCloseDto',
            'cityId',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminTicketCloseDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
