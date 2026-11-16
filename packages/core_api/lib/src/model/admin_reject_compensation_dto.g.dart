// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_reject_compensation_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRejectCompensationDto extends AdminRejectCompensationDto {
  @override
  final String cityId;

  factory _$AdminRejectCompensationDto([
    void Function(AdminRejectCompensationDtoBuilder)? updates,
  ]) => (AdminRejectCompensationDtoBuilder()..update(updates))._build();

  _$AdminRejectCompensationDto._({required this.cityId}) : super._();
  @override
  AdminRejectCompensationDto rebuild(
    void Function(AdminRejectCompensationDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRejectCompensationDtoBuilder toBuilder() =>
      AdminRejectCompensationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRejectCompensationDto && cityId == other.cityId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRejectCompensationDto',
    )..add('cityId', cityId)).toString();
  }
}

class AdminRejectCompensationDtoBuilder
    implements
        Builder<AdminRejectCompensationDto, AdminRejectCompensationDtoBuilder> {
  _$AdminRejectCompensationDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminRejectCompensationDtoBuilder() {
    AdminRejectCompensationDto._defaults(this);
  }

  AdminRejectCompensationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRejectCompensationDto other) {
    _$v = other as _$AdminRejectCompensationDto;
  }

  @override
  void update(void Function(AdminRejectCompensationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRejectCompensationDto build() => _build();

  _$AdminRejectCompensationDto _build() {
    final _$result =
        _$v ??
        _$AdminRejectCompensationDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminRejectCompensationDto',
            'cityId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
