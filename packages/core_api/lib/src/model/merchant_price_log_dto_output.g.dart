// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_price_log_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantPriceLogDtoOutput extends MerchantPriceLogDtoOutput {
  @override
  final BuiltList<MerchantPriceLogDtoOutputEntriesInner> entries;

  factory _$MerchantPriceLogDtoOutput([
    void Function(MerchantPriceLogDtoOutputBuilder)? updates,
  ]) => (MerchantPriceLogDtoOutputBuilder()..update(updates))._build();

  _$MerchantPriceLogDtoOutput._({required this.entries}) : super._();
  @override
  MerchantPriceLogDtoOutput rebuild(
    void Function(MerchantPriceLogDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantPriceLogDtoOutputBuilder toBuilder() =>
      MerchantPriceLogDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantPriceLogDtoOutput && entries == other.entries;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, entries.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantPriceLogDtoOutput',
    )..add('entries', entries)).toString();
  }
}

class MerchantPriceLogDtoOutputBuilder
    implements
        Builder<MerchantPriceLogDtoOutput, MerchantPriceLogDtoOutputBuilder> {
  _$MerchantPriceLogDtoOutput? _$v;

  ListBuilder<MerchantPriceLogDtoOutputEntriesInner>? _entries;
  ListBuilder<MerchantPriceLogDtoOutputEntriesInner> get entries =>
      _$this._entries ??= ListBuilder<MerchantPriceLogDtoOutputEntriesInner>();
  set entries(ListBuilder<MerchantPriceLogDtoOutputEntriesInner>? entries) =>
      _$this._entries = entries;

  MerchantPriceLogDtoOutputBuilder() {
    MerchantPriceLogDtoOutput._defaults(this);
  }

  MerchantPriceLogDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _entries = $v.entries.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantPriceLogDtoOutput other) {
    _$v = other as _$MerchantPriceLogDtoOutput;
  }

  @override
  void update(void Function(MerchantPriceLogDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantPriceLogDtoOutput build() => _build();

  _$MerchantPriceLogDtoOutput _build() {
    _$MerchantPriceLogDtoOutput _$result;
    try {
      _$result = _$v ?? _$MerchantPriceLogDtoOutput._(entries: entries.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'entries';
        entries.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantPriceLogDtoOutput',
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
