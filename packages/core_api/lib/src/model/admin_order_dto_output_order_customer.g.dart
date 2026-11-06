// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_customer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderCustomer
    extends AdminOrderDtoOutputOrderCustomer {
  @override
  final String? name;
  @override
  final AdminOrderDtoOutputOrderCustomerAddress address;
  @override
  final String? recipientName;
  @override
  final String? payIn;
  @override
  final AdminOrderDtoOutputOrderCustomerArrival? arrival;

  factory _$AdminOrderDtoOutputOrderCustomer([
    void Function(AdminOrderDtoOutputOrderCustomerBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderCustomerBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderCustomer._({
    this.name,
    required this.address,
    this.recipientName,
    this.payIn,
    this.arrival,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderCustomer rebuild(
    void Function(AdminOrderDtoOutputOrderCustomerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderCustomerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderCustomerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderCustomer &&
        name == other.name &&
        address == other.address &&
        recipientName == other.recipientName &&
        payIn == other.payIn &&
        arrival == other.arrival;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, recipientName.hashCode);
    _$hash = $jc(_$hash, payIn.hashCode);
    _$hash = $jc(_$hash, arrival.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderCustomer')
          ..add('name', name)
          ..add('address', address)
          ..add('recipientName', recipientName)
          ..add('payIn', payIn)
          ..add('arrival', arrival))
        .toString();
  }
}

class AdminOrderDtoOutputOrderCustomerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderCustomer,
          AdminOrderDtoOutputOrderCustomerBuilder
        > {
  _$AdminOrderDtoOutputOrderCustomer? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminOrderDtoOutputOrderCustomerAddressBuilder? _address;
  AdminOrderDtoOutputOrderCustomerAddressBuilder get address =>
      _$this._address ??= AdminOrderDtoOutputOrderCustomerAddressBuilder();
  set address(AdminOrderDtoOutputOrderCustomerAddressBuilder? address) =>
      _$this._address = address;

  String? _recipientName;
  String? get recipientName => _$this._recipientName;
  set recipientName(String? recipientName) =>
      _$this._recipientName = recipientName;

  String? _payIn;
  String? get payIn => _$this._payIn;
  set payIn(String? payIn) => _$this._payIn = payIn;

  AdminOrderDtoOutputOrderCustomerArrivalBuilder? _arrival;
  AdminOrderDtoOutputOrderCustomerArrivalBuilder get arrival =>
      _$this._arrival ??= AdminOrderDtoOutputOrderCustomerArrivalBuilder();
  set arrival(AdminOrderDtoOutputOrderCustomerArrivalBuilder? arrival) =>
      _$this._arrival = arrival;

  AdminOrderDtoOutputOrderCustomerBuilder() {
    AdminOrderDtoOutputOrderCustomer._defaults(this);
  }

  AdminOrderDtoOutputOrderCustomerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _address = $v.address.toBuilder();
      _recipientName = $v.recipientName;
      _payIn = $v.payIn;
      _arrival = $v.arrival?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderCustomer other) {
    _$v = other as _$AdminOrderDtoOutputOrderCustomer;
  }

  @override
  void update(void Function(AdminOrderDtoOutputOrderCustomerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderCustomer build() => _build();

  _$AdminOrderDtoOutputOrderCustomer _build() {
    _$AdminOrderDtoOutputOrderCustomer _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderCustomer._(
            name: name,
            address: address.build(),
            recipientName: recipientName,
            payIn: payIn,
            arrival: _arrival?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'address';
        address.build();

        _$failedField = 'arrival';
        _arrival?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderCustomer',
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
