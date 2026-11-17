// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_orders.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputOrders extends AdminCustomerDtoOutputOrders {
  @override
  final int count;
  @override
  final BuiltList<AdminCustomerDtoOutputOrdersSpentInner> spent;
  @override
  final AdminCustomerDtoOutputOrdersLast? last;

  factory _$AdminCustomerDtoOutputOrders([
    void Function(AdminCustomerDtoOutputOrdersBuilder)? updates,
  ]) => (AdminCustomerDtoOutputOrdersBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputOrders._({
    required this.count,
    required this.spent,
    this.last,
  }) : super._();
  @override
  AdminCustomerDtoOutputOrders rebuild(
    void Function(AdminCustomerDtoOutputOrdersBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputOrdersBuilder toBuilder() =>
      AdminCustomerDtoOutputOrdersBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputOrders &&
        count == other.count &&
        spent == other.spent &&
        last == other.last;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, count.hashCode);
    _$hash = $jc(_$hash, spent.hashCode);
    _$hash = $jc(_$hash, last.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputOrders')
          ..add('count', count)
          ..add('spent', spent)
          ..add('last', last))
        .toString();
  }
}

class AdminCustomerDtoOutputOrdersBuilder
    implements
        Builder<
          AdminCustomerDtoOutputOrders,
          AdminCustomerDtoOutputOrdersBuilder
        > {
  _$AdminCustomerDtoOutputOrders? _$v;

  int? _count;
  int? get count => _$this._count;
  set count(int? count) => _$this._count = count;

  ListBuilder<AdminCustomerDtoOutputOrdersSpentInner>? _spent;
  ListBuilder<AdminCustomerDtoOutputOrdersSpentInner> get spent =>
      _$this._spent ??= ListBuilder<AdminCustomerDtoOutputOrdersSpentInner>();
  set spent(ListBuilder<AdminCustomerDtoOutputOrdersSpentInner>? spent) =>
      _$this._spent = spent;

  AdminCustomerDtoOutputOrdersLastBuilder? _last;
  AdminCustomerDtoOutputOrdersLastBuilder get last =>
      _$this._last ??= AdminCustomerDtoOutputOrdersLastBuilder();
  set last(AdminCustomerDtoOutputOrdersLastBuilder? last) =>
      _$this._last = last;

  AdminCustomerDtoOutputOrdersBuilder() {
    AdminCustomerDtoOutputOrders._defaults(this);
  }

  AdminCustomerDtoOutputOrdersBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _count = $v.count;
      _spent = $v.spent.toBuilder();
      _last = $v.last?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputOrders other) {
    _$v = other as _$AdminCustomerDtoOutputOrders;
  }

  @override
  void update(void Function(AdminCustomerDtoOutputOrdersBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputOrders build() => _build();

  _$AdminCustomerDtoOutputOrders _build() {
    _$AdminCustomerDtoOutputOrders _$result;
    try {
      _$result =
          _$v ??
          _$AdminCustomerDtoOutputOrders._(
            count: BuiltValueNullFieldError.checkNotNull(
              count,
              r'AdminCustomerDtoOutputOrders',
              'count',
            ),
            spent: spent.build(),
            last: _last?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'spent';
        spent.build();
        _$failedField = 'last';
        _last?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCustomerDtoOutputOrders',
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
