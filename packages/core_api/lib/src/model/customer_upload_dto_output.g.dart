// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_upload_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerUploadDtoOutput extends CustomerUploadDtoOutput {
  @override
  final String uploadId;
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$CustomerUploadDtoOutput([
    void Function(CustomerUploadDtoOutputBuilder)? updates,
  ]) => (CustomerUploadDtoOutputBuilder()..update(updates))._build();

  _$CustomerUploadDtoOutput._({
    required this.uploadId,
    required this.url,
    required this.expiresAt,
  }) : super._();
  @override
  CustomerUploadDtoOutput rebuild(
    void Function(CustomerUploadDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerUploadDtoOutputBuilder toBuilder() =>
      CustomerUploadDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerUploadDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'CustomerUploadDtoOutput')
          ..add('uploadId', uploadId)
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class CustomerUploadDtoOutputBuilder
    implements
        Builder<CustomerUploadDtoOutput, CustomerUploadDtoOutputBuilder> {
  _$CustomerUploadDtoOutput? _$v;

  String? _uploadId;
  String? get uploadId => _$this._uploadId;
  set uploadId(String? uploadId) => _$this._uploadId = uploadId;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  CustomerUploadDtoOutputBuilder() {
    CustomerUploadDtoOutput._defaults(this);
  }

  CustomerUploadDtoOutputBuilder get _$this {
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
  void replace(CustomerUploadDtoOutput other) {
    _$v = other as _$CustomerUploadDtoOutput;
  }

  @override
  void update(void Function(CustomerUploadDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerUploadDtoOutput build() => _build();

  _$CustomerUploadDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerUploadDtoOutput._(
          uploadId: BuiltValueNullFieldError.checkNotNull(
            uploadId,
            r'CustomerUploadDtoOutput',
            'uploadId',
          ),
          url: BuiltValueNullFieldError.checkNotNull(
            url,
            r'CustomerUploadDtoOutput',
            'url',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'CustomerUploadDtoOutput',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
