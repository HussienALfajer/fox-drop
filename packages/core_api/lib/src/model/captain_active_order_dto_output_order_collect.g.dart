// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_collect.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderCollect
    extends CaptainActiveOrderDtoOutputOrderCollect {
  @override
  final String amount;
  @override
  final String currency;

  factory _$CaptainActiveOrderDtoOutputOrderCollect([
    void Function(CaptainActiveOrderDtoOutputOrderCollectBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputOrderCollectBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputOrderCollect._({
    required this.amount,
    required this.currency,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderCollect rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderCollectBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderCollectBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderCollectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderCollect &&
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
            r'CaptainActiveOrderDtoOutputOrderCollect',
          )
          ..add('amount', amount)
          ..add('currency', currency))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderCollectBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderCollect,
          CaptainActiveOrderDtoOutputOrderCollectBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderCollect? _$v;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  CaptainActiveOrderDtoOutputOrderCollectBuilder() {
    CaptainActiveOrderDtoOutputOrderCollect._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderCollectBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _amount = $v.amount;
      _currency = $v.currency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderCollect other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderCollect;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderCollectBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderCollect build() => _build();

  _$CaptainActiveOrderDtoOutputOrderCollect _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderCollect._(
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'CaptainActiveOrderDtoOutputOrderCollect',
            'amount',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'CaptainActiveOrderDtoOutputOrderCollect',
            'currency',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
