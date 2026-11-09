// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_order_dto_output_order_pickup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrderDtoOutputOrderPickup
    extends MerchantOrderDtoOutputOrderPickup {
  @override
  final MerchantOrderDtoOutputOrderPickupRequest? request;
  @override
  final DateTime? pickedUpAt;
  @override
  final bool readyNotPressed;
  @override
  final DateTime? disputeUntil;
  @override
  final DateTime? disputedAt;

  factory _$MerchantOrderDtoOutputOrderPickup([
    void Function(MerchantOrderDtoOutputOrderPickupBuilder)? updates,
  ]) => (MerchantOrderDtoOutputOrderPickupBuilder()..update(updates))._build();

  _$MerchantOrderDtoOutputOrderPickup._({
    this.request,
    this.pickedUpAt,
    required this.readyNotPressed,
    this.disputeUntil,
    this.disputedAt,
  }) : super._();
  @override
  MerchantOrderDtoOutputOrderPickup rebuild(
    void Function(MerchantOrderDtoOutputOrderPickupBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrderDtoOutputOrderPickupBuilder toBuilder() =>
      MerchantOrderDtoOutputOrderPickupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrderDtoOutputOrderPickup &&
        request == other.request &&
        pickedUpAt == other.pickedUpAt &&
        readyNotPressed == other.readyNotPressed &&
        disputeUntil == other.disputeUntil &&
        disputedAt == other.disputedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, request.hashCode);
    _$hash = $jc(_$hash, pickedUpAt.hashCode);
    _$hash = $jc(_$hash, readyNotPressed.hashCode);
    _$hash = $jc(_$hash, disputeUntil.hashCode);
    _$hash = $jc(_$hash, disputedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MerchantOrderDtoOutputOrderPickup')
          ..add('request', request)
          ..add('pickedUpAt', pickedUpAt)
          ..add('readyNotPressed', readyNotPressed)
          ..add('disputeUntil', disputeUntil)
          ..add('disputedAt', disputedAt))
        .toString();
  }
}

class MerchantOrderDtoOutputOrderPickupBuilder
    implements
        Builder<
          MerchantOrderDtoOutputOrderPickup,
          MerchantOrderDtoOutputOrderPickupBuilder
        > {
  _$MerchantOrderDtoOutputOrderPickup? _$v;

  MerchantOrderDtoOutputOrderPickupRequestBuilder? _request;
  MerchantOrderDtoOutputOrderPickupRequestBuilder get request =>
      _$this._request ??= MerchantOrderDtoOutputOrderPickupRequestBuilder();
  set request(MerchantOrderDtoOutputOrderPickupRequestBuilder? request) =>
      _$this._request = request;

  DateTime? _pickedUpAt;
  DateTime? get pickedUpAt => _$this._pickedUpAt;
  set pickedUpAt(DateTime? pickedUpAt) => _$this._pickedUpAt = pickedUpAt;

  bool? _readyNotPressed;
  bool? get readyNotPressed => _$this._readyNotPressed;
  set readyNotPressed(bool? readyNotPressed) =>
      _$this._readyNotPressed = readyNotPressed;

  DateTime? _disputeUntil;
  DateTime? get disputeUntil => _$this._disputeUntil;
  set disputeUntil(DateTime? disputeUntil) =>
      _$this._disputeUntil = disputeUntil;

  DateTime? _disputedAt;
  DateTime? get disputedAt => _$this._disputedAt;
  set disputedAt(DateTime? disputedAt) => _$this._disputedAt = disputedAt;

  MerchantOrderDtoOutputOrderPickupBuilder() {
    MerchantOrderDtoOutputOrderPickup._defaults(this);
  }

  MerchantOrderDtoOutputOrderPickupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _request = $v.request?.toBuilder();
      _pickedUpAt = $v.pickedUpAt;
      _readyNotPressed = $v.readyNotPressed;
      _disputeUntil = $v.disputeUntil;
      _disputedAt = $v.disputedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrderDtoOutputOrderPickup other) {
    _$v = other as _$MerchantOrderDtoOutputOrderPickup;
  }

  @override
  void update(
    void Function(MerchantOrderDtoOutputOrderPickupBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrderDtoOutputOrderPickup build() => _build();

  _$MerchantOrderDtoOutputOrderPickup _build() {
    _$MerchantOrderDtoOutputOrderPickup _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrderDtoOutputOrderPickup._(
            request: _request?.build(),
            pickedUpAt: pickedUpAt,
            readyNotPressed: BuiltValueNullFieldError.checkNotNull(
              readyNotPressed,
              r'MerchantOrderDtoOutputOrderPickup',
              'readyNotPressed',
            ),
            disputeUntil: disputeUntil,
            disputedAt: disputedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'request';
        _request?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrderDtoOutputOrderPickup',
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
