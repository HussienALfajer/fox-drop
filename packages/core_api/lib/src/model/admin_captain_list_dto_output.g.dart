// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainListDtoOutput extends AdminCaptainListDtoOutput {
  @override
  final BuiltList<AdminCaptainListDtoOutputCaptainsInner> captains;

  factory _$AdminCaptainListDtoOutput([
    void Function(AdminCaptainListDtoOutputBuilder)? updates,
  ]) => (AdminCaptainListDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainListDtoOutput._({required this.captains}) : super._();
  @override
  AdminCaptainListDtoOutput rebuild(
    void Function(AdminCaptainListDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainListDtoOutputBuilder toBuilder() =>
      AdminCaptainListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainListDtoOutput && captains == other.captains;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captains.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCaptainListDtoOutput',
    )..add('captains', captains)).toString();
  }
}

class AdminCaptainListDtoOutputBuilder
    implements
        Builder<AdminCaptainListDtoOutput, AdminCaptainListDtoOutputBuilder> {
  _$AdminCaptainListDtoOutput? _$v;

  ListBuilder<AdminCaptainListDtoOutputCaptainsInner>? _captains;
  ListBuilder<AdminCaptainListDtoOutputCaptainsInner> get captains =>
      _$this._captains ??=
          ListBuilder<AdminCaptainListDtoOutputCaptainsInner>();
  set captains(ListBuilder<AdminCaptainListDtoOutputCaptainsInner>? captains) =>
      _$this._captains = captains;

  AdminCaptainListDtoOutputBuilder() {
    AdminCaptainListDtoOutput._defaults(this);
  }

  AdminCaptainListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captains = $v.captains.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainListDtoOutput other) {
    _$v = other as _$AdminCaptainListDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainListDtoOutput build() => _build();

  _$AdminCaptainListDtoOutput _build() {
    _$AdminCaptainListDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminCaptainListDtoOutput._(captains: captains.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'captains';
        captains.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainListDtoOutput',
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
