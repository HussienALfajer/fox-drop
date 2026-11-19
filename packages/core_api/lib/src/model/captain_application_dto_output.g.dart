// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_application_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainApplicationDtoOutput extends CaptainApplicationDtoOutput {
  @override
  final CaptainApplicationDtoOutputApplication? application;

  factory _$CaptainApplicationDtoOutput([
    void Function(CaptainApplicationDtoOutputBuilder)? updates,
  ]) => (CaptainApplicationDtoOutputBuilder()..update(updates))._build();

  _$CaptainApplicationDtoOutput._({this.application}) : super._();
  @override
  CaptainApplicationDtoOutput rebuild(
    void Function(CaptainApplicationDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainApplicationDtoOutputBuilder toBuilder() =>
      CaptainApplicationDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainApplicationDtoOutput &&
        application == other.application;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, application.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainApplicationDtoOutput',
    )..add('application', application)).toString();
  }
}

class CaptainApplicationDtoOutputBuilder
    implements
        Builder<
          CaptainApplicationDtoOutput,
          CaptainApplicationDtoOutputBuilder
        > {
  _$CaptainApplicationDtoOutput? _$v;

  CaptainApplicationDtoOutputApplicationBuilder? _application;
  CaptainApplicationDtoOutputApplicationBuilder get application =>
      _$this._application ??= CaptainApplicationDtoOutputApplicationBuilder();
  set application(CaptainApplicationDtoOutputApplicationBuilder? application) =>
      _$this._application = application;

  CaptainApplicationDtoOutputBuilder() {
    CaptainApplicationDtoOutput._defaults(this);
  }

  CaptainApplicationDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _application = $v.application?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainApplicationDtoOutput other) {
    _$v = other as _$CaptainApplicationDtoOutput;
  }

  @override
  void update(void Function(CaptainApplicationDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainApplicationDtoOutput build() => _build();

  _$CaptainApplicationDtoOutput _build() {
    _$CaptainApplicationDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainApplicationDtoOutput._(application: _application?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'application';
        _application?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainApplicationDtoOutput',
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
