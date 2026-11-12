// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_balances_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainBalancesDtoOutput extends AdminCaptainBalancesDtoOutput {
  @override
  final BuiltList<AdminCaptainBalancesDtoOutputCaptainsInner> captains;

  factory _$AdminCaptainBalancesDtoOutput([
    void Function(AdminCaptainBalancesDtoOutputBuilder)? updates,
  ]) => (AdminCaptainBalancesDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainBalancesDtoOutput._({required this.captains}) : super._();
  @override
  AdminCaptainBalancesDtoOutput rebuild(
    void Function(AdminCaptainBalancesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainBalancesDtoOutputBuilder toBuilder() =>
      AdminCaptainBalancesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainBalancesDtoOutput && captains == other.captains;
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
      r'AdminCaptainBalancesDtoOutput',
    )..add('captains', captains)).toString();
  }
}

class AdminCaptainBalancesDtoOutputBuilder
    implements
        Builder<
          AdminCaptainBalancesDtoOutput,
          AdminCaptainBalancesDtoOutputBuilder
        > {
  _$AdminCaptainBalancesDtoOutput? _$v;

  ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInner>? _captains;
  ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInner> get captains =>
      _$this._captains ??=
          ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInner>();
  set captains(
    ListBuilder<AdminCaptainBalancesDtoOutputCaptainsInner>? captains,
  ) => _$this._captains = captains;

  AdminCaptainBalancesDtoOutputBuilder() {
    AdminCaptainBalancesDtoOutput._defaults(this);
  }

  AdminCaptainBalancesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captains = $v.captains.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainBalancesDtoOutput other) {
    _$v = other as _$AdminCaptainBalancesDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainBalancesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainBalancesDtoOutput build() => _build();

  _$AdminCaptainBalancesDtoOutput _build() {
    _$AdminCaptainBalancesDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminCaptainBalancesDtoOutput._(captains: captains.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'captains';
        captains.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainBalancesDtoOutput',
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
