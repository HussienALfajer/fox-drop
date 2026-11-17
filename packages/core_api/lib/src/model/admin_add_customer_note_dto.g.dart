// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_add_customer_note_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAddCustomerNoteDto extends AdminAddCustomerNoteDto {
  @override
  final String cityId;
  @override
  final String body;

  factory _$AdminAddCustomerNoteDto([
    void Function(AdminAddCustomerNoteDtoBuilder)? updates,
  ]) => (AdminAddCustomerNoteDtoBuilder()..update(updates))._build();

  _$AdminAddCustomerNoteDto._({required this.cityId, required this.body})
    : super._();
  @override
  AdminAddCustomerNoteDto rebuild(
    void Function(AdminAddCustomerNoteDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminAddCustomerNoteDtoBuilder toBuilder() =>
      AdminAddCustomerNoteDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAddCustomerNoteDto &&
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
    return (newBuiltValueToStringHelper(r'AdminAddCustomerNoteDto')
          ..add('cityId', cityId)
          ..add('body', body))
        .toString();
  }
}

class AdminAddCustomerNoteDtoBuilder
    implements
        Builder<AdminAddCustomerNoteDto, AdminAddCustomerNoteDtoBuilder> {
  _$AdminAddCustomerNoteDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  AdminAddCustomerNoteDtoBuilder() {
    AdminAddCustomerNoteDto._defaults(this);
  }

  AdminAddCustomerNoteDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _body = $v.body;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAddCustomerNoteDto other) {
    _$v = other as _$AdminAddCustomerNoteDto;
  }

  @override
  void update(void Function(AdminAddCustomerNoteDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAddCustomerNoteDto build() => _build();

  _$AdminAddCustomerNoteDto _build() {
    final _$result =
        _$v ??
        _$AdminAddCustomerNoteDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminAddCustomerNoteDto',
            'cityId',
          ),
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminAddCustomerNoteDto',
            'body',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
