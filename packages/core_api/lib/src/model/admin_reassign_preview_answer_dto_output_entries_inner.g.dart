// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reassign_preview_answer_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminReassignPreviewAnswerDtoOutputEntriesInner
    extends AdminReassignPreviewAnswerDtoOutputEntriesInner {
  @override
  final String type;
  @override
  final String account;
  @override
  final AdminEditPreviewAnswerDtoOutputEntriesInnerParty party;
  @override
  final AdminEditPreviewAnswerDtoOutputEntriesInnerAmount amount;

  factory _$AdminReassignPreviewAnswerDtoOutputEntriesInner([
    void Function(AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder)?
    updates,
  ]) =>
      (AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminReassignPreviewAnswerDtoOutputEntriesInner._({
    required this.type,
    required this.account,
    required this.party,
    required this.amount,
  }) : super._();
  @override
  AdminReassignPreviewAnswerDtoOutputEntriesInner rebuild(
    void Function(AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder toBuilder() =>
      AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminReassignPreviewAnswerDtoOutputEntriesInner &&
        type == other.type &&
        account == other.account &&
        party == other.party &&
        amount == other.amount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, account.hashCode);
    _$hash = $jc(_$hash, party.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminReassignPreviewAnswerDtoOutputEntriesInner',
          )
          ..add('type', type)
          ..add('account', account)
          ..add('party', party)
          ..add('amount', amount))
        .toString();
  }
}

class AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder
    implements
        Builder<
          AdminReassignPreviewAnswerDtoOutputEntriesInner,
          AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder
        > {
  _$AdminReassignPreviewAnswerDtoOutputEntriesInner? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

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

  AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder() {
    AdminReassignPreviewAnswerDtoOutputEntriesInner._defaults(this);
  }

  AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _account = $v.account;
      _party = $v.party.toBuilder();
      _amount = $v.amount.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminReassignPreviewAnswerDtoOutputEntriesInner other) {
    _$v = other as _$AdminReassignPreviewAnswerDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(AdminReassignPreviewAnswerDtoOutputEntriesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminReassignPreviewAnswerDtoOutputEntriesInner build() => _build();

  _$AdminReassignPreviewAnswerDtoOutputEntriesInner _build() {
    _$AdminReassignPreviewAnswerDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminReassignPreviewAnswerDtoOutputEntriesInner._(
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'AdminReassignPreviewAnswerDtoOutputEntriesInner',
              'type',
            ),
            account: BuiltValueNullFieldError.checkNotNull(
              account,
              r'AdminReassignPreviewAnswerDtoOutputEntriesInner',
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
          r'AdminReassignPreviewAnswerDtoOutputEntriesInner',
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
