// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_ticket_page_dto_output_redeliveries_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminTicketPageDtoOutputRedeliveriesInner
    extends AdminTicketPageDtoOutputRedeliveriesInner {
  @override
  final String orderId;
  @override
  final String number;
  @override
  final String status;

  factory _$AdminTicketPageDtoOutputRedeliveriesInner([
    void Function(AdminTicketPageDtoOutputRedeliveriesInnerBuilder)? updates,
  ]) => (AdminTicketPageDtoOutputRedeliveriesInnerBuilder()..update(updates))
      ._build();

  _$AdminTicketPageDtoOutputRedeliveriesInner._({
    required this.orderId,
    required this.number,
    required this.status,
  }) : super._();
  @override
  AdminTicketPageDtoOutputRedeliveriesInner rebuild(
    void Function(AdminTicketPageDtoOutputRedeliveriesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminTicketPageDtoOutputRedeliveriesInnerBuilder toBuilder() =>
      AdminTicketPageDtoOutputRedeliveriesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminTicketPageDtoOutputRedeliveriesInner &&
        orderId == other.orderId &&
        number == other.number &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminTicketPageDtoOutputRedeliveriesInner',
          )
          ..add('orderId', orderId)
          ..add('number', number)
          ..add('status', status))
        .toString();
  }
}

class AdminTicketPageDtoOutputRedeliveriesInnerBuilder
    implements
        Builder<
          AdminTicketPageDtoOutputRedeliveriesInner,
          AdminTicketPageDtoOutputRedeliveriesInnerBuilder
        > {
  _$AdminTicketPageDtoOutputRedeliveriesInner? _$v;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  AdminTicketPageDtoOutputRedeliveriesInnerBuilder() {
    AdminTicketPageDtoOutputRedeliveriesInner._defaults(this);
  }

  AdminTicketPageDtoOutputRedeliveriesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _orderId = $v.orderId;
      _number = $v.number;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminTicketPageDtoOutputRedeliveriesInner other) {
    _$v = other as _$AdminTicketPageDtoOutputRedeliveriesInner;
  }

  @override
  void update(
    void Function(AdminTicketPageDtoOutputRedeliveriesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminTicketPageDtoOutputRedeliveriesInner build() => _build();

  _$AdminTicketPageDtoOutputRedeliveriesInner _build() {
    final _$result =
        _$v ??
        _$AdminTicketPageDtoOutputRedeliveriesInner._(
          orderId: BuiltValueNullFieldError.checkNotNull(
            orderId,
            r'AdminTicketPageDtoOutputRedeliveriesInner',
            'orderId',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'AdminTicketPageDtoOutputRedeliveriesInner',
            'number',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminTicketPageDtoOutputRedeliveriesInner',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
