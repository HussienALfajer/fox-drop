// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_board_dto_output_orders_inner_captain.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBoardDtoOutputOrdersInnerCaptain
    extends AdminBoardDtoOutputOrdersInnerCaptain {
  @override
  final String id;
  @override
  final String name;
  @override
  final String vehicle;

  factory _$AdminBoardDtoOutputOrdersInnerCaptain([
    void Function(AdminBoardDtoOutputOrdersInnerCaptainBuilder)? updates,
  ]) => (AdminBoardDtoOutputOrdersInnerCaptainBuilder()..update(updates))
      ._build();

  _$AdminBoardDtoOutputOrdersInnerCaptain._({
    required this.id,
    required this.name,
    required this.vehicle,
  }) : super._();
  @override
  AdminBoardDtoOutputOrdersInnerCaptain rebuild(
    void Function(AdminBoardDtoOutputOrdersInnerCaptainBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBoardDtoOutputOrdersInnerCaptainBuilder toBuilder() =>
      AdminBoardDtoOutputOrdersInnerCaptainBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBoardDtoOutputOrdersInnerCaptain &&
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
    return (newBuiltValueToStringHelper(
            r'AdminBoardDtoOutputOrdersInnerCaptain',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('vehicle', vehicle))
        .toString();
  }
}

class AdminBoardDtoOutputOrdersInnerCaptainBuilder
    implements
        Builder<
          AdminBoardDtoOutputOrdersInnerCaptain,
          AdminBoardDtoOutputOrdersInnerCaptainBuilder
        > {
  _$AdminBoardDtoOutputOrdersInnerCaptain? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _vehicle;
  String? get vehicle => _$this._vehicle;
  set vehicle(String? vehicle) => _$this._vehicle = vehicle;

  AdminBoardDtoOutputOrdersInnerCaptainBuilder() {
    AdminBoardDtoOutputOrdersInnerCaptain._defaults(this);
  }

  AdminBoardDtoOutputOrdersInnerCaptainBuilder get _$this {
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
  void replace(AdminBoardDtoOutputOrdersInnerCaptain other) {
    _$v = other as _$AdminBoardDtoOutputOrdersInnerCaptain;
  }

  @override
  void update(
    void Function(AdminBoardDtoOutputOrdersInnerCaptainBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminBoardDtoOutputOrdersInnerCaptain build() => _build();

  _$AdminBoardDtoOutputOrdersInnerCaptain _build() {
    final _$result =
        _$v ??
        _$AdminBoardDtoOutputOrdersInnerCaptain._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminBoardDtoOutputOrdersInnerCaptain',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminBoardDtoOutputOrdersInnerCaptain',
            'name',
          ),
          vehicle: BuiltValueNullFieldError.checkNotNull(
            vehicle,
            r'AdminBoardDtoOutputOrdersInnerCaptain',
            'vehicle',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
