// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_receipts_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerReceiptsDtoOutput extends AdminCustomerReceiptsDtoOutput {
  @override
  final BuiltList<AdminCustomerReceiptsDtoOutputReceiptsInner> receipts;

  factory _$AdminCustomerReceiptsDtoOutput([
    void Function(AdminCustomerReceiptsDtoOutputBuilder)? updates,
  ]) => (AdminCustomerReceiptsDtoOutputBuilder()..update(updates))._build();

  _$AdminCustomerReceiptsDtoOutput._({required this.receipts}) : super._();
  @override
  AdminCustomerReceiptsDtoOutput rebuild(
    void Function(AdminCustomerReceiptsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerReceiptsDtoOutputBuilder toBuilder() =>
      AdminCustomerReceiptsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerReceiptsDtoOutput &&
        receipts == other.receipts;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, receipts.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCustomerReceiptsDtoOutput',
    )..add('receipts', receipts)).toString();
  }
}

class AdminCustomerReceiptsDtoOutputBuilder
    implements
        Builder<
          AdminCustomerReceiptsDtoOutput,
          AdminCustomerReceiptsDtoOutputBuilder
        > {
  _$AdminCustomerReceiptsDtoOutput? _$v;

  ListBuilder<AdminCustomerReceiptsDtoOutputReceiptsInner>? _receipts;
  ListBuilder<AdminCustomerReceiptsDtoOutputReceiptsInner> get receipts =>
      _$this._receipts ??=
          ListBuilder<AdminCustomerReceiptsDtoOutputReceiptsInner>();
  set receipts(
    ListBuilder<AdminCustomerReceiptsDtoOutputReceiptsInner>? receipts,
  ) => _$this._receipts = receipts;

  AdminCustomerReceiptsDtoOutputBuilder() {
    AdminCustomerReceiptsDtoOutput._defaults(this);
  }

  AdminCustomerReceiptsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _receipts = $v.receipts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerReceiptsDtoOutput other) {
    _$v = other as _$AdminCustomerReceiptsDtoOutput;
  }

  @override
  void update(void Function(AdminCustomerReceiptsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerReceiptsDtoOutput build() => _build();

  _$AdminCustomerReceiptsDtoOutput _build() {
    _$AdminCustomerReceiptsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminCustomerReceiptsDtoOutput._(receipts: receipts.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'receipts';
        receipts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCustomerReceiptsDtoOutput',
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
