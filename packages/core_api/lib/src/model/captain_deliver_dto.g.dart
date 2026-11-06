// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_deliver_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainDeliverDto extends CaptainDeliverDto {
  @override
  final BuiltList<MerchantPickupDisputeDtoReceivedLinesInner> received;
  @override
  final BuiltList<MerchantPickupDisputeDtoReceivedLinesInner> change;
  @override
  final AdminRecordDeliveryDtoAmountDue amountDue;
  @override
  final AdminRecordDeliveryDtoShortfall? shortfall;
  @override
  final CaptainArriveDtoLocation location;
  @override
  final CaptainDeliverDtoAway? away;

  factory _$CaptainDeliverDto([
    void Function(CaptainDeliverDtoBuilder)? updates,
  ]) => (CaptainDeliverDtoBuilder()..update(updates))._build();

  _$CaptainDeliverDto._({
    required this.received,
    required this.change,
    required this.amountDue,
    this.shortfall,
    required this.location,
    this.away,
  }) : super._();
  @override
  CaptainDeliverDto rebuild(void Function(CaptainDeliverDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CaptainDeliverDtoBuilder toBuilder() =>
      CaptainDeliverDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainDeliverDto &&
        received == other.received &&
        change == other.change &&
        amountDue == other.amountDue &&
        shortfall == other.shortfall &&
        location == other.location &&
        away == other.away;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jc(_$hash, change.hashCode);
    _$hash = $jc(_$hash, amountDue.hashCode);
    _$hash = $jc(_$hash, shortfall.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, away.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainDeliverDto')
          ..add('received', received)
          ..add('change', change)
          ..add('amountDue', amountDue)
          ..add('shortfall', shortfall)
          ..add('location', location)
          ..add('away', away))
        .toString();
  }
}

class CaptainDeliverDtoBuilder
    implements Builder<CaptainDeliverDto, CaptainDeliverDtoBuilder> {
  _$CaptainDeliverDto? _$v;

  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? _received;
  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner> get received =>
      _$this._received ??=
          ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>();
  set received(
    ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? received,
  ) => _$this._received = received;

  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? _change;
  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner> get change =>
      _$this._change ??=
          ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>();
  set change(ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? change) =>
      _$this._change = change;

  AdminRecordDeliveryDtoAmountDueBuilder? _amountDue;
  AdminRecordDeliveryDtoAmountDueBuilder get amountDue =>
      _$this._amountDue ??= AdminRecordDeliveryDtoAmountDueBuilder();
  set amountDue(AdminRecordDeliveryDtoAmountDueBuilder? amountDue) =>
      _$this._amountDue = amountDue;

  AdminRecordDeliveryDtoShortfallBuilder? _shortfall;
  AdminRecordDeliveryDtoShortfallBuilder get shortfall =>
      _$this._shortfall ??= AdminRecordDeliveryDtoShortfallBuilder();
  set shortfall(AdminRecordDeliveryDtoShortfallBuilder? shortfall) =>
      _$this._shortfall = shortfall;

  CaptainArriveDtoLocationBuilder? _location;
  CaptainArriveDtoLocationBuilder get location =>
      _$this._location ??= CaptainArriveDtoLocationBuilder();
  set location(CaptainArriveDtoLocationBuilder? location) =>
      _$this._location = location;

  CaptainDeliverDtoAwayBuilder? _away;
  CaptainDeliverDtoAwayBuilder get away =>
      _$this._away ??= CaptainDeliverDtoAwayBuilder();
  set away(CaptainDeliverDtoAwayBuilder? away) => _$this._away = away;

  CaptainDeliverDtoBuilder() {
    CaptainDeliverDto._defaults(this);
  }

  CaptainDeliverDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _received = $v.received.toBuilder();
      _change = $v.change.toBuilder();
      _amountDue = $v.amountDue.toBuilder();
      _shortfall = $v.shortfall?.toBuilder();
      _location = $v.location.toBuilder();
      _away = $v.away?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainDeliverDto other) {
    _$v = other as _$CaptainDeliverDto;
  }

  @override
  void update(void Function(CaptainDeliverDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainDeliverDto build() => _build();

  _$CaptainDeliverDto _build() {
    _$CaptainDeliverDto _$result;
    try {
      _$result =
          _$v ??
          _$CaptainDeliverDto._(
            received: received.build(),
            change: change.build(),
            amountDue: amountDue.build(),
            shortfall: _shortfall?.build(),
            location: location.build(),
            away: _away?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'received';
        received.build();
        _$failedField = 'change';
        change.build();
        _$failedField = 'amountDue';
        amountDue.build();
        _$failedField = 'shortfall';
        _shortfall?.build();
        _$failedField = 'location';
        location.build();
        _$failedField = 'away';
        _away?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainDeliverDto',
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
