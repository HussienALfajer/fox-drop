// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_banners_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminBannersOrderDto extends AdminBannersOrderDto {
  @override
  final String cityId;
  @override
  final BuiltList<String> ids;

  factory _$AdminBannersOrderDto([
    void Function(AdminBannersOrderDtoBuilder)? updates,
  ]) => (AdminBannersOrderDtoBuilder()..update(updates))._build();

  _$AdminBannersOrderDto._({required this.cityId, required this.ids})
    : super._();
  @override
  AdminBannersOrderDto rebuild(
    void Function(AdminBannersOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBannersOrderDtoBuilder toBuilder() =>
      AdminBannersOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBannersOrderDto &&
        cityId == other.cityId &&
        ids == other.ids;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, ids.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBannersOrderDto')
          ..add('cityId', cityId)
          ..add('ids', ids))
        .toString();
  }
}

class AdminBannersOrderDtoBuilder
    implements Builder<AdminBannersOrderDto, AdminBannersOrderDtoBuilder> {
  _$AdminBannersOrderDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  ListBuilder<String>? _ids;
  ListBuilder<String> get ids => _$this._ids ??= ListBuilder<String>();
  set ids(ListBuilder<String>? ids) => _$this._ids = ids;

  AdminBannersOrderDtoBuilder() {
    AdminBannersOrderDto._defaults(this);
  }

  AdminBannersOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _ids = $v.ids.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBannersOrderDto other) {
    _$v = other as _$AdminBannersOrderDto;
  }

  @override
  void update(void Function(AdminBannersOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminBannersOrderDto build() => _build();

  _$AdminBannersOrderDto _build() {
    _$AdminBannersOrderDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminBannersOrderDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminBannersOrderDto',
              'cityId',
            ),
            ids: ids.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ids';
        ids.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminBannersOrderDto',
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
