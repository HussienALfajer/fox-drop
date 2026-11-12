// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_city_office_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetCityOfficeDto extends AdminSetCityOfficeDto {
  @override
  final AdminSetCityOfficeDtoLocation location;
  @override
  final BuiltList<AdminSetCityOfficeDtoHoursInner> hours;

  factory _$AdminSetCityOfficeDto([
    void Function(AdminSetCityOfficeDtoBuilder)? updates,
  ]) => (AdminSetCityOfficeDtoBuilder()..update(updates))._build();

  _$AdminSetCityOfficeDto._({required this.location, required this.hours})
    : super._();
  @override
  AdminSetCityOfficeDto rebuild(
    void Function(AdminSetCityOfficeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetCityOfficeDtoBuilder toBuilder() =>
      AdminSetCityOfficeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetCityOfficeDto &&
        location == other.location &&
        hours == other.hours;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetCityOfficeDto')
          ..add('location', location)
          ..add('hours', hours))
        .toString();
  }
}

class AdminSetCityOfficeDtoBuilder
    implements Builder<AdminSetCityOfficeDto, AdminSetCityOfficeDtoBuilder> {
  _$AdminSetCityOfficeDto? _$v;

  AdminSetCityOfficeDtoLocationBuilder? _location;
  AdminSetCityOfficeDtoLocationBuilder get location =>
      _$this._location ??= AdminSetCityOfficeDtoLocationBuilder();
  set location(AdminSetCityOfficeDtoLocationBuilder? location) =>
      _$this._location = location;

  ListBuilder<AdminSetCityOfficeDtoHoursInner>? _hours;
  ListBuilder<AdminSetCityOfficeDtoHoursInner> get hours =>
      _$this._hours ??= ListBuilder<AdminSetCityOfficeDtoHoursInner>();
  set hours(ListBuilder<AdminSetCityOfficeDtoHoursInner>? hours) =>
      _$this._hours = hours;

  AdminSetCityOfficeDtoBuilder() {
    AdminSetCityOfficeDto._defaults(this);
  }

  AdminSetCityOfficeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location.toBuilder();
      _hours = $v.hours.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetCityOfficeDto other) {
    _$v = other as _$AdminSetCityOfficeDto;
  }

  @override
  void update(void Function(AdminSetCityOfficeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetCityOfficeDto build() => _build();

  _$AdminSetCityOfficeDto _build() {
    _$AdminSetCityOfficeDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminSetCityOfficeDto._(
            location: location.build(),
            hours: hours.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
        _$failedField = 'hours';
        hours.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminSetCityOfficeDto',
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
