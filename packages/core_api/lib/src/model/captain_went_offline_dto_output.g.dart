// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_went_offline_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainWentOfflineDtoOutput extends CaptainWentOfflineDtoOutput {
  @override
  final CaptainWentOfflineDtoOutputHandIn? handIn;

  factory _$CaptainWentOfflineDtoOutput([
    void Function(CaptainWentOfflineDtoOutputBuilder)? updates,
  ]) => (CaptainWentOfflineDtoOutputBuilder()..update(updates))._build();

  _$CaptainWentOfflineDtoOutput._({this.handIn}) : super._();
  @override
  CaptainWentOfflineDtoOutput rebuild(
    void Function(CaptainWentOfflineDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainWentOfflineDtoOutputBuilder toBuilder() =>
      CaptainWentOfflineDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainWentOfflineDtoOutput && handIn == other.handIn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, handIn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainWentOfflineDtoOutput',
    )..add('handIn', handIn)).toString();
  }
}

class CaptainWentOfflineDtoOutputBuilder
    implements
        Builder<
          CaptainWentOfflineDtoOutput,
          CaptainWentOfflineDtoOutputBuilder
        > {
  _$CaptainWentOfflineDtoOutput? _$v;

  CaptainWentOfflineDtoOutputHandInBuilder? _handIn;
  CaptainWentOfflineDtoOutputHandInBuilder get handIn =>
      _$this._handIn ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set handIn(CaptainWentOfflineDtoOutputHandInBuilder? handIn) =>
      _$this._handIn = handIn;

  CaptainWentOfflineDtoOutputBuilder() {
    CaptainWentOfflineDtoOutput._defaults(this);
  }

  CaptainWentOfflineDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _handIn = $v.handIn?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainWentOfflineDtoOutput other) {
    _$v = other as _$CaptainWentOfflineDtoOutput;
  }

  @override
  void update(void Function(CaptainWentOfflineDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainWentOfflineDtoOutput build() => _build();

  _$CaptainWentOfflineDtoOutput _build() {
    _$CaptainWentOfflineDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$CaptainWentOfflineDtoOutput._(handIn: _handIn?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'handIn';
        _handIn?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainWentOfflineDtoOutput',
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
