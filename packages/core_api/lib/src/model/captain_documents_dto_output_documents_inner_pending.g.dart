// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_documents_dto_output_documents_inner_pending.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainDocumentsDtoOutputDocumentsInnerPending
    extends CaptainDocumentsDtoOutputDocumentsInnerPending {
  @override
  final Date? issueDate;
  @override
  final Date? expiresOn;
  @override
  final DateTime uploadedAt;

  factory _$CaptainDocumentsDtoOutputDocumentsInnerPending([
    void Function(CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder)?
    updates,
  ]) =>
      (CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder()..update(updates))
          ._build();

  _$CaptainDocumentsDtoOutputDocumentsInnerPending._({
    this.issueDate,
    this.expiresOn,
    required this.uploadedAt,
  }) : super._();
  @override
  CaptainDocumentsDtoOutputDocumentsInnerPending rebuild(
    void Function(CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder toBuilder() =>
      CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDocumentsDtoOutputDocumentsInnerPending &&
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
            r'CaptainDocumentsDtoOutputDocumentsInnerPending',
          )
          ..add('issueDate', issueDate)
          ..add('expiresOn', expiresOn)
          ..add('uploadedAt', uploadedAt))
        .toString();
  }
}

class CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder
    implements
        Builder<
          CaptainDocumentsDtoOutputDocumentsInnerPending,
          CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder
        > {
  _$CaptainDocumentsDtoOutputDocumentsInnerPending? _$v;

  Date? _issueDate;
  Date? get issueDate => _$this._issueDate;
  set issueDate(Date? issueDate) => _$this._issueDate = issueDate;

  Date? _expiresOn;
  Date? get expiresOn => _$this._expiresOn;
  set expiresOn(Date? expiresOn) => _$this._expiresOn = expiresOn;

  DateTime? _uploadedAt;
  DateTime? get uploadedAt => _$this._uploadedAt;
  set uploadedAt(DateTime? uploadedAt) => _$this._uploadedAt = uploadedAt;

  CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder() {
    CaptainDocumentsDtoOutputDocumentsInnerPending._defaults(this);
  }

  CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder get _$this {
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
  void replace(CaptainDocumentsDtoOutputDocumentsInnerPending other) {
    _$v = other as _$CaptainDocumentsDtoOutputDocumentsInnerPending;
  }

  @override
  void update(
    void Function(CaptainDocumentsDtoOutputDocumentsInnerPendingBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDocumentsDtoOutputDocumentsInnerPending build() => _build();

  _$CaptainDocumentsDtoOutputDocumentsInnerPending _build() {
    final _$result =
        _$v ??
        _$CaptainDocumentsDtoOutputDocumentsInnerPending._(
          issueDate: issueDate,
          expiresOn: expiresOn,
          uploadedAt: BuiltValueNullFieldError.checkNotNull(
            uploadedAt,
            r'CaptainDocumentsDtoOutputDocumentsInnerPending',
            'uploadedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
