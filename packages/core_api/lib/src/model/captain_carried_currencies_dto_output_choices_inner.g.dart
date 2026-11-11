// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_carried_currencies_dto_output_choices_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCarriedCurrenciesDtoOutputChoicesInner
    extends CaptainCarriedCurrenciesDtoOutputChoicesInner {
  @override
  final String currency;
  @override
  final String name;

  factory _$CaptainCarriedCurrenciesDtoOutputChoicesInner([
    void Function(CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder)?
    updates,
  ]) =>
      (CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder()..update(updates))
          ._build();

  _$CaptainCarriedCurrenciesDtoOutputChoicesInner._({
    required this.currency,
    required this.name,
  }) : super._();
  @override
  CaptainCarriedCurrenciesDtoOutputChoicesInner rebuild(
    void Function(CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder toBuilder() =>
      CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCarriedCurrenciesDtoOutputChoicesInner &&
        currency == other.currency &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainCarriedCurrenciesDtoOutputChoicesInner',
          )
          ..add('currency', currency)
          ..add('name', name))
        .toString();
  }
}

class CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder
    implements
        Builder<
          CaptainCarriedCurrenciesDtoOutputChoicesInner,
          CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder
        > {
  _$CaptainCarriedCurrenciesDtoOutputChoicesInner? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder() {
    CaptainCarriedCurrenciesDtoOutputChoicesInner._defaults(this);
  }

  CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCarriedCurrenciesDtoOutputChoicesInner other) {
    _$v = other as _$CaptainCarriedCurrenciesDtoOutputChoicesInner;
  }

  @override
  void update(
    void Function(CaptainCarriedCurrenciesDtoOutputChoicesInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCarriedCurrenciesDtoOutputChoicesInner build() => _build();

  _$CaptainCarriedCurrenciesDtoOutputChoicesInner _build() {
    final _$result =
        _$v ??
        _$CaptainCarriedCurrenciesDtoOutputChoicesInner._(
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainCarriedCurrenciesDtoOutputChoicesInner',
            'currency',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'CaptainCarriedCurrenciesDtoOutputChoicesInner',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
