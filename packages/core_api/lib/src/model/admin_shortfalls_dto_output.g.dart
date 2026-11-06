// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shortfalls_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminShortfallsDtoOutput extends AdminShortfallsDtoOutput {
  @override
  final BuiltList<AdminShortfallsDtoOutputShortfallsInner> shortfalls;

  factory _$AdminShortfallsDtoOutput([
    void Function(AdminShortfallsDtoOutputBuilder)? updates,
  ]) => (AdminShortfallsDtoOutputBuilder()..update(updates))._build();

  _$AdminShortfallsDtoOutput._({required this.shortfalls}) : super._();
  @override
  AdminShortfallsDtoOutput rebuild(
    void Function(AdminShortfallsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminShortfallsDtoOutputBuilder toBuilder() =>
      AdminShortfallsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminShortfallsDtoOutput && shortfalls == other.shortfalls;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, shortfalls.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminShortfallsDtoOutput',
    )..add('shortfalls', shortfalls)).toString();
  }
}

class AdminShortfallsDtoOutputBuilder
    implements
        Builder<AdminShortfallsDtoOutput, AdminShortfallsDtoOutputBuilder> {
  _$AdminShortfallsDtoOutput? _$v;

  ListBuilder<AdminShortfallsDtoOutputShortfallsInner>? _shortfalls;
  ListBuilder<AdminShortfallsDtoOutputShortfallsInner> get shortfalls =>
      _$this._shortfalls ??=
          ListBuilder<AdminShortfallsDtoOutputShortfallsInner>();
  set shortfalls(
    ListBuilder<AdminShortfallsDtoOutputShortfallsInner>? shortfalls,
  ) => _$this._shortfalls = shortfalls;

  AdminShortfallsDtoOutputBuilder() {
    AdminShortfallsDtoOutput._defaults(this);
  }

  AdminShortfallsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _shortfalls = $v.shortfalls.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminShortfallsDtoOutput other) {
    _$v = other as _$AdminShortfallsDtoOutput;
  }

  @override
  void update(void Function(AdminShortfallsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminShortfallsDtoOutput build() => _build();

  _$AdminShortfallsDtoOutput _build() {
    _$AdminShortfallsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminShortfallsDtoOutput._(shortfalls: shortfalls.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'shortfalls';
        shortfalls.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminShortfallsDtoOutput',
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
