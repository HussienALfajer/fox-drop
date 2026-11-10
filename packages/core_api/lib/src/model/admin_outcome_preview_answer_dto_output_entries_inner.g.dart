// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_outcome_preview_answer_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOutcomePreviewAnswerDtoOutputEntriesInner
    extends AdminOutcomePreviewAnswerDtoOutputEntriesInner {
  @override
  final String type;
  @override
  final String? reason;
  @override
  final String account;
  @override
  final AdminOutcomePreviewAnswerDtoOutputEntriesInnerParty party;
  @override
  final AdminEditPreviewAnswerDtoOutputEntriesInnerAmount amount;

  factory _$AdminOutcomePreviewAnswerDtoOutputEntriesInner([
    void Function(AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder)?
    updates,
  ]) =>
      (AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder()..update(updates))
          ._build();

  _$AdminOutcomePreviewAnswerDtoOutputEntriesInner._({
    required this.type,
    this.reason,
    required this.account,
    required this.party,
    required this.amount,
  }) : super._();
  @override
  AdminOutcomePreviewAnswerDtoOutputEntriesInner rebuild(
    void Function(AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder toBuilder() =>
      AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOutcomePreviewAnswerDtoOutputEntriesInner &&
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
            r'AdminOutcomePreviewAnswerDtoOutputEntriesInner',
          )
          ..add('type', type)
          ..add('reason', reason)
          ..add('account', account)
          ..add('party', party)
          ..add('amount', amount))
        .toString();
  }
}

class AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder
    implements
        Builder<
          AdminOutcomePreviewAnswerDtoOutputEntriesInner,
          AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder
        > {
  _$AdminOutcomePreviewAnswerDtoOutputEntriesInner? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _account;
  String? get account => _$this._account;
  set account(String? account) => _$this._account = account;

  AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder? _party;
  AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder get party =>
      _$this._party ??=
          AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder();
  set party(
    AdminOutcomePreviewAnswerDtoOutputEntriesInnerPartyBuilder? party,
  ) => _$this._party = party;

  AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder? _amount;
  AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder get amount =>
      _$this._amount ??=
          AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder();
  set amount(
    AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder? amount,
  ) => _$this._amount = amount;

  AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder() {
    AdminOutcomePreviewAnswerDtoOutputEntriesInner._defaults(this);
  }

  AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder get _$this {
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
  void replace(AdminOutcomePreviewAnswerDtoOutputEntriesInner other) {
    _$v = other as _$AdminOutcomePreviewAnswerDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(AdminOutcomePreviewAnswerDtoOutputEntriesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOutcomePreviewAnswerDtoOutputEntriesInner build() => _build();

  _$AdminOutcomePreviewAnswerDtoOutputEntriesInner _build() {
    _$AdminOutcomePreviewAnswerDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminOutcomePreviewAnswerDtoOutputEntriesInner._(
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'AdminOutcomePreviewAnswerDtoOutputEntriesInner',
              'type',
            ),
            reason: reason,
            account: BuiltValueNullFieldError.checkNotNull(
              account,
              r'AdminOutcomePreviewAnswerDtoOutputEntriesInner',
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
          r'AdminOutcomePreviewAnswerDtoOutputEntriesInner',
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
