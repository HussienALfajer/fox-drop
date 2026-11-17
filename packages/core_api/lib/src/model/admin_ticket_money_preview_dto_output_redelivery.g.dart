// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_money_preview_dto_output_redelivery.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketMoneyPreviewDtoOutputRedelivery
    extends AdminTicketMoneyPreviewDtoOutputRedelivery {
  @override
  final String pickupPayment;
  @override
  final String commission;
  @override
  final String merchantNet;

  factory _$AdminTicketMoneyPreviewDtoOutputRedelivery([
    void Function(AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder)? updates,
  ]) => (AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder()..update(updates))
      ._build();

  _$AdminTicketMoneyPreviewDtoOutputRedelivery._({
    required this.pickupPayment,
    required this.commission,
    required this.merchantNet,
  }) : super._();
  @override
  AdminTicketMoneyPreviewDtoOutputRedelivery rebuild(
    void Function(AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder toBuilder() =>
      AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketMoneyPreviewDtoOutputRedelivery &&
        pickupPayment == other.pickupPayment &&
        commission == other.commission &&
        merchantNet == other.merchantNet;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, pickupPayment.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, merchantNet.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminTicketMoneyPreviewDtoOutputRedelivery',
          )
          ..add('pickupPayment', pickupPayment)
          ..add('commission', commission)
          ..add('merchantNet', merchantNet))
        .toString();
  }
}

class AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder
    implements
        Builder<
          AdminTicketMoneyPreviewDtoOutputRedelivery,
          AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder
        > {
  _$AdminTicketMoneyPreviewDtoOutputRedelivery? _$v;

  String? _pickupPayment;
  String? get pickupPayment => _$this._pickupPayment;
  set pickupPayment(String? pickupPayment) =>
      _$this._pickupPayment = pickupPayment;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  String? _merchantNet;
  String? get merchantNet => _$this._merchantNet;
  set merchantNet(String? merchantNet) => _$this._merchantNet = merchantNet;

  AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder() {
    AdminTicketMoneyPreviewDtoOutputRedelivery._defaults(this);
  }

  AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _pickupPayment = $v.pickupPayment;
      _commission = $v.commission;
      _merchantNet = $v.merchantNet;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketMoneyPreviewDtoOutputRedelivery other) {
    _$v = other as _$AdminTicketMoneyPreviewDtoOutputRedelivery;
  }

  @override
  void update(
    void Function(AdminTicketMoneyPreviewDtoOutputRedeliveryBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketMoneyPreviewDtoOutputRedelivery build() => _build();

  _$AdminTicketMoneyPreviewDtoOutputRedelivery _build() {
    final _$result =
        _$v ??
        _$AdminTicketMoneyPreviewDtoOutputRedelivery._(
          pickupPayment: BuiltValueNullFieldError.checkNotNull(
            pickupPayment,
            r'AdminTicketMoneyPreviewDtoOutputRedelivery',
            'pickupPayment',
          ),
          commission: BuiltValueNullFieldError.checkNotNull(
            commission,
            r'AdminTicketMoneyPreviewDtoOutputRedelivery',
            'commission',
          ),
          merchantNet: BuiltValueNullFieldError.checkNotNull(
            merchantNet,
            r'AdminTicketMoneyPreviewDtoOutputRedelivery',
            'merchantNet',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
