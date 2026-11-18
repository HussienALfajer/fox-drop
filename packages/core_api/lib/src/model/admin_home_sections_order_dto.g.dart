// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_home_sections_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminHomeSectionsOrderDto extends AdminHomeSectionsOrderDto {
  @override
  final String cityId;
  @override
  final BuiltList<String> keys;

  factory _$AdminHomeSectionsOrderDto([
    void Function(AdminHomeSectionsOrderDtoBuilder)? updates,
  ]) => (AdminHomeSectionsOrderDtoBuilder()..update(updates))._build();

  _$AdminHomeSectionsOrderDto._({required this.cityId, required this.keys})
    : super._();
  @override
  AdminHomeSectionsOrderDto rebuild(
    void Function(AdminHomeSectionsOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHomeSectionsOrderDtoBuilder toBuilder() =>
      AdminHomeSectionsOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHomeSectionsOrderDto &&
        cityId == other.cityId &&
        keys == other.keys;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, keys.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminHomeSectionsOrderDto')
          ..add('cityId', cityId)
          ..add('keys', keys))
        .toString();
  }
}

class AdminHomeSectionsOrderDtoBuilder
    implements
        Builder<AdminHomeSectionsOrderDto, AdminHomeSectionsOrderDtoBuilder> {
  _$AdminHomeSectionsOrderDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  ListBuilder<String>? _keys;
  ListBuilder<String> get keys => _$this._keys ??= ListBuilder<String>();
  set keys(ListBuilder<String>? keys) => _$this._keys = keys;

  AdminHomeSectionsOrderDtoBuilder() {
    AdminHomeSectionsOrderDto._defaults(this);
  }

  AdminHomeSectionsOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _keys = $v.keys.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHomeSectionsOrderDto other) {
    _$v = other as _$AdminHomeSectionsOrderDto;
  }

  @override
  void update(void Function(AdminHomeSectionsOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminHomeSectionsOrderDto build() => _build();

  _$AdminHomeSectionsOrderDto _build() {
    _$AdminHomeSectionsOrderDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminHomeSectionsOrderDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminHomeSectionsOrderDto',
              'cityId',
            ),
            keys: keys.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'keys';
        keys.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminHomeSectionsOrderDto',
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
