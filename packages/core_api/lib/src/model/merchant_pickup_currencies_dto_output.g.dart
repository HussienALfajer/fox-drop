// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_pickup_currencies_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPickupCurrenciesDtoOutput
    extends MerchantPickupCurrenciesDtoOutput {
  @override
  final MerchantPickupCurrenciesDtoOutputBaseCurrency? baseCurrency;
  @override
  final BuiltList<String> accepted;
  @override
  final BuiltList<MerchantPickupCurrenciesDtoOutputChoicesInner> choices;

  factory _$MerchantPickupCurrenciesDtoOutput([
    void Function(MerchantPickupCurrenciesDtoOutputBuilder)? updates,
  ]) => (MerchantPickupCurrenciesDtoOutputBuilder()..update(updates))._build();

  _$MerchantPickupCurrenciesDtoOutput._({
    this.baseCurrency,
    required this.accepted,
    required this.choices,
  }) : super._();
  @override
  MerchantPickupCurrenciesDtoOutput rebuild(
    void Function(MerchantPickupCurrenciesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPickupCurrenciesDtoOutputBuilder toBuilder() =>
      MerchantPickupCurrenciesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPickupCurrenciesDtoOutput &&
        baseCurrency == other.baseCurrency &&
        accepted == other.accepted &&
        choices == other.choices;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, baseCurrency.hashCode);
    _$hash = $jc(_$hash, accepted.hashCode);
    _$hash = $jc(_$hash, choices.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantPickupCurrenciesDtoOutput')
          ..add('baseCurrency', baseCurrency)
          ..add('accepted', accepted)
          ..add('choices', choices))
        .toString();
  }
}

class MerchantPickupCurrenciesDtoOutputBuilder
    implements
        Builder<
          MerchantPickupCurrenciesDtoOutput,
          MerchantPickupCurrenciesDtoOutputBuilder
        > {
  _$MerchantPickupCurrenciesDtoOutput? _$v;

  MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder? _baseCurrency;
  MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder get baseCurrency =>
      _$this._baseCurrency ??=
          MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder();
  set baseCurrency(
    MerchantPickupCurrenciesDtoOutputBaseCurrencyBuilder? baseCurrency,
  ) => _$this._baseCurrency = baseCurrency;

  ListBuilder<String>? _accepted;
  ListBuilder<String> get accepted =>
      _$this._accepted ??= ListBuilder<String>();
  set accepted(ListBuilder<String>? accepted) => _$this._accepted = accepted;

  ListBuilder<MerchantPickupCurrenciesDtoOutputChoicesInner>? _choices;
  ListBuilder<MerchantPickupCurrenciesDtoOutputChoicesInner> get choices =>
      _$this._choices ??=
          ListBuilder<MerchantPickupCurrenciesDtoOutputChoicesInner>();
  set choices(
    ListBuilder<MerchantPickupCurrenciesDtoOutputChoicesInner>? choices,
  ) => _$this._choices = choices;

  MerchantPickupCurrenciesDtoOutputBuilder() {
    MerchantPickupCurrenciesDtoOutput._defaults(this);
  }

  MerchantPickupCurrenciesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _baseCurrency = $v.baseCurrency?.toBuilder();
      _accepted = $v.accepted.toBuilder();
      _choices = $v.choices.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPickupCurrenciesDtoOutput other) {
    _$v = other as _$MerchantPickupCurrenciesDtoOutput;
  }

  @override
  void update(
    void Function(MerchantPickupCurrenciesDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPickupCurrenciesDtoOutput build() => _build();

  _$MerchantPickupCurrenciesDtoOutput _build() {
    _$MerchantPickupCurrenciesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$MerchantPickupCurrenciesDtoOutput._(
            baseCurrency: _baseCurrency?.build(),
            accepted: accepted.build(),
            choices: choices.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'baseCurrency';
        _baseCurrency?.build();
        _$failedField = 'accepted';
        accepted.build();
        _$failedField = 'choices';
        choices.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantPickupCurrenciesDtoOutput',
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
