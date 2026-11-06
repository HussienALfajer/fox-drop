// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_active_order_dto_output_order_pickup.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainActiveOrderDtoOutputOrderPickup
    extends CaptainActiveOrderDtoOutputOrderPickup {
  @override
  final BuiltList<CaptainWentOfflineDtoOutputHandIn?> proposedLines;
  @override
  final CaptainActiveOrderDtoOutputOrderPickupRequest? request;
  @override
  final DateTime? pickedUpAt;
  @override
  final DateTime? disputedAt;

  factory _$CaptainActiveOrderDtoOutputOrderPickup([
    void Function(CaptainActiveOrderDtoOutputOrderPickupBuilder)? updates,
  ]) => (CaptainActiveOrderDtoOutputOrderPickupBuilder()..update(updates))
      ._build();

  _$CaptainActiveOrderDtoOutputOrderPickup._({
    required this.proposedLines,
    this.request,
    this.pickedUpAt,
    this.disputedAt,
  }) : super._();
  @override
  CaptainActiveOrderDtoOutputOrderPickup rebuild(
    void Function(CaptainActiveOrderDtoOutputOrderPickupBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainActiveOrderDtoOutputOrderPickupBuilder toBuilder() =>
      CaptainActiveOrderDtoOutputOrderPickupBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainActiveOrderDtoOutputOrderPickup &&
        proposedLines == other.proposedLines &&
        request == other.request &&
        pickedUpAt == other.pickedUpAt &&
        disputedAt == other.disputedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, proposedLines.hashCode);
    _$hash = $jc(_$hash, request.hashCode);
    _$hash = $jc(_$hash, pickedUpAt.hashCode);
    _$hash = $jc(_$hash, disputedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainActiveOrderDtoOutputOrderPickup',
          )
          ..add('proposedLines', proposedLines)
          ..add('request', request)
          ..add('pickedUpAt', pickedUpAt)
          ..add('disputedAt', disputedAt))
        .toString();
  }
}

class CaptainActiveOrderDtoOutputOrderPickupBuilder
    implements
        Builder<
          CaptainActiveOrderDtoOutputOrderPickup,
          CaptainActiveOrderDtoOutputOrderPickupBuilder
        > {
  _$CaptainActiveOrderDtoOutputOrderPickup? _$v;

  ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? _proposedLines;
  ListBuilder<CaptainWentOfflineDtoOutputHandIn?> get proposedLines =>
      _$this._proposedLines ??=
          ListBuilder<CaptainWentOfflineDtoOutputHandIn?>();
  set proposedLines(
    ListBuilder<CaptainWentOfflineDtoOutputHandIn?>? proposedLines,
  ) => _$this._proposedLines = proposedLines;

  CaptainActiveOrderDtoOutputOrderPickupRequestBuilder? _request;
  CaptainActiveOrderDtoOutputOrderPickupRequestBuilder get request =>
      _$this._request ??=
          CaptainActiveOrderDtoOutputOrderPickupRequestBuilder();
  set request(CaptainActiveOrderDtoOutputOrderPickupRequestBuilder? request) =>
      _$this._request = request;

  DateTime? _pickedUpAt;
  DateTime? get pickedUpAt => _$this._pickedUpAt;
  set pickedUpAt(DateTime? pickedUpAt) => _$this._pickedUpAt = pickedUpAt;

  DateTime? _disputedAt;
  DateTime? get disputedAt => _$this._disputedAt;
  set disputedAt(DateTime? disputedAt) => _$this._disputedAt = disputedAt;

  CaptainActiveOrderDtoOutputOrderPickupBuilder() {
    CaptainActiveOrderDtoOutputOrderPickup._defaults(this);
  }

  CaptainActiveOrderDtoOutputOrderPickupBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _proposedLines = $v.proposedLines.toBuilder();
      _request = $v.request?.toBuilder();
      _pickedUpAt = $v.pickedUpAt;
      _disputedAt = $v.disputedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainActiveOrderDtoOutputOrderPickup other) {
    _$v = other as _$CaptainActiveOrderDtoOutputOrderPickup;
  }

  @override
  void update(
    void Function(CaptainActiveOrderDtoOutputOrderPickupBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainActiveOrderDtoOutputOrderPickup build() => _build();

  _$CaptainActiveOrderDtoOutputOrderPickup _build() {
    _$CaptainActiveOrderDtoOutputOrderPickup _$result;
    try {
      _$result =
          _$v ??
          _$CaptainActiveOrderDtoOutputOrderPickup._(
            proposedLines: proposedLines.build(),
            request: _request?.build(),
            pickedUpAt: pickedUpAt,
            disputedAt: disputedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'proposedLines';
        proposedLines.build();
        _$failedField = 'request';
        _request?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainActiveOrderDtoOutputOrderPickup',
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
