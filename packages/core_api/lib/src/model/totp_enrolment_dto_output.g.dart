// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'totp_enrolment_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$TotpEnrolmentDtoOutput extends TotpEnrolmentDtoOutput {
  @override
  final String secret;
  @override
  final String otpauthUri;

  factory _$TotpEnrolmentDtoOutput([
    void Function(TotpEnrolmentDtoOutputBuilder)? updates,
  ]) => (TotpEnrolmentDtoOutputBuilder()..update(updates))._build();

  _$TotpEnrolmentDtoOutput._({required this.secret, required this.otpauthUri})
    : super._();
  @override
  TotpEnrolmentDtoOutput rebuild(
    void Function(TotpEnrolmentDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  TotpEnrolmentDtoOutputBuilder toBuilder() =>
      TotpEnrolmentDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TotpEnrolmentDtoOutput &&
        secret == other.secret &&
        otpauthUri == other.otpauthUri;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, secret.hashCode);
    _$hash = $jc(_$hash, otpauthUri.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TotpEnrolmentDtoOutput')
          ..add('secret', secret)
          ..add('otpauthUri', otpauthUri))
        .toString();
  }
}

class TotpEnrolmentDtoOutputBuilder
    implements Builder<TotpEnrolmentDtoOutput, TotpEnrolmentDtoOutputBuilder> {
  _$TotpEnrolmentDtoOutput? _$v;

  String? _secret;
  String? get secret => _$this._secret;
  set secret(String? secret) => _$this._secret = secret;

  String? _otpauthUri;
  String? get otpauthUri => _$this._otpauthUri;
  set otpauthUri(String? otpauthUri) => _$this._otpauthUri = otpauthUri;

  TotpEnrolmentDtoOutputBuilder() {
    TotpEnrolmentDtoOutput._defaults(this);
  }

  TotpEnrolmentDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _secret = $v.secret;
      _otpauthUri = $v.otpauthUri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TotpEnrolmentDtoOutput other) {
    _$v = other as _$TotpEnrolmentDtoOutput;
  }

  @override
  void update(void Function(TotpEnrolmentDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TotpEnrolmentDtoOutput build() => _build();

  _$TotpEnrolmentDtoOutput _build() {
    final _$result =
        _$v ??
        _$TotpEnrolmentDtoOutput._(
          secret: BuiltValueNullFieldError.checkNotNull(
            secret,
            r'TotpEnrolmentDtoOutput',
            'secret',
          ),
          otpauthUri: BuiltValueNullFieldError.checkNotNull(
            otpauthUri,
            r'TotpEnrolmentDtoOutput',
            'otpauthUri',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
