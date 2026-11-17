// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_orders_last.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCustomerDtoOutputOrdersLast
    extends AdminCustomerDtoOutputOrdersLast {
  @override
  final String id;
  @override
  final String number;
  @override
  final String status;
  @override
  final DateTime placedAt;

  factory _$AdminCustomerDtoOutputOrdersLast([
    void Function(AdminCustomerDtoOutputOrdersLastBuilder)? updates,
  ]) => (AdminCustomerDtoOutputOrdersLastBuilder()..update(updates))._build();

  _$AdminCustomerDtoOutputOrdersLast._({
    required this.id,
    required this.number,
    required this.status,
    required this.placedAt,
  }) : super._();
  @override
  AdminCustomerDtoOutputOrdersLast rebuild(
    void Function(AdminCustomerDtoOutputOrdersLastBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputOrdersLastBuilder toBuilder() =>
      AdminCustomerDtoOutputOrdersLastBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputOrdersLast &&
        id == other.id &&
        number == other.number &&
        status == other.status &&
        placedAt == other.placedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, placedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCustomerDtoOutputOrdersLast')
          ..add('id', id)
          ..add('number', number)
          ..add('status', status)
          ..add('placedAt', placedAt))
        .toString();
  }
}

class AdminCustomerDtoOutputOrdersLastBuilder
    implements
        Builder<
          AdminCustomerDtoOutputOrdersLast,
          AdminCustomerDtoOutputOrdersLastBuilder
        > {
  _$AdminCustomerDtoOutputOrdersLast? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _placedAt;
  DateTime? get placedAt => _$this._placedAt;
  set placedAt(DateTime? placedAt) => _$this._placedAt = placedAt;

  AdminCustomerDtoOutputOrdersLastBuilder() {
    AdminCustomerDtoOutputOrdersLast._defaults(this);
  }

  AdminCustomerDtoOutputOrdersLastBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _status = $v.status;
      _placedAt = $v.placedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputOrdersLast other) {
    _$v = other as _$AdminCustomerDtoOutputOrdersLast;
  }

  @override
  void update(void Function(AdminCustomerDtoOutputOrdersLastBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputOrdersLast build() => _build();

  _$AdminCustomerDtoOutputOrdersLast _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputOrdersLast._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCustomerDtoOutputOrdersLast',
            'id',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'AdminCustomerDtoOutputOrdersLast',
            'number',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminCustomerDtoOutputOrdersLast',
            'status',
          ),
          placedAt: BuiltValueNullFieldError.checkNotNull(
            placedAt,
            r'AdminCustomerDtoOutputOrdersLast',
            'placedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
