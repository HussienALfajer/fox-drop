// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_option_group_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuOptionGroupDto extends AdminMenuOptionGroupDto {
  @override
  final String name;
  @override
  final int minChoices;
  @override
  final int maxChoices;

  factory _$AdminMenuOptionGroupDto([
    void Function(AdminMenuOptionGroupDtoBuilder)? updates,
  ]) => (AdminMenuOptionGroupDtoBuilder()..update(updates))._build();

  _$AdminMenuOptionGroupDto._({
    required this.name,
    required this.minChoices,
    required this.maxChoices,
  }) : super._();
  @override
  AdminMenuOptionGroupDto rebuild(
    void Function(AdminMenuOptionGroupDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuOptionGroupDtoBuilder toBuilder() =>
      AdminMenuOptionGroupDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuOptionGroupDto &&
        name == other.name &&
        minChoices == other.minChoices &&
        maxChoices == other.maxChoices;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, minChoices.hashCode);
    _$hash = $jc(_$hash, maxChoices.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuOptionGroupDto')
          ..add('name', name)
          ..add('minChoices', minChoices)
          ..add('maxChoices', maxChoices))
        .toString();
  }
}

class AdminMenuOptionGroupDtoBuilder
    implements
        Builder<AdminMenuOptionGroupDto, AdminMenuOptionGroupDtoBuilder> {
  _$AdminMenuOptionGroupDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _minChoices;
  int? get minChoices => _$this._minChoices;
  set minChoices(int? minChoices) => _$this._minChoices = minChoices;

  int? _maxChoices;
  int? get maxChoices => _$this._maxChoices;
  set maxChoices(int? maxChoices) => _$this._maxChoices = maxChoices;

  AdminMenuOptionGroupDtoBuilder() {
    AdminMenuOptionGroupDto._defaults(this);
  }

  AdminMenuOptionGroupDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _minChoices = $v.minChoices;
      _maxChoices = $v.maxChoices;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuOptionGroupDto other) {
    _$v = other as _$AdminMenuOptionGroupDto;
  }

  @override
  void update(void Function(AdminMenuOptionGroupDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuOptionGroupDto build() => _build();

  _$AdminMenuOptionGroupDto _build() {
    final _$result =
        _$v ??
        _$AdminMenuOptionGroupDto._(
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminMenuOptionGroupDto',
            'name',
          ),
          minChoices: BuiltValueNullFieldError.checkNotNull(
            minChoices,
            r'AdminMenuOptionGroupDto',
            'minChoices',
          ),
          maxChoices: BuiltValueNullFieldError.checkNotNull(
            maxChoices,
            r'AdminMenuOptionGroupDto',
            'maxChoices',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
