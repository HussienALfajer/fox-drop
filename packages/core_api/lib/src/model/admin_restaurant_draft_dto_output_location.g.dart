// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftDtoOutputLocation
    extends AdminRestaurantDraftDtoOutputLocation {
  @override
  final AdminDraftPointOutput? location;
  @override
  final String? address;
  @override
  final String? phone;
  @override
  final String? ownerName;

  factory _$AdminRestaurantDraftDtoOutputLocation([
    void Function(AdminRestaurantDraftDtoOutputLocationBuilder)? updates,
  ]) => (AdminRestaurantDraftDtoOutputLocationBuilder()..update(updates))
      ._build();

  _$AdminRestaurantDraftDtoOutputLocation._({
    this.location,
    this.address,
    this.phone,
    this.ownerName,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutputLocation rebuild(
    void Function(AdminRestaurantDraftDtoOutputLocationBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputLocationBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutputLocation &&
        location == other.location &&
        address == other.address &&
        phone == other.phone &&
        ownerName == other.ownerName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, ownerName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftDtoOutputLocation',
          )
          ..add('location', location)
          ..add('address', address)
          ..add('phone', phone)
          ..add('ownerName', ownerName))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputLocationBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutputLocation,
          AdminRestaurantDraftDtoOutputLocationBuilder
        > {
  _$AdminRestaurantDraftDtoOutputLocation? _$v;

  AdminDraftPointOutputBuilder? _location;
  AdminDraftPointOutputBuilder get location =>
      _$this._location ??= AdminDraftPointOutputBuilder();
  set location(AdminDraftPointOutputBuilder? location) =>
      _$this._location = location;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _phone;
  String? get phone => _$this._phone;
  set phone(String? phone) => _$this._phone = phone;

  String? _ownerName;
  String? get ownerName => _$this._ownerName;
  set ownerName(String? ownerName) => _$this._ownerName = ownerName;

  AdminRestaurantDraftDtoOutputLocationBuilder() {
    AdminRestaurantDraftDtoOutputLocation._defaults(this);
  }

  AdminRestaurantDraftDtoOutputLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location?.toBuilder();
      _address = $v.address;
      _phone = $v.phone;
      _ownerName = $v.ownerName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutputLocation other) {
    _$v = other as _$AdminRestaurantDraftDtoOutputLocation;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftDtoOutputLocationBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutputLocation build() => _build();

  _$AdminRestaurantDraftDtoOutputLocation _build() {
    _$AdminRestaurantDraftDtoOutputLocation _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantDraftDtoOutputLocation._(
            location: _location?.build(),
            address: address,
            phone: phone,
            ownerName: ownerName,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        _location?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantDraftDtoOutputLocation',
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
