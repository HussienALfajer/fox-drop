// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_tickets_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputTicketsInner
    extends AdminCustomerDtoOutputTicketsInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final String typeLabel;
  @override
  final String status;
  @override
  final String? orderNumber;
  @override
  final DateTime openedAt;

  factory _$AdminCustomerDtoOutputTicketsInner([
    void Function(AdminCustomerDtoOutputTicketsInnerBuilder)? updates,
  ]) => (AdminCustomerDtoOutputTicketsInnerBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputTicketsInner._({
    required this.id,
    required this.number,
    required this.typeLabel,
    required this.status,
    this.orderNumber,
    required this.openedAt,
  }) : super._();
  @override
  AdminCustomerDtoOutputTicketsInner rebuild(
    void Function(AdminCustomerDtoOutputTicketsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputTicketsInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputTicketsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputTicketsInner &&
        id == other.id &&
        number == other.number &&
        typeLabel == other.typeLabel &&
        status == other.status &&
        orderNumber == other.orderNumber &&
        openedAt == other.openedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, typeLabel.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, openedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputTicketsInner')
          ..add('id', id)
          ..add('number', number)
          ..add('typeLabel', typeLabel)
          ..add('status', status)
          ..add('orderNumber', orderNumber)
          ..add('openedAt', openedAt))
        .toString();
  }
}

class AdminCustomerDtoOutputTicketsInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputTicketsInner,
          AdminCustomerDtoOutputTicketsInnerBuilder
        > {
  _$AdminCustomerDtoOutputTicketsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _typeLabel;
  String? get typeLabel => _$this._typeLabel;
  set typeLabel(String? typeLabel) => _$this._typeLabel = typeLabel;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  DateTime? _openedAt;
  DateTime? get openedAt => _$this._openedAt;
  set openedAt(DateTime? openedAt) => _$this._openedAt = openedAt;

  AdminCustomerDtoOutputTicketsInnerBuilder() {
    AdminCustomerDtoOutputTicketsInner._defaults(this);
  }

  AdminCustomerDtoOutputTicketsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _typeLabel = $v.typeLabel;
      _status = $v.status;
      _orderNumber = $v.orderNumber;
      _openedAt = $v.openedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputTicketsInner other) {
    _$v = other as _$AdminCustomerDtoOutputTicketsInner;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputTicketsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputTicketsInner build() => _build();

  _$AdminCustomerDtoOutputTicketsInner _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputTicketsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCustomerDtoOutputTicketsInner',
            'id',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'AdminCustomerDtoOutputTicketsInner',
            'number',
          ),
          typeLabel: BuiltValueNullFieldError.checkNotNull(
            typeLabel,
            r'AdminCustomerDtoOutputTicketsInner',
            'typeLabel',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminCustomerDtoOutputTicketsInner',
            'status',
          ),
          orderNumber: orderNumber,
          openedAt: BuiltValueNullFieldError.checkNotNull(
            openedAt,
            r'AdminCustomerDtoOutputTicketsInner',
            'openedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
