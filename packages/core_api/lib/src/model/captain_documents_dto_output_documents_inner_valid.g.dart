// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_documents_dto_output_documents_inner_valid.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainDocumentsDtoOutputDocumentsInnerValid
    extends CaptainDocumentsDtoOutputDocumentsInnerValid {
  @override
  final Date? issueDate;
  @override
  final Date? expiresOn;
  @override
  final DateTime uploadedAt;

  factory _$CaptainDocumentsDtoOutputDocumentsInnerValid([
    void Function(CaptainDocumentsDtoOutputDocumentsInnerValidBuilder)? updates,
  ]) => (CaptainDocumentsDtoOutputDocumentsInnerValidBuilder()..update(updates))
      ._build();

  _$CaptainDocumentsDtoOutputDocumentsInnerValid._({
    this.issueDate,
    this.expiresOn,
    required this.uploadedAt,
  }) : super._();
  @override
  CaptainDocumentsDtoOutputDocumentsInnerValid rebuild(
    void Function(CaptainDocumentsDtoOutputDocumentsInnerValidBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDocumentsDtoOutputDocumentsInnerValidBuilder toBuilder() =>
      CaptainDocumentsDtoOutputDocumentsInnerValidBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDocumentsDtoOutputDocumentsInnerValid &&
        issueDate == other.issueDate &&
        expiresOn == other.expiresOn &&
        uploadedAt == other.uploadedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, issueDate.hashCode);
    _$hash = $jc(_$hash, expiresOn.hashCode);
    _$hash = $jc(_$hash, uploadedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainDocumentsDtoOutputDocumentsInnerValid',
          )
          ..add('issueDate', issueDate)
          ..add('expiresOn', expiresOn)
          ..add('uploadedAt', uploadedAt))
        .toString();
  }
}

class CaptainDocumentsDtoOutputDocumentsInnerValidBuilder
    implements
        Builder<
          CaptainDocumentsDtoOutputDocumentsInnerValid,
          CaptainDocumentsDtoOutputDocumentsInnerValidBuilder
        > {
  _$CaptainDocumentsDtoOutputDocumentsInnerValid? _$v;

  Date? _issueDate;
  Date? get issueDate => _$this._issueDate;
  set issueDate(Date? issueDate) => _$this._issueDate = issueDate;

  Date? _expiresOn;
  Date? get expiresOn => _$this._expiresOn;
  set expiresOn(Date? expiresOn) => _$this._expiresOn = expiresOn;

  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _$this._uploadedAt;
  set uploadedAt(DateTime? uploadedAt) => _$this._uploadedAt = uploadedAt;

  CaptainDocumentsDtoOutputDocumentsInnerValidBuilder() {
    CaptainDocumentsDtoOutputDocumentsInnerValid._defaults(this);
  }

  CaptainDocumentsDtoOutputDocumentsInnerValidBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _issueDate = $v.issueDate;
      _expiresOn = $v.expiresOn;
      _uploadedAt = $v.uploadedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDocumentsDtoOutputDocumentsInnerValid other) {
    _$v = other as _$CaptainDocumentsDtoOutputDocumentsInnerValid;
  }

  @override
  void update(
    void Function(CaptainDocumentsDtoOutputDocumentsInnerValidBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDocumentsDtoOutputDocumentsInnerValid build() => _build();

  _$CaptainDocumentsDtoOutputDocumentsInnerValid _build() {
    final _$result =
        _$v ??
        _$CaptainDocumentsDtoOutputDocumentsInnerValid._(
          issueDate: issueDate,
          expiresOn: expiresOn,
          uploadedAt: BuiltValueNullFieldError.checkNotNull(
            uploadedAt,
            r'CaptainDocumentsDtoOutputDocumentsInnerValid',
            'uploadedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
