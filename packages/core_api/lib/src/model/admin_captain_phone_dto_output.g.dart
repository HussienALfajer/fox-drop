// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_phone_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainPhoneDtoOutput extends AdminCaptainPhoneDtoOutput {
  @override
  final String? phone;

  factory _$AdminCaptainPhoneDtoOutput([
    void Function(AdminCaptainPhoneDtoOutputBuilder)? updates,
  ]) => (AdminCaptainPhoneDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainPhoneDtoOutput._({this.phone}) : super._();
  @override
  AdminCaptainPhoneDtoOutput rebuild(
    void Function(AdminCaptainPhoneDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainPhoneDtoOutputBuilder toBuilder() =>
      AdminCaptainPhoneDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainPhoneDtoOutput && phone == other.phone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCaptainPhoneDtoOutput',
    )..add('phone', phone)).toString();
  }
}

class AdminCaptainPhoneDtoOutputBuilder
    implements
        Builder<AdminCaptainPhoneDtoOutput, AdminCaptainPhoneDtoOutputBuilder> {
  _$AdminCaptainPhoneDtoOutput? _$v;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  AdminCaptainPhoneDtoOutputBuilder() {
    AdminCaptainPhoneDtoOutput._defaults(this);
  }

  AdminCaptainPhoneDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainPhoneDtoOutput other) {
    _$v = other as _$AdminCaptainPhoneDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainPhoneDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainPhoneDtoOutput build() => _build();

  _$AdminCaptainPhoneDtoOutput _build() {
    final _$result = _$v ?? _$AdminCaptainPhoneDtoOutput._(phone: phone);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
