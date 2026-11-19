// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_documents_dto_output_documents_inner_rejection.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainDocumentsDtoOutputDocumentsInnerRejection
    extends CaptainDocumentsDtoOutputDocumentsInnerRejection {
  @override
  final String reason;
  @override
  final DateTime at;

  factory _$CaptainDocumentsDtoOutputDocumentsInnerRejection([
    void Function(CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder)?
    updates,
  ]) =>
      (CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder()
            ..update(updates))
          ._build();

  _$CaptainDocumentsDtoOutputDocumentsInnerRejection._({
    required this.reason,
    required this.at,
  }) : super._();
  @override
  CaptainDocumentsDtoOutputDocumentsInnerRejection rebuild(
    void Function(CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder toBuilder() =>
      CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDocumentsDtoOutputDocumentsInnerRejection &&
        reason == other.reason &&
        at == other.at;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainDocumentsDtoOutputDocumentsInnerRejection',
          )
          ..add('reason', reason)
          ..add('at', at))
        .toString();
  }
}

class CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder
    implements
        Builder<
          CaptainDocumentsDtoOutputDocumentsInnerRejection,
          CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder
        > {
  _$CaptainDocumentsDtoOutputDocumentsInnerRejection? _$v;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder() {
    CaptainDocumentsDtoOutputDocumentsInnerRejection._defaults(this);
  }

  CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _reason = $v.reason;
      _at = $v.at;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDocumentsDtoOutputDocumentsInnerRejection other) {
    _$v = other as _$CaptainDocumentsDtoOutputDocumentsInnerRejection;
  }

  @override
  void update(
    void Function(CaptainDocumentsDtoOutputDocumentsInnerRejectionBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDocumentsDtoOutputDocumentsInnerRejection build() => _build();

  _$CaptainDocumentsDtoOutputDocumentsInnerRejection _build() {
    final _$result =
        _$v ??
        _$CaptainDocumentsDtoOutputDocumentsInnerRejection._(
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'CaptainDocumentsDtoOutputDocumentsInnerRejection',
            'reason',
          ),
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainDocumentsDtoOutputDocumentsInnerRejection',
            'at',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
