// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_hand_in_dto_conversions_inner_rates_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHandInDtoConversionsInnerRatesInner
    extends AdminHandInDtoConversionsInnerRatesInner {
  @override
  final String currency;
  @override
  final String rateVersionId;

  factory _$AdminHandInDtoConversionsInnerRatesInner([
    void Function(AdminHandInDtoConversionsInnerRatesInnerBuilder)? updates,
  ]) => (AdminHandInDtoConversionsInnerRatesInnerBuilder()..update(updates))
      ._build();

  _$AdminHandInDtoConversionsInnerRatesInner._({
    required this.currency,
    required this.rateVersionId,
  }) : super._();
  @override
  AdminHandInDtoConversionsInnerRatesInner rebuild(
    void Function(AdminHandInDtoConversionsInnerRatesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHandInDtoConversionsInnerRatesInnerBuilder toBuilder() =>
      AdminHandInDtoConversionsInnerRatesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHandInDtoConversionsInnerRatesInner &&
        currency == other.currency &&
        rateVersionId == other.rateVersionId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, rateVersionId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminHandInDtoConversionsInnerRatesInner',
          )
          ..add('currency', currency)
          ..add('rateVersionId', rateVersionId))
        .toString();
  }
}

class AdminHandInDtoConversionsInnerRatesInnerBuilder
    implements
        Builder<
          AdminHandInDtoConversionsInnerRatesInner,
          AdminHandInDtoConversionsInnerRatesInnerBuilder
        > {
  _$AdminHandInDtoConversionsInnerRatesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _rateVersionId;
  String? get rateVersionId => _$this._rateVersionId;
  set rateVersionId(String? rateVersionId) =>
      _$this._rateVersionId = rateVersionId;

  AdminHandInDtoConversionsInnerRatesInnerBuilder() {
    AdminHandInDtoConversionsInnerRatesInner._defaults(this);
  }

  AdminHandInDtoConversionsInnerRatesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _rateVersionId = $v.rateVersionId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHandInDtoConversionsInnerRatesInner other) {
    _$v = other as _$AdminHandInDtoConversionsInnerRatesInner;
  }

  @override
  void update(
    void Function(AdminHandInDtoConversionsInnerRatesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminHandInDtoConversionsInnerRatesInner build() => _build();

  _$AdminHandInDtoConversionsInnerRatesInner _build() {
    final _$result =
        _$v ??
        _$AdminHandInDtoConversionsInnerRatesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminHandInDtoConversionsInnerRatesInner',
            'currency',
          ),
          rateVersionId: BuiltValueNullFieldError.checkNotNull(
            rateVersionId,
            r'AdminHandInDtoConversionsInnerRatesInner',
            'rateVersionId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
