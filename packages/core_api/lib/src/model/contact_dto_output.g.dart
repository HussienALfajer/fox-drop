// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactDtoOutput extends ContactDtoOutput {
  @override
  final String? phone;
  @override
  final String? whatsapp;

  factory _$ContactDtoOutput([
    void Function(ContactDtoOutputBuilder)? updates,
  ]) => (ContactDtoOutputBuilder()..update(updates))._build();

  _$ContactDtoOutput._({this.phone, this.whatsapp}) : super._();
  @override
  ContactDtoOutput rebuild(void Function(ContactDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ContactDtoOutputBuilder toBuilder() =>
      ContactDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ContactDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'ContactDtoOutput')
          ..add('phone', phone)
          ..add('whatsapp', whatsapp))
        .toString();
  }
}

class ContactDtoOutputBuilder
    implements Builder<ContactDtoOutput, ContactDtoOutputBuilder> {
  _$ContactDtoOutput? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _whatsapp;
  String? get whatsapp => _$this._whatsapp;
  set whatsapp(String? whatsapp) => _$this._whatsapp = whatsapp;

  ContactDtoOutputBuilder() {
    ContactDtoOutput._defaults(this);
  }

  ContactDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _whatsapp = $v.whatsapp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ContactDtoOutput other) {
    _$v = other as _$ContactDtoOutput;
  }

  @override
  void update(void Function(ContactDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ContactDtoOutput build() => _build();

  _$ContactDtoOutput _build() {
    final _$result =
        _$v ?? _$ContactDtoOutput._(phone: phone, whatsapp: whatsapp);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
