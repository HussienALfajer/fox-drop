// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_import_upload_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuImportUploadDto extends AdminMenuImportUploadDto {
  @override
  final String uploadId;

  factory _$AdminMenuImportUploadDto([
    void Function(AdminMenuImportUploadDtoBuilder)? updates,
  ]) => (AdminMenuImportUploadDtoBuilder()..update(updates))._build();

  _$AdminMenuImportUploadDto._({required this.uploadId}) : super._();
  @override
  AdminMenuImportUploadDto rebuild(
    void Function(AdminMenuImportUploadDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuImportUploadDtoBuilder toBuilder() =>
      AdminMenuImportUploadDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuImportUploadDto && uploadId == other.uploadId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, uploadId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminMenuImportUploadDto',
    )..add('uploadId', uploadId)).toString();
  }
}

class AdminMenuImportUploadDtoBuilder
    implements
        Builder<AdminMenuImportUploadDto, AdminMenuImportUploadDtoBuilder> {
  _$AdminMenuImportUploadDto? _$v;

  String? _uploadId;
  String? get uploadId => _$this._uploadId;
  set uploadId(String? uploadId) => _$this._uploadId = uploadId;

  AdminMenuImportUploadDtoBuilder() {
    AdminMenuImportUploadDto._defaults(this);
  }

  AdminMenuImportUploadDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uploadId = $v.uploadId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuImportUploadDto other) {
    _$v = other as _$AdminMenuImportUploadDto;
  }

  @override
  void update(void Function(AdminMenuImportUploadDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuImportUploadDto build() => _build();

  _$AdminMenuImportUploadDto _build() {
    final _$result =
        _$v ??
        _$AdminMenuImportUploadDto._(
          uploadId: BuiltValueNullFieldError.checkNotNull(
            uploadId,
            r'AdminMenuImportUploadDto',
            'uploadId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
