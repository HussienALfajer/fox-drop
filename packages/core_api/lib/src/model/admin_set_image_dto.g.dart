// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_image_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetImageDto extends AdminSetImageDto {
  @override
  final String uploadId;

  factory _$AdminSetImageDto([
    void Function(AdminSetImageDtoBuilder)? updates,
  ]) => (AdminSetImageDtoBuilder()..update(updates))._build();

  _$AdminSetImageDto._({required this.uploadId}) : super._();
  @override
  AdminSetImageDto rebuild(void Function(AdminSetImageDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminSetImageDtoBuilder toBuilder() =>
      AdminSetImageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetImageDto && uploadId == other.uploadId;
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
      r'AdminSetImageDto',
    )..add('uploadId', uploadId)).toString();
  }
}

class AdminSetImageDtoBuilder
    implements Builder<AdminSetImageDto, AdminSetImageDtoBuilder> {
  _$AdminSetImageDto? _$v;

  String? _uploadId;
  String? get uploadId => _$this._uploadId;
  set uploadId(String? uploadId) => _$this._uploadId = uploadId;

  AdminSetImageDtoBuilder() {
    AdminSetImageDto._defaults(this);
  }

  AdminSetImageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uploadId = $v.uploadId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetImageDto other) {
    _$v = other as _$AdminSetImageDto;
  }

  @override
  void update(void Function(AdminSetImageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetImageDto build() => _build();

  _$AdminSetImageDto _build() {
    final _$result =
        _$v ??
        _$AdminSetImageDto._(
          uploadId: BuiltValueNullFieldError.checkNotNull(
            uploadId,
            r'AdminSetImageDto',
            'uploadId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
