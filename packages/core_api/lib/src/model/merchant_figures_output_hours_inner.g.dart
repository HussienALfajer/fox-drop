// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_figures_output_hours_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantFiguresOutputHoursInner
    extends MerchantFiguresOutputHoursInner {
  @override
  final int hour;
  @override
  final int delivered;

  factory _$MerchantFiguresOutputHoursInner([
    void Function(MerchantFiguresOutputHoursInnerBuilder)? updates,
  ]) => (MerchantFiguresOutputHoursInnerBuilder()..update(updates))._build();

  _$MerchantFiguresOutputHoursInner._({
    required this.hour,
    required this.delivered,
  }) : super._();
  @override
  MerchantFiguresOutputHoursInner rebuild(
    void Function(MerchantFiguresOutputHoursInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantFiguresOutputHoursInnerBuilder toBuilder() =>
      MerchantFiguresOutputHoursInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantFiguresOutputHoursInner &&
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
    return (newBuiltValueToStringHelper(r'MerchantFiguresOutputHoursInner')
          ..add('hour', hour)
          ..add('delivered', delivered))
        .toString();
  }
}

class MerchantFiguresOutputHoursInnerBuilder
    implements
        Builder<
          MerchantFiguresOutputHoursInner,
          MerchantFiguresOutputHoursInnerBuilder
        > {
  _$MerchantFiguresOutputHoursInner? _$v;

  int? _hour;
  int? get hour => _$this._hour;
  set hour(int? hour) => _$this._hour = hour;

  int? _delivered;
  int? get delivered => _$this._delivered;
  set delivered(int? delivered) => _$this._delivered = delivered;

  MerchantFiguresOutputHoursInnerBuilder() {
    MerchantFiguresOutputHoursInner._defaults(this);
  }

  MerchantFiguresOutputHoursInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _hour = $v.hour;
      _delivered = $v.delivered;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantFiguresOutputHoursInner other) {
    _$v = other as _$MerchantFiguresOutputHoursInner;
  }

  @override
  void update(void Function(MerchantFiguresOutputHoursInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantFiguresOutputHoursInner build() => _build();

  _$MerchantFiguresOutputHoursInner _build() {
    final _$result =
        _$v ??
        _$MerchantFiguresOutputHoursInner._(
          hour: BuiltValueNullFieldError.checkNotNull(
            hour,
            r'MerchantFiguresOutputHoursInner',
            'hour',
          ),
          delivered: BuiltValueNullFieldError.checkNotNull(
            delivered,
            r'MerchantFiguresOutputHoursInner',
            'delivered',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
