// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_picker_dto_output_captains_inner_custody_usage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPickerDtoOutputCaptainsInnerCustodyUsage
    extends AdminPickerDtoOutputCaptainsInnerCustodyUsage {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminPickerDtoOutputCaptainsInnerCustodyUsage([
    void Function(AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder)?
    updates,
  ]) =>
      (AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder()..update(updates))
          ._build();

  _$AdminPickerDtoOutputCaptainsInnerCustodyUsage._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminPickerDtoOutputCaptainsInnerCustodyUsage rebuild(
    void Function(AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder toBuilder() =>
      AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPickerDtoOutputCaptainsInnerCustodyUsage &&
        amount == other.amount &&
        currency == other.currency;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminPickerDtoOutputCaptainsInnerCustodyUsage',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder
    implements
        Builder<
          AdminPickerDtoOutputCaptainsInnerCustodyUsage,
          AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder
        > {
  _$AdminPickerDtoOutputCaptainsInnerCustodyUsage? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder() {
    AdminPickerDtoOutputCaptainsInnerCustodyUsage._defaults(this);
  }

  AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPickerDtoOutputCaptainsInnerCustodyUsage other) {
    _$v = other as _$AdminPickerDtoOutputCaptainsInnerCustodyUsage;
  }

  @override
  void update(
    void Function(AdminPickerDtoOutputCaptainsInnerCustodyUsageBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPickerDtoOutputCaptainsInnerCustodyUsage build() => _build();

  _$AdminPickerDtoOutputCaptainsInnerCustodyUsage _build() {
    final _$result =
        _$v ??
        _$AdminPickerDtoOutputCaptainsInnerCustodyUsage._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminPickerDtoOutputCaptainsInnerCustodyUsage',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminPickerDtoOutputCaptainsInnerCustodyUsage',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
