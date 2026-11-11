// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_outcome_payment_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainOutcomePaymentDto extends CaptainOutcomePaymentDto {
  @override
  final BuiltList<AdminRecordDeliveryDtoReceivedInner> received;
  @override
  final BuiltList<AdminRecordDeliveryDtoReceivedInner> change;
  @override
  final AdminRecordDeliveryDtoAmountDue amountDue;
  @override
  final AdminRecordDeliveryDtoShortfall? shortfall;
  @override
  final CaptainEmergencyDtoLocation? location;

  factory _$CaptainOutcomePaymentDto([
    void Function(CaptainOutcomePaymentDtoBuilder)? updates,
  ]) => (CaptainOutcomePaymentDtoBuilder()..update(updates))._build();

  _$CaptainOutcomePaymentDto._({
    required this.received,
    required this.change,
    required this.amountDue,
    this.shortfall,
    this.location,
  }) : super._();
  @override
  CaptainOutcomePaymentDto rebuild(
    void Function(CaptainOutcomePaymentDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainOutcomePaymentDtoBuilder toBuilder() =>
      CaptainOutcomePaymentDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainOutcomePaymentDto &&
        received == other.received &&
        change == other.change &&
        amountDue == other.amountDue &&
        shortfall == other.shortfall &&
        location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jc(_$hash, change.hashCode);
    _$hash = $jc(_$hash, amountDue.hashCode);
    _$hash = $jc(_$hash, shortfall.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainOutcomePaymentDto')
          ..add('received', received)
          ..add('change', change)
          ..add('amountDue', amountDue)
          ..add('shortfall', shortfall)
          ..add('location', location))
        .toString();
  }
}

class CaptainOutcomePaymentDtoBuilder
    implements
        Builder<CaptainOutcomePaymentDto, CaptainOutcomePaymentDtoBuilder> {
  _$CaptainOutcomePaymentDto? _$v;

  ListBuilder<AdminRecordDeliveryDtoReceivedInner>? _received;
  ListBuilder<AdminRecordDeliveryDtoReceivedInner> get received =>
      _$this._received ??= ListBuilder<AdminRecordDeliveryDtoReceivedInner>();
  set received(ListBuilder<AdminRecordDeliveryDtoReceivedInner>? received) =>
      _$this._received = received;

  ListBuilder<AdminRecordDeliveryDtoReceivedInner>? _change;
  ListBuilder<AdminRecordDeliveryDtoReceivedInner> get change =>
      _$this._change ??= ListBuilder<AdminRecordDeliveryDtoReceivedInner>();
  set change(ListBuilder<AdminRecordDeliveryDtoReceivedInner>? change) =>
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

  CaptainEmergencyDtoLocationBuilder? _location;
  CaptainEmergencyDtoLocationBuilder get location =>
      _$this._location ??= CaptainEmergencyDtoLocationBuilder();
  set location(CaptainEmergencyDtoLocationBuilder? location) =>
      _$this._location = location;

  CaptainOutcomePaymentDtoBuilder() {
    CaptainOutcomePaymentDto._defaults(this);
  }

  CaptainOutcomePaymentDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _received = $v.received.toBuilder();
      _change = $v.change.toBuilder();
      _amountDue = $v.amountDue.toBuilder();
      _shortfall = $v.shortfall?.toBuilder();
      _location = $v.location?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainOutcomePaymentDto other) {
    _$v = other as _$CaptainOutcomePaymentDto;
  }

  @override
  void update(void Function(CaptainOutcomePaymentDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainOutcomePaymentDto build() => _build();

  _$CaptainOutcomePaymentDto _build() {
    _$CaptainOutcomePaymentDto _$result;
    try {
      _$result =
          _$v ??
          _$CaptainOutcomePaymentDto._(
            received: received.build(),
            change: change.build(),
            amountDue: amountDue.build(),
            shortfall: _shortfall?.build(),
            location: _location?.build(),
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
        _location?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainOutcomePaymentDto',
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
