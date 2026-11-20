// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_this_device_check_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainThisDeviceCheckDtoOutput
    extends CaptainThisDeviceCheckDtoOutput {
  @override
  final CaptainDeviceCheckOutput? check;

  factory _$CaptainThisDeviceCheckDtoOutput([
    void Function(CaptainThisDeviceCheckDtoOutputBuilder)? updates,
  ]) => (CaptainThisDeviceCheckDtoOutputBuilder()..update(updates))._build();

  _$CaptainThisDeviceCheckDtoOutput._({this.check}) : super._();
  @override
  CaptainThisDeviceCheckDtoOutput rebuild(
    void Function(CaptainThisDeviceCheckDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainThisDeviceCheckDtoOutputBuilder toBuilder() =>
      CaptainThisDeviceCheckDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainThisDeviceCheckDtoOutput && check == other.check;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, check.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainThisDeviceCheckDtoOutput',
    )..add('check', check)).toString();
  }
}

class CaptainThisDeviceCheckDtoOutputBuilder
    implements
        Builder<
          CaptainThisDeviceCheckDtoOutput,
          CaptainThisDeviceCheckDtoOutputBuilder
        > {
  _$CaptainThisDeviceCheckDtoOutput? _$v;

  CaptainDeviceCheckOutputBuilder? _check;
  CaptainDeviceCheckOutputBuilder get check =>
      _$this._check ??= CaptainDeviceCheckOutputBuilder();
  set check(CaptainDeviceCheckOutputBuilder? check) => _$this._check = check;

  CaptainThisDeviceCheckDtoOutputBuilder() {
    CaptainThisDeviceCheckDtoOutput._defaults(this);
  }

  CaptainThisDeviceCheckDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _check = $v.check?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainThisDeviceCheckDtoOutput other) {
    _$v = other as _$CaptainThisDeviceCheckDtoOutput;
  }

  @override
  void update(void Function(CaptainThisDeviceCheckDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainThisDeviceCheckDtoOutput build() => _build();

  _$CaptainThisDeviceCheckDtoOutput _build() {
    _$CaptainThisDeviceCheckDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$CaptainThisDeviceCheckDtoOutput._(check: _check?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'check';
        _check?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainThisDeviceCheckDtoOutput',
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
