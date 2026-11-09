// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_arrive_at_customer_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainArriveAtCustomerDto extends CaptainArriveAtCustomerDto {
  @override
  final CaptainArriveDtoLocation location;
  @override
  final CaptainArriveAtCustomerDtoAway? away;

  factory _$CaptainArriveAtCustomerDto([
    void Function(CaptainArriveAtCustomerDtoBuilder)? updates,
  ]) => (CaptainArriveAtCustomerDtoBuilder()..update(updates))._build();

  _$CaptainArriveAtCustomerDto._({required this.location, this.away})
    : super._();
  @override
  CaptainArriveAtCustomerDto rebuild(
    void Function(CaptainArriveAtCustomerDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainArriveAtCustomerDtoBuilder toBuilder() =>
      CaptainArriveAtCustomerDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainArriveAtCustomerDto &&
        location == other.location &&
        away == other.away;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, away.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainArriveAtCustomerDto')
          ..add('location', location)
          ..add('away', away))
        .toString();
  }
}

class CaptainArriveAtCustomerDtoBuilder
    implements
        Builder<CaptainArriveAtCustomerDto, CaptainArriveAtCustomerDtoBuilder> {
  _$CaptainArriveAtCustomerDto? _$v;

  CaptainArriveDtoLocationBuilder? _location;
  CaptainArriveDtoLocationBuilder get location =>
      _$this._location ??= CaptainArriveDtoLocationBuilder();
  set location(CaptainArriveDtoLocationBuilder? location) =>
      _$this._location = location;

  CaptainArriveAtCustomerDtoAwayBuilder? _away;
  CaptainArriveAtCustomerDtoAwayBuilder get away =>
      _$this._away ??= CaptainArriveAtCustomerDtoAwayBuilder();
  set away(CaptainArriveAtCustomerDtoAwayBuilder? away) => _$this._away = away;

  CaptainArriveAtCustomerDtoBuilder() {
    CaptainArriveAtCustomerDto._defaults(this);
  }

  CaptainArriveAtCustomerDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location.toBuilder();
      _away = $v.away?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainArriveAtCustomerDto other) {
    _$v = other as _$CaptainArriveAtCustomerDto;
  }

  @override
  void update(void Function(CaptainArriveAtCustomerDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainArriveAtCustomerDto build() => _build();

  _$CaptainArriveAtCustomerDto _build() {
    _$CaptainArriveAtCustomerDto _$result;
    try {
      _$result =
          _$v ??
          _$CaptainArriveAtCustomerDto._(
            location: location.build(),
            away: _away?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
        _$failedField = 'away';
        _away?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainArriveAtCustomerDto',
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
