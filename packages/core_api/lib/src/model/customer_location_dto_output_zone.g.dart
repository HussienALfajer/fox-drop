// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_location_dto_output_zone.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerLocationDtoOutputZone extends CustomerLocationDtoOutputZone {
  @override
  final String id;
  @override
  final String name;

  factory _$CustomerLocationDtoOutputZone([
    void Function(CustomerLocationDtoOutputZoneBuilder)? updates,
  ]) => (CustomerLocationDtoOutputZoneBuilder()..update(updates))._build();

  _$CustomerLocationDtoOutputZone._({required this.id, required this.name})
    : super._();
  @override
  CustomerLocationDtoOutputZone rebuild(
    void Function(CustomerLocationDtoOutputZoneBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerLocationDtoOutputZoneBuilder toBuilder() =>
      CustomerLocationDtoOutputZoneBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerLocationDtoOutputZone &&
        id == other.id &&
        name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerLocationDtoOutputZone')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class CustomerLocationDtoOutputZoneBuilder
    implements
        Builder<
          CustomerLocationDtoOutputZone,
          CustomerLocationDtoOutputZoneBuilder
        > {
  _$CustomerLocationDtoOutputZone? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CustomerLocationDtoOutputZoneBuilder() {
    CustomerLocationDtoOutputZone._defaults(this);
  }

  CustomerLocationDtoOutputZoneBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerLocationDtoOutputZone other) {
    _$v = other as _$CustomerLocationDtoOutputZone;
  }

  @override
  void update(void Function(CustomerLocationDtoOutputZoneBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerLocationDtoOutputZone build() => _build();

  _$CustomerLocationDtoOutputZone _build() {
    final _$result =
        _$v ??
        _$CustomerLocationDtoOutputZone._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'CustomerLocationDtoOutputZone',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'CustomerLocationDtoOutputZone',
            'name',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
