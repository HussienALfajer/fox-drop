// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_windows_pairing_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantWindowsPairingDtoOutput
    extends MerchantWindowsPairingDtoOutput {
  @override
  final String code;
  @override
  final DateTime expiresAt;

  factory _$MerchantWindowsPairingDtoOutput([
    void Function(MerchantWindowsPairingDtoOutputBuilder)? updates,
  ]) => (MerchantWindowsPairingDtoOutputBuilder()..update(updates))._build();

  _$MerchantWindowsPairingDtoOutput._({
    required this.code,
    required this.expiresAt,
  }) : super._();
  @override
  MerchantWindowsPairingDtoOutput rebuild(
    void Function(MerchantWindowsPairingDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantWindowsPairingDtoOutputBuilder toBuilder() =>
      MerchantWindowsPairingDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantWindowsPairingDtoOutput &&
        code == other.code &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantWindowsPairingDtoOutput')
          ..add('code', code)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class MerchantWindowsPairingDtoOutputBuilder
    implements
        Builder<
          MerchantWindowsPairingDtoOutput,
          MerchantWindowsPairingDtoOutputBuilder
        > {
  _$MerchantWindowsPairingDtoOutput? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  MerchantWindowsPairingDtoOutputBuilder() {
    MerchantWindowsPairingDtoOutput._defaults(this);
  }

  MerchantWindowsPairingDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantWindowsPairingDtoOutput other) {
    _$v = other as _$MerchantWindowsPairingDtoOutput;
  }

  @override
  void update(void Function(MerchantWindowsPairingDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantWindowsPairingDtoOutput build() => _build();

  _$MerchantWindowsPairingDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantWindowsPairingDtoOutput._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'MerchantWindowsPairingDtoOutput',
            'code',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'MerchantWindowsPairingDtoOutput',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
