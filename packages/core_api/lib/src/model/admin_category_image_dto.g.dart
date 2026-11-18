// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_category_image_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCategoryImageDto extends AdminCategoryImageDto {
  @override
  final String uploadId;

  factory _$AdminCategoryImageDto([
    void Function(AdminCategoryImageDtoBuilder)? updates,
  ]) => (AdminCategoryImageDtoBuilder()..update(updates))._build();

  _$AdminCategoryImageDto._({required this.uploadId}) : super._();
  @override
  AdminCategoryImageDto rebuild(
    void Function(AdminCategoryImageDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCategoryImageDtoBuilder toBuilder() =>
      AdminCategoryImageDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCategoryImageDto && uploadId == other.uploadId;
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
      r'AdminCategoryImageDto',
    )..add('uploadId', uploadId)).toString();
  }
}

class AdminCategoryImageDtoBuilder
    implements Builder<AdminCategoryImageDto, AdminCategoryImageDtoBuilder> {
  _$AdminCategoryImageDto? _$v;

  String? _uploadId;
  String? get uploadId => _$this._uploadId;
  set uploadId(String? uploadId) => _$this._uploadId = uploadId;

  AdminCategoryImageDtoBuilder() {
    AdminCategoryImageDto._defaults(this);
  }

  AdminCategoryImageDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uploadId = $v.uploadId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCategoryImageDto other) {
    _$v = other as _$AdminCategoryImageDto;
  }

  @override
  void update(void Function(AdminCategoryImageDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCategoryImageDto build() => _build();

  _$AdminCategoryImageDto _build() {
    final _$result =
        _$v ??
        _$AdminCategoryImageDto._(
          uploadId: BuiltValueNullFieldError.checkNotNull(
            uploadId,
            r'AdminCategoryImageDto',
            'uploadId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
