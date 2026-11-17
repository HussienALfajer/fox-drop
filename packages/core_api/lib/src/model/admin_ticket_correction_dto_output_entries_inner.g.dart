// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_correction_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketCorrectionDtoOutputEntriesInner
    extends AdminTicketCorrectionDtoOutputEntriesInner {
  @override
  final String type;
  @override
  final String? reason;
  @override
  final String account;
  @override
  final AdminEditPreviewAnswerDtoOutputEntriesInnerParty party;
  @override
  final AdminTicketCorrectionDtoOutputEntriesInnerAmount amount;

  factory _$AdminTicketCorrectionDtoOutputEntriesInner([
    void Function(AdminTicketCorrectionDtoOutputEntriesInnerBuilder)? updates,
  ]) => (AdminTicketCorrectionDtoOutputEntriesInnerBuilder()..update(updates))
      ._build();

  _$AdminTicketCorrectionDtoOutputEntriesInner._({
    required this.type,
    this.reason,
    required this.account,
    required this.party,
    required this.amount,
  }) : super._();
  @override
  AdminTicketCorrectionDtoOutputEntriesInner rebuild(
    void Function(AdminTicketCorrectionDtoOutputEntriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketCorrectionDtoOutputEntriesInnerBuilder toBuilder() =>
      AdminTicketCorrectionDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketCorrectionDtoOutputEntriesInner &&
        type == other.type &&
        reason == other.reason &&
        account == other.account &&
        party == other.party &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, account.hashCode);
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminTicketCorrectionDtoOutputEntriesInner',
          )
          ..add('type', type)
          ..add('reason', reason)
          ..add('account', account)
          ..add('party', party)
          ..add('amount', amount))
        .toString();
  }
}

class AdminTicketCorrectionDtoOutputEntriesInnerBuilder
    implements
        Builder<
          AdminTicketCorrectionDtoOutputEntriesInner,
          AdminTicketCorrectionDtoOutputEntriesInnerBuilder
        > {
  _$AdminTicketCorrectionDtoOutputEntriesInner? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _account;
  String? get account => _$this._account;
  set account(String? account) => _$this._account = account;

  AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder? _party;
  AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder get party =>
      _$this._party ??=
          AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder();
  set party(AdminEditPreviewAnswerDtoOutputEntriesInnerPartyBuilder? party) =>
      _$this._party = party;

  AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder? _amount;
  AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder get amount =>
      _$this._amount ??=
          AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder();
  set amount(AdminTicketCorrectionDtoOutputEntriesInnerAmountBuilder? amount) =>
      _$this._amount = amount;

  AdminTicketCorrectionDtoOutputEntriesInnerBuilder() {
    AdminTicketCorrectionDtoOutputEntriesInner._defaults(this);
  }

  AdminTicketCorrectionDtoOutputEntriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _reason = $v.reason;
      _account = $v.account;
      _party = $v.party.toBuilder();
      _amount = $v.amount.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketCorrectionDtoOutputEntriesInner other) {
    _$v = other as _$AdminTicketCorrectionDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(AdminTicketCorrectionDtoOutputEntriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketCorrectionDtoOutputEntriesInner build() => _build();

  _$AdminTicketCorrectionDtoOutputEntriesInner _build() {
    _$AdminTicketCorrectionDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketCorrectionDtoOutputEntriesInner._(
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'AdminTicketCorrectionDtoOutputEntriesInner',
              'type',
            ),
            reason: reason,
            account: BuiltValueNullFieldError.checkNotNull(
              account,
              r'AdminTicketCorrectionDtoOutputEntriesInner',
              'account',
            ),
            party: party.build(),
            amount: amount.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'party';
        party.build();
        _$failedField = 'amount';
        amount.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketCorrectionDtoOutputEntriesInner',
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
