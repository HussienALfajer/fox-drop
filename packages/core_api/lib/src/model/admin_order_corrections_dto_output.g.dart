// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_corrections_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderCorrectionsDtoOutput extends AdminOrderCorrectionsDtoOutput {
  @override
  final bool finished;
  @override
  final bool canCorrect;
  @override
  final BuiltList<AdminManualEntriesDtoOutputEntriesInner> entries;
  @override
  final BuiltList<AdminOrderCorrectionsDtoOutputAccountsInner> accounts;

  factory _$AdminOrderCorrectionsDtoOutput([
    void Function(AdminOrderCorrectionsDtoOutputBuilder)? updates,
  ]) => (AdminOrderCorrectionsDtoOutputBuilder()..update(updates))._build();

  _$AdminOrderCorrectionsDtoOutput._({
    required this.finished,
    required this.canCorrect,
    required this.entries,
    required this.accounts,
  }) : super._();
  @override
  AdminOrderCorrectionsDtoOutput rebuild(
    void Function(AdminOrderCorrectionsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCorrectionsDtoOutputBuilder toBuilder() =>
      AdminOrderCorrectionsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCorrectionsDtoOutput &&
        finished == other.finished &&
        canCorrect == other.canCorrect &&
        entries == other.entries &&
        accounts == other.accounts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, finished.hashCode);
    _$hash = $jc(_$hash, canCorrect.hashCode);
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jc(_$hash, accounts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderCorrectionsDtoOutput')
          ..add('finished', finished)
          ..add('canCorrect', canCorrect)
          ..add('entries', entries)
          ..add('accounts', accounts))
        .toString();
  }
}

class AdminOrderCorrectionsDtoOutputBuilder
    implements
        Builder<
          AdminOrderCorrectionsDtoOutput,
          AdminOrderCorrectionsDtoOutputBuilder
        > {
  _$AdminOrderCorrectionsDtoOutput? _$v;

  bool? _finished;
  bool? get finished => _$this._finished;
  set finished(bool? finished) => _$this._finished = finished;

  bool? _canCorrect;
  bool? get canCorrect => _$this._canCorrect;
  set canCorrect(bool? canCorrect) => _$this._canCorrect = canCorrect;

  ListBuilder<AdminManualEntriesDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminManualEntriesDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminManualEntriesDtoOutputEntriesInner>();
  set entries(ListBuilder<AdminManualEntriesDtoOutputEntriesInner>? entries) =>
      _$this._entries = entries;

  ListBuilder<AdminOrderCorrectionsDtoOutputAccountsInner>? _accounts;
  ListBuilder<AdminOrderCorrectionsDtoOutputAccountsInner> get accounts =>
      _$this._accounts ??=
          ListBuilder<AdminOrderCorrectionsDtoOutputAccountsInner>();
  set accounts(
    ListBuilder<AdminOrderCorrectionsDtoOutputAccountsInner>? accounts,
  ) => _$this._accounts = accounts;

  AdminOrderCorrectionsDtoOutputBuilder() {
    AdminOrderCorrectionsDtoOutput._defaults(this);
  }

  AdminOrderCorrectionsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _finished = $v.finished;
      _canCorrect = $v.canCorrect;
      _entries = $v.entries.toBuilder();
      _accounts = $v.accounts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderCorrectionsDtoOutput other) {
    _$v = other as _$AdminOrderCorrectionsDtoOutput;
  }

  @override
  void update(void Function(AdminOrderCorrectionsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCorrectionsDtoOutput build() => _build();

  _$AdminOrderCorrectionsDtoOutput _build() {
    _$AdminOrderCorrectionsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderCorrectionsDtoOutput._(
            finished: BuiltValueNullFieldError.checkNotNull(
              finished,
              r'AdminOrderCorrectionsDtoOutput',
              'finished',
            ),
            canCorrect: BuiltValueNullFieldError.checkNotNull(
              canCorrect,
              r'AdminOrderCorrectionsDtoOutput',
              'canCorrect',
            ),
            entries: entries.build(),
            accounts: accounts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entries';
        entries.build();
        _$failedField = 'accounts';
        accounts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderCorrectionsDtoOutput',
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
