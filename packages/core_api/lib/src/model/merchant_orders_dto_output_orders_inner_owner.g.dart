// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_owner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputOrdersInnerOwner
    extends MerchantOrdersDtoOutputOrdersInnerOwner {
  @override
  final bool testOrder;
  @override
  final int? commissionBp;
  @override
  final String? commission;
  @override
  final String? merchantNet;

  factory _$MerchantOrdersDtoOutputOrdersInnerOwner([
    void Function(MerchantOrdersDtoOutputOrdersInnerOwnerBuilder)? updates,
  ]) => (MerchantOrdersDtoOutputOrdersInnerOwnerBuilder()..update(updates))
      ._build();

  _$MerchantOrdersDtoOutputOrdersInnerOwner._({
    required this.testOrder,
    this.commissionBp,
    this.commission,
    this.merchantNet,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerOwner rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerOwnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerOwnerBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerOwnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerOwner &&
        testOrder == other.testOrder &&
        commissionBp == other.commissionBp &&
        commission == other.commission &&
        merchantNet == other.merchantNet;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, testOrder.hashCode);
    _$hash = $jc(_$hash, commissionBp.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, merchantNet.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerOwner',
          )
          ..add('testOrder', testOrder)
          ..add('commissionBp', commissionBp)
          ..add('commission', commission)
          ..add('merchantNet', merchantNet))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerOwnerBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerOwner,
          MerchantOrdersDtoOutputOrdersInnerOwnerBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerOwner? _$v;

  bool? _testOrder;
  bool? get testOrder => _$this._testOrder;
  set testOrder(bool? testOrder) => _$this._testOrder = testOrder;

  int? _commissionBp;
  int? get commissionBp => _$this._commissionBp;
  set commissionBp(int? commissionBp) => _$this._commissionBp = commissionBp;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  String? _merchantNet;
  String? get merchantNet => _$this._merchantNet;
  set merchantNet(String? merchantNet) => _$this._merchantNet = merchantNet;

  MerchantOrdersDtoOutputOrdersInnerOwnerBuilder() {
    MerchantOrdersDtoOutputOrdersInnerOwner._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerOwnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _testOrder = $v.testOrder;
      _commissionBp = $v.commissionBp;
      _commission = $v.commission;
      _merchantNet = $v.merchantNet;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerOwner other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerOwner;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerOwnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerOwner build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerOwner _build() {
    final _$result =
        _$v ??
        _$MerchantOrdersDtoOutputOrdersInnerOwner._(
          testOrder: BuiltValueNullFieldError.checkNotNull(
            testOrder,
            r'MerchantOrdersDtoOutputOrdersInnerOwner',
            'testOrder',
          ),
          commissionBp: commissionBp,
          commission: commission,
          merchantNet: merchantNet,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
