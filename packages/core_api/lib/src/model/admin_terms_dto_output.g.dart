// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_terms_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTermsDtoOutput extends AdminTermsDtoOutput {
  @override
  final AdminTermsDtoOutputCustomer customer;
  @override
  final AdminTermsDtoOutputCustomer captain;
  @override
  final AdminTermsDtoOutputCustomer merchant;

  factory _$AdminTermsDtoOutput([
    void Function(AdminTermsDtoOutputBuilder)? updates,
  ]) => (AdminTermsDtoOutputBuilder()..update(updates))._build();

  _$AdminTermsDtoOutput._({
    required this.customer,
    required this.captain,
    required this.merchant,
  }) : super._();
  @override
  AdminTermsDtoOutput rebuild(
    void Function(AdminTermsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTermsDtoOutputBuilder toBuilder() =>
      AdminTermsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTermsDtoOutput &&
        customer == other.customer &&
        captain == other.captain &&
        merchant == other.merchant;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jc(_$hash, captain.hashCode);
    _$hash = $jc(_$hash, merchant.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTermsDtoOutput')
          ..add('customer', customer)
          ..add('captain', captain)
          ..add('merchant', merchant))
        .toString();
  }
}

class AdminTermsDtoOutputBuilder
    implements Builder<AdminTermsDtoOutput, AdminTermsDtoOutputBuilder> {
  _$AdminTermsDtoOutput? _$v;

  AdminTermsDtoOutputCustomerBuilder? _customer;
  AdminTermsDtoOutputCustomerBuilder get customer =>
      _$this._customer ??= AdminTermsDtoOutputCustomerBuilder();
  set customer(AdminTermsDtoOutputCustomerBuilder? customer) =>
      _$this._customer = customer;

  AdminTermsDtoOutputCustomerBuilder? _captain;
  AdminTermsDtoOutputCustomerBuilder get captain =>
      _$this._captain ??= AdminTermsDtoOutputCustomerBuilder();
  set captain(AdminTermsDtoOutputCustomerBuilder? captain) =>
      _$this._captain = captain;

  AdminTermsDtoOutputCustomerBuilder? _merchant;
  AdminTermsDtoOutputCustomerBuilder get merchant =>
      _$this._merchant ??= AdminTermsDtoOutputCustomerBuilder();
  set merchant(AdminTermsDtoOutputCustomerBuilder? merchant) =>
      _$this._merchant = merchant;

  AdminTermsDtoOutputBuilder() {
    AdminTermsDtoOutput._defaults(this);
  }

  AdminTermsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _customer = $v.customer.toBuilder();
      _captain = $v.captain.toBuilder();
      _merchant = $v.merchant.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTermsDtoOutput other) {
    _$v = other as _$AdminTermsDtoOutput;
  }

  @override
  void update(void Function(AdminTermsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTermsDtoOutput build() => _build();

  _$AdminTermsDtoOutput _build() {
    _$AdminTermsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminTermsDtoOutput._(
            customer: customer.build(),
            captain: captain.build(),
            merchant: merchant.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'customer';
        customer.build();
        _$failedField = 'captain';
        captain.build();
        _$failedField = 'merchant';
        merchant.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTermsDtoOutput',
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
