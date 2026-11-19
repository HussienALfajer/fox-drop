// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_documents_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainDocumentsDtoOutput extends CaptainDocumentsDtoOutput {
  @override
  final BuiltList<CaptainDocumentsDtoOutputDocumentsInner> documents;

  factory _$CaptainDocumentsDtoOutput([
    void Function(CaptainDocumentsDtoOutputBuilder)? updates,
  ]) => (CaptainDocumentsDtoOutputBuilder()..update(updates))._build();

  _$CaptainDocumentsDtoOutput._({required this.documents}) : super._();
  @override
  CaptainDocumentsDtoOutput rebuild(
    void Function(CaptainDocumentsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDocumentsDtoOutputBuilder toBuilder() =>
      CaptainDocumentsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDocumentsDtoOutput && documents == other.documents;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, documents.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CaptainDocumentsDtoOutput',
    )..add('documents', documents)).toString();
  }
}

class CaptainDocumentsDtoOutputBuilder
    implements
        Builder<CaptainDocumentsDtoOutput, CaptainDocumentsDtoOutputBuilder> {
  _$CaptainDocumentsDtoOutput? _$v;

  ListBuilder<CaptainDocumentsDtoOutputDocumentsInner>? _documents;
  ListBuilder<CaptainDocumentsDtoOutputDocumentsInner> get documents =>
      _$this._documents ??=
          ListBuilder<CaptainDocumentsDtoOutputDocumentsInner>();
  set documents(
    ListBuilder<CaptainDocumentsDtoOutputDocumentsInner>? documents,
  ) => _$this._documents = documents;

  CaptainDocumentsDtoOutputBuilder() {
    CaptainDocumentsDtoOutput._defaults(this);
  }

  CaptainDocumentsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _documents = $v.documents.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDocumentsDtoOutput other) {
    _$v = other as _$CaptainDocumentsDtoOutput;
  }

  @override
  void update(void Function(CaptainDocumentsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDocumentsDtoOutput build() => _build();

  _$CaptainDocumentsDtoOutput _build() {
    _$CaptainDocumentsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$CaptainDocumentsDtoOutput._(documents: documents.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'documents';
        documents.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainDocumentsDtoOutput',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
