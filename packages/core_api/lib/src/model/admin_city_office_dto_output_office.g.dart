// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_city_office_dto_output_office.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCityOfficeDtoOutputOffice extends AdminCityOfficeDtoOutputOffice {
  @override
  final AdminCityOfficeDtoOutputOfficeLocation location;
  @override
  final BuiltList<AdminCityOfficeDtoOutputOfficeHoursInner> hours;
  @override
  final bool open;
  @override
  final DateTime? closesAt;
  @override
  final DateTime? opensAt;

  factory _$AdminCityOfficeDtoOutputOffice([
    void Function(AdminCityOfficeDtoOutputOfficeBuilder)? updates,
  ]) => (AdminCityOfficeDtoOutputOfficeBuilder()..update(updates))._build();

  _$AdminCityOfficeDtoOutputOffice._({
    required this.location,
    required this.hours,
    required this.open,
    this.closesAt,
    this.opensAt,
  }) : super._();
  @override
  AdminCityOfficeDtoOutputOffice rebuild(
    void Function(AdminCityOfficeDtoOutputOfficeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCityOfficeDtoOutputOfficeBuilder toBuilder() =>
      AdminCityOfficeDtoOutputOfficeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCityOfficeDtoOutputOffice &&
        location == other.location &&
        hours == other.hours &&
        open == other.open &&
        closesAt == other.closesAt &&
        opensAt == other.opensAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jc(_$hash, open.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminCityOfficeDtoOutputOffice')
          ..add('location', location)
          ..add('hours', hours)
          ..add('open', open)
          ..add('closesAt', closesAt)
          ..add('opensAt', opensAt))
        .toString();
  }
}

class AdminCityOfficeDtoOutputOfficeBuilder
    implements
        Builder<
          AdminCityOfficeDtoOutputOffice,
          AdminCityOfficeDtoOutputOfficeBuilder
        > {
  _$AdminCityOfficeDtoOutputOffice? _$v;

  AdminCityOfficeDtoOutputOfficeLocationBuilder? _location;
  AdminCityOfficeDtoOutputOfficeLocationBuilder get location =>
      _$this._location ??= AdminCityOfficeDtoOutputOfficeLocationBuilder();
  set location(AdminCityOfficeDtoOutputOfficeLocationBuilder? location) =>
      _$this._location = location;

  ListBuilder<AdminCityOfficeDtoOutputOfficeHoursInner>? _hours;
  ListBuilder<AdminCityOfficeDtoOutputOfficeHoursInner> get hours =>
      _$this._hours ??= ListBuilder<AdminCityOfficeDtoOutputOfficeHoursInner>();
  set hours(ListBuilder<AdminCityOfficeDtoOutputOfficeHoursInner>? hours) =>
      _$this._hours = hours;

  bool? _open;
  bool? get open => _$this._open;
  set open(bool? open) => _$this._open = open;

  DateTime? _closesAt;
  DateTime? get closesAt => _$this._closesAt;
  set closesAt(DateTime? closesAt) => _$this._closesAt = closesAt;

  DateTime? _opensAt;
  DateTime? get opensAt => _$this._opensAt;
  set opensAt(DateTime? opensAt) => _$this._opensAt = opensAt;

  AdminCityOfficeDtoOutputOfficeBuilder() {
    AdminCityOfficeDtoOutputOffice._defaults(this);
  }

  AdminCityOfficeDtoOutputOfficeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location.toBuilder();
      _hours = $v.hours.toBuilder();
      _open = $v.open;
      _closesAt = $v.closesAt;
      _opensAt = $v.opensAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCityOfficeDtoOutputOffice other) {
    _$v = other as _$AdminCityOfficeDtoOutputOffice;
  }

  @override
  void update(void Function(AdminCityOfficeDtoOutputOfficeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCityOfficeDtoOutputOffice build() => _build();

  _$AdminCityOfficeDtoOutputOffice _build() {
    _$AdminCityOfficeDtoOutputOffice _$result;
    try {
      _$result =
          _$v ??
          _$AdminCityOfficeDtoOutputOffice._(
            location: location.build(),
            hours: hours.build(),
            open: BuiltValueNullFieldError.checkNotNull(
              open,
              r'AdminCityOfficeDtoOutputOffice',
              'open',
            ),
            closesAt: closesAt,
            opensAt: opensAt,
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
          r'AdminCityOfficeDtoOutputOffice',
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
