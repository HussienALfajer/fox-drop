// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_document_replacement_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainDocumentReplacementDto extends CaptainDocumentReplacementDto {
  @override
  final BuiltList<String> uploadIds;
  @override
  final String? number;
  @override
  final Date? issueDate;

  factory _$CaptainDocumentReplacementDto([
    void Function(CaptainDocumentReplacementDtoBuilder)? updates,
  ]) => (CaptainDocumentReplacementDtoBuilder()..update(updates))._build();

  _$CaptainDocumentReplacementDto._({
    required this.uploadIds,
    this.number,
    this.issueDate,
  }) : super._();
  @override
  CaptainDocumentReplacementDto rebuild(
    void Function(CaptainDocumentReplacementDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainDocumentReplacementDtoBuilder toBuilder() =>
      CaptainDocumentReplacementDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDocumentReplacementDto &&
        uploadIds == other.uploadIds &&
        number == other.number &&
        issueDate == other.issueDate;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, uploadIds.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, issueDate.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainDocumentReplacementDto')
          ..add('uploadIds', uploadIds)
          ..add('number', number)
          ..add('issueDate', issueDate))
        .toString();
  }
}

class CaptainDocumentReplacementDtoBuilder
    implements
        Builder<
          CaptainDocumentReplacementDto,
          CaptainDocumentReplacementDtoBuilder
        > {
  _$CaptainDocumentReplacementDto? _$v;

  ListBuilder<String>? _uploadIds;
  ListBuilder<String> get uploadIds =>
      _$this._uploadIds ??= ListBuilder<String>();
  set uploadIds(ListBuilder<String>? uploadIds) =>
      _$this._uploadIds = uploadIds;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  Date? _issueDate;
  Date? get issueDate => _$this._issueDate;
  set issueDate(Date? issueDate) => _$this._issueDate = issueDate;

  CaptainDocumentReplacementDtoBuilder() {
    CaptainDocumentReplacementDto._defaults(this);
  }

  CaptainDocumentReplacementDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _uploadIds = $v.uploadIds.toBuilder();
      _number = $v.number;
      _issueDate = $v.issueDate;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDocumentReplacementDto other) {
    _$v = other as _$CaptainDocumentReplacementDto;
  }

  @override
  void update(void Function(CaptainDocumentReplacementDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDocumentReplacementDto build() => _build();

  _$CaptainDocumentReplacementDto _build() {
    _$CaptainDocumentReplacementDto _$result;
    try {
      _$result =
          _$v ??
          _$CaptainDocumentReplacementDto._(
            uploadIds: uploadIds.build(),
            number: number,
            issueDate: issueDate,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'uploadIds';
        uploadIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainDocumentReplacementDto',
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
