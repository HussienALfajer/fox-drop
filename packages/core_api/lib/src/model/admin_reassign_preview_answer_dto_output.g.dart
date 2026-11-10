// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reassign_preview_answer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReassignPreviewAnswerDtoOutput
    extends AdminReassignPreviewAnswerDtoOutput {
  @override
  final BuiltList<AdminReassignPreviewAnswerDtoOutputEntriesInner> entries;
  @override
  final bool cashAsked;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit>? cashLines;

  factory _$AdminReassignPreviewAnswerDtoOutput([
    void Function(AdminReassignPreviewAnswerDtoOutputBuilder)? updates,
  ]) =>
      (AdminReassignPreviewAnswerDtoOutputBuilder()..update(updates))._build();

  _$AdminReassignPreviewAnswerDtoOutput._({
    required this.entries,
    required this.cashAsked,
    this.cashLines,
  }) : super._();
  @override
  AdminReassignPreviewAnswerDtoOutput rebuild(
    void Function(AdminReassignPreviewAnswerDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReassignPreviewAnswerDtoOutputBuilder toBuilder() =>
      AdminReassignPreviewAnswerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReassignPreviewAnswerDtoOutput &&
        entries == other.entries &&
        cashAsked == other.cashAsked &&
        cashLines == other.cashLines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jc(_$hash, cashAsked.hashCode);
    _$hash = $jc(_$hash, cashLines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminReassignPreviewAnswerDtoOutput')
          ..add('entries', entries)
          ..add('cashAsked', cashAsked)
          ..add('cashLines', cashLines))
        .toString();
  }
}

class AdminReassignPreviewAnswerDtoOutputBuilder
    implements
        Builder<
          AdminReassignPreviewAnswerDtoOutput,
          AdminReassignPreviewAnswerDtoOutputBuilder
        > {
  _$AdminReassignPreviewAnswerDtoOutput? _$v;

  ListBuilder<AdminReassignPreviewAnswerDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminReassignPreviewAnswerDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminReassignPreviewAnswerDtoOutputEntriesInner>();
  set entries(
    ListBuilder<AdminReassignPreviewAnswerDtoOutputEntriesInner>? entries,
  ) => _$this._entries = entries;

  bool? _cashAsked;
  bool? get cashAsked => _$this._cashAsked;
  set cashAsked(bool? cashAsked) => _$this._cashAsked = cashAsked;

  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? _cashLines;
  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit> get cashLines =>
      _$this._cashLines ??=
          ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>();
  set cashLines(
    ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? cashLines,
  ) => _$this._cashLines = cashLines;

  AdminReassignPreviewAnswerDtoOutputBuilder() {
    AdminReassignPreviewAnswerDtoOutput._defaults(this);
  }

  AdminReassignPreviewAnswerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entries = $v.entries.toBuilder();
      _cashAsked = $v.cashAsked;
      _cashLines = $v.cashLines?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReassignPreviewAnswerDtoOutput other) {
    _$v = other as _$AdminReassignPreviewAnswerDtoOutput;
  }

  @override
  void update(
    void Function(AdminReassignPreviewAnswerDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminReassignPreviewAnswerDtoOutput build() => _build();

  _$AdminReassignPreviewAnswerDtoOutput _build() {
    _$AdminReassignPreviewAnswerDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminReassignPreviewAnswerDtoOutput._(
            entries: entries.build(),
            cashAsked: BuiltValueNullFieldError.checkNotNull(
              cashAsked,
              r'AdminReassignPreviewAnswerDtoOutput',
              'cashAsked',
            ),
            cashLines: _cashLines?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entries';
        entries.build();

        _$failedField = 'cashLines';
        _cashLines?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminReassignPreviewAnswerDtoOutput',
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
