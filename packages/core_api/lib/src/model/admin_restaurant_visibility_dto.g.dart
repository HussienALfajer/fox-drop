// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_visibility_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantVisibilityDto extends AdminRestaurantVisibilityDto {
  @override
  final bool visible;

  factory _$AdminRestaurantVisibilityDto([
    void Function(AdminRestaurantVisibilityDtoBuilder)? updates,
  ]) => (AdminRestaurantVisibilityDtoBuilder()..update(updates))._build();

  _$AdminRestaurantVisibilityDto._({required this.visible}) : super._();
  @override
  AdminRestaurantVisibilityDto rebuild(
    void Function(AdminRestaurantVisibilityDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantVisibilityDtoBuilder toBuilder() =>
      AdminRestaurantVisibilityDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantVisibilityDto && visible == other.visible;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, visible.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRestaurantVisibilityDto',
    )..add('visible', visible)).toString();
  }
}

class AdminRestaurantVisibilityDtoBuilder
    implements
        Builder<
          AdminRestaurantVisibilityDto,
          AdminRestaurantVisibilityDtoBuilder
        > {
  _$AdminRestaurantVisibilityDto? _$v;

  bool? _visible;
  bool? get visible => _$this._visible;
  set visible(bool? visible) => _$this._visible = visible;

  AdminRestaurantVisibilityDtoBuilder() {
    AdminRestaurantVisibilityDto._defaults(this);
  }

  AdminRestaurantVisibilityDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _visible = $v.visible;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantVisibilityDto other) {
    _$v = other as _$AdminRestaurantVisibilityDto;
  }

  @override
  void update(void Function(AdminRestaurantVisibilityDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantVisibilityDto build() => _build();

  _$AdminRestaurantVisibilityDto _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantVisibilityDto._(
          visible: BuiltValueNullFieldError.checkNotNull(
            visible,
            r'AdminRestaurantVisibilityDto',
            'visible',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
