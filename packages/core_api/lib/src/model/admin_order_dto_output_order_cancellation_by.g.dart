// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_cancellation_by.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderCancellationBy
    extends AdminOrderDtoOutputOrderCancellationBy {
  @override
  final String type;
  @override
  final String? id;

  factory _$AdminOrderDtoOutputOrderCancellationBy([
    void Function(AdminOrderDtoOutputOrderCancellationByBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderCancellationByBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderCancellationBy._({required this.type, this.id})
    : super._();
  @override
  AdminOrderDtoOutputOrderCancellationBy rebuild(
    void Function(AdminOrderDtoOutputOrderCancellationByBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderCancellationByBuilder toBuilder() =>
      AdminOrderDtoOutputOrderCancellationByBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderCancellationBy &&
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
            r'AdminOrderDtoOutputOrderCancellationBy',
          )
          ..add('type', type)
          ..add('id', id))
        .toString();
  }
}

class AdminOrderDtoOutputOrderCancellationByBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderCancellationBy,
          AdminOrderDtoOutputOrderCancellationByBuilder
        > {
  _$AdminOrderDtoOutputOrderCancellationBy? _$v;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminOrderDtoOutputOrderCancellationByBuilder() {
    AdminOrderDtoOutputOrderCancellationBy._defaults(this);
  }

  AdminOrderDtoOutputOrderCancellationByBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderCancellationBy other) {
    _$v = other as _$AdminOrderDtoOutputOrderCancellationBy;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderCancellationByBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderCancellationBy build() => _build();

  _$AdminOrderDtoOutputOrderCancellationBy _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderCancellationBy._(
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'AdminOrderDtoOutputOrderCancellationBy',
            'type',
          ),
          id: id,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
