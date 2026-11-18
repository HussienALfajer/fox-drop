// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_category_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCategoryOrderDto extends AdminCategoryOrderDto {
  @override
  final BuiltList<String> ids;

  factory _$AdminCategoryOrderDto([
    void Function(AdminCategoryOrderDtoBuilder)? updates,
  ]) => (AdminCategoryOrderDtoBuilder()..update(updates))._build();

  _$AdminCategoryOrderDto._({required this.ids}) : super._();
  @override
  AdminCategoryOrderDto rebuild(
    void Function(AdminCategoryOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCategoryOrderDtoBuilder toBuilder() =>
      AdminCategoryOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCategoryOrderDto && ids == other.ids;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ids.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminCategoryOrderDto',
    )..add('ids', ids)).toString();
  }
}

class AdminCategoryOrderDtoBuilder
    implements Builder<AdminCategoryOrderDto, AdminCategoryOrderDtoBuilder> {
  _$AdminCategoryOrderDto? _$v;

  ListBuilder<String>? _ids;
  ListBuilder<String> get ids => _$this._ids ??= ListBuilder<String>();
  set ids(ListBuilder<String>? ids) => _$this._ids = ids;

  AdminCategoryOrderDtoBuilder() {
    AdminCategoryOrderDto._defaults(this);
  }

  AdminCategoryOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ids = $v.ids.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCategoryOrderDto other) {
    _$v = other as _$AdminCategoryOrderDto;
  }

  @override
  void update(void Function(AdminCategoryOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCategoryOrderDto build() => _build();

  _$AdminCategoryOrderDto _build() {
    _$AdminCategoryOrderDto _$result;
    try {
      _$result = _$v ?? _$AdminCategoryOrderDto._(ids: ids.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'ids';
        ids.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCategoryOrderDto',
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
