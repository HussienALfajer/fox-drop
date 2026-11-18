// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_draft_location_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDraftLocationDto extends AdminDraftLocationDto {
  @override
  final AdminDraftLocationDtoLocation location;
  @override
  final String? address;
  @override
  final String? phone;
  @override
  final String? ownerName;
  @override
  final String? ownerPhone;

  factory _$AdminDraftLocationDto([
    void Function(AdminDraftLocationDtoBuilder)? updates,
  ]) => (AdminDraftLocationDtoBuilder()..update(updates))._build();

  _$AdminDraftLocationDto._({
    required this.location,
    this.address,
    this.phone,
    this.ownerName,
    this.ownerPhone,
  }) : super._();
  @override
  AdminDraftLocationDto rebuild(
    void Function(AdminDraftLocationDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDraftLocationDtoBuilder toBuilder() =>
      AdminDraftLocationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDraftLocationDto &&
        location == other.location &&
        address == other.address &&
        phone == other.phone &&
        ownerName == other.ownerName &&
        ownerPhone == other.ownerPhone;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, phone.hashCode);
    _$hash = $jc(_$hash, ownerName.hashCode);
    _$hash = $jc(_$hash, ownerPhone.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminDraftLocationDto')
          ..add('location', location)
          ..add('address', address)
          ..add('phone', phone)
          ..add('ownerName', ownerName)
          ..add('ownerPhone', ownerPhone))
        .toString();
  }
}

class AdminDraftLocationDtoBuilder
    implements Builder<AdminDraftLocationDto, AdminDraftLocationDtoBuilder> {
  _$AdminDraftLocationDto? _$v;

  AdminDraftLocationDtoLocationBuilder? _location;
  AdminDraftLocationDtoLocationBuilder get location =>
      _$this._location ??= AdminDraftLocationDtoLocationBuilder();
  set location(AdminDraftLocationDtoLocationBuilder? location) =>
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

  String? _ownerPhone;
  String? get ownerPhone => _$this._ownerPhone;
  set ownerPhone(String? ownerPhone) => _$this._ownerPhone = ownerPhone;

  AdminDraftLocationDtoBuilder() {
    AdminDraftLocationDto._defaults(this);
  }

  AdminDraftLocationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location.toBuilder();
      _address = $v.address;
      _phone = $v.phone;
      _ownerName = $v.ownerName;
      _ownerPhone = $v.ownerPhone;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDraftLocationDto other) {
    _$v = other as _$AdminDraftLocationDto;
  }

  @override
  void update(void Function(AdminDraftLocationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminDraftLocationDto build() => _build();

  _$AdminDraftLocationDto _build() {
    _$AdminDraftLocationDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminDraftLocationDto._(
            location: location.build(),
            address: address,
            phone: phone,
            ownerName: ownerName,
            ownerPhone: ownerPhone,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDraftLocationDto',
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
