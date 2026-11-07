// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_contact_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminContactDtoOutput extends AdminContactDtoOutput {
  @override
  final String? phone;
  @override
  final String? whatsapp;

  factory _$AdminContactDtoOutput([
    void Function(AdminContactDtoOutputBuilder)? updates,
  ]) => (AdminContactDtoOutputBuilder()..update(updates))._build();

  _$AdminContactDtoOutput._({this.phone, this.whatsapp}) : super._();
  @override
  AdminContactDtoOutput rebuild(
    void Function(AdminContactDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminContactDtoOutputBuilder toBuilder() =>
      AdminContactDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminContactDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminContactDtoOutput')
          ..add('phone', phone)
          ..add('whatsapp', whatsapp))
        .toString();
  }
}

class AdminContactDtoOutputBuilder
    implements Builder<AdminContactDtoOutput, AdminContactDtoOutputBuilder> {
  _$AdminContactDtoOutput? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _whatsapp;
  String? get whatsapp => _$this._whatsapp;
  set whatsapp(String? whatsapp) => _$this._whatsapp = whatsapp;

  AdminContactDtoOutputBuilder() {
    AdminContactDtoOutput._defaults(this);
  }

  AdminContactDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _whatsapp = $v.whatsapp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminContactDtoOutput other) {
    _$v = other as _$AdminContactDtoOutput;
  }

  @override
  void update(void Function(AdminContactDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminContactDtoOutput build() => _build();

  _$AdminContactDtoOutput _build() {
    final _$result =
        _$v ?? _$AdminContactDtoOutput._(phone: phone, whatsapp: whatsapp);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
