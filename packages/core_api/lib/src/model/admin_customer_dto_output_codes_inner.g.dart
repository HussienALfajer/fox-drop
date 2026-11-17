// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_codes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputCodesInner
    extends AdminCustomerDtoOutputCodesInner {
  @override
  final String code;
  @override
  final String kind;
  @override
  final String orderId;
  @override
  final String currency;
  @override
  final String discount;
  @override
  final String status;
  @override
  final DateTime heldAt;

  factory _$AdminCustomerDtoOutputCodesInner([
    void Function(AdminCustomerDtoOutputCodesInnerBuilder)? updates,
  ]) => (AdminCustomerDtoOutputCodesInnerBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputCodesInner._({
    required this.code,
    required this.kind,
    required this.orderId,
    required this.currency,
    required this.discount,
    required this.status,
    required this.heldAt,
  }) : super._();
  @override
  AdminCustomerDtoOutputCodesInner rebuild(
    void Function(AdminCustomerDtoOutputCodesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputCodesInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputCodesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputCodesInner &&
        code == other.code &&
        kind == other.kind &&
        orderId == other.orderId &&
        currency == other.currency &&
        discount == other.discount &&
        status == other.status &&
        heldAt == other.heldAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, heldAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputCodesInner')
          ..add('code', code)
          ..add('kind', kind)
          ..add('orderId', orderId)
          ..add('currency', currency)
          ..add('discount', discount)
          ..add('status', status)
          ..add('heldAt', heldAt))
        .toString();
  }
}

class AdminCustomerDtoOutputCodesInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputCodesInner,
          AdminCustomerDtoOutputCodesInnerBuilder
        > {
  _$AdminCustomerDtoOutputCodesInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _kind;
  String? get kind => _$this._kind;
  set kind(String? kind) => _$this._kind = kind;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  String? _discount;
  String? get discount => _$this._discount;
  set discount(String? discount) => _$this._discount = discount;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _heldAt;
  DateTime? get heldAt => _$this._heldAt;
  set heldAt(DateTime? heldAt) => _$this._heldAt = heldAt;

  AdminCustomerDtoOutputCodesInnerBuilder() {
    AdminCustomerDtoOutputCodesInner._defaults(this);
  }

  AdminCustomerDtoOutputCodesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _kind = $v.kind;
      _orderId = $v.orderId;
      _currency = $v.currency;
      _discount = $v.discount;
      _status = $v.status;
      _heldAt = $v.heldAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputCodesInner other) {
    _$v = other as _$AdminCustomerDtoOutputCodesInner;
  }

  @override
  void update(void Function(AdminCustomerDtoOutputCodesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputCodesInner build() => _build();

  _$AdminCustomerDtoOutputCodesInner _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputCodesInner._(
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminCustomerDtoOutputCodesInner',
            'code',
          ),
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminCustomerDtoOutputCodesInner',
            'kind',
          ),
          orderId: BuiltValueNullFieldError.checkNotNull(
            orderId,
            r'AdminCustomerDtoOutputCodesInner',
            'orderId',
          ),
          currency: BuiltValueNullFieldError.checkNotNull(
            currency,
            r'AdminCustomerDtoOutputCodesInner',
            'currency',
          ),
          discount: BuiltValueNullFieldError.checkNotNull(
            discount,
            r'AdminCustomerDtoOutputCodesInner',
            'discount',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminCustomerDtoOutputCodesInner',
            'status',
          ),
          heldAt: BuiltValueNullFieldError.checkNotNull(
            heldAt,
            r'AdminCustomerDtoOutputCodesInner',
            'heldAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
