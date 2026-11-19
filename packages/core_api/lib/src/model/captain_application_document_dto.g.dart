// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_application_document_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainApplicationDocumentDto extends CaptainApplicationDocumentDto {
  @override
  final BuiltList<String> uploadIds;
  @override
  final String? number;
  @override
  final Date? issueDate;

  factory _$CaptainApplicationDocumentDto([
    void Function(CaptainApplicationDocumentDtoBuilder)? updates,
  ]) => (CaptainApplicationDocumentDtoBuilder()..update(updates))._build();

  _$CaptainApplicationDocumentDto._({
    required this.uploadIds,
    this.number,
    this.issueDate,
  }) : super._();
  @override
  CaptainApplicationDocumentDto rebuild(
    void Function(CaptainApplicationDocumentDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainApplicationDocumentDtoBuilder toBuilder() =>
      CaptainApplicationDocumentDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainApplicationDocumentDto &&
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
    return (newBuiltValueToStringHelper(r'CaptainApplicationDocumentDto')
          ..add('uploadIds', uploadIds)
          ..add('number', number)
          ..add('issueDate', issueDate))
        .toString();
  }
}

class CaptainApplicationDocumentDtoBuilder
    implements
        Builder<
          CaptainApplicationDocumentDto,
          CaptainApplicationDocumentDtoBuilder
        > {
  _$CaptainApplicationDocumentDto? _$v;

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

  CaptainApplicationDocumentDtoBuilder() {
    CaptainApplicationDocumentDto._defaults(this);
  }

  CaptainApplicationDocumentDtoBuilder get _$this {
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
  void replace(CaptainApplicationDocumentDto other) {
    _$v = other as _$CaptainApplicationDocumentDto;
  }

  @override
  void update(void Function(CaptainApplicationDocumentDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainApplicationDocumentDto build() => _build();

  _$CaptainApplicationDocumentDto _build() {
    _$CaptainApplicationDocumentDto _$result;
    try {
      _$result =
          _$v ??
          _$CaptainApplicationDocumentDto._(
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
          r'CaptainApplicationDocumentDto',
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
