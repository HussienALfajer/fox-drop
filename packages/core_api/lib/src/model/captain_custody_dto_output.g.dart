// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_custody_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCustodyDtoOutput extends CaptainCustodyDtoOutput {
  @override
  final CaptainCustodyDtoOutputUsage usage;
  @override
  final CaptainCustodyDtoOutputLimit limit;
  @override
  final bool warn;
  @override
  final CaptainCustodyDtoOutputTotal total;
  @override
  final CaptainCustodyDtoOutputClosedDue closedDue;
  @override
  final DateTime lastCutoff;
  @override
  final DateTime? handInGraceUntil;
  @override
  final BuiltList<CaptainCustodyDtoOutputCurrenciesInner> currencies;
  @override
  final BuiltList<CaptainCustodyDtoOutputEntriesInner> entries;
  @override
  final BuiltList<CaptainCustodyDtoOutputReceiptsInner> receipts;

  factory _$CaptainCustodyDtoOutput([
    void Function(CaptainCustodyDtoOutputBuilder)? updates,
  ]) => (CaptainCustodyDtoOutputBuilder()..update(updates))._build();

  _$CaptainCustodyDtoOutput._({
    required this.usage,
    required this.limit,
    required this.warn,
    required this.total,
    required this.closedDue,
    required this.lastCutoff,
    this.handInGraceUntil,
    required this.currencies,
    required this.entries,
    required this.receipts,
  }) : super._();
  @override
  CaptainCustodyDtoOutput rebuild(
    void Function(CaptainCustodyDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCustodyDtoOutputBuilder toBuilder() =>
      CaptainCustodyDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCustodyDtoOutput &&
        usage == other.usage &&
        limit == other.limit &&
        warn == other.warn &&
        total == other.total &&
        closedDue == other.closedDue &&
        lastCutoff == other.lastCutoff &&
        handInGraceUntil == other.handInGraceUntil &&
        currencies == other.currencies &&
        entries == other.entries &&
        receipts == other.receipts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, usage.hashCode);
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, warn.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, closedDue.hashCode);
    _$hash = $jc(_$hash, lastCutoff.hashCode);
    _$hash = $jc(_$hash, handInGraceUntil.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jc(_$hash, receipts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainCustodyDtoOutput')
          ..add('usage', usage)
          ..add('limit', limit)
          ..add('warn', warn)
          ..add('total', total)
          ..add('closedDue', closedDue)
          ..add('lastCutoff', lastCutoff)
          ..add('handInGraceUntil', handInGraceUntil)
          ..add('currencies', currencies)
          ..add('entries', entries)
          ..add('receipts', receipts))
        .toString();
  }
}

