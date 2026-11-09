// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_captain_arrival.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputOrdersInnerCaptainArrival
    extends MerchantOrdersDtoOutputOrdersInnerCaptainArrival {
  @override
  final DateTime at;
  @override
  final DateTime waitingAlertAt;

  factory _$MerchantOrdersDtoOutputOrdersInnerCaptainArrival([
    void Function(MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder)?
    updates,
  ]) =>
      (MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder()
            ..update(updates))
          ._build();

  _$MerchantOrdersDtoOutputOrdersInnerCaptainArrival._({
    required this.at,
    required this.waitingAlertAt,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerCaptainArrival rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerCaptainArrival &&
        at == other.at &&
        waitingAlertAt == other.waitingAlertAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, waitingAlertAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerCaptainArrival',
          )
          ..add('at', at)
          ..add('waitingAlertAt', waitingAlertAt))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerCaptainArrival,
          MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerCaptainArrival? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  DateTime? _waitingAlertAt;
  DateTime? get waitingAlertAt => _$this._waitingAlertAt;
  set waitingAlertAt(DateTime? waitingAlertAt) =>
      _$this._waitingAlertAt = waitingAlertAt;

  MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder() {
    MerchantOrdersDtoOutputOrdersInnerCaptainArrival._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _waitingAlertAt = $v.waitingAlertAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerCaptainArrival other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerCaptainArrival;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerCaptainArrivalBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerCaptainArrival build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerCaptainArrival _build() {
    final _$result =
        _$v ??
        _$MerchantOrdersDtoOutputOrdersInnerCaptainArrival._(
          at: BuiltValueNullFieldError.checkNotNull(
            at,
            r'MerchantOrdersDtoOutputOrdersInnerCaptainArrival',
            'at',
          ),
          waitingAlertAt: BuiltValueNullFieldError.checkNotNull(
            waitingAlertAt,
            r'MerchantOrdersDtoOutputOrdersInnerCaptainArrival',
            'waitingAlertAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
