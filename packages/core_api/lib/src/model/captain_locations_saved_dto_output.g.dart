// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_locations_saved_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainLocationsSavedDtoOutput extends CaptainLocationsSavedDtoOutput {
  @override
  final int accepted;

  factory _$CaptainLocationsSavedDtoOutput([
    void Function(CaptainLocationsSavedDtoOutputBuilder)? updates,
  ]) => (CaptainLocationsSavedDtoOutputBuilder()..update(updates))._build();

  _$CaptainLocationsSavedDtoOutput._({required this.accepted}) : super._();
  @override
  CaptainLocationsSavedDtoOutput rebuild(
    void Function(CaptainLocationsSavedDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainLocationsSavedDtoOutputBuilder toBuilder() =>
      CaptainLocationsSavedDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainLocationsSavedDtoOutput &&
        accepted == other.accepted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainLocationsSavedDtoOutput',
    )..add('accepted', accepted)).toString();
  }
}

class CaptainLocationsSavedDtoOutputBuilder
    implements
        Builder<
          CaptainLocationsSavedDtoOutput,
          CaptainLocationsSavedDtoOutputBuilder
        > {
  _$CaptainLocationsSavedDtoOutput? _$v;

  int? _accepted;
  int? get accepted => _$this._accepted;
  set accepted(int? accepted) => _$this._accepted = accepted;

  CaptainLocationsSavedDtoOutputBuilder() {
    CaptainLocationsSavedDtoOutput._defaults(this);
  }

  CaptainLocationsSavedDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _accepted = $v.accepted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainLocationsSavedDtoOutput other) {
    _$v = other as _$CaptainLocationsSavedDtoOutput;
  }

  @override
  void update(void Function(CaptainLocationsSavedDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainLocationsSavedDtoOutput build() => _build();

  _$CaptainLocationsSavedDtoOutput _build() {
    final _$result =
        _$v ??
        _$CaptainLocationsSavedDtoOutput._(
          accepted: BuiltValueNullFieldError.checkNotNull(
            accepted,
            r'CaptainLocationsSavedDtoOutput',
            'accepted',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
