// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_output_pause_minutes.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresOutputPauseMinutes
    extends MerchantFiguresOutputPauseMinutes {
  @override
  final int restaurant;
  @override
  final int ops;
  @override
  final int auto;

  factory _$MerchantFiguresOutputPauseMinutes([
    void Function(MerchantFiguresOutputPauseMinutesBuilder)? updates,
  ]) => (MerchantFiguresOutputPauseMinutesBuilder()..update(updates))._build();

  _$MerchantFiguresOutputPauseMinutes._({
    required this.restaurant,
    required this.ops,
    required this.auto,
  }) : super._();
  @override
  MerchantFiguresOutputPauseMinutes rebuild(
    void Function(MerchantFiguresOutputPauseMinutesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresOutputPauseMinutesBuilder toBuilder() =>
      MerchantFiguresOutputPauseMinutesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresOutputPauseMinutes &&
        restaurant == other.restaurant &&
        ops == other.ops &&
        auto == other.auto;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurant.hashCode);
    _$hash = $jc(_$hash, ops.hashCode);
    _$hash = $jc(_$hash, auto.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantFiguresOutputPauseMinutes')
          ..add('restaurant', restaurant)
          ..add('ops', ops)
          ..add('auto', auto))
        .toString();
  }
}

class MerchantFiguresOutputPauseMinutesBuilder
    implements
        Builder<
          MerchantFiguresOutputPauseMinutes,
          MerchantFiguresOutputPauseMinutesBuilder
        > {
  _$MerchantFiguresOutputPauseMinutes? _$v;

  int? _restaurant;
  int? get restaurant => _$this._restaurant;
  set restaurant(int? restaurant) => _$this._restaurant = restaurant;

  int? _ops;
  int? get ops => _$this._ops;
  set ops(int? ops) => _$this._ops = ops;

  int? _auto;
  int? get auto => _$this._auto;
  set auto(int? auto) => _$this._auto = auto;

  MerchantFiguresOutputPauseMinutesBuilder() {
    MerchantFiguresOutputPauseMinutes._defaults(this);
  }

  MerchantFiguresOutputPauseMinutesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurant = $v.restaurant;
      _ops = $v.ops;
      _auto = $v.auto;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantFiguresOutputPauseMinutes other) {
    _$v = other as _$MerchantFiguresOutputPauseMinutes;
  }

  @override
  void update(
    void Function(MerchantFiguresOutputPauseMinutesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresOutputPauseMinutes build() => _build();

  _$MerchantFiguresOutputPauseMinutes _build() {
    final _$result =
        _$v ??
        _$MerchantFiguresOutputPauseMinutes._(
          restaurant: BuiltValueNullFieldError.checkNotNull(
            restaurant,
            r'MerchantFiguresOutputPauseMinutes',
            'restaurant',
          ),
          ops: BuiltValueNullFieldError.checkNotNull(
            ops,
            r'MerchantFiguresOutputPauseMinutes',
            'ops',
          ),
          auto: BuiltValueNullFieldError.checkNotNull(
            auto,
            r'MerchantFiguresOutputPauseMinutes',
            'auto',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
