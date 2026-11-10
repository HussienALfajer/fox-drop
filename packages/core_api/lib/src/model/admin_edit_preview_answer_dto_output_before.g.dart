// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_edit_preview_answer_dto_output_before.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminEditPreviewAnswerDtoOutputBefore
    extends AdminEditPreviewAnswerDtoOutputBefore {
  @override
  final String itemsValue;
  @override
  final String deliveryFee;
  @override
  final String discount;
  @override
  final String rounding;
  @override
  final String total;
  @override
  final String commission;
  @override
  final String merchantNet;

  factory _$AdminEditPreviewAnswerDtoOutputBefore([
    void Function(AdminEditPreviewAnswerDtoOutputBeforeBuilder)? updates,
  ]) => (AdminEditPreviewAnswerDtoOutputBeforeBuilder()..update(updates))
      ._build();

  _$AdminEditPreviewAnswerDtoOutputBefore._({
    required this.itemsValue,
    required this.deliveryFee,
    required this.discount,
    required this.rounding,
    required this.total,
    required this.commission,
    required this.merchantNet,
  }) : super._();
  @override
  AdminEditPreviewAnswerDtoOutputBefore rebuild(
    void Function(AdminEditPreviewAnswerDtoOutputBeforeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminEditPreviewAnswerDtoOutputBeforeBuilder toBuilder() =>
      AdminEditPreviewAnswerDtoOutputBeforeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminEditPreviewAnswerDtoOutputBefore &&
        itemsValue == other.itemsValue &&
        deliveryFee == other.deliveryFee &&
        discount == other.discount &&
        rounding == other.rounding &&
        total == other.total &&
        commission == other.commission &&
        merchantNet == other.merchantNet;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jc(_$hash, deliveryFee.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, rounding.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, commission.hashCode);
    _$hash = $jc(_$hash, merchantNet.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminEditPreviewAnswerDtoOutputBefore',
          )
          ..add('itemsValue', itemsValue)
          ..add('deliveryFee', deliveryFee)
          ..add('discount', discount)
          ..add('rounding', rounding)
          ..add('total', total)
          ..add('commission', commission)
          ..add('merchantNet', merchantNet))
        .toString();
  }
}

class AdminEditPreviewAnswerDtoOutputBeforeBuilder
    implements
        Builder<
          AdminEditPreviewAnswerDtoOutputBefore,
          AdminEditPreviewAnswerDtoOutputBeforeBuilder
        > {
  _$AdminEditPreviewAnswerDtoOutputBefore? _$v;

  String? _itemsValue;
  String? get itemsValue => _$this._itemsValue;
  set itemsValue(String? itemsValue) => _$this._itemsValue = itemsValue;

  String? _deliveryFee;
  String? get deliveryFee => _$this._deliveryFee;
  set deliveryFee(String? deliveryFee) => _$this._deliveryFee = deliveryFee;

  String? _discount;
  String? get discount => _$this._discount;
  set discount(String? discount) => _$this._discount = discount;

  String? _rounding;
  String? get rounding => _$this._rounding;
  set rounding(String? rounding) => _$this._rounding = rounding;

  String? _total;
  String? get total => _$this._total;
  set total(String? total) => _$this._total = total;

  String? _commission;
  String? get commission => _$this._commission;
  set commission(String? commission) => _$this._commission = commission;

  String? _merchantNet;
  String? get merchantNet => _$this._merchantNet;
  set merchantNet(String? merchantNet) => _$this._merchantNet = merchantNet;

  AdminEditPreviewAnswerDtoOutputBeforeBuilder() {
    AdminEditPreviewAnswerDtoOutputBefore._defaults(this);
  }

  AdminEditPreviewAnswerDtoOutputBeforeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _itemsValue = $v.itemsValue;
      _deliveryFee = $v.deliveryFee;
      _discount = $v.discount;
      _rounding = $v.rounding;
      _total = $v.total;
      _commission = $v.commission;
      _merchantNet = $v.merchantNet;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminEditPreviewAnswerDtoOutputBefore other) {
    _$v = other as _$AdminEditPreviewAnswerDtoOutputBefore;
  }

  @override
  void update(
    void Function(AdminEditPreviewAnswerDtoOutputBeforeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminEditPreviewAnswerDtoOutputBefore build() => _build();

  _$AdminEditPreviewAnswerDtoOutputBefore _build() {
    final _$result =
        _$v ??
        _$AdminEditPreviewAnswerDtoOutputBefore._(
          itemsValue: BuiltValueNullFieldError.checkNotNull(
            itemsValue,
            r'AdminEditPreviewAnswerDtoOutputBefore',
            'itemsValue',
          ),
          deliveryFee: BuiltValueNullFieldError.checkNotNull(
            deliveryFee,
            r'AdminEditPreviewAnswerDtoOutputBefore',
            'deliveryFee',
          ),
          discount: BuiltValueNullFieldError.checkNotNull(
            discount,
            r'AdminEditPreviewAnswerDtoOutputBefore',
            'discount',
          ),
          rounding: BuiltValueNullFieldError.checkNotNull(
            rounding,
            r'AdminEditPreviewAnswerDtoOutputBefore',
            'rounding',
          ),
          total: BuiltValueNullFieldError.checkNotNull(
            total,
            r'AdminEditPreviewAnswerDtoOutputBefore',
            'total',
          ),
          commission: BuiltValueNullFieldError.checkNotNull(
            commission,
            r'AdminEditPreviewAnswerDtoOutputBefore',
            'commission',
          ),
          merchantNet: BuiltValueNullFieldError.checkNotNull(
            merchantNet,
            r'AdminEditPreviewAnswerDtoOutputBefore',
            'merchantNet',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
