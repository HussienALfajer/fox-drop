// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_schedule_dto_periods_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantScheduleDtoPeriodsInner
    extends MerchantScheduleDtoPeriodsInner {
  @override
  final int weekday;
  @override
  final int opensAt;
  @override
  final int closesAt;

  factory _$MerchantScheduleDtoPeriodsInner([
    void Function(MerchantScheduleDtoPeriodsInnerBuilder)? updates,
  ]) => (MerchantScheduleDtoPeriodsInnerBuilder()..update(updates))._build();

  _$MerchantScheduleDtoPeriodsInner._({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  }) : super._();
  @override
  MerchantScheduleDtoPeriodsInner rebuild(
    void Function(MerchantScheduleDtoPeriodsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantScheduleDtoPeriodsInnerBuilder toBuilder() =>
      MerchantScheduleDtoPeriodsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantScheduleDtoPeriodsInner &&
        weekday == other.weekday &&
        opensAt == other.opensAt &&
        closesAt == other.closesAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weekday.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantScheduleDtoPeriodsInner')
          ..add('weekday', weekday)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class MerchantScheduleDtoPeriodsInnerBuilder
    implements
        Builder<
          MerchantScheduleDtoPeriodsInner,
          MerchantScheduleDtoPeriodsInnerBuilder
        > {
  _$MerchantScheduleDtoPeriodsInner? _$v;

  int? _weekday;
  int? get weekday => _$this._weekday;
  set weekday(int? weekday) => _$this._weekday = weekday;

  int? _opensAt;
  int? get opensAt => _$this._opensAt;
  set opensAt(int? opensAt) => _$this._opensAt = opensAt;

  int? _closesAt;
  int? get closesAt => _$this._closesAt;
  set closesAt(int? closesAt) => _$this._closesAt = closesAt;

  MerchantScheduleDtoPeriodsInnerBuilder() {
    MerchantScheduleDtoPeriodsInner._defaults(this);
  }

  MerchantScheduleDtoPeriodsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weekday = $v.weekday;
      _opensAt = $v.opensAt;
      _closesAt = $v.closesAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantScheduleDtoPeriodsInner other) {
    _$v = other as _$MerchantScheduleDtoPeriodsInner;
  }

  @override
  void update(void Function(MerchantScheduleDtoPeriodsInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantScheduleDtoPeriodsInner build() => _build();

  _$MerchantScheduleDtoPeriodsInner _build() {
    final _$result =
        _$v ??
        _$MerchantScheduleDtoPeriodsInner._(
          weekday: BuiltValueNullFieldError.checkNotNull(
            weekday,
            r'MerchantScheduleDtoPeriodsInner',
            'weekday',
          ),
          opensAt: BuiltValueNullFieldError.checkNotNull(
            opensAt,
            r'MerchantScheduleDtoPeriodsInner',
            'opensAt',
          ),
          closesAt: BuiltValueNullFieldError.checkNotNull(
            closesAt,
            r'MerchantScheduleDtoPeriodsInner',
            'closesAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
