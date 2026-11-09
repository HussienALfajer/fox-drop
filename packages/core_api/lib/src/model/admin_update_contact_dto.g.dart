// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_update_contact_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUpdateContactDto extends AdminUpdateContactDto {
  @override
  final String? phone;
  @override
  final String? whatsapp;

  factory _$AdminUpdateContactDto([
    void Function(AdminUpdateContactDtoBuilder)? updates,
  ]) => (AdminUpdateContactDtoBuilder()..update(updates))._build();

  _$AdminUpdateContactDto._({this.phone, this.whatsapp}) : super._();
  @override
  AdminUpdateContactDto rebuild(
    void Function(AdminUpdateContactDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminUpdateContactDtoBuilder toBuilder() =>
      AdminUpdateContactDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUpdateContactDto &&
        phone == other.phone &&
        whatsapp == other.whatsapp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, whatsapp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminUpdateContactDto')
          ..add('phone', phone)
          ..add('whatsapp', whatsapp))
        .toString();
  }
}

class AdminUpdateContactDtoBuilder
    implements Builder<AdminUpdateContactDto, AdminUpdateContactDtoBuilder> {
  _$AdminUpdateContactDto? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _whatsapp;
  String? get whatsapp => _$this._whatsapp;
  set whatsapp(String? whatsapp) => _$this._whatsapp = whatsapp;

  AdminUpdateContactDtoBuilder() {
    AdminUpdateContactDto._defaults(this);
  }

  AdminUpdateContactDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _whatsapp = $v.whatsapp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminUpdateContactDto other) {
    _$v = other as _$AdminUpdateContactDto;
  }

  @override
  void update(void Function(AdminUpdateContactDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUpdateContactDto build() => _build();

  _$AdminUpdateContactDto _build() {
    final _$result =
        _$v ?? _$AdminUpdateContactDto._(phone: phone, whatsapp: whatsapp);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
