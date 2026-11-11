// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_order_dto_output_order_pickup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainOrderDtoOutputOrderPickup
    extends CaptainOrderDtoOutputOrderPickup {
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> proposedLines;
  @override
  final BuiltList<CaptainAvailabilityDtoOutputCustodyLimit> currencies;
  @override
  final CaptainOrderDtoOutputOrderPickupRequest? request;
  @override
  final DateTime? pickedUpAt;
  @override
  final DateTime? disputedAt;

  factory _$CaptainOrderDtoOutputOrderPickup([
    void Function(CaptainOrderDtoOutputOrderPickupBuilder)? updates,
  ]) => (CaptainOrderDtoOutputOrderPickupBuilder()..update(updates))._build();

  _$CaptainOrderDtoOutputOrderPickup._({
    required this.proposedLines,
    required this.currencies,
    this.request,
    this.pickedUpAt,
    this.disputedAt,
  }) : super._();
  @override
  CaptainOrderDtoOutputOrderPickup rebuild(
    void Function(CaptainOrderDtoOutputOrderPickupBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOrderDtoOutputOrderPickupBuilder toBuilder() =>
      CaptainOrderDtoOutputOrderPickupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOrderDtoOutputOrderPickup &&
        proposedLines == other.proposedLines &&
        currencies == other.currencies &&
        request == other.request &&
        pickedUpAt == other.pickedUpAt &&
        disputedAt == other.disputedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, proposedLines.hashCode);
    _$hash = $jc(_$hash, currencies.hashCode);
    _$hash = $jc(_$hash, request.hashCode);
    _$hash = $jc(_$hash, pickedUpAt.hashCode);
    _$hash = $jc(_$hash, disputedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainOrderDtoOutputOrderPickup')
          ..add('proposedLines', proposedLines)
          ..add('currencies', currencies)
          ..add('request', request)
          ..add('pickedUpAt', pickedUpAt)
          ..add('disputedAt', disputedAt))
        .toString();
  }
}

class CaptainOrderDtoOutputOrderPickupBuilder
    implements
        Builder<
          CaptainOrderDtoOutputOrderPickup,
          CaptainOrderDtoOutputOrderPickupBuilder
        > {
  _$CaptainOrderDtoOutputOrderPickup? _$v;

  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? _proposedLines;
  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit> get proposedLines =>
      _$this._proposedLines ??=
          ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>();
  set proposedLines(
    ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? proposedLines,
  ) => _$this._proposedLines = proposedLines;

  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? _currencies;
  ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit> get currencies =>
      _$this._currencies ??=
          ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>();
  set currencies(
    ListBuilder<CaptainAvailabilityDtoOutputCustodyLimit>? currencies,
  ) => _$this._currencies = currencies;

  CaptainOrderDtoOutputOrderPickupRequestBuilder? _request;
  CaptainOrderDtoOutputOrderPickupRequestBuilder get request =>
      _$this._request ??= CaptainOrderDtoOutputOrderPickupRequestBuilder();
  set request(CaptainOrderDtoOutputOrderPickupRequestBuilder? request) =>
      _$this._request = request;

  DateTime? _pickedUpAt;
  DateTime? get pickedUpAt => _$this._pickedUpAt;
  set pickedUpAt(DateTime? pickedUpAt) => _$this._pickedUpAt = pickedUpAt;

  DateTime? _disputedAt;
  DateTime? get disputedAt => _$this._disputedAt;
  set disputedAt(DateTime? disputedAt) => _$this._disputedAt = disputedAt;

  CaptainOrderDtoOutputOrderPickupBuilder() {
    CaptainOrderDtoOutputOrderPickup._defaults(this);
  }

  CaptainOrderDtoOutputOrderPickupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _proposedLines = $v.proposedLines.toBuilder();
      _currencies = $v.currencies.toBuilder();
      _request = $v.request?.toBuilder();
      _pickedUpAt = $v.pickedUpAt;
      _disputedAt = $v.disputedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOrderDtoOutputOrderPickup other) {
    _$v = other as _$CaptainOrderDtoOutputOrderPickup;
  }

  @override
  void update(void Function(CaptainOrderDtoOutputOrderPickupBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOrderDtoOutputOrderPickup build() => _build();

  _$CaptainOrderDtoOutputOrderPickup _build() {
    _$CaptainOrderDtoOutputOrderPickup _$result;
    try {
      _$result =
          _$v ??
          _$CaptainOrderDtoOutputOrderPickup._(
            proposedLines: proposedLines.build(),
            currencies: currencies.build(),
            request: _request?.build(),
            pickedUpAt: pickedUpAt,
            disputedAt: disputedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'proposedLines';
        proposedLines.build();
        _$failedField = 'currencies';
        currencies.build();
        _$failedField = 'request';
        _request?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainOrderDtoOutputOrderPickup',
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
