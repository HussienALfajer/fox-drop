// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_suggestion_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerSuggestionDto extends CustomerSuggestionDto {
  @override
  final num latitude;
  @override
  final num longitude;
  @override
  final String restaurantName;
  @override
  final String? note;
  @override
  final String? query;

  factory _$CustomerSuggestionDto([
    void Function(CustomerSuggestionDtoBuilder)? updates,
  ]) => (CustomerSuggestionDtoBuilder()..update(updates))._build();

  _$CustomerSuggestionDto._({
    required this.latitude,
    required this.longitude,
    required this.restaurantName,
    this.note,
    this.query,
  }) : super._();
  @override
  CustomerSuggestionDto rebuild(
    void Function(CustomerSuggestionDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSuggestionDtoBuilder toBuilder() =>
      CustomerSuggestionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSuggestionDto &&
        latitude == other.latitude &&
        longitude == other.longitude &&
        restaurantName == other.restaurantName &&
        note == other.note &&
        query == other.query;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, query.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerSuggestionDto')
          ..add('latitude', latitude)
          ..add('longitude', longitude)
          ..add('restaurantName', restaurantName)
          ..add('note', note)
          ..add('query', query))
        .toString();
  }
}

class CustomerSuggestionDtoBuilder
    implements Builder<CustomerSuggestionDto, CustomerSuggestionDtoBuilder> {
  _$CustomerSuggestionDto? _$v;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _query;
  String? get query => _$this._query;
  set query(String? query) => _$this._query = query;

  CustomerSuggestionDtoBuilder() {
    CustomerSuggestionDto._defaults(this);
  }

  CustomerSuggestionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _restaurantName = $v.restaurantName;
      _note = $v.note;
      _query = $v.query;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSuggestionDto other) {
    _$v = other as _$CustomerSuggestionDto;
  }

  @override
  void update(void Function(CustomerSuggestionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSuggestionDto build() => _build();

  _$CustomerSuggestionDto _build() {
    final _$result =
        _$v ??
        _$CustomerSuggestionDto._(
          latitude: BuiltValueNullFieldError.checkNotNull(
            latitude,
            r'CustomerSuggestionDto',
            'latitude',
          ),
          longitude: BuiltValueNullFieldError.checkNotNull(
            longitude,
            r'CustomerSuggestionDto',
            'longitude',
          ),
          restaurantName: BuiltValueNullFieldError.checkNotNull(
            restaurantName,
            r'CustomerSuggestionDto',
            'restaurantName',
          ),
          note: note,
          query: query,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
