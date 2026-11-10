// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_current_offer_dto_output_offer_handover.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCurrentOfferDtoOutputOfferHandover
    extends CaptainCurrentOfferDtoOutputOfferHandover {
  @override
  final String fromCaptainName;
  @override
  final CaptainCurrentOfferDtoOutputOfferHandoverLocation? location;

  factory _$CaptainCurrentOfferDtoOutputOfferHandover([
    void Function(CaptainCurrentOfferDtoOutputOfferHandoverBuilder)? updates,
  ]) => (CaptainCurrentOfferDtoOutputOfferHandoverBuilder()..update(updates))
      ._build();

  _$CaptainCurrentOfferDtoOutputOfferHandover._({
    required this.fromCaptainName,
    this.location,
  }) : super._();
  @override
  CaptainCurrentOfferDtoOutputOfferHandover rebuild(
    void Function(CaptainCurrentOfferDtoOutputOfferHandoverBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCurrentOfferDtoOutputOfferHandoverBuilder toBuilder() =>
      CaptainCurrentOfferDtoOutputOfferHandoverBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCurrentOfferDtoOutputOfferHandover &&
        fromCaptainName == other.fromCaptainName &&
        location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fromCaptainName.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainCurrentOfferDtoOutputOfferHandover',
          )
          ..add('fromCaptainName', fromCaptainName)
          ..add('location', location))
        .toString();
  }
}

class CaptainCurrentOfferDtoOutputOfferHandoverBuilder
    implements
        Builder<
          CaptainCurrentOfferDtoOutputOfferHandover,
          CaptainCurrentOfferDtoOutputOfferHandoverBuilder
        > {
  _$CaptainCurrentOfferDtoOutputOfferHandover? _$v;

  String? _fromCaptainName;
  String? get fromCaptainName => _$this._fromCaptainName;
  set fromCaptainName(String? fromCaptainName) =>
      _$this._fromCaptainName = fromCaptainName;

  CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder? _location;
  CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder get location =>
      _$this._location ??=
          CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder();
  set location(
    CaptainCurrentOfferDtoOutputOfferHandoverLocationBuilder? location,
  ) => _$this._location = location;

  CaptainCurrentOfferDtoOutputOfferHandoverBuilder() {
    CaptainCurrentOfferDtoOutputOfferHandover._defaults(this);
  }

  CaptainCurrentOfferDtoOutputOfferHandoverBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fromCaptainName = $v.fromCaptainName;
      _location = $v.location?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCurrentOfferDtoOutputOfferHandover other) {
    _$v = other as _$CaptainCurrentOfferDtoOutputOfferHandover;
  }

  @override
  void update(
    void Function(CaptainCurrentOfferDtoOutputOfferHandoverBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCurrentOfferDtoOutputOfferHandover build() => _build();

  _$CaptainCurrentOfferDtoOutputOfferHandover _build() {
    _$CaptainCurrentOfferDtoOutputOfferHandover _$result;
    try {
      _$result =
          _$v ??
          _$CaptainCurrentOfferDtoOutputOfferHandover._(
            fromCaptainName: BuiltValueNullFieldError.checkNotNull(
              fromCaptainName,
              r'CaptainCurrentOfferDtoOutputOfferHandover',
              'fromCaptainName',
            ),
            location: _location?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        _location?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainCurrentOfferDtoOutputOfferHandover',
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
