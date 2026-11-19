// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_upload_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantUploadDtoOutput extends MerchantUploadDtoOutput {
  @override
  final String uploadId;
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$MerchantUploadDtoOutput([
    void Function(MerchantUploadDtoOutputBuilder)? updates,
  ]) => (MerchantUploadDtoOutputBuilder()..update(updates))._build();

  _$MerchantUploadDtoOutput._({
    required this.uploadId,
    required this.url,
    required this.expiresAt,
  }) : super._();
  @override
  MerchantUploadDtoOutput rebuild(
    void Function(MerchantUploadDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantUploadDtoOutputBuilder toBuilder() =>
      MerchantUploadDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantUploadDtoOutput &&
        uploadId == other.uploadId &&
        url == other.url &&
        expiresAt == other.expiresAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, uploadId.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantUploadDtoOutput')
          ..add('uploadId', uploadId)
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class MerchantUploadDtoOutputBuilder
    implements
        Builder<MerchantUploadDtoOutput, MerchantUploadDtoOutputBuilder> {
  _$MerchantUploadDtoOutput? _$v;

  String? _uploadId;
  String? get uploadId => _$this._uploadId;
  set uploadId(String? uploadId) => _$this._uploadId = uploadId;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  MerchantUploadDtoOutputBuilder() {
    MerchantUploadDtoOutput._defaults(this);
  }

  MerchantUploadDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uploadId = $v.uploadId;
      _url = $v.url;
      _expiresAt = $v.expiresAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantUploadDtoOutput other) {
    _$v = other as _$MerchantUploadDtoOutput;
  }

  @override
  void update(void Function(MerchantUploadDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantUploadDtoOutput build() => _build();

  _$MerchantUploadDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantUploadDtoOutput._(
          uploadId: BuiltValueNullFieldError.checkNotNull(
            uploadId,
            r'MerchantUploadDtoOutput',
            'uploadId',
          ),
          url: BuiltValueNullFieldError.checkNotNull(
            url,
            r'MerchantUploadDtoOutput',
            'url',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'MerchantUploadDtoOutput',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
