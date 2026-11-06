// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_quote_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerQuoteRequestDto extends CustomerQuoteRequestDto {
  @override
  final String restaurantId;
  @override
  final CustomerQuoteRequestDtoLocation location;
  @override
  final BuiltList<CustomerQuoteRequestDtoLinesInner> lines;
  @override
  final String? payIn;
  @override
  final String appVersion;

  factory _$CustomerQuoteRequestDto([
    void Function(CustomerQuoteRequestDtoBuilder)? updates,
  ]) => (CustomerQuoteRequestDtoBuilder()..update(updates))._build();

  _$CustomerQuoteRequestDto._({
    required this.restaurantId,
    required this.location,
    required this.lines,
    this.payIn,
    required this.appVersion,
  }) : super._();
  @override
  CustomerQuoteRequestDto rebuild(
    void Function(CustomerQuoteRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerQuoteRequestDtoBuilder toBuilder() =>
      CustomerQuoteRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerQuoteRequestDto &&
        restaurantId == other.restaurantId &&
        location == other.location &&
        lines == other.lines &&
        payIn == other.payIn &&
        appVersion == other.appVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, payIn.hashCode);
    _$hash = $jc(_$hash, appVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerQuoteRequestDto')
          ..add('restaurantId', restaurantId)
          ..add('location', location)
          ..add('lines', lines)
          ..add('payIn', payIn)
          ..add('appVersion', appVersion))
        .toString();
  }
}

class CustomerQuoteRequestDtoBuilder
    implements
        Builder<CustomerQuoteRequestDto, CustomerQuoteRequestDtoBuilder> {
  _$CustomerQuoteRequestDto? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  CustomerQuoteRequestDtoLocationBuilder? _location;
  CustomerQuoteRequestDtoLocationBuilder get location =>
      _$this._location ??= CustomerQuoteRequestDtoLocationBuilder();
  set location(CustomerQuoteRequestDtoLocationBuilder? location) =>
      _$this._location = location;

  ListBuilder<CustomerQuoteRequestDtoLinesInner>? _lines;
  ListBuilder<CustomerQuoteRequestDtoLinesInner> get lines =>
      _$this._lines ??= ListBuilder<CustomerQuoteRequestDtoLinesInner>();
  set lines(ListBuilder<CustomerQuoteRequestDtoLinesInner>? lines) =>
      _$this._lines = lines;

  String? _payIn;
  String? get payIn => _$this._payIn;
  set payIn(String? payIn) => _$this._payIn = payIn;

  String? _appVersion;
  String? get appVersion => _$this._appVersion;
  set appVersion(String? appVersion) => _$this._appVersion = appVersion;

  CustomerQuoteRequestDtoBuilder() {
    CustomerQuoteRequestDto._defaults(this);
  }

  CustomerQuoteRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _location = $v.location.toBuilder();
      _lines = $v.lines.toBuilder();
      _payIn = $v.payIn;
      _appVersion = $v.appVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerQuoteRequestDto other) {
    _$v = other as _$CustomerQuoteRequestDto;
  }

  @override
  void update(void Function(CustomerQuoteRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerQuoteRequestDto build() => _build();

  _$CustomerQuoteRequestDto _build() {
    _$CustomerQuoteRequestDto _$result;
    try {
      _$result =
          _$v ??
          _$CustomerQuoteRequestDto._(
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'CustomerQuoteRequestDto',
              'restaurantId',
            ),
            location: location.build(),
            lines: lines.build(),
            payIn: payIn,
            appVersion: BuiltValueNullFieldError.checkNotNull(
              appVersion,
              r'CustomerQuoteRequestDto',
              'appVersion',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
        _$failedField = 'lines';
        lines.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerQuoteRequestDto',
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
