// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_account_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantAccountDtoOutput extends MerchantAccountDtoOutput {
  @override
  final String? currency;
  @override
  final String balance;
  @override
  final Date settlementDate;
  @override
  final int? commissionBp;
  @override
  final MerchantAccountDtoOutputNextCommission? nextCommission;
  @override
  final DateTime todayFrom;
  @override
  final BuiltList<MerchantAccountDtoOutputPickupsInner> pickups;
  @override
  final DateTime? weekFrom;
  @override
  final BuiltList<MerchantAccountDtoOutputWeekLinesInner> weekLines;

  factory _$MerchantAccountDtoOutput([
    void Function(MerchantAccountDtoOutputBuilder)? updates,
  ]) => (MerchantAccountDtoOutputBuilder()..update(updates))._build();

  _$MerchantAccountDtoOutput._({
    this.currency,
    required this.balance,
    required this.settlementDate,
    this.commissionBp,
    this.nextCommission,
    required this.todayFrom,
    required this.pickups,
    this.weekFrom,
    required this.weekLines,
  }) : super._();
  @override
  MerchantAccountDtoOutput rebuild(
    void Function(MerchantAccountDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantAccountDtoOutputBuilder toBuilder() =>
      MerchantAccountDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantAccountDtoOutput &&
        currency == other.currency &&
        balance == other.balance &&
        settlementDate == other.settlementDate &&
        commissionBp == other.commissionBp &&
        nextCommission == other.nextCommission &&
        todayFrom == other.todayFrom &&
        pickups == other.pickups &&
        weekFrom == other.weekFrom &&
        weekLines == other.weekLines;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, balance.hashCode);
    _$hash = $jc(_$hash, settlementDate.hashCode);
    _$hash = $jc(_$hash, commissionBp.hashCode);
    _$hash = $jc(_$hash, nextCommission.hashCode);
    _$hash = $jc(_$hash, todayFrom.hashCode);
    _$hash = $jc(_$hash, pickups.hashCode);
    _$hash = $jc(_$hash, weekFrom.hashCode);
    _$hash = $jc(_$hash, weekLines.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantAccountDtoOutput')
          ..add('currency', currency)
          ..add('balance', balance)
          ..add('settlementDate', settlementDate)
          ..add('commissionBp', commissionBp)
          ..add('nextCommission', nextCommission)
          ..add('todayFrom', todayFrom)
          ..add('pickups', pickups)
          ..add('weekFrom', weekFrom)
          ..add('weekLines', weekLines))
        .toString();
  }
}

class MerchantAccountDtoOutputBuilder
    implements
        Builder<MerchantAccountDtoOutput, MerchantAccountDtoOutputBuilder> {
  _$MerchantAccountDtoOutput? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _balance;
  String? get balance => _$this._balance;
  set balance(String? balance) => _$this._balance = balance;

  Date? _settlementDate;
  Date? get settlementDate => _$this._settlementDate;
  set settlementDate(Date? settlementDate) =>
      _$this._settlementDate = settlementDate;

  int? _commissionBp;
  int? get commissionBp => _$this._commissionBp;
  set commissionBp(int? commissionBp) => _$this._commissionBp = commissionBp;

  MerchantAccountDtoOutputNextCommissionBuilder? _nextCommission;
  MerchantAccountDtoOutputNextCommissionBuilder get nextCommission =>
      _$this._nextCommission ??=
          MerchantAccountDtoOutputNextCommissionBuilder();
  set nextCommission(
    MerchantAccountDtoOutputNextCommissionBuilder? nextCommission,
  ) => _$this._nextCommission = nextCommission;

  DateTime? _todayFrom;
  DateTime? get todayFrom => _$this._todayFrom;
  set todayFrom(DateTime? todayFrom) => _$this._todayFrom = todayFrom;

  ListBuilder<MerchantAccountDtoOutputPickupsInner>? _pickups;
  ListBuilder<MerchantAccountDtoOutputPickupsInner> get pickups =>
      _$this._pickups ??= ListBuilder<MerchantAccountDtoOutputPickupsInner>();
  set pickups(ListBuilder<MerchantAccountDtoOutputPickupsInner>? pickups) =>
      _$this._pickups = pickups;

  DateTime? _weekFrom;
  DateTime? get weekFrom => _$this._weekFrom;
  set weekFrom(DateTime? weekFrom) => _$this._weekFrom = weekFrom;

  ListBuilder<MerchantAccountDtoOutputWeekLinesInner>? _weekLines;
  ListBuilder<MerchantAccountDtoOutputWeekLinesInner> get weekLines =>
      _$this._weekLines ??=
          ListBuilder<MerchantAccountDtoOutputWeekLinesInner>();
  set weekLines(
    ListBuilder<MerchantAccountDtoOutputWeekLinesInner>? weekLines,
  ) => _$this._weekLines = weekLines;

  MerchantAccountDtoOutputBuilder() {
    MerchantAccountDtoOutput._defaults(this);
  }

  MerchantAccountDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _balance = $v.balance;
      _settlementDate = $v.settlementDate;
      _commissionBp = $v.commissionBp;
      _nextCommission = $v.nextCommission?.toBuilder();
      _todayFrom = $v.todayFrom;
      _pickups = $v.pickups.toBuilder();
      _weekFrom = $v.weekFrom;
      _weekLines = $v.weekLines.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantAccountDtoOutput other) {
    _$v = other as _$MerchantAccountDtoOutput;
  }

  @override
  void update(void Function(MerchantAccountDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantAccountDtoOutput build() => _build();

  _$MerchantAccountDtoOutput _build() {
    _$MerchantAccountDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantAccountDtoOutput._(
            currency: currency,
            balance: BuiltValueNullFieldError.checkNotNull(
              balance,
              r'MerchantAccountDtoOutput',
              'balance',
            ),
            settlementDate: BuiltValueNullFieldError.checkNotNull(
              settlementDate,
              r'MerchantAccountDtoOutput',
              'settlementDate',
            ),
            commissionBp: commissionBp,
            nextCommission: _nextCommission?.build(),
            todayFrom: BuiltValueNullFieldError.checkNotNull(
              todayFrom,
              r'MerchantAccountDtoOutput',
              'todayFrom',
            ),
            pickups: pickups.build(),
            weekFrom: weekFrom,
            weekLines: weekLines.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'nextCommission';
        _nextCommission?.build();

        _$failedField = 'pickups';
        pickups.build();

        _$failedField = 'weekLines';
        weekLines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantAccountDtoOutput',
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
