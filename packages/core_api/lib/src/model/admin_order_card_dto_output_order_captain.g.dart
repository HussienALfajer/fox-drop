// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_card_dto_output_order_captain.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderCardDtoOutputOrderCaptain
    extends AdminOrderCardDtoOutputOrderCaptain {
  @override
  final String id;
  @override
  final String name;
  @override
  final String vehicle;

  factory _$AdminOrderCardDtoOutputOrderCaptain([
    void Function(AdminOrderCardDtoOutputOrderCaptainBuilder)? updates,
  ]) =>
      (AdminOrderCardDtoOutputOrderCaptainBuilder()..update(updates))._build();

  _$AdminOrderCardDtoOutputOrderCaptain._({
    required this.id,
    required this.name,
    required this.vehicle,
  }) : super._();
  @override
  AdminOrderCardDtoOutputOrderCaptain rebuild(
    void Function(AdminOrderCardDtoOutputOrderCaptainBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderCardDtoOutputOrderCaptainBuilder toBuilder() =>
      AdminOrderCardDtoOutputOrderCaptainBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderCardDtoOutputOrderCaptain &&
        id == other.id &&
        name == other.name &&
        vehicle == other.vehicle;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, vehicle.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderCardDtoOutputOrderCaptain')
          ..add('id', id)
          ..add('name', name)
          ..add('vehicle', vehicle))
        .toString();
  }
}

class AdminOrderCardDtoOutputOrderCaptainBuilder
    implements
        Builder<
          AdminOrderCardDtoOutputOrderCaptain,
          AdminOrderCardDtoOutputOrderCaptainBuilder
        > {
  _$AdminOrderCardDtoOutputOrderCaptain? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _vehicle;
  String? get vehicle => _$this._vehicle;
  set vehicle(String? vehicle) => _$this._vehicle = vehicle;

  AdminOrderCardDtoOutputOrderCaptainBuilder() {
    AdminOrderCardDtoOutputOrderCaptain._defaults(this);
  }

  AdminOrderCardDtoOutputOrderCaptainBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _vehicle = $v.vehicle;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderCardDtoOutputOrderCaptain other) {
    _$v = other as _$AdminOrderCardDtoOutputOrderCaptain;
  }

  @override
  void update(
    void Function(AdminOrderCardDtoOutputOrderCaptainBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderCardDtoOutputOrderCaptain build() => _build();

  _$AdminOrderCardDtoOutputOrderCaptain _build() {
    final _$result =
        _$v ??
        _$AdminOrderCardDtoOutputOrderCaptain._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminOrderCardDtoOutputOrderCaptain',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminOrderCardDtoOutputOrderCaptain',
            'name',
          ),
          vehicle: BuiltValueNullFieldError.checkNotNull(
            vehicle,
            r'AdminOrderCardDtoOutputOrderCaptain',
            'vehicle',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
