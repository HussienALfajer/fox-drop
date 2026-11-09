// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_schedule_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantScheduleDto extends MerchantScheduleDto {
  @override
  final BuiltList<MerchantScheduleDtoPeriodsInner> periods;

  factory _$MerchantScheduleDto([
    void Function(MerchantScheduleDtoBuilder)? updates,
  ]) => (MerchantScheduleDtoBuilder()..update(updates))._build();

  _$MerchantScheduleDto._({required this.periods}) : super._();
  @override
  MerchantScheduleDto rebuild(
    void Function(MerchantScheduleDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantScheduleDtoBuilder toBuilder() =>
      MerchantScheduleDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantScheduleDto && periods == other.periods;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, periods.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'MerchantScheduleDto',
    )..add('periods', periods)).toString();
  }
}

class MerchantScheduleDtoBuilder
    implements Builder<MerchantScheduleDto, MerchantScheduleDtoBuilder> {
  _$MerchantScheduleDto? _$v;

  ListBuilder<MerchantScheduleDtoPeriodsInner>? _periods;
  ListBuilder<MerchantScheduleDtoPeriodsInner> get periods =>
      _$this._periods ??= ListBuilder<MerchantScheduleDtoPeriodsInner>();
  set periods(ListBuilder<MerchantScheduleDtoPeriodsInner>? periods) =>
      _$this._periods = periods;

  MerchantScheduleDtoBuilder() {
    MerchantScheduleDto._defaults(this);
  }

  MerchantScheduleDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _periods = $v.periods.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantScheduleDto other) {
    _$v = other as _$MerchantScheduleDto;
  }

  @override
  void update(void Function(MerchantScheduleDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantScheduleDto build() => _build();

  _$MerchantScheduleDto _build() {
    _$MerchantScheduleDto _$result;
    try {
      _$result = _$v ?? _$MerchantScheduleDto._(periods: periods.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'periods';
        periods.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantScheduleDto',
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
