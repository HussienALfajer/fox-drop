// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_city_office_dto_output_office_hours_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCityOfficeDtoOutputOfficeHoursInner
    extends AdminCityOfficeDtoOutputOfficeHoursInner {
  @override
  final int weekday;
  @override
  final int opensAt;
  @override
  final int closesAt;

  factory _$AdminCityOfficeDtoOutputOfficeHoursInner([
    void Function(AdminCityOfficeDtoOutputOfficeHoursInnerBuilder)? updates,
  ]) => (AdminCityOfficeDtoOutputOfficeHoursInnerBuilder()..update(updates))
      ._build();

  _$AdminCityOfficeDtoOutputOfficeHoursInner._({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  }) : super._();
  @override
  AdminCityOfficeDtoOutputOfficeHoursInner rebuild(
    void Function(AdminCityOfficeDtoOutputOfficeHoursInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCityOfficeDtoOutputOfficeHoursInnerBuilder toBuilder() =>
      AdminCityOfficeDtoOutputOfficeHoursInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCityOfficeDtoOutputOfficeHoursInner &&
        weekday == other.weekday &&
        opensAt == other.opensAt &&
        closesAt == other.closesAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, weekday.hashCode);
    _$hash = $jc(_$hash, opensAt.hashCode);
    _$hash = $jc(_$hash, closesAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCityOfficeDtoOutputOfficeHoursInner',
          )
          ..add('weekday', weekday)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class AdminCityOfficeDtoOutputOfficeHoursInnerBuilder
    implements
        Builder<
          AdminCityOfficeDtoOutputOfficeHoursInner,
          AdminCityOfficeDtoOutputOfficeHoursInnerBuilder
        > {
  _$AdminCityOfficeDtoOutputOfficeHoursInner? _$v;

  int? _weekday;
  int? get weekday => _$this._weekday;
  set weekday(int? weekday) => _$this._weekday = weekday;

  int? _opensAt;
  int? get opensAt => _$this._opensAt;
  set opensAt(int? opensAt) => _$this._opensAt = opensAt;

  int? _closesAt;
  int? get closesAt => _$this._closesAt;
  set closesAt(int? closesAt) => _$this._closesAt = closesAt;

  AdminCityOfficeDtoOutputOfficeHoursInnerBuilder() {
    AdminCityOfficeDtoOutputOfficeHoursInner._defaults(this);
  }

  AdminCityOfficeDtoOutputOfficeHoursInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _weekday = $v.weekday;
      _opensAt = $v.opensAt;
      _closesAt = $v.closesAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCityOfficeDtoOutputOfficeHoursInner other) {
    _$v = other as _$AdminCityOfficeDtoOutputOfficeHoursInner;
  }

  @override
  void update(
    void Function(AdminCityOfficeDtoOutputOfficeHoursInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCityOfficeDtoOutputOfficeHoursInner build() => _build();

  _$AdminCityOfficeDtoOutputOfficeHoursInner _build() {
    final _$result =
        _$v ??
        _$AdminCityOfficeDtoOutputOfficeHoursInner._(
          weekday: BuiltValueNullFieldError.checkNotNull(
            weekday,
            r'AdminCityOfficeDtoOutputOfficeHoursInner',
            'weekday',
          ),
          opensAt: BuiltValueNullFieldError.checkNotNull(
            opensAt,
            r'AdminCityOfficeDtoOutputOfficeHoursInner',
            'opensAt',
          ),
          closesAt: BuiltValueNullFieldError.checkNotNull(
            closesAt,
            r'AdminCityOfficeDtoOutputOfficeHoursInner',
            'closesAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
