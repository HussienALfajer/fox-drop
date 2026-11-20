// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_live_map_dto_output_captains_inner_custody_usage.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminLiveMapDtoOutputCaptainsInnerCustodyUsage
    extends AdminLiveMapDtoOutputCaptainsInnerCustodyUsage {
  @override
  final String amount;
  @override
  final String currency;

  factory _$AdminLiveMapDtoOutputCaptainsInnerCustodyUsage([
    void Function(AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder)?
    updates,
  ]) =>
      (AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder()..update(updates))
          ._build();

  _$AdminLiveMapDtoOutputCaptainsInnerCustodyUsage._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  AdminLiveMapDtoOutputCaptainsInnerCustodyUsage rebuild(
    void Function(AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder toBuilder() =>
      AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLiveMapDtoOutputCaptainsInnerCustodyUsage &&
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
            r'AdminLiveMapDtoOutputCaptainsInnerCustodyUsage',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder
    implements
        Builder<
          AdminLiveMapDtoOutputCaptainsInnerCustodyUsage,
          AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder
        > {
  _$AdminLiveMapDtoOutputCaptainsInnerCustodyUsage? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder() {
    AdminLiveMapDtoOutputCaptainsInnerCustodyUsage._defaults(this);
  }

  AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLiveMapDtoOutputCaptainsInnerCustodyUsage other) {
    _$v = other as _$AdminLiveMapDtoOutputCaptainsInnerCustodyUsage;
  }

  @override
  void update(
    void Function(AdminLiveMapDtoOutputCaptainsInnerCustodyUsageBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminLiveMapDtoOutputCaptainsInnerCustodyUsage build() => _build();

  _$AdminLiveMapDtoOutputCaptainsInnerCustodyUsage _build() {
    final _$result =
        _$v ??
        _$AdminLiveMapDtoOutputCaptainsInnerCustodyUsage._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'AdminLiveMapDtoOutputCaptainsInnerCustodyUsage',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminLiveMapDtoOutputCaptainsInnerCustodyUsage',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
