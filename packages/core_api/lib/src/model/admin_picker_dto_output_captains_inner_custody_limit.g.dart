// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_picker_dto_output_captains_inner_custody_limit.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminPickerDtoOutputCaptainsInnerCustodyLimit
    extends AdminPickerDtoOutputCaptainsInnerCustodyLimit {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminPickerDtoOutputCaptainsInnerCustodyLimit([
    void Function(AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder)?
    updates,
  ]) =>
      (AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder()..update(updates))
          ._build();

  _$AdminPickerDtoOutputCaptainsInnerCustodyLimit._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminPickerDtoOutputCaptainsInnerCustodyLimit rebuild(
    void Function(AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder toBuilder() =>
      AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminPickerDtoOutputCaptainsInnerCustodyLimit &&
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
            r'AdminPickerDtoOutputCaptainsInnerCustodyLimit',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder
    implements
        Builder<
          AdminPickerDtoOutputCaptainsInnerCustodyLimit,
          AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder
        > {
  _$AdminPickerDtoOutputCaptainsInnerCustodyLimit? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder() {
    AdminPickerDtoOutputCaptainsInnerCustodyLimit._defaults(this);
  }

  AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminPickerDtoOutputCaptainsInnerCustodyLimit other) {
    _$v = other as _$AdminPickerDtoOutputCaptainsInnerCustodyLimit;
  }

  @override
  void update(
    void Function(AdminPickerDtoOutputCaptainsInnerCustodyLimitBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminPickerDtoOutputCaptainsInnerCustodyLimit build() => _build();

  _$AdminPickerDtoOutputCaptainsInnerCustodyLimit _build() {
    final _$result =
        _$v ??
        _$AdminPickerDtoOutputCaptainsInnerCustodyLimit._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminPickerDtoOutputCaptainsInnerCustodyLimit',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminPickerDtoOutputCaptainsInnerCustodyLimit',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
