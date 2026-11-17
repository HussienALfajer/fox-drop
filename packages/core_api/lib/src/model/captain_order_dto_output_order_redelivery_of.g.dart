// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_order_dto_output_order_redelivery_of.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainOrderDtoOutputOrderRedeliveryOf
    extends CaptainOrderDtoOutputOrderRedeliveryOf {
  @override
  final String orderId;
  @override
  final String number;

  factory _$CaptainOrderDtoOutputOrderRedeliveryOf([
    void Function(CaptainOrderDtoOutputOrderRedeliveryOfBuilder)? updates,
  ]) => (CaptainOrderDtoOutputOrderRedeliveryOfBuilder()..update(updates))
      ._build();

  _$CaptainOrderDtoOutputOrderRedeliveryOf._({
    required this.orderId,
    required this.number,
  }) : super._();
  @override
  CaptainOrderDtoOutputOrderRedeliveryOf rebuild(
    void Function(CaptainOrderDtoOutputOrderRedeliveryOfBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOrderDtoOutputOrderRedeliveryOfBuilder toBuilder() =>
      CaptainOrderDtoOutputOrderRedeliveryOfBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOrderDtoOutputOrderRedeliveryOf &&
        orderId == other.orderId &&
        number == other.number;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainOrderDtoOutputOrderRedeliveryOf',
          )
          ..add('orderId', orderId)
          ..add('number', number))
        .toString();
  }
}

class CaptainOrderDtoOutputOrderRedeliveryOfBuilder
    implements
        Builder<
          CaptainOrderDtoOutputOrderRedeliveryOf,
          CaptainOrderDtoOutputOrderRedeliveryOfBuilder
        > {
  _$CaptainOrderDtoOutputOrderRedeliveryOf? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  CaptainOrderDtoOutputOrderRedeliveryOfBuilder() {
    CaptainOrderDtoOutputOrderRedeliveryOf._defaults(this);
  }

  CaptainOrderDtoOutputOrderRedeliveryOfBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOrderDtoOutputOrderRedeliveryOf other) {
    _$v = other as _$CaptainOrderDtoOutputOrderRedeliveryOf;
  }

  @override
  void update(
    void Function(CaptainOrderDtoOutputOrderRedeliveryOfBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOrderDtoOutputOrderRedeliveryOf build() => _build();

  _$CaptainOrderDtoOutputOrderRedeliveryOf _build() {
    final _$result =
        _$v ??
        _$CaptainOrderDtoOutputOrderRedeliveryOf._(
          orderId: BuiltValueNullFieldError.checkNotNull(
            orderId,
            r'CaptainOrderDtoOutputOrderRedeliveryOf',
            'orderId',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'CaptainOrderDtoOutputOrderRedeliveryOf',
            'number',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
