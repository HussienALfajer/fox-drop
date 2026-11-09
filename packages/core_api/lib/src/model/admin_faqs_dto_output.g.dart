// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_faqs_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminFaqsDtoOutput extends AdminFaqsDtoOutput {
  @override
  final BuiltList<AdminFaqsDtoOutputCustomerInner> customer;
  @override
  final BuiltList<AdminFaqsDtoOutputCustomerInner> captain;
  @override
  final BuiltList<AdminFaqsDtoOutputCustomerInner> merchant;

  factory _$AdminFaqsDtoOutput([
    void Function(AdminFaqsDtoOutputBuilder)? updates,
  ]) => (AdminFaqsDtoOutputBuilder()..update(updates))._build();

  _$AdminFaqsDtoOutput._({
    required this.customer,
    required this.captain,
    required this.merchant,
  }) : super._();
  @override
  AdminFaqsDtoOutput rebuild(
    void Function(AdminFaqsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminFaqsDtoOutputBuilder toBuilder() =>
      AdminFaqsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminFaqsDtoOutput &&
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
    return (newBuiltValueToStringHelper(r'AdminFaqsDtoOutput')
          ..add('customer', customer)
          ..add('captain', captain)
          ..add('merchant', merchant))
        .toString();
  }
}

class AdminFaqsDtoOutputBuilder
    implements Builder<AdminFaqsDtoOutput, AdminFaqsDtoOutputBuilder> {
  _$AdminFaqsDtoOutput? _$v;

  ListBuilder<AdminFaqsDtoOutputCustomerInner>? _customer;
  ListBuilder<AdminFaqsDtoOutputCustomerInner> get customer =>
      _$this._customer ??= ListBuilder<AdminFaqsDtoOutputCustomerInner>();
  set customer(ListBuilder<AdminFaqsDtoOutputCustomerInner>? customer) =>
      _$this._customer = customer;

  ListBuilder<AdminFaqsDtoOutputCustomerInner>? _captain;
  ListBuilder<AdminFaqsDtoOutputCustomerInner> get captain =>
      _$this._captain ??= ListBuilder<AdminFaqsDtoOutputCustomerInner>();
  set captain(ListBuilder<AdminFaqsDtoOutputCustomerInner>? captain) =>
      _$this._captain = captain;

  ListBuilder<AdminFaqsDtoOutputCustomerInner>? _merchant;
  ListBuilder<AdminFaqsDtoOutputCustomerInner> get merchant =>
      _$this._merchant ??= ListBuilder<AdminFaqsDtoOutputCustomerInner>();
  set merchant(ListBuilder<AdminFaqsDtoOutputCustomerInner>? merchant) =>
      _$this._merchant = merchant;

  AdminFaqsDtoOutputBuilder() {
    AdminFaqsDtoOutput._defaults(this);
  }

  AdminFaqsDtoOutputBuilder get _$this {
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
  void replace(AdminFaqsDtoOutput other) {
    _$v = other as _$AdminFaqsDtoOutput;
  }

  @override
  void update(void Function(AdminFaqsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminFaqsDtoOutput build() => _build();

  _$AdminFaqsDtoOutput _build() {
    _$AdminFaqsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminFaqsDtoOutput._(
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
          r'AdminFaqsDtoOutput',
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
