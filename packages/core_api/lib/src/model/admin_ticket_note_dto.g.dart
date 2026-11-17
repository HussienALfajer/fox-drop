// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_note_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketNoteDto extends AdminTicketNoteDto {
  @override
  final String cityId;
  @override
  final String body;

  factory _$AdminTicketNoteDto([
    void Function(AdminTicketNoteDtoBuilder)? updates,
  ]) => (AdminTicketNoteDtoBuilder()..update(updates))._build();

  _$AdminTicketNoteDto._({required this.cityId, required this.body})
    : super._();
  @override
  AdminTicketNoteDto rebuild(
    void Function(AdminTicketNoteDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketNoteDtoBuilder toBuilder() =>
      AdminTicketNoteDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketNoteDto &&
        cityId == other.cityId &&
        body == other.body;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketNoteDto')
          ..add('cityId', cityId)
          ..add('body', body))
        .toString();
  }
}

class AdminTicketNoteDtoBuilder
    implements Builder<AdminTicketNoteDto, AdminTicketNoteDtoBuilder> {
  _$AdminTicketNoteDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  AdminTicketNoteDtoBuilder() {
    AdminTicketNoteDto._defaults(this);
  }

  AdminTicketNoteDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketNoteDto other) {
    _$v = other as _$AdminTicketNoteDto;
  }

  @override
  void update(void Function(AdminTicketNoteDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketNoteDto build() => _build();

  _$AdminTicketNoteDto _build() {
    final _$result =
        _$v ??
        _$AdminTicketNoteDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminTicketNoteDto',
            'cityId',
          ),
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminTicketNoteDto',
            'body',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
