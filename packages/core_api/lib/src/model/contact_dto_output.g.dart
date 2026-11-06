// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ContactDtoOutput extends ContactDtoOutput {
  @override
  final BuiltList<String> phone;
  @override
  final BuiltList<String> whatsapp;

  factory _$ContactDtoOutput([
    void Function(ContactDtoOutputBuilder)? updates,
  ]) => (ContactDtoOutputBuilder()..update(updates))._build();

  _$ContactDtoOutput._({required this.phone, required this.whatsapp})
    : super._();
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

  ListBuilder<String>? _phone;
  ListBuilder<String> get phone => _$this._phone ??= ListBuilder<String>();
  set phone(ListBuilder<String>? phone) => _$this._phone = phone;

  ListBuilder<String>? _whatsapp;
  ListBuilder<String> get whatsapp =>
      _$this._whatsapp ??= ListBuilder<String>();
  set whatsapp(ListBuilder<String>? whatsapp) => _$this._whatsapp = whatsapp;

  ContactDtoOutputBuilder() {
    ContactDtoOutput._defaults(this);
  }

  ContactDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _phone = $v.phone.toBuilder();
      _whatsapp = $v.whatsapp.toBuilder();
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
    _$ContactDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$ContactDtoOutput._(
            phone: phone.build(),
            whatsapp: whatsapp.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'phone';
        phone.build();
        _$failedField = 'whatsapp';
        whatsapp.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ContactDtoOutput',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
