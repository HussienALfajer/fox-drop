// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_assign_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminAssignDto extends AdminAssignDto {
  @override
  final String captainId;

  factory _$AdminAssignDto([void Function(AdminAssignDtoBuilder)? updates]) =>
      (AdminAssignDtoBuilder()..update(updates))._build();

  _$AdminAssignDto._({required this.captainId}) : super._();
  @override
  AdminAssignDto rebuild(void Function(AdminAssignDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminAssignDtoBuilder toBuilder() => AdminAssignDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAssignDto && captainId == other.captainId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminAssignDto',
    )..add('captainId', captainId)).toString();
  }
}

class AdminAssignDtoBuilder
    implements Builder<AdminAssignDto, AdminAssignDtoBuilder> {
  _$AdminAssignDto? _$v;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  AdminAssignDtoBuilder() {
    AdminAssignDto._defaults(this);
  }

  AdminAssignDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _captainId = $v.captainId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAssignDto other) {
    _$v = other as _$AdminAssignDto;
  }

  @override
  void update(void Function(AdminAssignDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminAssignDto build() => _build();

  _$AdminAssignDto _build() {
    final _$result =
        _$v ??
        _$AdminAssignDto._(
          captainId: BuiltValueNullFieldError.checkNotNull(
            captainId,
            r'AdminAssignDto',
            'captainId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
