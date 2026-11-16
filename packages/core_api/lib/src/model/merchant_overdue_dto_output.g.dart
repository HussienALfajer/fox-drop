// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_overdue_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOverdueDtoOutput extends MerchantOverdueDtoOutput {
  @override
  final MerchantOverdueDtoOutputOverdue? overdue;

  factory _$MerchantOverdueDtoOutput([
    void Function(MerchantOverdueDtoOutputBuilder)? updates,
  ]) => (MerchantOverdueDtoOutputBuilder()..update(updates))._build();

  _$MerchantOverdueDtoOutput._({this.overdue}) : super._();
  @override
  MerchantOverdueDtoOutput rebuild(
    void Function(MerchantOverdueDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOverdueDtoOutputBuilder toBuilder() =>
      MerchantOverdueDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOverdueDtoOutput && overdue == other.overdue;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, overdue.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantOverdueDtoOutput',
    )..add('overdue', overdue)).toString();
  }
}

class MerchantOverdueDtoOutputBuilder
    implements
        Builder<MerchantOverdueDtoOutput, MerchantOverdueDtoOutputBuilder> {
  _$MerchantOverdueDtoOutput? _$v;

  MerchantOverdueDtoOutputOverdueBuilder? _overdue;
  MerchantOverdueDtoOutputOverdueBuilder get overdue =>
      _$this._overdue ??= MerchantOverdueDtoOutputOverdueBuilder();
  set overdue(MerchantOverdueDtoOutputOverdueBuilder? overdue) =>
      _$this._overdue = overdue;

  MerchantOverdueDtoOutputBuilder() {
    MerchantOverdueDtoOutput._defaults(this);
  }

  MerchantOverdueDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _overdue = $v.overdue?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOverdueDtoOutput other) {
    _$v = other as _$MerchantOverdueDtoOutput;
  }

  @override
  void update(void Function(MerchantOverdueDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOverdueDtoOutput build() => _build();

  _$MerchantOverdueDtoOutput _build() {
    _$MerchantOverdueDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$MerchantOverdueDtoOutput._(overdue: _overdue?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'overdue';
        _overdue?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOverdueDtoOutput',
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
