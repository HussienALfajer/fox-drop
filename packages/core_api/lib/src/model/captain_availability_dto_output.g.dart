// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_availability_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainAvailabilityDtoOutput extends CaptainAvailabilityDtoOutput {
  @override
  final CaptainAvailabilityDtoOutputAvailability availability;
  @override
  final CaptainAvailabilityDtoOutputCustody custody;

  factory _$CaptainAvailabilityDtoOutput([
    void Function(CaptainAvailabilityDtoOutputBuilder)? updates,
  ]) => (CaptainAvailabilityDtoOutputBuilder()..update(updates))._build();

  _$CaptainAvailabilityDtoOutput._({
    required this.availability,
    required this.custody,
  }) : super._();
  @override
  CaptainAvailabilityDtoOutput rebuild(
    void Function(CaptainAvailabilityDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainAvailabilityDtoOutputBuilder toBuilder() =>
      CaptainAvailabilityDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainAvailabilityDtoOutput &&
        availability == other.availability &&
        custody == other.custody;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, availability.hashCode);
    _$hash = $jc(_$hash, custody.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainAvailabilityDtoOutput')
          ..add('availability', availability)
          ..add('custody', custody))
        .toString();
  }
}

class CaptainAvailabilityDtoOutputBuilder
    implements
        Builder<
          CaptainAvailabilityDtoOutput,
          CaptainAvailabilityDtoOutputBuilder
        > {
  _$CaptainAvailabilityDtoOutput? _$v;

  CaptainAvailabilityDtoOutputAvailabilityBuilder? _availability;
  CaptainAvailabilityDtoOutputAvailabilityBuilder get availability =>
      _$this._availability ??=
          CaptainAvailabilityDtoOutputAvailabilityBuilder();
  set availability(
    CaptainAvailabilityDtoOutputAvailabilityBuilder? availability,
  ) => _$this._availability = availability;

  CaptainAvailabilityDtoOutputCustodyBuilder? _custody;
  CaptainAvailabilityDtoOutputCustodyBuilder get custody =>
      _$this._custody ??= CaptainAvailabilityDtoOutputCustodyBuilder();
  set custody(CaptainAvailabilityDtoOutputCustodyBuilder? custody) =>
      _$this._custody = custody;

  CaptainAvailabilityDtoOutputBuilder() {
    CaptainAvailabilityDtoOutput._defaults(this);
  }

  CaptainAvailabilityDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _availability = $v.availability.toBuilder();
      _custody = $v.custody.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainAvailabilityDtoOutput other) {
    _$v = other as _$CaptainAvailabilityDtoOutput;
  }

  @override
  void update(void Function(CaptainAvailabilityDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainAvailabilityDtoOutput build() => _build();

  _$CaptainAvailabilityDtoOutput _build() {
    _$CaptainAvailabilityDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$CaptainAvailabilityDtoOutput._(
            availability: availability.build(),
            custody: custody.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'availability';
        availability.build();
        _$failedField = 'custody';
        custody.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainAvailabilityDtoOutput',
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
