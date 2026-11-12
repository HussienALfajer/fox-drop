// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_city_office_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCityOfficeDtoOutput extends AdminCityOfficeDtoOutput {
  @override
  final AdminCityOfficeDtoOutputOffice? office;

  factory _$AdminCityOfficeDtoOutput([
    void Function(AdminCityOfficeDtoOutputBuilder)? updates,
  ]) => (AdminCityOfficeDtoOutputBuilder()..update(updates))._build();

  _$AdminCityOfficeDtoOutput._({this.office}) : super._();
  @override
  AdminCityOfficeDtoOutput rebuild(
    void Function(AdminCityOfficeDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCityOfficeDtoOutputBuilder toBuilder() =>
      AdminCityOfficeDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCityOfficeDtoOutput && office == other.office;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, office.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCityOfficeDtoOutput',
    )..add('office', office)).toString();
  }
}

class AdminCityOfficeDtoOutputBuilder
    implements
        Builder<AdminCityOfficeDtoOutput, AdminCityOfficeDtoOutputBuilder> {
  _$AdminCityOfficeDtoOutput? _$v;

  AdminCityOfficeDtoOutputOfficeBuilder? _office;
  AdminCityOfficeDtoOutputOfficeBuilder get office =>
      _$this._office ??= AdminCityOfficeDtoOutputOfficeBuilder();
  set office(AdminCityOfficeDtoOutputOfficeBuilder? office) =>
      _$this._office = office;

  AdminCityOfficeDtoOutputBuilder() {
    AdminCityOfficeDtoOutput._defaults(this);
  }

  AdminCityOfficeDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _office = $v.office?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCityOfficeDtoOutput other) {
    _$v = other as _$AdminCityOfficeDtoOutput;
  }

  @override
  void update(void Function(AdminCityOfficeDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCityOfficeDtoOutput build() => _build();

  _$AdminCityOfficeDtoOutput _build() {
    _$AdminCityOfficeDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminCityOfficeDtoOutput._(office: _office?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'office';
        _office?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCityOfficeDtoOutput',
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
