// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_appeal_body_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainAppealBodyDto extends CaptainAppealBodyDto {
  @override
  final String text;
  @override
  final String? photoUploadId;

  factory _$CaptainAppealBodyDto([
    void Function(CaptainAppealBodyDtoBuilder)? updates,
  ]) => (CaptainAppealBodyDtoBuilder()..update(updates))._build();

  _$CaptainAppealBodyDto._({required this.text, this.photoUploadId})
    : super._();
  @override
  CaptainAppealBodyDto rebuild(
    void Function(CaptainAppealBodyDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAppealBodyDtoBuilder toBuilder() =>
      CaptainAppealBodyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAppealBodyDto &&
        text == other.text &&
        photoUploadId == other.photoUploadId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, photoUploadId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainAppealBodyDto')
          ..add('text', text)
          ..add('photoUploadId', photoUploadId))
        .toString();
  }
}

class CaptainAppealBodyDtoBuilder
    implements Builder<CaptainAppealBodyDto, CaptainAppealBodyDtoBuilder> {
  _$CaptainAppealBodyDto? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _photoUploadId;
  String? get photoUploadId => _$this._photoUploadId;
  set photoUploadId(String? photoUploadId) =>
      _$this._photoUploadId = photoUploadId;

  CaptainAppealBodyDtoBuilder() {
    CaptainAppealBodyDto._defaults(this);
  }

  CaptainAppealBodyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _photoUploadId = $v.photoUploadId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAppealBodyDto other) {
    _$v = other as _$CaptainAppealBodyDto;
  }

  @override
  void update(void Function(CaptainAppealBodyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAppealBodyDto build() => _build();

  _$CaptainAppealBodyDto _build() {
    final _$result =
        _$v ??
        _$CaptainAppealBodyDto._(
          text: BuiltValueNullFieldError.checkNotNull(
            text,
            r'CaptainAppealBodyDto',
            'text',
          ),
          photoUploadId: photoUploadId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
