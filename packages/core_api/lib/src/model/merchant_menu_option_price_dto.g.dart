// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_option_price_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuOptionPriceDto extends MerchantMenuOptionPriceDto {
  @override
  final MerchantMenuOptionPriceDtoPriceDelta priceDelta;

  factory _$MerchantMenuOptionPriceDto([
    void Function(MerchantMenuOptionPriceDtoBuilder)? updates,
  ]) => (MerchantMenuOptionPriceDtoBuilder()..update(updates))._build();

  _$MerchantMenuOptionPriceDto._({required this.priceDelta}) : super._();
  @override
  MerchantMenuOptionPriceDto rebuild(
    void Function(MerchantMenuOptionPriceDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuOptionPriceDtoBuilder toBuilder() =>
      MerchantMenuOptionPriceDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuOptionPriceDto &&
        priceDelta == other.priceDelta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, priceDelta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantMenuOptionPriceDto',
    )..add('priceDelta', priceDelta)).toString();
  }
}

class MerchantMenuOptionPriceDtoBuilder
    implements
        Builder<MerchantMenuOptionPriceDto, MerchantMenuOptionPriceDtoBuilder> {
  _$MerchantMenuOptionPriceDto? _$v;

  MerchantMenuOptionPriceDtoPriceDeltaBuilder? _priceDelta;
  MerchantMenuOptionPriceDtoPriceDeltaBuilder get priceDelta =>
      _$this._priceDelta ??= MerchantMenuOptionPriceDtoPriceDeltaBuilder();
  set priceDelta(MerchantMenuOptionPriceDtoPriceDeltaBuilder? priceDelta) =>
      _$this._priceDelta = priceDelta;

  MerchantMenuOptionPriceDtoBuilder() {
    MerchantMenuOptionPriceDto._defaults(this);
  }

  MerchantMenuOptionPriceDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _priceDelta = $v.priceDelta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuOptionPriceDto other) {
    _$v = other as _$MerchantMenuOptionPriceDto;
  }

  @override
  void update(void Function(MerchantMenuOptionPriceDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuOptionPriceDto build() => _build();

  _$MerchantMenuOptionPriceDto _build() {
    _$MerchantMenuOptionPriceDto _$result;
    try {
      _$result =
          _$v ?? _$MerchantMenuOptionPriceDto._(priceDelta: priceDelta.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'priceDelta';
        priceDelta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuOptionPriceDto',
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
