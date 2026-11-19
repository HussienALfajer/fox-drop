// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_item_photo_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantItemPhotoRequestDto extends MerchantItemPhotoRequestDto {
  @override
  final String uploadId;

  factory _$MerchantItemPhotoRequestDto([
    void Function(MerchantItemPhotoRequestDtoBuilder)? updates,
  ]) => (MerchantItemPhotoRequestDtoBuilder()..update(updates))._build();

  _$MerchantItemPhotoRequestDto._({required this.uploadId}) : super._();
  @override
  MerchantItemPhotoRequestDto rebuild(
    void Function(MerchantItemPhotoRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantItemPhotoRequestDtoBuilder toBuilder() =>
      MerchantItemPhotoRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantItemPhotoRequestDto && uploadId == other.uploadId;
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
      r'MerchantItemPhotoRequestDto',
    )..add('uploadId', uploadId)).toString();
  }
}

class MerchantItemPhotoRequestDtoBuilder
    implements
        Builder<
          MerchantItemPhotoRequestDto,
          MerchantItemPhotoRequestDtoBuilder
        > {
  _$MerchantItemPhotoRequestDto? _$v;

  String? _uploadId;
  String? get uploadId => _$this._uploadId;
  set uploadId(String? uploadId) => _$this._uploadId = uploadId;

  MerchantItemPhotoRequestDtoBuilder() {
    MerchantItemPhotoRequestDto._defaults(this);
  }

  MerchantItemPhotoRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uploadId = $v.uploadId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantItemPhotoRequestDto other) {
    _$v = other as _$MerchantItemPhotoRequestDto;
  }

  @override
  void update(void Function(MerchantItemPhotoRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantItemPhotoRequestDto build() => _build();

  _$MerchantItemPhotoRequestDto _build() {
    final _$result =
        _$v ??
        _$MerchantItemPhotoRequestDto._(
          uploadId: BuiltValueNullFieldError.checkNotNull(
            uploadId,
            r'MerchantItemPhotoRequestDto',
            'uploadId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
