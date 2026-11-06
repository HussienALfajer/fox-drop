// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_pickup_requests_inner_closed_by.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy
    extends AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy {
  @override
  final String type;
  @override
  final String? id;

  factory _$AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy([
    void Function(AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy._({
    required this.type,
    this.id,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy rebuild(
    void Function(AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder toBuilder() =>
      AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy &&
        type == other.type &&
        id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy',
          )
          ..add('type', type)
          ..add('id', id))
        .toString();
  }
}

class AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy,
          AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder
        > {
  _$AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder() {
    AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy._defaults(this);
  }

  AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy other) {
    _$v = other as _$AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderPickupRequestsInnerClosedByBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy build() => _build();

  _$AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy._(
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'AdminOrderDtoOutputOrderPickupRequestsInnerClosedBy',
            'type',
          ),
          id: id,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
