// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_hand_in_receipts_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHandInReceiptsDtoOutput extends AdminHandInReceiptsDtoOutput {
  @override
  final BuiltList<AdminHandInReceiptsDtoOutputReceiptsInner> receipts;

  factory _$AdminHandInReceiptsDtoOutput([
    void Function(AdminHandInReceiptsDtoOutputBuilder)? updates,
  ]) => (AdminHandInReceiptsDtoOutputBuilder()..update(updates))._build();

  _$AdminHandInReceiptsDtoOutput._({required this.receipts}) : super._();
  @override
  AdminHandInReceiptsDtoOutput rebuild(
    void Function(AdminHandInReceiptsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHandInReceiptsDtoOutputBuilder toBuilder() =>
      AdminHandInReceiptsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHandInReceiptsDtoOutput && receipts == other.receipts;
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
      r'AdminHandInReceiptsDtoOutput',
    )..add('receipts', receipts)).toString();
  }
}

class AdminHandInReceiptsDtoOutputBuilder
    implements
        Builder<
          AdminHandInReceiptsDtoOutput,
          AdminHandInReceiptsDtoOutputBuilder
        > {
  _$AdminHandInReceiptsDtoOutput? _$v;

  ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInner>? _receipts;
  ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInner> get receipts =>
      _$this._receipts ??=
          ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInner>();
  set receipts(
    ListBuilder<AdminHandInReceiptsDtoOutputReceiptsInner>? receipts,
  ) => _$this._receipts = receipts;

  AdminHandInReceiptsDtoOutputBuilder() {
    AdminHandInReceiptsDtoOutput._defaults(this);
  }

  AdminHandInReceiptsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _receipts = $v.receipts.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHandInReceiptsDtoOutput other) {
    _$v = other as _$AdminHandInReceiptsDtoOutput;
  }

  @override
  void update(void Function(AdminHandInReceiptsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminHandInReceiptsDtoOutput build() => _build();

  _$AdminHandInReceiptsDtoOutput _build() {
    _$AdminHandInReceiptsDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminHandInReceiptsDtoOutput._(receipts: receipts.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'receipts';
        receipts.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminHandInReceiptsDtoOutput',
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
