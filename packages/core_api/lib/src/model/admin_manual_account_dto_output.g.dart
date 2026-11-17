// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_manual_account_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminManualAccountDtoOutput extends AdminManualAccountDtoOutput {
  @override
  final String partyId;
  @override
  final String partyName;
  @override
  final BuiltList<
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
  >
  balances;
  @override
  final BuiltList<String> currencies;
  @override
  final BuiltList<AdminManualAccountDtoOutputEntriesInner> entries;

  factory _$AdminManualAccountDtoOutput([
    void Function(AdminManualAccountDtoOutputBuilder)? updates,
  ]) => (AdminManualAccountDtoOutputBuilder()..update(updates))._build();

  _$AdminManualAccountDtoOutput._({
    required this.partyId,
    required this.partyName,
    required this.balances,
    required this.currencies,
    required this.entries,
  }) : super._();
  @override
  AdminManualAccountDtoOutput rebuild(
    void Function(AdminManualAccountDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminManualAccountDtoOutputBuilder toBuilder() =>
      AdminManualAccountDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminManualAccountDtoOutput &&
        partyId == other.partyId &&
        partyName == other.partyName &&
        balances == other.balances &&
        currencies == other.currencies &&
        entries == other.entries;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, partyId.hashCode);
    _$hash = $jc(_$hash, partyName.hashCode);
    _$hash = $jc(_$hash, balances.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminManualAccountDtoOutput')
          ..add('partyId', partyId)
          ..add('partyName', partyName)
          ..add('balances', balances)
          ..add('currencies', currencies)
          ..add('entries', entries))
        .toString();
  }
}

class AdminManualAccountDtoOutputBuilder
    implements
        Builder<
          AdminManualAccountDtoOutput,
          AdminManualAccountDtoOutputBuilder
        > {
  _$AdminManualAccountDtoOutput? _$v;

  String? _partyId;
  String? get partyId => _$this._partyId;
  set partyId(String? partyId) => _$this._partyId = partyId;

  String? _partyName;
  String? get partyName => _$this._partyName;
  set partyName(String? partyName) => _$this._partyName = partyName;

  ListBuilder<
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
  >?
  _balances;
  ListBuilder<
    AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
  >
  get balances => _$this._balances ??=
      ListBuilder<
        AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
      >();
  set balances(
    ListBuilder<
      AdminOrderTicketsDtoOutputTicketsInnerResolutionCorrectedLinesInner
    >?
    balances,
  ) => _$this._balances = balances;

  ListBuilder<String>? _currencies;
  ListBuilder<String> get currencies =>
      _$this._currencies ??= ListBuilder<String>();
  set currencies(ListBuilder<String>? currencies) =>
      _$this._currencies = currencies;

  ListBuilder<AdminManualAccountDtoOutputEntriesInner>? _entries;
  ListBuilder<AdminManualAccountDtoOutputEntriesInner> get entries =>
      _$this._entries ??=
          ListBuilder<AdminManualAccountDtoOutputEntriesInner>();
  set entries(ListBuilder<AdminManualAccountDtoOutputEntriesInner>? entries) =>
      _$this._entries = entries;

  AdminManualAccountDtoOutputBuilder() {
    AdminManualAccountDtoOutput._defaults(this);
  }

  AdminManualAccountDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _partyId = $v.partyId;
      _partyName = $v.partyName;
      _balances = $v.balances.toBuilder();
      _currencies = $v.currencies.toBuilder();
      _entries = $v.entries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminManualAccountDtoOutput other) {
    _$v = other as _$AdminManualAccountDtoOutput;
  }

  @override
  void update(void Function(AdminManualAccountDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminManualAccountDtoOutput build() => _build();

  _$AdminManualAccountDtoOutput _build() {
    _$AdminManualAccountDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminManualAccountDtoOutput._(
            partyId: BuiltValueNullFieldError.checkNotNull(
              partyId,
              r'AdminManualAccountDtoOutput',
              'partyId',
            ),
            partyName: BuiltValueNullFieldError.checkNotNull(
              partyName,
              r'AdminManualAccountDtoOutput',
              'partyName',
            ),
            balances: balances.build(),
            currencies: currencies.build(),
            entries: entries.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'balances';
        balances.build();
        _$failedField = 'currencies';
        currencies.build();
        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminManualAccountDtoOutput',
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
