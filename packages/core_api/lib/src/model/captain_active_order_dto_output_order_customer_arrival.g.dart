// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_customer_arrival.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderCustomerArrival
    extends CaptainActiveOrderDtoOutputOrderCustomerArrival {
  @override
  final DateTime at;
  @override
  final String? awayReason;

  factory _$CaptainActiveOrderDtoOutputOrderCustomerArrival([
    void Function(CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder)?
    updates,
  ]) =>
      (CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder()
            ..update(updates))
          ._build();

  _$CaptainActiveOrderDtoOutputOrderCustomerArrival._({
    required this.at,
    this.awayReason,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderCustomerArrival rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderCustomerArrival &&
        at == other.at &&
        awayReason == other.awayReason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, awayReason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderCustomerArrival',
          )
          ..add('at', at)
          ..add('awayReason', awayReason))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderCustomerArrival,
          CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderCustomerArrival? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _awayReason;
  String? get awayReason => _$this._awayReason;
  set awayReason(String? awayReason) => _$this._awayReason = awayReason;

  CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder() {
    CaptainActiveOrderDtoOutputOrderCustomerArrival._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _awayReason = $v.awayReason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderCustomerArrival other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderCustomerArrival;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderCustomerArrivalBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderCustomerArrival build() => _build();

  _$CaptainActiveOrderDtoOutputOrderCustomerArrival _build() {
    final _$result =
        _$v ??
        _$CaptainActiveOrderDtoOutputOrderCustomerArrival._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'CaptainActiveOrderDtoOutputOrderCustomerArrival',
            'at',
          ),
          awayReason: awayReason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
