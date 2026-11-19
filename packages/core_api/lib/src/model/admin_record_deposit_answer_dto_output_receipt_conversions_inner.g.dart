// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_record_deposit_answer_dto_output_receipt_conversions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRecordDepositAnswerDtoOutputReceiptConversionsInner
    extends AdminRecordDepositAnswerDtoOutputReceiptConversionsInner {
  @override
  final String from;
  @override
  final String amount;
  @override
  final String to;
  @override
  final String converted;

  factory _$AdminRecordDepositAnswerDtoOutputReceiptConversionsInner([
    void Function(
      AdminRecordDepositAnswerDtoOutputReceiptConversionsInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminRecordDepositAnswerDtoOutputReceiptConversionsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminRecordDepositAnswerDtoOutputReceiptConversionsInner._({
    required this.from,
    required this.amount,
    required this.to,
    required this.converted,
  }) : super._();
  @override
  AdminRecordDepositAnswerDtoOutputReceiptConversionsInner rebuild(
    void Function(
      AdminRecordDepositAnswerDtoOutputReceiptConversionsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRecordDepositAnswerDtoOutputReceiptConversionsInnerBuilder toBuilder() =>
      AdminRecordDepositAnswerDtoOutputReceiptConversionsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRecordDepositAnswerDtoOutputReceiptConversionsInner &&
        from == other.from &&
        amount == other.amount &&
        to == other.to &&
        converted == other.converted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, converted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRecordDepositAnswerDtoOutputReceiptConversionsInner',
          )
          ..add('from', from)
          ..add('amount', amount)
          ..add('to', to)
          ..add('converted', converted))
        .toString();
  }
}

class AdminRecordDepositAnswerDtoOutputReceiptConversionsInnerBuilder
    implements
        Builder<
          AdminRecordDepositAnswerDtoOutputReceiptConversionsInner,
          AdminRecordDepositAnswerDtoOutputReceiptConversionsInnerBuilder
        > {
  _$AdminRecordDepositAnswerDtoOutputReceiptConversionsInner? _$v;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  String? _converted;
  String? get converted => _$this._converted;
  set converted(String? converted) => _$this._converted = converted;

  AdminRecordDepositAnswerDtoOutputReceiptConversionsInnerBuilder() {
    AdminRecordDepositAnswerDtoOutputReceiptConversionsInner._defaults(this);
  }

  AdminRecordDepositAnswerDtoOutputReceiptConversionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _amount = $v.amount;
      _to = $v.to;
      _converted = $v.converted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRecordDepositAnswerDtoOutputReceiptConversionsInner other) {
    _$v = other as _$AdminRecordDepositAnswerDtoOutputReceiptConversionsInner;
  }

  @override
  void update(
    void Function(
      AdminRecordDepositAnswerDtoOutputReceiptConversionsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRecordDepositAnswerDtoOutputReceiptConversionsInner build() => _build();

  _$AdminRecordDepositAnswerDtoOutputReceiptConversionsInner _build() {
    final _$result =
        _$v ??
        _$AdminRecordDepositAnswerDtoOutputReceiptConversionsInner._(
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminRecordDepositAnswerDtoOutputReceiptConversionsInner',
            'from',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminRecordDepositAnswerDtoOutputReceiptConversionsInner',
            'amount',
          ),
          to: BuiltValueNullFieldError.checkNotNull(
            to,
            r'AdminRecordDepositAnswerDtoOutputReceiptConversionsInner',
            'to',
          ),
          converted: BuiltValueNullFieldError.checkNotNull(
            converted,
            r'AdminRecordDepositAnswerDtoOutputReceiptConversionsInner',
            'converted',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
