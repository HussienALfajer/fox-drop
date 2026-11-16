// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_approve_compensation_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminApproveCompensationDto extends AdminApproveCompensationDto {
  @override
  final String cityId;
  @override
  final AdminApproveCompensationDtoValue? value;

  factory _$AdminApproveCompensationDto([
    void Function(AdminApproveCompensationDtoBuilder)? updates,
  ]) => (AdminApproveCompensationDtoBuilder()..update(updates))._build();

  _$AdminApproveCompensationDto._({required this.cityId, this.value})
    : super._();
  @override
  AdminApproveCompensationDto rebuild(
    void Function(AdminApproveCompensationDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminApproveCompensationDtoBuilder toBuilder() =>
      AdminApproveCompensationDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminApproveCompensationDto &&
        cityId == other.cityId &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminApproveCompensationDto')
          ..add('cityId', cityId)
          ..add('value', value))
        .toString();
  }
}

class AdminApproveCompensationDtoBuilder
    implements
        Builder<
          AdminApproveCompensationDto,
          AdminApproveCompensationDtoBuilder
        > {
  _$AdminApproveCompensationDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminApproveCompensationDtoValueBuilder? _value;
  AdminApproveCompensationDtoValueBuilder get value =>
      _$this._value ??= AdminApproveCompensationDtoValueBuilder();
  set value(AdminApproveCompensationDtoValueBuilder? value) =>
      _$this._value = value;

  AdminApproveCompensationDtoBuilder() {
    AdminApproveCompensationDto._defaults(this);
  }

  AdminApproveCompensationDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _value = $v.value?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminApproveCompensationDto other) {
    _$v = other as _$AdminApproveCompensationDto;
  }

  @override
  void update(void Function(AdminApproveCompensationDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminApproveCompensationDto build() => _build();

  _$AdminApproveCompensationDto _build() {
    _$AdminApproveCompensationDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminApproveCompensationDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminApproveCompensationDto',
              'cityId',
            ),
            value: _value?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'value';
        _value?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminApproveCompensationDto',
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
