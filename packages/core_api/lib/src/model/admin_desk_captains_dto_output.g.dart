// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_desk_captains_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDeskCaptainsDtoOutput extends AdminDeskCaptainsDtoOutput {
  @override
  final BuiltList<AdminDeskCaptainsDtoOutputCaptainsInner> captains;

  factory _$AdminDeskCaptainsDtoOutput([
    void Function(AdminDeskCaptainsDtoOutputBuilder)? updates,
  ]) => (AdminDeskCaptainsDtoOutputBuilder()..update(updates))._build();

  _$AdminDeskCaptainsDtoOutput._({required this.captains}) : super._();
  @override
  AdminDeskCaptainsDtoOutput rebuild(
    void Function(AdminDeskCaptainsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeskCaptainsDtoOutputBuilder toBuilder() =>
      AdminDeskCaptainsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeskCaptainsDtoOutput && captains == other.captains;
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
      r'AdminDeskCaptainsDtoOutput',
    )..add('captains', captains)).toString();
  }
}

class AdminDeskCaptainsDtoOutputBuilder
    implements
        Builder<AdminDeskCaptainsDtoOutput, AdminDeskCaptainsDtoOutputBuilder> {
  _$AdminDeskCaptainsDtoOutput? _$v;

  ListBuilder<AdminDeskCaptainsDtoOutputCaptainsInner>? _captains;
  ListBuilder<AdminDeskCaptainsDtoOutputCaptainsInner> get captains =>
      _$this._captains ??=
          ListBuilder<AdminDeskCaptainsDtoOutputCaptainsInner>();
  set captains(
    ListBuilder<AdminDeskCaptainsDtoOutputCaptainsInner>? captains,
  ) => _$this._captains = captains;

  AdminDeskCaptainsDtoOutputBuilder() {
    AdminDeskCaptainsDtoOutput._defaults(this);
  }

  AdminDeskCaptainsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captains = $v.captains.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeskCaptainsDtoOutput other) {
    _$v = other as _$AdminDeskCaptainsDtoOutput;
  }

  @override
  void update(void Function(AdminDeskCaptainsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeskCaptainsDtoOutput build() => _build();

  _$AdminDeskCaptainsDtoOutput _build() {
    _$AdminDeskCaptainsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminDeskCaptainsDtoOutput._(captains: captains.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'captains';
        captains.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDeskCaptainsDtoOutput',
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
