// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_application_personal_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainApplicationPersonalDto extends CaptainApplicationPersonalDto {
  @override
  final String fullName;
  @override
  final Date birthDate;
  @override
  final String zoneId;

  factory _$CaptainApplicationPersonalDto([
    void Function(CaptainApplicationPersonalDtoBuilder)? updates,
  ]) => (CaptainApplicationPersonalDtoBuilder()..update(updates))._build();

  _$CaptainApplicationPersonalDto._({
    required this.fullName,
    required this.birthDate,
    required this.zoneId,
  }) : super._();
  @override
  CaptainApplicationPersonalDto rebuild(
    void Function(CaptainApplicationPersonalDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainApplicationPersonalDtoBuilder toBuilder() =>
      CaptainApplicationPersonalDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainApplicationPersonalDto &&
        fullName == other.fullName &&
        birthDate == other.birthDate &&
        zoneId == other.zoneId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, birthDate.hashCode);
    _$hash = $jc(_$hash, zoneId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CaptainApplicationPersonalDto')
          ..add('fullName', fullName)
          ..add('birthDate', birthDate)
          ..add('zoneId', zoneId))
        .toString();
  }
}

class CaptainApplicationPersonalDtoBuilder
    implements
        Builder<
          CaptainApplicationPersonalDto,
          CaptainApplicationPersonalDtoBuilder
        > {
  _$CaptainApplicationPersonalDto? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  Date? _birthDate;
  Date? get birthDate => _$this._birthDate;
  set birthDate(Date? birthDate) => _$this._birthDate = birthDate;

  String? _zoneId;
  String? get zoneId => _$this._zoneId;
  set zoneId(String? zoneId) => _$this._zoneId = zoneId;

  CaptainApplicationPersonalDtoBuilder() {
    CaptainApplicationPersonalDto._defaults(this);
  }

  CaptainApplicationPersonalDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _birthDate = $v.birthDate;
      _zoneId = $v.zoneId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainApplicationPersonalDto other) {
    _$v = other as _$CaptainApplicationPersonalDto;
  }

  @override
  void update(void Function(CaptainApplicationPersonalDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CaptainApplicationPersonalDto build() => _build();

  _$CaptainApplicationPersonalDto _build() {
    final _$result =
        _$v ??
        _$CaptainApplicationPersonalDto._(
          fullName: BuiltValueNullFieldError.checkNotNull(
            fullName,
            r'CaptainApplicationPersonalDto',
            'fullName',
          ),
          birthDate: BuiltValueNullFieldError.checkNotNull(
            birthDate,
            r'CaptainApplicationPersonalDto',
            'birthDate',
          ),
          zoneId: BuiltValueNullFieldError.checkNotNull(
            zoneId,
            r'CaptainApplicationPersonalDto',
            'zoneId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
