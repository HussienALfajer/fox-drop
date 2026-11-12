// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_hand_in_dto_conversions_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHandInDtoConversionsInner extends AdminHandInDtoConversionsInner {
  @override
  final String from;
  @override
  final String to;
  @override
  final String amount;
  @override
  final String converted;
  @override
  final BuiltList<AdminHandInDtoConversionsInnerRatesInner> rates;

  factory _$AdminHandInDtoConversionsInner([
    void Function(AdminHandInDtoConversionsInnerBuilder)? updates,
  ]) => (AdminHandInDtoConversionsInnerBuilder()..update(updates))._build();

  _$AdminHandInDtoConversionsInner._({
    required this.from,
    required this.to,
    required this.amount,
    required this.converted,
    required this.rates,
  }) : super._();
  @override
  AdminHandInDtoConversionsInner rebuild(
    void Function(AdminHandInDtoConversionsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHandInDtoConversionsInnerBuilder toBuilder() =>
      AdminHandInDtoConversionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHandInDtoConversionsInner &&
        from == other.from &&
        to == other.to &&
        amount == other.amount &&
        converted == other.converted &&
        rates == other.rates;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, converted.hashCode);
    _$hash = $jc(_$hash, rates.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminHandInDtoConversionsInner')
          ..add('from', from)
          ..add('to', to)
          ..add('amount', amount)
          ..add('converted', converted)
          ..add('rates', rates))
        .toString();
  }
}

class AdminHandInDtoConversionsInnerBuilder
    implements
        Builder<
          AdminHandInDtoConversionsInner,
          AdminHandInDtoConversionsInnerBuilder
        > {
  _$AdminHandInDtoConversionsInner? _$v;

  String? _from;
  String? get from => _$this._from;
  set from(String? from) => _$this._from = from;

  String? _to;
  String? get to => _$this._to;
  set to(String? to) => _$this._to = to;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _converted;
  String? get converted => _$this._converted;
  set converted(String? converted) => _$this._converted = converted;

  ListBuilder<AdminHandInDtoConversionsInnerRatesInner>? _rates;
  ListBuilder<AdminHandInDtoConversionsInnerRatesInner> get rates =>
      _$this._rates ??= ListBuilder<AdminHandInDtoConversionsInnerRatesInner>();
  set rates(ListBuilder<AdminHandInDtoConversionsInnerRatesInner>? rates) =>
      _$this._rates = rates;

  AdminHandInDtoConversionsInnerBuilder() {
    AdminHandInDtoConversionsInner._defaults(this);
  }

  AdminHandInDtoConversionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _from = $v.from;
      _to = $v.to;
      _amount = $v.amount;
      _converted = $v.converted;
      _rates = $v.rates.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHandInDtoConversionsInner other) {
    _$v = other as _$AdminHandInDtoConversionsInner;
  }

  @override
  void update(void Function(AdminHandInDtoConversionsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminHandInDtoConversionsInner build() => _build();

  _$AdminHandInDtoConversionsInner _build() {
    _$AdminHandInDtoConversionsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminHandInDtoConversionsInner._(
            from: BuiltValueNullFieldError.checkNotNull(
              from,
              r'AdminHandInDtoConversionsInner',
              'from',
            ),
            to: BuiltValueNullFieldError.checkNotNull(
              to,
              r'AdminHandInDtoConversionsInner',
              'to',
            ),
            amount: BuiltValueNullFieldError.checkNotNull(
              amount,
              r'AdminHandInDtoConversionsInner',
              'amount',
            ),
            converted: BuiltValueNullFieldError.checkNotNull(
              converted,
              r'AdminHandInDtoConversionsInner',
              'converted',
            ),
            rates: rates.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'rates';
        rates.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminHandInDtoConversionsInner',
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
