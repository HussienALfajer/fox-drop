// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_types_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketTypesDtoOutput extends AdminTicketTypesDtoOutput {
  @override
  final BuiltList<AdminCompensationRequestsDtoOutputRequestsInnerReason?>
  customer;
  @override
  final BuiltList<AdminCustomerDtoOutputBlockReasonsInner> restaurant;
  @override
  final BuiltList<AdminCustomerDtoOutputBlockReasonsInner> captain;

  factory _$AdminTicketTypesDtoOutput([
    void Function(AdminTicketTypesDtoOutputBuilder)? updates,
  ]) => (AdminTicketTypesDtoOutputBuilder()..update(updates))._build();

  _$AdminTicketTypesDtoOutput._({
    required this.customer,
    required this.restaurant,
    required this.captain,
  }) : super._();
  @override
  AdminTicketTypesDtoOutput rebuild(
    void Function(AdminTicketTypesDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketTypesDtoOutputBuilder toBuilder() =>
      AdminTicketTypesDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketTypesDtoOutput &&
        customer == other.customer &&
        restaurant == other.restaurant &&
        captain == other.captain;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, customer.hashCode);
    _$hash = $jc(_$hash, restaurant.hashCode);
    _$hash = $jc(_$hash, captain.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminTicketTypesDtoOutput')
          ..add('customer', customer)
          ..add('restaurant', restaurant)
          ..add('captain', captain))
        .toString();
  }
}

class AdminTicketTypesDtoOutputBuilder
    implements
        Builder<AdminTicketTypesDtoOutput, AdminTicketTypesDtoOutputBuilder> {
  _$AdminTicketTypesDtoOutput? _$v;

  ListBuilder<AdminCompensationRequestsDtoOutputRequestsInnerReason?>?
  _customer;
  ListBuilder<AdminCompensationRequestsDtoOutputRequestsInnerReason?>
  get customer => _$this._customer ??=
      ListBuilder<AdminCompensationRequestsDtoOutputRequestsInnerReason?>();
  set customer(
    ListBuilder<AdminCompensationRequestsDtoOutputRequestsInnerReason?>?
    customer,
  ) => _$this._customer = customer;

  ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>? _restaurant;
  ListBuilder<AdminCustomerDtoOutputBlockReasonsInner> get restaurant =>
      _$this._restaurant ??=
          ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>();
  set restaurant(
    ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>? restaurant,
  ) => _$this._restaurant = restaurant;

  ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>? _captain;
  ListBuilder<AdminCustomerDtoOutputBlockReasonsInner> get captain =>
      _$this._captain ??=
          ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>();
  set captain(ListBuilder<AdminCustomerDtoOutputBlockReasonsInner>? captain) =>
      _$this._captain = captain;

  AdminTicketTypesDtoOutputBuilder() {
    AdminTicketTypesDtoOutput._defaults(this);
  }

  AdminTicketTypesDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _customer = $v.customer.toBuilder();
      _restaurant = $v.restaurant.toBuilder();
      _captain = $v.captain.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketTypesDtoOutput other) {
    _$v = other as _$AdminTicketTypesDtoOutput;
  }

  @override
  void update(void Function(AdminTicketTypesDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketTypesDtoOutput build() => _build();

  _$AdminTicketTypesDtoOutput _build() {
    _$AdminTicketTypesDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminTicketTypesDtoOutput._(
            customer: customer.build(),
            restaurant: restaurant.build(),
            captain: captain.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'customer';
        customer.build();
        _$failedField = 'restaurant';
        restaurant.build();
        _$failedField = 'captain';
        captain.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminTicketTypesDtoOutput',
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
