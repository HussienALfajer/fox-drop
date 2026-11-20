// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_order_history_dto_output_orders_inner_owner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrderHistoryDtoOutputOrdersInnerOwner
    extends MerchantOrderHistoryDtoOutputOrdersInnerOwner {
  @override
  final bool testOrder;
  @override
  final int? commissionBp;
  @override
  final String? commission;
  @override
  final String? discountShare;
  @override
  final bool discountOnDelivery;
  @override
  final String? merchantNet;

  factory _$MerchantOrderHistoryDtoOutputOrdersInnerOwner([
    void Function(MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder)?
    updates,
  ]) =>
      (MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder()..update(updates))
          ._build();

  _$MerchantOrderHistoryDtoOutputOrdersInnerOwner._({
    required this.testOrder,
    this.commissionBp,
    this.commission,
    this.discountShare,
    required this.discountOnDelivery,
    this.merchantNet,
  }) : super._();
  @override
  MerchantOrderHistoryDtoOutputOrdersInnerOwner rebuild(
    void Function(MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder toBuilder() =>
      MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrderHistoryDtoOutputOrdersInnerOwner &&
        testOrder == other.testOrder &&
        commissionBp == other.commissionBp &&
        commission == other.commission &&
        discountShare == other.discountShare &&
        discountOnDelivery == other.discountOnDelivery &&
        merchantNet == other.merchantNet;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, testOrder.hashCode);
    _$hash = $jc(_$hash, commissionBp.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, discountShare.hashCode);
    _$hash = $jc(_$hash, discountOnDelivery.hashCode);
    _$hash = $jc(_$hash, merchantNet.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrderHistoryDtoOutputOrdersInnerOwner',
          )
          ..add('testOrder', testOrder)
          ..add('commissionBp', commissionBp)
          ..add('commission', commission)
          ..add('discountShare', discountShare)
          ..add('discountOnDelivery', discountOnDelivery)
          ..add('merchantNet', merchantNet))
        .toString();
  }
}

class MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder
    implements
        Builder<
          MerchantOrderHistoryDtoOutputOrdersInnerOwner,
          MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder
        > {
  _$MerchantOrderHistoryDtoOutputOrdersInnerOwner? _$v;

  bool? _testOrder;
  bool? get testOrder => _$this._testOrder;
  set testOrder(bool? testOrder) => _$this._testOrder = testOrder;

  int? _commissionBp;
  int? get commissionBp => _$this._commissionBp;
  set commissionBp(int? commissionBp) => _$this._commissionBp = commissionBp;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  String? _discountShare;
  String? get discountShare => _$this._discountShare;
  set discountShare(String? discountShare) =>
      _$this._discountShare = discountShare;

  bool? _discountOnDelivery;
  bool? get discountOnDelivery => _$this._discountOnDelivery;
  set discountOnDelivery(bool? discountOnDelivery) =>
      _$this._discountOnDelivery = discountOnDelivery;

  String? _merchantNet;
  String? get merchantNet => _$this._merchantNet;
  set merchantNet(String? merchantNet) => _$this._merchantNet = merchantNet;

  MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder() {
    MerchantOrderHistoryDtoOutputOrdersInnerOwner._defaults(this);
  }

  MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _testOrder = $v.testOrder;
      _commissionBp = $v.commissionBp;
      _commission = $v.commission;
      _discountShare = $v.discountShare;
      _discountOnDelivery = $v.discountOnDelivery;
      _merchantNet = $v.merchantNet;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrderHistoryDtoOutputOrdersInnerOwner other) {
    _$v = other as _$MerchantOrderHistoryDtoOutputOrdersInnerOwner;
  }

  @override
  void update(
    void Function(MerchantOrderHistoryDtoOutputOrdersInnerOwnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrderHistoryDtoOutputOrdersInnerOwner build() => _build();

  _$MerchantOrderHistoryDtoOutputOrdersInnerOwner _build() {
    final _$result =
        _$v ??
        _$MerchantOrderHistoryDtoOutputOrdersInnerOwner._(
          testOrder: BuiltValueNullFieldError.checkNotNull(
            testOrder,
            r'MerchantOrderHistoryDtoOutputOrdersInnerOwner',
            'testOrder',
          ),
          commissionBp: commissionBp,
          commission: commission,
          discountShare: discountShare,
          discountOnDelivery: BuiltValueNullFieldError.checkNotNull(
            discountOnDelivery,
            r'MerchantOrderHistoryDtoOutputOrdersInnerOwner',
            'discountOnDelivery',
          ),
          merchantNet: merchantNet,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
