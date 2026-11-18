// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_home_section_visibility_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHomeSectionVisibilityDto extends AdminHomeSectionVisibilityDto {
  @override
  final String cityId;
  @override
  final String key;
  @override
  final bool visible;

  factory _$AdminHomeSectionVisibilityDto([
    void Function(AdminHomeSectionVisibilityDtoBuilder)? updates,
  ]) => (AdminHomeSectionVisibilityDtoBuilder()..update(updates))._build();

  _$AdminHomeSectionVisibilityDto._({
    required this.cityId,
    required this.key,
    required this.visible,
  }) : super._();
  @override
  AdminHomeSectionVisibilityDto rebuild(
    void Function(AdminHomeSectionVisibilityDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHomeSectionVisibilityDtoBuilder toBuilder() =>
      AdminHomeSectionVisibilityDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHomeSectionVisibilityDto &&
        cityId == other.cityId &&
        key == other.key &&
        visible == other.visible;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, visible.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminHomeSectionVisibilityDto')
          ..add('cityId', cityId)
          ..add('key', key)
          ..add('visible', visible))
        .toString();
  }
}

class AdminHomeSectionVisibilityDtoBuilder
    implements
        Builder<
          AdminHomeSectionVisibilityDto,
          AdminHomeSectionVisibilityDtoBuilder
        > {
  _$AdminHomeSectionVisibilityDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  bool? _visible;
  bool? get visible => _$this._visible;
  set visible(bool? visible) => _$this._visible = visible;

  AdminHomeSectionVisibilityDtoBuilder() {
    AdminHomeSectionVisibilityDto._defaults(this);
  }

  AdminHomeSectionVisibilityDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _key = $v.key;
      _visible = $v.visible;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHomeSectionVisibilityDto other) {
    _$v = other as _$AdminHomeSectionVisibilityDto;
  }

  @override
  void update(void Function(AdminHomeSectionVisibilityDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminHomeSectionVisibilityDto build() => _build();

  _$AdminHomeSectionVisibilityDto _build() {
    final _$result =
        _$v ??
        _$AdminHomeSectionVisibilityDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminHomeSectionVisibilityDto',
            'cityId',
          ),
          key: BuiltValueNullFieldError.checkNotNull(
            key,
            r'AdminHomeSectionVisibilityDto',
            'key',
          ),
          visible: BuiltValueNullFieldError.checkNotNull(
            visible,
            r'AdminHomeSectionVisibilityDto',
            'visible',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
