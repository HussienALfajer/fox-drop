// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_carried_currencies_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCarriedCurrenciesDtoOutput
    extends CaptainCarriedCurrenciesDtoOutput {
  @override
  final String? baseCurrency;
  @override
  final BuiltList<String> carried;
  @override
  final BuiltList<CaptainCarriedCurrenciesDtoOutputChoicesInner> choices;

  factory _$CaptainCarriedCurrenciesDtoOutput([
    void Function(CaptainCarriedCurrenciesDtoOutputBuilder)? updates,
  ]) => (CaptainCarriedCurrenciesDtoOutputBuilder()..update(updates))._build();

  _$CaptainCarriedCurrenciesDtoOutput._({
    this.baseCurrency,
    required this.carried,
    required this.choices,
  }) : super._();
  @override
  CaptainCarriedCurrenciesDtoOutput rebuild(
    void Function(CaptainCarriedCurrenciesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCarriedCurrenciesDtoOutputBuilder toBuilder() =>
      CaptainCarriedCurrenciesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCarriedCurrenciesDtoOutput &&
        baseCurrency == other.baseCurrency &&
        carried == other.carried &&
        choices == other.choices;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, baseCurrency.hashCode);
    _$hash = $jc(_$hash, carried.hashCode);
    _$hash = $jc(_$hash, choices.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainCarriedCurrenciesDtoOutput')
          ..add('baseCurrency', baseCurrency)
          ..add('carried', carried)
          ..add('choices', choices))
        .toString();
  }
}

class CaptainCarriedCurrenciesDtoOutputBuilder
    implements
        Builder<
          CaptainCarriedCurrenciesDtoOutput,
          CaptainCarriedCurrenciesDtoOutputBuilder
        > {
  _$CaptainCarriedCurrenciesDtoOutput? _$v;

  String? _baseCurrency;
  String? get baseCurrency => _$this._baseCurrency;
  set baseCurrency(String? baseCurrency) => _$this._baseCurrency = baseCurrency;

  ListBuilder<String>? _carried;
  ListBuilder<String> get carried => _$this._carried ??= ListBuilder<String>();
  set carried(ListBuilder<String>? carried) => _$this._carried = carried;

  ListBuilder<CaptainCarriedCurrenciesDtoOutputChoicesInner>? _choices;
  ListBuilder<CaptainCarriedCurrenciesDtoOutputChoicesInner> get choices =>
      _$this._choices ??=
          ListBuilder<CaptainCarriedCurrenciesDtoOutputChoicesInner>();
  set choices(
    ListBuilder<CaptainCarriedCurrenciesDtoOutputChoicesInner>? choices,
  ) => _$this._choices = choices;

  CaptainCarriedCurrenciesDtoOutputBuilder() {
    CaptainCarriedCurrenciesDtoOutput._defaults(this);
  }

  CaptainCarriedCurrenciesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _baseCurrency = $v.baseCurrency;
      _carried = $v.carried.toBuilder();
      _choices = $v.choices.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCarriedCurrenciesDtoOutput other) {
    _$v = other as _$CaptainCarriedCurrenciesDtoOutput;
  }

  @override
  void update(
    void Function(CaptainCarriedCurrenciesDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCarriedCurrenciesDtoOutput build() => _build();

  _$CaptainCarriedCurrenciesDtoOutput _build() {
    _$CaptainCarriedCurrenciesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainCarriedCurrenciesDtoOutput._(
            baseCurrency: baseCurrency,
            carried: carried.build(),
            choices: choices.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'carried';
        carried.build();
        _$failedField = 'choices';
        choices.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainCarriedCurrenciesDtoOutput',
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
