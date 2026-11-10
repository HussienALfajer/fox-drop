// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_edit_preview_answer_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEditPreviewAnswerDtoOutputEntriesInner
    extends AdminEditPreviewAnswerDtoOutputEntriesInner {
  @override
  final String type;
  @override
  final String? reason;
  @override
  final String account;
  @override
  final AdminEditPreviewAnswerDtoOutputEntriesInnerParty party;
  @override
  final AdminEditPreviewAnswerDtoOutputEntriesInnerAmount amount;

  factory _$AdminEditPreviewAnswerDtoOutputEntriesInner([
    void Function(AdminEditPreviewAnswerDtoOutputEntriesInnerBuilder)? updates,
  ]) => (AdminEditPreviewAnswerDtoOutputEntriesInnerBuilder()..update(updates))
      ._build();

  _$AdminEditPreviewAnswerDtoOutputEntriesInner._({
    required this.type,
    this.reason,
    required this.account,
    required this.party,
    required this.amount,
  }) : super._();
  @override
  AdminEditPreviewAnswerDtoOutputEntriesInner rebuild(
    void Function(AdminEditPreviewAnswerDtoOutputEntriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEditPreviewAnswerDtoOutputEntriesInnerBuilder toBuilder() =>
      AdminEditPreviewAnswerDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEditPreviewAnswerDtoOutputEntriesInner &&
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
            r'AdminEditPreviewAnswerDtoOutputEntriesInner',
          )
          ..add('type', type)
          ..add('reason', reason)
          ..add('account', account)
          ..add('party', party)
          ..add('amount', amount))
        .toString();
  }
}

class AdminEditPreviewAnswerDtoOutputEntriesInnerBuilder
    implements
        Builder<
          AdminEditPreviewAnswerDtoOutputEntriesInner,
          AdminEditPreviewAnswerDtoOutputEntriesInnerBuilder
        > {
  _$AdminEditPreviewAnswerDtoOutputEntriesInner? _$v;

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

  AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder? _amount;
  AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder get amount =>
      _$this._amount ??=
          AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder();
  set amount(
    AdminEditPreviewAnswerDtoOutputEntriesInnerAmountBuilder? amount,
  ) => _$this._amount = amount;

  AdminEditPreviewAnswerDtoOutputEntriesInnerBuilder() {
    AdminEditPreviewAnswerDtoOutputEntriesInner._defaults(this);
  }

  AdminEditPreviewAnswerDtoOutputEntriesInnerBuilder get _$this {
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
  void replace(AdminEditPreviewAnswerDtoOutputEntriesInner other) {
    _$v = other as _$AdminEditPreviewAnswerDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(AdminEditPreviewAnswerDtoOutputEntriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminEditPreviewAnswerDtoOutputEntriesInner build() => _build();

  _$AdminEditPreviewAnswerDtoOutputEntriesInner _build() {
    _$AdminEditPreviewAnswerDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminEditPreviewAnswerDtoOutputEntriesInner._(
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'AdminEditPreviewAnswerDtoOutputEntriesInner',
              'type',
            ),
            reason: reason,
            account: BuiltValueNullFieldError.checkNotNull(
              account,
              r'AdminEditPreviewAnswerDtoOutputEntriesInner',
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
          r'AdminEditPreviewAnswerDtoOutputEntriesInner',
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
