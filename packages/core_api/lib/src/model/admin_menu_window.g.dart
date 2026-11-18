// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_window.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuWindow extends AdminMenuWindow {
  @override
  final int startsAt;
  @override
  final int endsAt;

  factory _$AdminMenuWindow([void Function(AdminMenuWindowBuilder)? updates]) =>
      (AdminMenuWindowBuilder()..update(updates))._build();

  _$AdminMenuWindow._({required this.startsAt, required this.endsAt})
    : super._();
  @override
  AdminMenuWindow rebuild(void Function(AdminMenuWindowBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminMenuWindowBuilder toBuilder() => AdminMenuWindowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuWindow &&
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
    return (newBuiltValueToStringHelper(r'AdminMenuWindow')
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt))
        .toString();
  }
}

class AdminMenuWindowBuilder
    implements Builder<AdminMenuWindow, AdminMenuWindowBuilder> {
  _$AdminMenuWindow? _$v;

  int? _startsAt;
  int? get startsAt => _$this._startsAt;
  set startsAt(int? startsAt) => _$this._startsAt = startsAt;

  int? _endsAt;
  int? get endsAt => _$this._endsAt;
  set endsAt(int? endsAt) => _$this._endsAt = endsAt;

  AdminMenuWindowBuilder() {
    AdminMenuWindow._defaults(this);
  }

  AdminMenuWindowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuWindow other) {
    _$v = other as _$AdminMenuWindow;
  }

  @override
  void update(void Function(AdminMenuWindowBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuWindow build() => _build();

  _$AdminMenuWindow _build() {
    final _$result =
        _$v ??
        _$AdminMenuWindow._(
          startsAt: BuiltValueNullFieldError.checkNotNull(
            startsAt,
            r'AdminMenuWindow',
            'startsAt',
          ),
          endsAt: BuiltValueNullFieldError.checkNotNull(
            endsAt,
            r'AdminMenuWindow',
            'endsAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
