// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_pickup_request_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainPickupRequestDto extends CaptainPickupRequestDto {
  @override
  final BuiltList<MerchantPickupDisputeDtoReceivedLinesInner> lines;
  @override
  final CaptainArriveDtoLocation location;

  factory _$CaptainPickupRequestDto([
    void Function(CaptainPickupRequestDtoBuilder)? updates,
  ]) => (CaptainPickupRequestDtoBuilder()..update(updates))._build();

  _$CaptainPickupRequestDto._({required this.lines, required this.location})
    : super._();
  @override
  CaptainPickupRequestDto rebuild(
    void Function(CaptainPickupRequestDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainPickupRequestDtoBuilder toBuilder() =>
      CaptainPickupRequestDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainPickupRequestDto &&
        lines == other.lines &&
        location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, lines.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainPickupRequestDto')
          ..add('lines', lines)
          ..add('location', location))
        .toString();
  }
}

class CaptainPickupRequestDtoBuilder
    implements
        Builder<CaptainPickupRequestDto, CaptainPickupRequestDtoBuilder> {
  _$CaptainPickupRequestDto? _$v;

  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? _lines;
  ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner> get lines =>
      _$this._lines ??=
          ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>();
  set lines(ListBuilder<MerchantPickupDisputeDtoReceivedLinesInner>? lines) =>
      _$this._lines = lines;

  CaptainArriveDtoLocationBuilder? _location;
  CaptainArriveDtoLocationBuilder get location =>
      _$this._location ??= CaptainArriveDtoLocationBuilder();
  set location(CaptainArriveDtoLocationBuilder? location) =>
      _$this._location = location;

  CaptainPickupRequestDtoBuilder() {
    CaptainPickupRequestDto._defaults(this);
  }

  CaptainPickupRequestDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _lines = $v.lines.toBuilder();
      _location = $v.location.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainPickupRequestDto other) {
    _$v = other as _$CaptainPickupRequestDto;
  }

  @override
  void update(void Function(CaptainPickupRequestDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainPickupRequestDto build() => _build();

  _$CaptainPickupRequestDto _build() {
    _$CaptainPickupRequestDto _$result;
    try {
      _$result =
          _$v ??
          _$CaptainPickupRequestDto._(
            lines: lines.build(),
            location: location.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lines';
        lines.build();
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainPickupRequestDto',
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
