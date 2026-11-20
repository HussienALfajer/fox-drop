// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_code_request_dto_device_signature.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantCodeRequestDtoDeviceSignature
    extends MerchantCodeRequestDtoDeviceSignature {
  @override
  final DateTime signedAt;
  @override
  final String signature;

  factory _$MerchantCodeRequestDtoDeviceSignature([
    void Function(MerchantCodeRequestDtoDeviceSignatureBuilder)? updates,
  ]) => (MerchantCodeRequestDtoDeviceSignatureBuilder()..update(updates))
      ._build();

  _$MerchantCodeRequestDtoDeviceSignature._({
    required this.signedAt,
    required this.signature,
  }) : super._();
  @override
  MerchantCodeRequestDtoDeviceSignature rebuild(
    void Function(MerchantCodeRequestDtoDeviceSignatureBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantCodeRequestDtoDeviceSignatureBuilder toBuilder() =>
      MerchantCodeRequestDtoDeviceSignatureBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantCodeRequestDtoDeviceSignature &&
        signedAt == other.signedAt &&
        signature == other.signature;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, signedAt.hashCode);
    _$hash = $jc(_$hash, signature.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantCodeRequestDtoDeviceSignature',
          )
          ..add('signedAt', signedAt)
          ..add('signature', signature))
        .toString();
  }
}

class MerchantCodeRequestDtoDeviceSignatureBuilder
    implements
        Builder<
          MerchantCodeRequestDtoDeviceSignature,
          MerchantCodeRequestDtoDeviceSignatureBuilder
        > {
  _$MerchantCodeRequestDtoDeviceSignature? _$v;

  DateTime? _signedAt;
  DateTime? get signedAt => _$this._signedAt;
  set signedAt(DateTime? signedAt) => _$this._signedAt = signedAt;

  String? _signature;
  String? get signature => _$this._signature;
  set signature(String? signature) => _$this._signature = signature;

  MerchantCodeRequestDtoDeviceSignatureBuilder() {
    MerchantCodeRequestDtoDeviceSignature._defaults(this);
  }

  MerchantCodeRequestDtoDeviceSignatureBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _signedAt = $v.signedAt;
      _signature = $v.signature;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantCodeRequestDtoDeviceSignature other) {
    _$v = other as _$MerchantCodeRequestDtoDeviceSignature;
  }

  @override
  void update(
    void Function(MerchantCodeRequestDtoDeviceSignatureBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantCodeRequestDtoDeviceSignature build() => _build();

  _$MerchantCodeRequestDtoDeviceSignature _build() {
    final _$result =
        _$v ??
        _$MerchantCodeRequestDtoDeviceSignature._(
          signedAt: BuiltValueNullFieldError.checkNotNull(
            signedAt,
            r'MerchantCodeRequestDtoDeviceSignature',
            'signedAt',
          ),
          signature: BuiltValueNullFieldError.checkNotNull(
            signature,
            r'MerchantCodeRequestDtoDeviceSignature',
            'signature',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
