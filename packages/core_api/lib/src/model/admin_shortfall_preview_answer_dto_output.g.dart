// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_shortfall_preview_answer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminShortfallPreviewAnswerDtoOutput
    extends AdminShortfallPreviewAnswerDtoOutput {
  @override
  final AdminShortfallPreviewAnswerDtoOutputShortfall shortfall;
  @override
  final CaptainWentOfflineDtoOutputHandIn? dues;
  @override
  final CaptainWentOfflineDtoOutputHandIn? captainCharge;
  @override
  final BuiltList<AdminOutcomePreviewAnswerDtoOutputEntriesInner> entries;

  factory _$AdminShortfallPreviewAnswerDtoOutput([
    void Function(AdminShortfallPreviewAnswerDtoOutputBuilder)? updates,
  ]) =>
      (AdminShortfallPreviewAnswerDtoOutputBuilder()..update(updates))._build();

  _$AdminShortfallPreviewAnswerDtoOutput._({
    required this.shortfall,
    this.dues,
    this.captainCharge,
    required this.entries,
  }) : super._();
  @override
  AdminShortfallPreviewAnswerDtoOutput rebuild(
    void Function(AdminShortfallPreviewAnswerDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminShortfallPreviewAnswerDtoOutputBuilder toBuilder() =>
      AdminShortfallPreviewAnswerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminShortfallPreviewAnswerDtoOutput &&
        shortfall == other.shortfall &&
        dues == other.dues &&
        captainCharge == other.captainCharge &&
        entries == other.entries;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, shortfall.hashCode);
    _$hash = $jc(_$hash, dues.hashCode);
    _$hash = $jc(_$hash, captainCharge.hashCode);
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminShortfallPreviewAnswerDtoOutput')
          ..add('shortfall', shortfall)
          ..add('dues', dues)
          ..add('captainCharge', captainCharge)
          ..add('entries', entries))
        .toString();
  }
}

class AdminShortfallPreviewAnswerDtoOutputBuilder
    implements
        Builder<
          AdminShortfallPreviewAnswerDtoOutput,
          AdminShortfallPreviewAnswerDtoOutputBuilder
        > {
  _$AdminShortfallPreviewAnswerDtoOutput? _$v;

  AdminShortfallPreviewAnswerDtoOutputShortfallBuilder? _shortfall;
  AdminShortfallPreviewAnswerDtoOutputShortfallBuilder get shortfall =>
      _$this._shortfall ??=
          AdminShortfallPreviewAnswerDtoOutputShortfallBuilder();
  set shortfall(
    AdminShortfallPreviewAnswerDtoOutputShortfallBuilder? shortfall,
  ) => _$this._shortfall = shortfall;

  CaptainWentOfflineDtoOutputHandInBuilder? _dues;
  CaptainWentOfflineDtoOutputHandInBuilder get dues =>
      _$this._dues ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set dues(CaptainWentOfflineDtoOutputHandInBuilder? dues) =>
      _$this._dues = dues;

  CaptainWentOfflineDtoOutputHandInBuilder? _captainCharge;
  CaptainWentOfflineDtoOutputHandInBuilder get captainCharge =>
      _$this._captainCharge ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set captainCharge(CaptainWentOfflineDtoOutputHandInBuilder? captainCharge) =>
      _$this._captainCharge = captainCharge;

  ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner>();
  set entries(
    ListBuilder<AdminOutcomePreviewAnswerDtoOutputEntriesInner>? entries,
  ) => _$this._entries = entries;

  AdminShortfallPreviewAnswerDtoOutputBuilder() {
    AdminShortfallPreviewAnswerDtoOutput._defaults(this);
  }

  AdminShortfallPreviewAnswerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _shortfall = $v.shortfall.toBuilder();
      _dues = $v.dues?.toBuilder();
      _captainCharge = $v.captainCharge?.toBuilder();
      _entries = $v.entries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminShortfallPreviewAnswerDtoOutput other) {
    _$v = other as _$AdminShortfallPreviewAnswerDtoOutput;
  }

  @override
  void update(
    void Function(AdminShortfallPreviewAnswerDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminShortfallPreviewAnswerDtoOutput build() => _build();

  _$AdminShortfallPreviewAnswerDtoOutput _build() {
    _$AdminShortfallPreviewAnswerDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminShortfallPreviewAnswerDtoOutput._(
            shortfall: shortfall.build(),
            dues: _dues?.build(),
            captainCharge: _captainCharge?.build(),
            entries: entries.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'shortfall';
        shortfall.build();
        _$failedField = 'dues';
        _dues?.build();
        _$failedField = 'captainCharge';
        _captainCharge?.build();
        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminShortfallPreviewAnswerDtoOutput',
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
