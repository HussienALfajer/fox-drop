// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_texts_dto_output_contact.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTextsDtoOutputContact extends AdminTextsDtoOutputContact {
  @override
  final String? phone;
  @override
  final String? whatsapp;

  factory _$AdminTextsDtoOutputContact([
    void Function(AdminTextsDtoOutputContactBuilder)? updates,
  ]) => (AdminTextsDtoOutputContactBuilder()..update(updates))._build();

  _$AdminTextsDtoOutputContact._({this.phone, this.whatsapp}) : super._();
  @override
  AdminTextsDtoOutputContact rebuild(
    void Function(AdminTextsDtoOutputContactBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTextsDtoOutputContactBuilder toBuilder() =>
      AdminTextsDtoOutputContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTextsDtoOutputContact &&
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
    return (newBuiltValueToStringHelper(r'AdminTextsDtoOutputContact')
          ..add('phone', phone)
          ..add('whatsapp', whatsapp))
        .toString();
  }
}

class AdminTextsDtoOutputContactBuilder
    implements
        Builder<AdminTextsDtoOutputContact, AdminTextsDtoOutputContactBuilder> {
  _$AdminTextsDtoOutputContact? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _whatsapp;
  String? get whatsapp => _$this._whatsapp;
  set whatsapp(String? whatsapp) => _$this._whatsapp = whatsapp;

  AdminTextsDtoOutputContactBuilder() {
    AdminTextsDtoOutputContact._defaults(this);
  }

  AdminTextsDtoOutputContactBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _whatsapp = $v.whatsapp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTextsDtoOutputContact other) {
    _$v = other as _$AdminTextsDtoOutputContact;
  }

  @override
  void update(void Function(AdminTextsDtoOutputContactBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTextsDtoOutputContact build() => _build();

  _$AdminTextsDtoOutputContact _build() {
    final _$result =
        _$v ?? _$AdminTextsDtoOutputContact._(phone: phone, whatsapp: whatsapp);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
