// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_peak_bonus_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPeakBonusDtoOutput extends CaptainPeakBonusDtoOutput {
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInner> windows;
  @override
  final BuiltList<CaptainPeakBonusDtoOutputActiveInner> active;

  factory _$CaptainPeakBonusDtoOutput([
    void Function(CaptainPeakBonusDtoOutputBuilder)? updates,
  ]) => (CaptainPeakBonusDtoOutputBuilder()..update(updates))._build();

  _$CaptainPeakBonusDtoOutput._({required this.windows, required this.active})
    : super._();
  @override
  CaptainPeakBonusDtoOutput rebuild(
    void Function(CaptainPeakBonusDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPeakBonusDtoOutputBuilder toBuilder() =>
      CaptainPeakBonusDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPeakBonusDtoOutput &&
        windows == other.windows &&
        active == other.active;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, windows.hashCode);
    _$hash = $jc(_$hash, active.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainPeakBonusDtoOutput')
          ..add('windows', windows)
          ..add('active', active))
        .toString();
  }
}

class CaptainPeakBonusDtoOutputBuilder
    implements
        Builder<CaptainPeakBonusDtoOutput, CaptainPeakBonusDtoOutputBuilder> {
  _$CaptainPeakBonusDtoOutput? _$v;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInner>? _windows;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInner> get windows =>
      _$this._windows ??= ListBuilder<CaptainPeakBonusDtoOutputWindowsInner>();
  set windows(ListBuilder<CaptainPeakBonusDtoOutputWindowsInner>? windows) =>
      _$this._windows = windows;

  ListBuilder<CaptainPeakBonusDtoOutputActiveInner>? _active;
  ListBuilder<CaptainPeakBonusDtoOutputActiveInner> get active =>
      _$this._active ??= ListBuilder<CaptainPeakBonusDtoOutputActiveInner>();
  set active(ListBuilder<CaptainPeakBonusDtoOutputActiveInner>? active) =>
      _$this._active = active;

  CaptainPeakBonusDtoOutputBuilder() {
    CaptainPeakBonusDtoOutput._defaults(this);
  }

  CaptainPeakBonusDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _windows = $v.windows.toBuilder();
      _active = $v.active.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPeakBonusDtoOutput other) {
    _$v = other as _$CaptainPeakBonusDtoOutput;
  }

  @override
  void update(void Function(CaptainPeakBonusDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPeakBonusDtoOutput build() => _build();

  _$CaptainPeakBonusDtoOutput _build() {
    _$CaptainPeakBonusDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPeakBonusDtoOutput._(
            windows: windows.build(),
            active: active.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'windows';
        windows.build();
        _$failedField = 'active';
        active.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainPeakBonusDtoOutput',
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
