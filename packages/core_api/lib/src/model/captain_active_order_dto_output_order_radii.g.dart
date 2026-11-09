// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_radii.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderRadii
    extends CaptainActiveOrderDtoOutputOrderRadii {
  @override
  final int restaurantMetres;
  @override
  final int customerMetres;

  factory _$CaptainActiveOrderDtoOutputOrderRadii([
    void Function(CaptainActiveOrderDtoOutputOrderRadiiBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputOrderRadiiBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputOrderRadii._({
    required this.restaurantMetres,
    required this.customerMetres,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderRadii rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderRadiiBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderRadiiBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderRadiiBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderRadii &&
        restaurantMetres == other.restaurantMetres &&
        customerMetres == other.customerMetres;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantMetres.hashCode);
    _$hash = $jc(_$hash, customerMetres.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderRadii',
          )
          ..add('restaurantMetres', restaurantMetres)
          ..add('customerMetres', customerMetres))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderRadiiBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderRadii,
          CaptainActiveOrderDtoOutputOrderRadiiBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderRadii? _$v;

  int? _restaurantMetres;
  int? get restaurantMetres => _$this._restaurantMetres;
  set restaurantMetres(int? restaurantMetres) =>
      _$this._restaurantMetres = restaurantMetres;

  int? _customerMetres;
  int? get customerMetres => _$this._customerMetres;
  set customerMetres(int? customerMetres) =>
      _$this._customerMetres = customerMetres;

  CaptainActiveOrderDtoOutputOrderRadiiBuilder() {
    CaptainActiveOrderDtoOutputOrderRadii._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderRadiiBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantMetres = $v.restaurantMetres;
      _customerMetres = $v.customerMetres;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderRadii other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderRadii;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderRadiiBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderRadii build() => _build();

  _$CaptainActiveOrderDtoOutputOrderRadii _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderRadii._(
          restaurantMetres: BuiltValueNullFieldError.checkNotNull(
            restaurantMetres,
            r'CaptainActiveOrderDtoOutputOrderRadii',
            'restaurantMetres',
          ),
          customerMetres: BuiltValueNullFieldError.checkNotNull(
            customerMetres,
            r'CaptainActiveOrderDtoOutputOrderRadii',
            'customerMetres',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
