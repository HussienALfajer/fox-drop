// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_record_delivery_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRecordDeliveryDto extends AdminRecordDeliveryDto {
  @override
  final BuiltList<MerchantPickupDisputeDtoReceivedLinesInner> received;
  @override
  final BuiltList<MerchantPickupDisputeDtoReceivedLinesInner> change;
  @override
  final AdminRecordDeliveryDtoAmountDue amountDue;
  @override
  final AdminRecordDeliveryDtoShortfall? shortfall;
  @override
  final String reason;

  factory _$AdminRecordDeliveryDto([
    void Function(AdminRecordDeliveryDtoBuilder)? updates,
  ]) => (AdminRecordDeliveryDtoBuilder()..update(updates))._build();

  _$AdminRecordDeliveryDto._({
    required this.received,
    required this.change,
    required this.amountDue,
    this.shortfall,
    required this.reason,
  }) : super._();
  @override
  AdminRecordDeliveryDto rebuild(
    void Function(AdminRecordDeliveryDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRecordDeliveryDtoBuilder toBuilder() =>
      AdminRecordDeliveryDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRecordDeliveryDto &&
        received == other.received &&
        change == other.change &&
        amountDue == other.amountDue &&
        shortfall == other.shortfall &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, received.hashCode);
    _$hash = $jc(_$hash, change.hashCode);
    _$hash = $jc(_$hash, amountDue.hashCode);
    _$hash = $jc(_$hash, shortfall.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRecordDeliveryDto')
          ..add('received', received)
          ..add('change', change)
          ..add('amountDue', amountDue)
          ..add('shortfall', shortfall)
          ..add('reason', reason))
        .toString();
  }
}

class AdminRecordDeliveryDtoBuilder
    implements Builder<AdminRecordDeliveryDto, AdminRecordDeliveryDtoBuilder> {
  _$AdminRecordDeliveryDto? _$v;

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

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminRecordDeliveryDtoBuilder() {
    AdminRecordDeliveryDto._defaults(this);
  }

  AdminRecordDeliveryDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _received = $v.received.toBuilder();
      _change = $v.change.toBuilder();
      _amountDue = $v.amountDue.toBuilder();
      _shortfall = $v.shortfall?.toBuilder();
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRecordDeliveryDto other) {
    _$v = other as _$AdminRecordDeliveryDto;
  }

  @override
  void update(void Function(AdminRecordDeliveryDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRecordDeliveryDto build() => _build();

  _$AdminRecordDeliveryDto _build() {
    _$AdminRecordDeliveryDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminRecordDeliveryDto._(
            received: received.build(),
            change: change.build(),
            amountDue: amountDue.build(),
            shortfall: _shortfall?.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'AdminRecordDeliveryDto',
              'reason',
            ),
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
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRecordDeliveryDto',
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
