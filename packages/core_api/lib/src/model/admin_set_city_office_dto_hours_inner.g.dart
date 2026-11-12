// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_city_office_dto_hours_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminSetCityOfficeDtoHoursInner
    extends AdminSetCityOfficeDtoHoursInner {
  @override
  final int weekday;
  @override
  final int opensAt;
  @override
  final int closesAt;

  factory _$AdminSetCityOfficeDtoHoursInner([
    void Function(AdminSetCityOfficeDtoHoursInnerBuilder)? updates,
  ]) => (AdminSetCityOfficeDtoHoursInnerBuilder()..update(updates))._build();

  _$AdminSetCityOfficeDtoHoursInner._({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  }) : super._();
  @override
  AdminSetCityOfficeDtoHoursInner rebuild(
    void Function(AdminSetCityOfficeDtoHoursInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetCityOfficeDtoHoursInnerBuilder toBuilder() =>
      AdminSetCityOfficeDtoHoursInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetCityOfficeDtoHoursInner &&
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
    return (newBuiltValueToStringHelper(r'AdminSetCityOfficeDtoHoursInner')
          ..add('weekday', weekday)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class AdminSetCityOfficeDtoHoursInnerBuilder
    implements
        Builder<
          AdminSetCityOfficeDtoHoursInner,
          AdminSetCityOfficeDtoHoursInnerBuilder
        > {
  _$AdminSetCityOfficeDtoHoursInner? _$v;

  int? _weekday;
  int? get weekday => _$this._weekday;
  set weekday(int? weekday) => _$this._weekday = weekday;

  int? _opensAt;
  int? get opensAt => _$this._opensAt;
  set opensAt(int? opensAt) => _$this._opensAt = opensAt;

  int? _closesAt;
  int? get closesAt => _$this._closesAt;
  set closesAt(int? closesAt) => _$this._closesAt = closesAt;

  AdminSetCityOfficeDtoHoursInnerBuilder() {
    AdminSetCityOfficeDtoHoursInner._defaults(this);
  }

  AdminSetCityOfficeDtoHoursInnerBuilder get _$this {
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
  void replace(AdminSetCityOfficeDtoHoursInner other) {
    _$v = other as _$AdminSetCityOfficeDtoHoursInner;
  }

  @override
  void update(void Function(AdminSetCityOfficeDtoHoursInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetCityOfficeDtoHoursInner build() => _build();

  _$AdminSetCityOfficeDtoHoursInner _build() {
    final _$result =
        _$v ??
        _$AdminSetCityOfficeDtoHoursInner._(
          weekday: BuiltValueNullFieldError.checkNotNull(
            weekday,
            r'AdminSetCityOfficeDtoHoursInner',
            'weekday',
          ),
          opensAt: BuiltValueNullFieldError.checkNotNull(
            opensAt,
            r'AdminSetCityOfficeDtoHoursInner',
            'opensAt',
          ),
          closesAt: BuiltValueNullFieldError.checkNotNull(
            closesAt,
            r'AdminSetCityOfficeDtoHoursInner',
            'closesAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
