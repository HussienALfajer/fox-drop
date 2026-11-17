// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_report_body_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainReportBodyDto extends CaptainReportBodyDto {
  @override
  final String typeCode;
  @override
  final String? orderId;
  @override
  final String? note;
  @override
  final String? photoUploadId;

  factory _$CaptainReportBodyDto([
    void Function(CaptainReportBodyDtoBuilder)? updates,
  ]) => (CaptainReportBodyDtoBuilder()..update(updates))._build();

  _$CaptainReportBodyDto._({
    required this.typeCode,
    this.orderId,
    this.note,
    this.photoUploadId,
  }) : super._();
  @override
  CaptainReportBodyDto rebuild(
    void Function(CaptainReportBodyDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainReportBodyDtoBuilder toBuilder() =>
      CaptainReportBodyDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainReportBodyDto &&
        typeCode == other.typeCode &&
        orderId == other.orderId &&
        note == other.note &&
        photoUploadId == other.photoUploadId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, typeCode.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, photoUploadId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainReportBodyDto')
          ..add('typeCode', typeCode)
          ..add('orderId', orderId)
          ..add('note', note)
          ..add('photoUploadId', photoUploadId))
        .toString();
  }
}

class CaptainReportBodyDtoBuilder
    implements Builder<CaptainReportBodyDto, CaptainReportBodyDtoBuilder> {
  _$CaptainReportBodyDto? _$v;

  String? _typeCode;
  String? get typeCode => _$this._typeCode;
  set typeCode(String? typeCode) => _$this._typeCode = typeCode;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _photoUploadId;
  String? get photoUploadId => _$this._photoUploadId;
  set photoUploadId(String? photoUploadId) =>
      _$this._photoUploadId = photoUploadId;

  CaptainReportBodyDtoBuilder() {
    CaptainReportBodyDto._defaults(this);
  }

  CaptainReportBodyDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _typeCode = $v.typeCode;
      _orderId = $v.orderId;
      _note = $v.note;
      _photoUploadId = $v.photoUploadId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainReportBodyDto other) {
    _$v = other as _$CaptainReportBodyDto;
  }

  @override
  void update(void Function(CaptainReportBodyDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainReportBodyDto build() => _build();

  _$CaptainReportBodyDto _build() {
    final _$result =
        _$v ??
        _$CaptainReportBodyDto._(
          typeCode: BuiltValueNullFieldError.checkNotNull(
            typeCode,
            r'CaptainReportBodyDto',
            'typeCode',
          ),
          orderId: orderId,
          note: note,
          photoUploadId: photoUploadId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
