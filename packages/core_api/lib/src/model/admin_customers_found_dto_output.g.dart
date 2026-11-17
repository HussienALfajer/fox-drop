// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customers_found_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomersFoundDtoOutput extends AdminCustomersFoundDtoOutput {
  @override
  final BuiltList<AdminCustomersFoundDtoOutputCustomersInner> customers;

  factory _$AdminCustomersFoundDtoOutput([
    void Function(AdminCustomersFoundDtoOutputBuilder)? updates,
  ]) => (AdminCustomersFoundDtoOutputBuilder()..update(updates))._build();

  _$AdminCustomersFoundDtoOutput._({required this.customers}) : super._();
  @override
  AdminCustomersFoundDtoOutput rebuild(
    void Function(AdminCustomersFoundDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomersFoundDtoOutputBuilder toBuilder() =>
      AdminCustomersFoundDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomersFoundDtoOutput &&
        customers == other.customers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, customers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCustomersFoundDtoOutput',
    )..add('customers', customers)).toString();
  }
}

class AdminCustomersFoundDtoOutputBuilder
    implements
        Builder<
          AdminCustomersFoundDtoOutput,
          AdminCustomersFoundDtoOutputBuilder
        > {
  _$AdminCustomersFoundDtoOutput? _$v;

  ListBuilder<AdminCustomersFoundDtoOutputCustomersInner>? _customers;
  ListBuilder<AdminCustomersFoundDtoOutputCustomersInner> get customers =>
      _$this._customers ??=
          ListBuilder<AdminCustomersFoundDtoOutputCustomersInner>();
  set customers(
    ListBuilder<AdminCustomersFoundDtoOutputCustomersInner>? customers,
  ) => _$this._customers = customers;

  AdminCustomersFoundDtoOutputBuilder() {
    AdminCustomersFoundDtoOutput._defaults(this);
  }

  AdminCustomersFoundDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _customers = $v.customers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomersFoundDtoOutput other) {
    _$v = other as _$AdminCustomersFoundDtoOutput;
  }

  @override
  void update(void Function(AdminCustomersFoundDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomersFoundDtoOutput build() => _build();

  _$AdminCustomersFoundDtoOutput _build() {
    _$AdminCustomersFoundDtoOutput _$result;
    try {
      _$result =
          _$v ?? _$AdminCustomersFoundDtoOutput._(customers: customers.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'customers';
        customers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCustomersFoundDtoOutput',
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
