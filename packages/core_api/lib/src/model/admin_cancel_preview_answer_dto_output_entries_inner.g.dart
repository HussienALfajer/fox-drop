// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_cancel_preview_answer_dto_output_entries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCancelPreviewAnswerDtoOutputEntriesInner
    extends AdminCancelPreviewAnswerDtoOutputEntriesInner {
  @override
  final String type;
  @override
  final String account;
  @override
  final AdminEditPreviewAnswerDtoOutputEntriesInnerParty party;
  @override
  final AdminEditPreviewAnswerDtoOutputEntriesInnerAmount amount;

  factory _$AdminCancelPreviewAnswerDtoOutputEntriesInner([
    void Function(AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder)?
    updates,
  ]) =>
      (AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder()..update(updates))
          ._build();

  _$AdminCancelPreviewAnswerDtoOutputEntriesInner._({
    required this.type,
    required this.account,
    required this.party,
    required this.amount,
  }) : super._();
  @override
  AdminCancelPreviewAnswerDtoOutputEntriesInner rebuild(
    void Function(AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder toBuilder() =>
      AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCancelPreviewAnswerDtoOutputEntriesInner &&
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
            r'AdminCancelPreviewAnswerDtoOutputEntriesInner',
          )
          ..add('type', type)
          ..add('account', account)
          ..add('party', party)
          ..add('amount', amount))
        .toString();
  }
}

class AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder
    implements
        Builder<
          AdminCancelPreviewAnswerDtoOutputEntriesInner,
          AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder
        > {
  _$AdminCancelPreviewAnswerDtoOutputEntriesInner? _$v;

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

  AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder() {
    AdminCancelPreviewAnswerDtoOutputEntriesInner._defaults(this);
  }

  AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder get _$this {
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
  void replace(AdminCancelPreviewAnswerDtoOutputEntriesInner other) {
    _$v = other as _$AdminCancelPreviewAnswerDtoOutputEntriesInner;
  }

  @override
  void update(
    void Function(AdminCancelPreviewAnswerDtoOutputEntriesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCancelPreviewAnswerDtoOutputEntriesInner build() => _build();

  _$AdminCancelPreviewAnswerDtoOutputEntriesInner _build() {
    _$AdminCancelPreviewAnswerDtoOutputEntriesInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminCancelPreviewAnswerDtoOutputEntriesInner._(
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'AdminCancelPreviewAnswerDtoOutputEntriesInner',
              'type',
            ),
            account: BuiltValueNullFieldError.checkNotNull(
              account,
              r'AdminCancelPreviewAnswerDtoOutputEntriesInner',
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
          r'AdminCancelPreviewAnswerDtoOutputEntriesInner',
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
