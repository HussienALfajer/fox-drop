// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_drawer_sessions_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDrawerSessionsDtoOutput extends AdminDrawerSessionsDtoOutput {
  @override
  final BuiltList<AdminDrawerSessionsDtoOutputSessionsInner> sessions;

  factory _$AdminDrawerSessionsDtoOutput([
    void Function(AdminDrawerSessionsDtoOutputBuilder)? updates,
  ]) => (AdminDrawerSessionsDtoOutputBuilder()..update(updates))._build();

  _$AdminDrawerSessionsDtoOutput._({required this.sessions}) : super._();
  @override
  AdminDrawerSessionsDtoOutput rebuild(
    void Function(AdminDrawerSessionsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDrawerSessionsDtoOutputBuilder toBuilder() =>
      AdminDrawerSessionsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDrawerSessionsDtoOutput && sessions == other.sessions;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sessions.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminDrawerSessionsDtoOutput',
    )..add('sessions', sessions)).toString();
  }
}

class AdminDrawerSessionsDtoOutputBuilder
    implements
        Builder<
          AdminDrawerSessionsDtoOutput,
          AdminDrawerSessionsDtoOutputBuilder
        > {
  _$AdminDrawerSessionsDtoOutput? _$v;

  ListBuilder<AdminDrawerSessionsDtoOutputSessionsInner>? _sessions;
  ListBuilder<AdminDrawerSessionsDtoOutputSessionsInner> get sessions =>
      _$this._sessions ??=
          ListBuilder<AdminDrawerSessionsDtoOutputSessionsInner>();
  set sessions(
    ListBuilder<AdminDrawerSessionsDtoOutputSessionsInner>? sessions,
  ) => _$this._sessions = sessions;

  AdminDrawerSessionsDtoOutputBuilder() {
    AdminDrawerSessionsDtoOutput._defaults(this);
  }

  AdminDrawerSessionsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sessions = $v.sessions.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDrawerSessionsDtoOutput other) {
    _$v = other as _$AdminDrawerSessionsDtoOutput;
  }

  @override
  void update(void Function(AdminDrawerSessionsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDrawerSessionsDtoOutput build() => _build();

  _$AdminDrawerSessionsDtoOutput _build() {
    _$AdminDrawerSessionsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminDrawerSessionsDtoOutput._(sessions: sessions.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sessions';
        sessions.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDrawerSessionsDtoOutput',
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
