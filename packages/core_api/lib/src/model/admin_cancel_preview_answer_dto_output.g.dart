// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancel_preview_answer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCancelPreviewAnswerDtoOutput
    extends AdminCancelPreviewAnswerDtoOutput {
  @override
  final BuiltList<AdminCancelPreviewAnswerDtoOutputEntriesInner> entries;
  @override
  final bool cashAsked;
  @override
  final bool compensationAllowed;
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?>? cashLines;
  @override
  final bool strike;

  factory _$AdminCancelPreviewAnswerDtoOutput([
    void Function(AdminCancelPreviewAnswerDtoOutputBuilder)? updates,
  ]) => (AdminCancelPreviewAnswerDtoOutputBuilder()..update(updates))._build();

  _$AdminCancelPreviewAnswerDtoOutput._({
    required this.entries,
    required this.cashAsked,
    required this.compensationAllowed,
    this.cashLines,
    required this.strike,
  }) : super._();
  @override
  AdminCancelPreviewAnswerDtoOutput rebuild(
    void Function(AdminCancelPreviewAnswerDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCancelPreviewAnswerDtoOutputBuilder toBuilder() =>
      AdminCancelPreviewAnswerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCancelPreviewAnswerDtoOutput &&
        entries == other.entries &&
        cashAsked == other.cashAsked &&
        compensationAllowed == other.compensationAllowed &&
        cashLines == other.cashLines &&
        strike == other.strike;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jc(_$hash, cashAsked.hashCode);
    _$hash = $jc(_$hash, compensationAllowed.hashCode);
    _$hash = $jc(_$hash, cashLines.hashCode);
    _$hash = $jc(_$hash, strike.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCancelPreviewAnswerDtoOutput')
          ..add('entries', entries)
          ..add('cashAsked', cashAsked)
          ..add('compensationAllowed', compensationAllowed)
          ..add('cashLines', cashLines)
          ..add('strike', strike))
        .toString();
  }
}

class AdminCancelPreviewAnswerDtoOutputBuilder
    implements
        Builder<
          AdminCancelPreviewAnswerDtoOutput,
          AdminCancelPreviewAnswerDtoOutputBuilder
        > {
  _$AdminCancelPreviewAnswerDtoOutput? _$v;

  ListBuilder<AdminCancelPreviewAnswerDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminCancelPreviewAnswerDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminCancelPreviewAnswerDtoOutputEntriesInner>();
  set entries(
    ListBuilder<AdminCancelPreviewAnswerDtoOutputEntriesInner>? entries,
  ) => _$this._entries = entries;

  bool? _cashAsked;
  bool? get cashAsked => _$this._cashAsked;
  set cashAsked(bool? cashAsked) => _$this._cashAsked = cashAsked;

  bool? _compensationAllowed;
  bool? get compensationAllowed => _$this._compensationAllowed;
  set compensationAllowed(bool? compensationAllowed) =>
      _$this._compensationAllowed = compensationAllowed;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _cashLines;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get cashLines =>
      _$this._cashLines ??= ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set cashLines(ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? cashLines) =>
      _$this._cashLines = cashLines;

  bool? _strike;
  bool? get strike => _$this._strike;
  set strike(bool? strike) => _$this._strike = strike;

  AdminCancelPreviewAnswerDtoOutputBuilder() {
    AdminCancelPreviewAnswerDtoOutput._defaults(this);
  }

  AdminCancelPreviewAnswerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entries = $v.entries.toBuilder();
      _cashAsked = $v.cashAsked;
      _compensationAllowed = $v.compensationAllowed;
      _cashLines = $v.cashLines?.toBuilder();
      _strike = $v.strike;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCancelPreviewAnswerDtoOutput other) {
    _$v = other as _$AdminCancelPreviewAnswerDtoOutput;
  }

  @override
  void update(
    void Function(AdminCancelPreviewAnswerDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCancelPreviewAnswerDtoOutput build() => _build();

  _$AdminCancelPreviewAnswerDtoOutput _build() {
    _$AdminCancelPreviewAnswerDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminCancelPreviewAnswerDtoOutput._(
            entries: entries.build(),
            cashAsked: BuiltValueNullFieldError.checkNotNull(
              cashAsked,
              r'AdminCancelPreviewAnswerDtoOutput',
              'cashAsked',
            ),
            compensationAllowed: BuiltValueNullFieldError.checkNotNull(
              compensationAllowed,
              r'AdminCancelPreviewAnswerDtoOutput',
              'compensationAllowed',
            ),
            cashLines: _cashLines?.build(),
            strike: BuiltValueNullFieldError.checkNotNull(
              strike,
              r'AdminCancelPreviewAnswerDtoOutput',
              'strike',
            ),
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
          r'AdminCancelPreviewAnswerDtoOutput',
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
