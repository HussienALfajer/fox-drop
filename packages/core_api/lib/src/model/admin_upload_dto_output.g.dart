// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_upload_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminUploadDtoOutput extends AdminUploadDtoOutput {
  @override
  final String uploadId;
  @override
  final String url;
  @override
  final DateTime expiresAt;

  factory _$AdminUploadDtoOutput([
    void Function(AdminUploadDtoOutputBuilder)? updates,
  ]) => (AdminUploadDtoOutputBuilder()..update(updates))._build();

  _$AdminUploadDtoOutput._({
    required this.uploadId,
    required this.url,
    required this.expiresAt,
  }) : super._();
  @override
  AdminUploadDtoOutput rebuild(
    void Function(AdminUploadDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminUploadDtoOutputBuilder toBuilder() =>
      AdminUploadDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUploadDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminUploadDtoOutput')
          ..add('uploadId', uploadId)
          ..add('url', url)
          ..add('expiresAt', expiresAt))
        .toString();
  }
}

class AdminUploadDtoOutputBuilder
    implements Builder<AdminUploadDtoOutput, AdminUploadDtoOutputBuilder> {
  _$AdminUploadDtoOutput? _$v;

  String? _uploadId;
  String? get uploadId => _$this._uploadId;
  set uploadId(String? uploadId) => _$this._uploadId = uploadId;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  AdminUploadDtoOutputBuilder() {
    AdminUploadDtoOutput._defaults(this);
  }

  AdminUploadDtoOutputBuilder get _$this {
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
  void replace(AdminUploadDtoOutput other) {
    _$v = other as _$AdminUploadDtoOutput;
  }

  @override
  void update(void Function(AdminUploadDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUploadDtoOutput build() => _build();

  _$AdminUploadDtoOutput _build() {
    final _$result =
        _$v ??
        _$AdminUploadDtoOutput._(
          uploadId: BuiltValueNullFieldError.checkNotNull(
            uploadId,
            r'AdminUploadDtoOutput',
            'uploadId',
          ),
          url: BuiltValueNullFieldError.checkNotNull(
            url,
            r'AdminUploadDtoOutput',
            'url',
          ),
          expiresAt: BuiltValueNullFieldError.checkNotNull(
            expiresAt,
            r'AdminUploadDtoOutput',
            'expiresAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
