// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_receipt_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantReceiptListDtoOutput extends MerchantReceiptListDtoOutput {
  @override
  final BuiltList<MerchantReceiptListDtoOutputReceiptsInner> receipts;

  factory _$MerchantReceiptListDtoOutput([
    void Function(MerchantReceiptListDtoOutputBuilder)? updates,
  ]) => (MerchantReceiptListDtoOutputBuilder()..update(updates))._build();

  _$MerchantReceiptListDtoOutput._({required this.receipts}) : super._();
  @override
  MerchantReceiptListDtoOutput rebuild(
    void Function(MerchantReceiptListDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantReceiptListDtoOutputBuilder toBuilder() =>
      MerchantReceiptListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantReceiptListDtoOutput && receipts == other.receipts;
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
      r'MerchantReceiptListDtoOutput',
    )..add('receipts', receipts)).toString();
  }
}

class MerchantReceiptListDtoOutputBuilder
    implements
        Builder<
          MerchantReceiptListDtoOutput,
          MerchantReceiptListDtoOutputBuilder
        > {
  _$MerchantReceiptListDtoOutput? _$v;

  ListBuilder<MerchantReceiptListDtoOutputReceiptsInner>? _receipts;
  ListBuilder<MerchantReceiptListDtoOutputReceiptsInner> get receipts =>
      _$this._receipts ??=
          ListBuilder<MerchantReceiptListDtoOutputReceiptsInner>();
  set receipts(
    ListBuilder<MerchantReceiptListDtoOutputReceiptsInner>? receipts,
  ) => _$this._receipts = receipts;

  MerchantReceiptListDtoOutputBuilder() {
    MerchantReceiptListDtoOutput._defaults(this);
  }

  MerchantReceiptListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _receipts = $v.receipts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantReceiptListDtoOutput other) {
    _$v = other as _$MerchantReceiptListDtoOutput;
  }

  @override
  void update(void Function(MerchantReceiptListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantReceiptListDtoOutput build() => _build();

  _$MerchantReceiptListDtoOutput _build() {
    _$MerchantReceiptListDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$MerchantReceiptListDtoOutput._(receipts: receipts.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'receipts';
        receipts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantReceiptListDtoOutput',
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
