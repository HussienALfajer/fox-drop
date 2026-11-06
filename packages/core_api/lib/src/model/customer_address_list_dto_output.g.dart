// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_address_list_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerAddressListDtoOutput extends CustomerAddressListDtoOutput {
  @override
  final BuiltList<CustomerAddressListDtoOutputAddressesInner> addresses;

  factory _$CustomerAddressListDtoOutput([
    void Function(CustomerAddressListDtoOutputBuilder)? updates,
  ]) => (CustomerAddressListDtoOutputBuilder()..update(updates))._build();

  _$CustomerAddressListDtoOutput._({required this.addresses}) : super._();
  @override
  CustomerAddressListDtoOutput rebuild(
    void Function(CustomerAddressListDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerAddressListDtoOutputBuilder toBuilder() =>
      CustomerAddressListDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerAddressListDtoOutput &&
        addresses == other.addresses;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, addresses.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'CustomerAddressListDtoOutput',
    )..add('addresses', addresses)).toString();
  }
}

class CustomerAddressListDtoOutputBuilder
    implements
        Builder<
          CustomerAddressListDtoOutput,
          CustomerAddressListDtoOutputBuilder
        > {
  _$CustomerAddressListDtoOutput? _$v;

  ListBuilder<CustomerAddressListDtoOutputAddressesInner>? _addresses;
  ListBuilder<CustomerAddressListDtoOutputAddressesInner> get addresses =>
      _$this._addresses ??=
          ListBuilder<CustomerAddressListDtoOutputAddressesInner>();
  set addresses(
    ListBuilder<CustomerAddressListDtoOutputAddressesInner>? addresses,
  ) => _$this._addresses = addresses;

  CustomerAddressListDtoOutputBuilder() {
    CustomerAddressListDtoOutput._defaults(this);
  }

  CustomerAddressListDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _addresses = $v.addresses.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerAddressListDtoOutput other) {
    _$v = other as _$CustomerAddressListDtoOutput;
  }

  @override
  void update(void Function(CustomerAddressListDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerAddressListDtoOutput build() => _build();

  _$CustomerAddressListDtoOutput _build() {
    _$CustomerAddressListDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$CustomerAddressListDtoOutput._(addresses: addresses.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'addresses';
        addresses.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerAddressListDtoOutput',
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
