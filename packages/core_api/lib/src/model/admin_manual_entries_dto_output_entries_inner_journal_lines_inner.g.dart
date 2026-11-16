// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_entries_dto_output_entries_inner_journal_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner
    extends AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner {
  @override
  final String purpose;
  @override
  final String currency;
  @override
  final String amount;

  factory _$AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner([
    void Function(
      AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner._({
    required this.purpose,
    required this.currency,
    required this.amount,
  }) : super._();
  @override
  AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner rebuild(
    void Function(
      AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder toBuilder() =>
      AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner &&
        purpose == other.purpose &&
        currency == other.currency &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, purpose.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner',
          )
          ..add('purpose', purpose)
          ..add('currency', currency)
          ..add('amount', amount))
        .toString();
  }
}

class AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder
    implements
        Builder<
          AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner,
          AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder
        > {
  _$AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner? _$v;

  String? _purpose;
  String? get purpose => _$this._purpose;
  set purpose(String? purpose) => _$this._purpose = purpose;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder() {
    AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner._defaults(this);
  }

  AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _purpose = $v.purpose;
      _currency = $v.currency;
      _amount = $v.amount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner other) {
    _$v = other as _$AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner;
  }

  @override
  void update(
    void Function(
      AdminManualEntriesDtoOutputEntriesInnerJournalLinesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner build() => _build();

  _$AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner _build() {
    final _$result =
        _$v ??
        _$AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner._(
          purpose: BuiltValueNullFieldError.checkNotNull(
            purpose,
            r'AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner',
            'purpose',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner',
            'currency',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminManualEntriesDtoOutputEntriesInnerJournalLinesInner',
            'amount',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
