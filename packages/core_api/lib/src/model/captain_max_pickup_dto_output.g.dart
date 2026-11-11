// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_max_pickup_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainMaxPickupDtoOutput extends CaptainMaxPickupDtoOutput {
  @override
  final CaptainWentOfflineDtoOutputHandIn? limit;
  @override
  final bool answered;
  @override
  final String? baseCurrency;

  factory _$CaptainMaxPickupDtoOutput([
    void Function(CaptainMaxPickupDtoOutputBuilder)? updates,
  ]) => (CaptainMaxPickupDtoOutputBuilder()..update(updates))._build();

  _$CaptainMaxPickupDtoOutput._({
    this.limit,
    required this.answered,
    this.baseCurrency,
  }) : super._();
  @override
  CaptainMaxPickupDtoOutput rebuild(
    void Function(CaptainMaxPickupDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainMaxPickupDtoOutputBuilder toBuilder() =>
      CaptainMaxPickupDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainMaxPickupDtoOutput &&
        limit == other.limit &&
        answered == other.answered &&
        baseCurrency == other.baseCurrency;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, limit.hashCode);
    _$hash = $jc(_$hash, answered.hashCode);
    _$hash = $jc(_$hash, baseCurrency.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainMaxPickupDtoOutput')
          ..add('limit', limit)
          ..add('answered', answered)
          ..add('baseCurrency', baseCurrency))
        .toString();
  }
}

class CaptainMaxPickupDtoOutputBuilder
    implements
        Builder<CaptainMaxPickupDtoOutput, CaptainMaxPickupDtoOutputBuilder> {
  _$CaptainMaxPickupDtoOutput? _$v;

  CaptainWentOfflineDtoOutputHandInBuilder? _limit;
  CaptainWentOfflineDtoOutputHandInBuilder get limit =>
      _$this._limit ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set limit(CaptainWentOfflineDtoOutputHandInBuilder? limit) =>
      _$this._limit = limit;

  bool? _answered;
  bool? get answered => _$this._answered;
  set answered(bool? answered) => _$this._answered = answered;

  String? _baseCurrency;
  String? get baseCurrency => _$this._baseCurrency;
  set baseCurrency(String? baseCurrency) => _$this._baseCurrency = baseCurrency;

  CaptainMaxPickupDtoOutputBuilder() {
    CaptainMaxPickupDtoOutput._defaults(this);
  }

  CaptainMaxPickupDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _limit = $v.limit?.toBuilder();
      _answered = $v.answered;
      _baseCurrency = $v.baseCurrency;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainMaxPickupDtoOutput other) {
    _$v = other as _$CaptainMaxPickupDtoOutput;
  }

  @override
  void update(void Function(CaptainMaxPickupDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainMaxPickupDtoOutput build() => _build();

  _$CaptainMaxPickupDtoOutput _build() {
    _$CaptainMaxPickupDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainMaxPickupDtoOutput._(
            limit: _limit?.build(),
            answered: BuiltValueNullFieldError.checkNotNull(
              answered,
              r'CaptainMaxPickupDtoOutput',
              'answered',
            ),
            baseCurrency: baseCurrency,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'limit';
        _limit?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainMaxPickupDtoOutput',
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
