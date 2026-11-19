// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_bulk_price_result_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuBulkPriceResultDtoOutput
    extends MerchantMenuBulkPriceResultDtoOutput {
  @override
  final int changed;
  @override
  final int unchanged;

  factory _$MerchantMenuBulkPriceResultDtoOutput([
    void Function(MerchantMenuBulkPriceResultDtoOutputBuilder)? updates,
  ]) =>
      (MerchantMenuBulkPriceResultDtoOutputBuilder()..update(updates))._build();

  _$MerchantMenuBulkPriceResultDtoOutput._({
    required this.changed,
    required this.unchanged,
  }) : super._();
  @override
  MerchantMenuBulkPriceResultDtoOutput rebuild(
    void Function(MerchantMenuBulkPriceResultDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuBulkPriceResultDtoOutputBuilder toBuilder() =>
      MerchantMenuBulkPriceResultDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuBulkPriceResultDtoOutput &&
        changed == other.changed &&
        unchanged == other.unchanged;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, changed.hashCode);
    _$hash = $jc(_$hash, unchanged.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantMenuBulkPriceResultDtoOutput')
          ..add('changed', changed)
          ..add('unchanged', unchanged))
        .toString();
  }
}

class MerchantMenuBulkPriceResultDtoOutputBuilder
    implements
        Builder<
          MerchantMenuBulkPriceResultDtoOutput,
          MerchantMenuBulkPriceResultDtoOutputBuilder
        > {
  _$MerchantMenuBulkPriceResultDtoOutput? _$v;

  int? _changed;
  int? get changed => _$this._changed;
  set changed(int? changed) => _$this._changed = changed;

  int? _unchanged;
  int? get unchanged => _$this._unchanged;
  set unchanged(int? unchanged) => _$this._unchanged = unchanged;

  MerchantMenuBulkPriceResultDtoOutputBuilder() {
    MerchantMenuBulkPriceResultDtoOutput._defaults(this);
  }

  MerchantMenuBulkPriceResultDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _changed = $v.changed;
      _unchanged = $v.unchanged;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuBulkPriceResultDtoOutput other) {
    _$v = other as _$MerchantMenuBulkPriceResultDtoOutput;
  }

  @override
  void update(
    void Function(MerchantMenuBulkPriceResultDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuBulkPriceResultDtoOutput build() => _build();

  _$MerchantMenuBulkPriceResultDtoOutput _build() {
    final _$result =
        _$v ??
        _$MerchantMenuBulkPriceResultDtoOutput._(
          changed: BuiltValueNullFieldError.checkNotNull(
            changed,
            r'MerchantMenuBulkPriceResultDtoOutput',
            'changed',
          ),
          unchanged: BuiltValueNullFieldError.checkNotNull(
            unchanged,
            r'MerchantMenuBulkPriceResultDtoOutput',
            'unchanged',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
