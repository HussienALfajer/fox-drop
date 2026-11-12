// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output_office_hours_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainAvailabilityDtoOutputOfficeHoursInner
    extends CaptainAvailabilityDtoOutputOfficeHoursInner {
  @override
  final int weekday;
  @override
  final int opensAt;
  @override
  final int closesAt;

  factory _$CaptainAvailabilityDtoOutputOfficeHoursInner([
    void Function(CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder)? updates,
  ]) => (CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder()..update(updates))
      ._build();

  _$CaptainAvailabilityDtoOutputOfficeHoursInner._({
    required this.weekday,
    required this.opensAt,
    required this.closesAt,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutputOfficeHoursInner rebuild(
    void Function(CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder toBuilder() =>
      CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutputOfficeHoursInner &&
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
            r'CaptainAvailabilityDtoOutputOfficeHoursInner',
          )
          ..add('weekday', weekday)
          ..add('opensAt', opensAt)
          ..add('closesAt', closesAt))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder
    implements
        Builder<
          CaptainAvailabilityDtoOutputOfficeHoursInner,
          CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder
        > {
  _$CaptainAvailabilityDtoOutputOfficeHoursInner? _$v;

  int? _weekday;
  int? get weekday => _$this._weekday;
  set weekday(int? weekday) => _$this._weekday = weekday;

  int? _opensAt;
  int? get opensAt => _$this._opensAt;
  set opensAt(int? opensAt) => _$this._opensAt = opensAt;

  int? _closesAt;
  int? get closesAt => _$this._closesAt;
  set closesAt(int? closesAt) => _$this._closesAt = closesAt;

  CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder() {
    CaptainAvailabilityDtoOutputOfficeHoursInner._defaults(this);
  }

  CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder get _$this {
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
  void replace(CaptainAvailabilityDtoOutputOfficeHoursInner other) {
    _$v = other as _$CaptainAvailabilityDtoOutputOfficeHoursInner;
  }

  @override
  void update(
    void Function(CaptainAvailabilityDtoOutputOfficeHoursInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutputOfficeHoursInner build() => _build();

  _$CaptainAvailabilityDtoOutputOfficeHoursInner _build() {
    final _$result =
        _$v ??
        _$CaptainAvailabilityDtoOutputOfficeHoursInner._(
          weekday: BuiltValueNullFieldError.checkNotNull(
            weekday,
            r'CaptainAvailabilityDtoOutputOfficeHoursInner',
            'weekday',
          ),
          opensAt: BuiltValueNullFieldError.checkNotNull(
            opensAt,
            r'CaptainAvailabilityDtoOutputOfficeHoursInner',
            'opensAt',
          ),
          closesAt: BuiltValueNullFieldError.checkNotNull(
            closesAt,
            r'CaptainAvailabilityDtoOutputOfficeHoursInner',
            'closesAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
