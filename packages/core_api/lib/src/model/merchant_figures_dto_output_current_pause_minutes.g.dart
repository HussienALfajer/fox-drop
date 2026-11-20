// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_dto_output_current_pause_minutes.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresDtoOutputCurrentPauseMinutes
    extends MerchantFiguresDtoOutputCurrentPauseMinutes {
  @override
  final int restaurant;
  @override
  final int ops;
  @override
  final int auto;

  factory _$MerchantFiguresDtoOutputCurrentPauseMinutes([
    void Function(MerchantFiguresDtoOutputCurrentPauseMinutesBuilder)? updates,
  ]) => (MerchantFiguresDtoOutputCurrentPauseMinutesBuilder()..update(updates))
      ._build();

  _$MerchantFiguresDtoOutputCurrentPauseMinutes._({
    required this.restaurant,
    required this.ops,
    required this.auto,
  }) : super._();
  @override
  MerchantFiguresDtoOutputCurrentPauseMinutes rebuild(
    void Function(MerchantFiguresDtoOutputCurrentPauseMinutesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresDtoOutputCurrentPauseMinutesBuilder toBuilder() =>
      MerchantFiguresDtoOutputCurrentPauseMinutesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresDtoOutputCurrentPauseMinutes &&
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
    return (newBuiltValueToStringHelper(
            r'MerchantFiguresDtoOutputCurrentPauseMinutes',
          )
          ..add('restaurant', restaurant)
          ..add('ops', ops)
          ..add('auto', auto))
        .toString();
  }
}

class MerchantFiguresDtoOutputCurrentPauseMinutesBuilder
    implements
        Builder<
          MerchantFiguresDtoOutputCurrentPauseMinutes,
          MerchantFiguresDtoOutputCurrentPauseMinutesBuilder
        > {
  _$MerchantFiguresDtoOutputCurrentPauseMinutes? _$v;

  int? _restaurant;
  int? get restaurant => _$this._restaurant;
  set restaurant(int? restaurant) => _$this._restaurant = restaurant;

  int? _ops;
  int? get ops => _$this._ops;
  set ops(int? ops) => _$this._ops = ops;

  int? _auto;
  int? get auto => _$this._auto;
  set auto(int? auto) => _$this._auto = auto;

  MerchantFiguresDtoOutputCurrentPauseMinutesBuilder() {
    MerchantFiguresDtoOutputCurrentPauseMinutes._defaults(this);
  }

  MerchantFiguresDtoOutputCurrentPauseMinutesBuilder get _$this {
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
  void replace(MerchantFiguresDtoOutputCurrentPauseMinutes other) {
    _$v = other as _$MerchantFiguresDtoOutputCurrentPauseMinutes;
  }

  @override
  void update(
    void Function(MerchantFiguresDtoOutputCurrentPauseMinutesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresDtoOutputCurrentPauseMinutes build() => _build();

  _$MerchantFiguresDtoOutputCurrentPauseMinutes _build() {
    final _$result =
        _$v ??
        _$MerchantFiguresDtoOutputCurrentPauseMinutes._(
          restaurant: BuiltValueNullFieldError.checkNotNull(
            restaurant,
            r'MerchantFiguresDtoOutputCurrentPauseMinutes',
            'restaurant',
          ),
          ops: BuiltValueNullFieldError.checkNotNull(
            ops,
            r'MerchantFiguresDtoOutputCurrentPauseMinutes',
            'ops',
          ),
          auto: BuiltValueNullFieldError.checkNotNull(
            auto,
            r'MerchantFiguresDtoOutputCurrentPauseMinutes',
            'auto',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