class CaptainCustodyDtoOutputBuilder
    implements
        Builder<CaptainCustodyDtoOutput, CaptainCustodyDtoOutputBuilder> {
  _$CaptainCustodyDtoOutput? _$v;

  CaptainCustodyDtoOutputUsageBuilder? _usage;
  CaptainCustodyDtoOutputUsageBuilder get usage =>
      _$this._usage ??= CaptainCustodyDtoOutputUsageBuilder();
  set usage(CaptainCustodyDtoOutputUsageBuilder? usage) =>
      _$this._usage = usage;

  CaptainCustodyDtoOutputLimitBuilder? _limit;
  CaptainCustodyDtoOutputLimitBuilder get limit =>
      _$this._limit ??= CaptainCustodyDtoOutputLimitBuilder();
  set limit(CaptainCustodyDtoOutputLimitBuilder? limit) =>
      _$this._limit = limit;

  bool? _warn;
  bool? get warn => _$this._warn;
  set warn(bool? warn) => _$this._warn = warn;

  CaptainCustodyDtoOutputTotalBuilder? _total;
  CaptainCustodyDtoOutputTotalBuilder get total =>
      _$this._total ??= CaptainCustodyDtoOutputTotalBuilder();
  set total(CaptainCustodyDtoOutputTotalBuilder? total) =>
      _$this._total = total;

  CaptainCustodyDtoOutputClosedDueBuilder? _closedDue;
  CaptainCustodyDtoOutputClosedDueBuilder get closedDue =>
      _$this._closedDue ??= CaptainCustodyDtoOutputClosedDueBuilder();
  set closedDue(CaptainCustodyDtoOutputClosedDueBuilder? closedDue) =>
      _$this._closedDue = closedDue;

  DateTime? _lastCutoff;
  DateTime? get lastCutoff => _$this._lastCutoff;
  set lastCutoff(DateTime? lastCutoff) => _$this._lastCutoff = lastCutoff;

  DateTime? _handInGraceUntil;
  DateTime? get handInGraceUntil => _$this._handInGraceUntil;
  set handInGraceUntil(DateTime? handInGraceUntil) =>
      _$this._handInGraceUntil = handInGraceUntil;

  ListBuilder<CaptainCustodyDtoOutputCurrenciesInner>? _currencies;
  ListBuilder<CaptainCustodyDtoOutputCurrenciesInner> get currencies =>
      _$this._currencies ??=
          ListBuilder<CaptainCustodyDtoOutputCurrenciesInner>();
  set currencies(
    ListBuilder<CaptainCustodyDtoOutputCurrenciesInner>? currencies,
  ) => _$this._currencies = currencies;

  ListBuilder<CaptainCustodyDtoOutputEntriesInner>? _entries;
  ListBuilder<CaptainCustodyDtoOutputEntriesInner> get entries =>
      _$this._entries ??= ListBuilder<CaptainCustodyDtoOutputEntriesInner>();
  set entries(ListBuilder<CaptainCustodyDtoOutputEntriesInner>? entries) =>
      _$this._entries = entries;

  ListBuilder<CaptainCustodyDtoOutputReceiptsInner>? _receipts;
  ListBuilder<CaptainCustodyDtoOutputReceiptsInner> get receipts =>
      _$this._receipts ??= ListBuilder<CaptainCustodyDtoOutputReceiptsInner>();
  set receipts(ListBuilder<CaptainCustodyDtoOutputReceiptsInner>? receipts) =>
      _$this._receipts = receipts;

  CaptainCustodyDtoOutputBuilder() {
    CaptainCustodyDtoOutput._defaults(this);
  }

  CaptainCustodyDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _usage = $v.usage.toBuilder();
      _limit = $v.limit.toBuilder();
      _warn = $v.warn;
      _total = $v.total.toBuilder();
      _closedDue = $v.closedDue.toBuilder();
      _lastCutoff = $v.lastCutoff;
      _handInGraceUntil = $v.handInGraceUntil;
      _currencies = $v.currencies.toBuilder();
      _entries = $v.entries.toBuilder();
      _receipts = $v.receipts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCustodyDtoOutput other) {
    _$v = other as _$CaptainCustodyDtoOutput;
  }

  @override
  void update(void Function(CaptainCustodyDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCustodyDtoOutput build() => _build();

  _$CaptainCustodyDtoOutput _build() {
    _$CaptainCustodyDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainCustodyDtoOutput._(
            usage: usage.build(),
            limit: limit.build(),
            warn: BuiltValueNullFieldError.checkNotNull(
              warn,
              r'CaptainCustodyDtoOutput',
              'warn',
            ),
            total: total.build(),
            closedDue: closedDue.build(),
            lastCutoff: BuiltValueNullFieldError.checkNotNull(
              lastCutoff,
              r'CaptainCustodyDtoOutput',
              'lastCutoff',
            ),
            handInGraceUntil: handInGraceUntil,
            currencies: currencies.build(),
            entries: entries.build(),
            receipts: receipts.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'usage';
        usage.build();
        _$failedField = 'limit';
        limit.build();

        _$failedField = 'total';
        total.build();
        _$failedField = 'closedDue';
        closedDue.build();

        _$failedField = 'currencies';
        currencies.build();
        _$failedField = 'entries';
        entries.build();
        _$failedField = 'receipts';
        receipts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainCustodyDtoOutput',
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
