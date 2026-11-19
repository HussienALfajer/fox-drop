// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_document_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationDocumentDto
    extends AdminCaptainApplicationDocumentDto {
  @override
  final BuiltList<String> uploadIds;
  @override
  final String? number;
  @override
  final Date? issueDate;

  factory _$AdminCaptainApplicationDocumentDto([
    void Function(AdminCaptainApplicationDocumentDtoBuilder)? updates,
  ]) => (AdminCaptainApplicationDocumentDtoBuilder()..update(updates))._build();

  _$AdminCaptainApplicationDocumentDto._({
    required this.uploadIds,
    this.number,
    this.issueDate,
  }) : super._();
  @override
  AdminCaptainApplicationDocumentDto rebuild(
    void Function(AdminCaptainApplicationDocumentDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationDocumentDtoBuilder toBuilder() =>
      AdminCaptainApplicationDocumentDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationDocumentDto &&
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
    return (newBuiltValueToStringHelper(r'AdminCaptainApplicationDocumentDto')
          ..add('uploadIds', uploadIds)
          ..add('number', number)
          ..add('issueDate', issueDate))
        .toString();
  }
}

class AdminCaptainApplicationDocumentDtoBuilder
    implements
        Builder<
          AdminCaptainApplicationDocumentDto,
          AdminCaptainApplicationDocumentDtoBuilder
        > {
  _$AdminCaptainApplicationDocumentDto? _$v;

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

  AdminCaptainApplicationDocumentDtoBuilder() {
    AdminCaptainApplicationDocumentDto._defaults(this);
  }

  AdminCaptainApplicationDocumentDtoBuilder get _$this {
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
  void replace(AdminCaptainApplicationDocumentDto other) {
    _$v = other as _$AdminCaptainApplicationDocumentDto;
  }

  @override
  void update(
    void Function(AdminCaptainApplicationDocumentDtoBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationDocumentDto build() => _build();

  _$AdminCaptainApplicationDocumentDto _build() {
    _$AdminCaptainApplicationDocumentDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminCaptainApplicationDocumentDto._(
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
          r'AdminCaptainApplicationDocumentDto',
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
