// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_window_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuWindowOutput extends AdminMenuWindowOutput {
  @override
  final int startsAt;
  @override
  final int endsAt;

  factory _$AdminMenuWindowOutput([
    void Function(AdminMenuWindowOutputBuilder)? updates,
  ]) => (AdminMenuWindowOutputBuilder()..update(updates))._build();

  _$AdminMenuWindowOutput._({required this.startsAt, required this.endsAt})
    : super._();
  @override
  AdminMenuWindowOutput rebuild(
    void Function(AdminMenuWindowOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuWindowOutputBuilder toBuilder() =>
      AdminMenuWindowOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuWindowOutput &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuWindowOutput')
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt))
        .toString();
  }
}

class AdminMenuWindowOutputBuilder
    implements Builder<AdminMenuWindowOutput, AdminMenuWindowOutputBuilder> {
  _$AdminMenuWindowOutput? _$v;

  int? _startsAt;
  int? get startsAt => _$this._startsAt;
  set startsAt(int? startsAt) => _$this._startsAt = startsAt;

  int? _endsAt;
  int? get endsAt => _$this._endsAt;
  set endsAt(int? endsAt) => _$this._endsAt = endsAt;

  AdminMenuWindowOutputBuilder() {
    AdminMenuWindowOutput._defaults(this);
  }

  AdminMenuWindowOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuWindowOutput other) {
    _$v = other as _$AdminMenuWindowOutput;
  }

  @override
  void update(void Function(AdminMenuWindowOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuWindowOutput build() => _build();

  _$AdminMenuWindowOutput _build() {
    final _$result =
        _$v ??
        _$AdminMenuWindowOutput._(
          startsAt: BuiltValueNullFieldError.checkNotNull(
            startsAt,
            r'AdminMenuWindowOutput',
            'startsAt',
          ),
          endsAt: BuiltValueNullFieldError.checkNotNull(
            endsAt,
            r'AdminMenuWindowOutput',
            'endsAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
