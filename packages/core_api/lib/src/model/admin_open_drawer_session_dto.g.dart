// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_open_drawer_session_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOpenDrawerSessionDto extends AdminOpenDrawerSessionDto {
  @override
  final String cityId;
  @override
  final BuiltList<AdminOpenDrawerSessionDtoFloatsInner> floats;

  factory _$AdminOpenDrawerSessionDto([
    void Function(AdminOpenDrawerSessionDtoBuilder)? updates,
  ]) => (AdminOpenDrawerSessionDtoBuilder()..update(updates))._build();

  _$AdminOpenDrawerSessionDto._({required this.cityId, required this.floats})
    : super._();
  @override
  AdminOpenDrawerSessionDto rebuild(
    void Function(AdminOpenDrawerSessionDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOpenDrawerSessionDtoBuilder toBuilder() =>
      AdminOpenDrawerSessionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOpenDrawerSessionDto &&
        cityId == other.cityId &&
        floats == other.floats;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, floats.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOpenDrawerSessionDto')
          ..add('cityId', cityId)
          ..add('floats', floats))
        .toString();
  }
}

class AdminOpenDrawerSessionDtoBuilder
    implements
        Builder<AdminOpenDrawerSessionDto, AdminOpenDrawerSessionDtoBuilder> {
  _$AdminOpenDrawerSessionDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>? _floats;
  ListBuilder<AdminOpenDrawerSessionDtoFloatsInner> get floats =>
      _$this._floats ??= ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>();
  set floats(ListBuilder<AdminOpenDrawerSessionDtoFloatsInner>? floats) =>
      _$this._floats = floats;

  AdminOpenDrawerSessionDtoBuilder() {
    AdminOpenDrawerSessionDto._defaults(this);
  }

  AdminOpenDrawerSessionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _floats = $v.floats.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOpenDrawerSessionDto other) {
    _$v = other as _$AdminOpenDrawerSessionDto;
  }

  @override
  void update(void Function(AdminOpenDrawerSessionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOpenDrawerSessionDto build() => _build();

  _$AdminOpenDrawerSessionDto _build() {
    _$AdminOpenDrawerSessionDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminOpenDrawerSessionDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminOpenDrawerSessionDto',
              'cityId',
            ),
            floats: floats.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'floats';
        floats.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOpenDrawerSessionDto',
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
