// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_option_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuOptionDto extends AdminMenuOptionDto {
  @override
  final String name;
  @override
  final AdminMenuMoney priceDelta;
  @override
  final bool removed;

  factory _$AdminMenuOptionDto([
    void Function(AdminMenuOptionDtoBuilder)? updates,
  ]) => (AdminMenuOptionDtoBuilder()..update(updates))._build();

  _$AdminMenuOptionDto._({
    required this.name,
    required this.priceDelta,
    required this.removed,
  }) : super._();
  @override
  AdminMenuOptionDto rebuild(
    void Function(AdminMenuOptionDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuOptionDtoBuilder toBuilder() =>
      AdminMenuOptionDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuOptionDto &&
        name == other.name &&
        priceDelta == other.priceDelta &&
        removed == other.removed;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, priceDelta.hashCode);
    _$hash = $jc(_$hash, removed.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuOptionDto')
          ..add('name', name)
          ..add('priceDelta', priceDelta)
          ..add('removed', removed))
        .toString();
  }
}

class AdminMenuOptionDtoBuilder
    implements Builder<AdminMenuOptionDto, AdminMenuOptionDtoBuilder> {
  _$AdminMenuOptionDto? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminMenuMoneyBuilder? _priceDelta;
  AdminMenuMoneyBuilder get priceDelta =>
      _$this._priceDelta ??= AdminMenuMoneyBuilder();
  set priceDelta(AdminMenuMoneyBuilder? priceDelta) =>
      _$this._priceDelta = priceDelta;

  bool? _removed;
  bool? get removed => _$this._removed;
  set removed(bool? removed) => _$this._removed = removed;

  AdminMenuOptionDtoBuilder() {
    AdminMenuOptionDto._defaults(this);
  }

  AdminMenuOptionDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _priceDelta = $v.priceDelta.toBuilder();
      _removed = $v.removed;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuOptionDto other) {
    _$v = other as _$AdminMenuOptionDto;
  }

  @override
  void update(void Function(AdminMenuOptionDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuOptionDto build() => _build();

  _$AdminMenuOptionDto _build() {
    _$AdminMenuOptionDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuOptionDto._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminMenuOptionDto',
              'name',
            ),
            priceDelta: priceDelta.build(),
            removed: BuiltValueNullFieldError.checkNotNull(
              removed,
              r'AdminMenuOptionDto',
              'removed',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'priceDelta';
        priceDelta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuOptionDto',
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
