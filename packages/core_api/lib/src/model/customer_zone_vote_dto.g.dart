// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_zone_vote_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerZoneVoteDto extends CustomerZoneVoteDto {
  @override
  final String deviceId;
  @override
  final CustomerZoneVoteDtoLocation location;

  factory _$CustomerZoneVoteDto([
    void Function(CustomerZoneVoteDtoBuilder)? updates,
  ]) => (CustomerZoneVoteDtoBuilder()..update(updates))._build();

  _$CustomerZoneVoteDto._({required this.deviceId, required this.location})
    : super._();
  @override
  CustomerZoneVoteDto rebuild(
    void Function(CustomerZoneVoteDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerZoneVoteDtoBuilder toBuilder() =>
      CustomerZoneVoteDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerZoneVoteDto &&
        deviceId == other.deviceId &&
        location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerZoneVoteDto')
          ..add('deviceId', deviceId)
          ..add('location', location))
        .toString();
  }
}

class CustomerZoneVoteDtoBuilder
    implements Builder<CustomerZoneVoteDto, CustomerZoneVoteDtoBuilder> {
  _$CustomerZoneVoteDto? _$v;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  CustomerZoneVoteDtoLocationBuilder? _location;
  CustomerZoneVoteDtoLocationBuilder get location =>
      _$this._location ??= CustomerZoneVoteDtoLocationBuilder();
  set location(CustomerZoneVoteDtoLocationBuilder? location) =>
      _$this._location = location;

  CustomerZoneVoteDtoBuilder() {
    CustomerZoneVoteDto._defaults(this);
  }

  CustomerZoneVoteDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _deviceId = $v.deviceId;
      _location = $v.location.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerZoneVoteDto other) {
    _$v = other as _$CustomerZoneVoteDto;
  }

  @override
  void update(void Function(CustomerZoneVoteDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerZoneVoteDto build() => _build();

  _$CustomerZoneVoteDto _build() {
    _$CustomerZoneVoteDto _$result;
    try {
      _$result =
          _$v ??
          _$CustomerZoneVoteDto._(
            deviceId: BuiltValueNullFieldError.checkNotNull(
              deviceId,
              r'CustomerZoneVoteDto',
              'deviceId',
            ),
            location: location.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerZoneVoteDto',
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
