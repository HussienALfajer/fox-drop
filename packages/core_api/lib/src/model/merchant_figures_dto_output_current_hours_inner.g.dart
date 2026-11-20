// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_dto_output_current_hours_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresDtoOutputCurrentHoursInner
    extends MerchantFiguresDtoOutputCurrentHoursInner {
  @override
  final int hour;
  @override
  final int delivered;

  factory _$MerchantFiguresDtoOutputCurrentHoursInner([
    void Function(MerchantFiguresDtoOutputCurrentHoursInnerBuilder)? updates,
  ]) => (MerchantFiguresDtoOutputCurrentHoursInnerBuilder()..update(updates))
      ._build();

  _$MerchantFiguresDtoOutputCurrentHoursInner._({
    required this.hour,
    required this.delivered,
  }) : super._();
  @override
  MerchantFiguresDtoOutputCurrentHoursInner rebuild(
    void Function(MerchantFiguresDtoOutputCurrentHoursInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresDtoOutputCurrentHoursInnerBuilder toBuilder() =>
      MerchantFiguresDtoOutputCurrentHoursInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresDtoOutputCurrentHoursInner &&
        hour == other.hour &&
        delivered == other.delivered;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, hour.hashCode);
    _$hash = $jc(_$hash, delivered.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantFiguresDtoOutputCurrentHoursInner',
          )
          ..add('hour', hour)
          ..add('delivered', delivered))
        .toString();
  }
}

class MerchantFiguresDtoOutputCurrentHoursInnerBuilder
    implements
        Builder<
          MerchantFiguresDtoOutputCurrentHoursInner,
          MerchantFiguresDtoOutputCurrentHoursInnerBuilder
        > {
  _$MerchantFiguresDtoOutputCurrentHoursInner? _$v;

  int? _hour;
  int? get hour => _$this._hour;
  set hour(int? hour) => _$this._hour = hour;

  int? _delivered;
  int? get delivered => _$this._delivered;
  set delivered(int? delivered) => _$this._delivered = delivered;

  MerchantFiguresDtoOutputCurrentHoursInnerBuilder() {
    MerchantFiguresDtoOutputCurrentHoursInner._defaults(this);
  }

  MerchantFiguresDtoOutputCurrentHoursInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hour = $v.hour;
      _delivered = $v.delivered;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantFiguresDtoOutputCurrentHoursInner other) {
    _$v = other as _$MerchantFiguresDtoOutputCurrentHoursInner;
  }

  @override
  void update(
    void Function(MerchantFiguresDtoOutputCurrentHoursInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresDtoOutputCurrentHoursInner build() => _build();

  _$MerchantFiguresDtoOutputCurrentHoursInner _build() {
    final _$result =
        _$v ??
        _$MerchantFiguresDtoOutputCurrentHoursInner._(
          hour: BuiltValueNullFieldError.checkNotNull(
            hour,
            r'MerchantFiguresDtoOutputCurrentHoursInner',
            'hour',
          ),
          delivered: BuiltValueNullFieldError.checkNotNull(
            delivered,
            r'MerchantFiguresDtoOutputCurrentHoursInner',
            'delivered',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
