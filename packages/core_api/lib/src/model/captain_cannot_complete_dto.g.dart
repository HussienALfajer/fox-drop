// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_cannot_complete_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCannotCompleteDto extends CaptainCannotCompleteDto {
  @override
  final CaptainArriveDtoLocation location;
  @override
  final String reason;
  @override
  final String? note;

  factory _$CaptainCannotCompleteDto([
    void Function(CaptainCannotCompleteDtoBuilder)? updates,
  ]) => (CaptainCannotCompleteDtoBuilder()..update(updates))._build();

  _$CaptainCannotCompleteDto._({
    required this.location,
    required this.reason,
    this.note,
  }) : super._();
  @override
  CaptainCannotCompleteDto rebuild(
    void Function(CaptainCannotCompleteDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCannotCompleteDtoBuilder toBuilder() =>
      CaptainCannotCompleteDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCannotCompleteDto &&
        location == other.location &&
        reason == other.reason &&
        note == other.note;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainCannotCompleteDto')
          ..add('location', location)
          ..add('reason', reason)
          ..add('note', note))
        .toString();
  }
}

class CaptainCannotCompleteDtoBuilder
    implements
        Builder<CaptainCannotCompleteDto, CaptainCannotCompleteDtoBuilder> {
  _$CaptainCannotCompleteDto? _$v;

  CaptainArriveDtoLocationBuilder? _location;
  CaptainArriveDtoLocationBuilder get location =>
      _$this._location ??= CaptainArriveDtoLocationBuilder();
  set location(CaptainArriveDtoLocationBuilder? location) =>
      _$this._location = location;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  CaptainCannotCompleteDtoBuilder() {
    CaptainCannotCompleteDto._defaults(this);
  }

  CaptainCannotCompleteDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _location = $v.location.toBuilder();
      _reason = $v.reason;
      _note = $v.note;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCannotCompleteDto other) {
    _$v = other as _$CaptainCannotCompleteDto;
  }

  @override
  void update(void Function(CaptainCannotCompleteDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCannotCompleteDto build() => _build();

  _$CaptainCannotCompleteDto _build() {
    _$CaptainCannotCompleteDto _$result;
    try {
      _$result =
          _$v ??
          _$CaptainCannotCompleteDto._(
            location: location.build(),
            reason: BuiltValueNullFieldError.checkNotNull(
              reason,
              r'CaptainCannotCompleteDto',
              'reason',
            ),
            note: note,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CaptainCannotCompleteDto',
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
