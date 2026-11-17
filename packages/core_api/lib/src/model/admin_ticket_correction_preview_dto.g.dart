// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_correction_preview_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketCorrectionPreviewDto
    extends AdminTicketCorrectionPreviewDto {
  @override
  final String cityId;
  @override
  final BuiltList<AdminTicketCorrectionPreviewDtoReceivedLinesInner>
  receivedLines;

  factory _$AdminTicketCorrectionPreviewDto([
    void Function(AdminTicketCorrectionPreviewDtoBuilder)? updates,
  ]) => (AdminTicketCorrectionPreviewDtoBuilder()..update(updates))._build();

  _$AdminTicketCorrectionPreviewDto._({
    required this.cityId,
    required this.receivedLines,
  }) : super._();
  @override
  AdminTicketCorrectionPreviewDto rebuild(
    void Function(AdminTicketCorrectionPreviewDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketCorrectionPreviewDtoBuilder toBuilder() =>
      AdminTicketCorrectionPreviewDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketCorrectionPreviewDto &&
        cityId == other.cityId &&
        receivedLines == other.receivedLines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, receivedLines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketCorrectionPreviewDto')
          ..add('cityId', cityId)
          ..add('receivedLines', receivedLines))
        .toString();
  }
}

class AdminTicketCorrectionPreviewDtoBuilder
    implements
        Builder<
          AdminTicketCorrectionPreviewDto,
          AdminTicketCorrectionPreviewDtoBuilder
        > {
  _$AdminTicketCorrectionPreviewDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  ListBuilder<AdminTicketCorrectionPreviewDtoReceivedLinesInner>?
  _receivedLines;
  ListBuilder<AdminTicketCorrectionPreviewDtoReceivedLinesInner>
  get receivedLines => _$this._receivedLines ??=
      ListBuilder<AdminTicketCorrectionPreviewDtoReceivedLinesInner>();
  set receivedLines(
    ListBuilder<AdminTicketCorrectionPreviewDtoReceivedLinesInner>?
    receivedLines,
  ) => _$this._receivedLines = receivedLines;

  AdminTicketCorrectionPreviewDtoBuilder() {
    AdminTicketCorrectionPreviewDto._defaults(this);
  }

  AdminTicketCorrectionPreviewDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _receivedLines = $v.receivedLines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketCorrectionPreviewDto other) {
    _$v = other as _$AdminTicketCorrectionPreviewDto;
  }

  @override
  void update(void Function(AdminTicketCorrectionPreviewDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketCorrectionPreviewDto build() => _build();

  _$AdminTicketCorrectionPreviewDto _build() {
    _$AdminTicketCorrectionPreviewDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketCorrectionPreviewDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminTicketCorrectionPreviewDto',
              'cityId',
            ),
            receivedLines: receivedLines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'receivedLines';
        receivedLines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketCorrectionPreviewDto',
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
