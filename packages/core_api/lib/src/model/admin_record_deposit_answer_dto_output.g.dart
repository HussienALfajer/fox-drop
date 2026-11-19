// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_record_deposit_answer_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRecordDepositAnswerDtoOutput
    extends AdminRecordDepositAnswerDtoOutput {
  @override
  final AdminRecordDepositAnswerDtoOutputReceipt? receipt;

  factory _$AdminRecordDepositAnswerDtoOutput([
    void Function(AdminRecordDepositAnswerDtoOutputBuilder)? updates,
  ]) => (AdminRecordDepositAnswerDtoOutputBuilder()..update(updates))._build();

  _$AdminRecordDepositAnswerDtoOutput._({this.receipt}) : super._();
  @override
  AdminRecordDepositAnswerDtoOutput rebuild(
    void Function(AdminRecordDepositAnswerDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRecordDepositAnswerDtoOutputBuilder toBuilder() =>
      AdminRecordDepositAnswerDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRecordDepositAnswerDtoOutput &&
        receipt == other.receipt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, receipt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRecordDepositAnswerDtoOutput',
    )..add('receipt', receipt)).toString();
  }
}

class AdminRecordDepositAnswerDtoOutputBuilder
    implements
        Builder<
          AdminRecordDepositAnswerDtoOutput,
          AdminRecordDepositAnswerDtoOutputBuilder
        > {
  _$AdminRecordDepositAnswerDtoOutput? _$v;

  AdminRecordDepositAnswerDtoOutputReceiptBuilder? _receipt;
  AdminRecordDepositAnswerDtoOutputReceiptBuilder get receipt =>
      _$this._receipt ??= AdminRecordDepositAnswerDtoOutputReceiptBuilder();
  set receipt(AdminRecordDepositAnswerDtoOutputReceiptBuilder? receipt) =>
      _$this._receipt = receipt;

  AdminRecordDepositAnswerDtoOutputBuilder() {
    AdminRecordDepositAnswerDtoOutput._defaults(this);
  }

  AdminRecordDepositAnswerDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _receipt = $v.receipt?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRecordDepositAnswerDtoOutput other) {
    _$v = other as _$AdminRecordDepositAnswerDtoOutput;
  }

  @override
  void update(
    void Function(AdminRecordDepositAnswerDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRecordDepositAnswerDtoOutput build() => _build();

  _$AdminRecordDepositAnswerDtoOutput _build() {
    _$AdminRecordDepositAnswerDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRecordDepositAnswerDtoOutput._(receipt: _receipt?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'receipt';
        _receipt?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRecordDepositAnswerDtoOutput',
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
