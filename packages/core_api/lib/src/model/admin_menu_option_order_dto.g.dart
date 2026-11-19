// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_option_order_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuOptionOrderDto extends AdminMenuOptionOrderDto {
  @override
  final BuiltList<String> optionIds;

  factory _$AdminMenuOptionOrderDto([
    void Function(AdminMenuOptionOrderDtoBuilder)? updates,
  ]) => (AdminMenuOptionOrderDtoBuilder()..update(updates))._build();

  _$AdminMenuOptionOrderDto._({required this.optionIds}) : super._();
  @override
  AdminMenuOptionOrderDto rebuild(
    void Function(AdminMenuOptionOrderDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuOptionOrderDtoBuilder toBuilder() =>
      AdminMenuOptionOrderDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuOptionOrderDto && optionIds == other.optionIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, optionIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminMenuOptionOrderDto',
    )..add('optionIds', optionIds)).toString();
  }
}

class AdminMenuOptionOrderDtoBuilder
    implements
        Builder<AdminMenuOptionOrderDto, AdminMenuOptionOrderDtoBuilder> {
  _$AdminMenuOptionOrderDto? _$v;

  ListBuilder<String>? _optionIds;
  ListBuilder<String> get optionIds =>
      _$this._optionIds ??= ListBuilder<String>();
  set optionIds(ListBuilder<String>? optionIds) =>
      _$this._optionIds = optionIds;

  AdminMenuOptionOrderDtoBuilder() {
    AdminMenuOptionOrderDto._defaults(this);
  }

  AdminMenuOptionOrderDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _optionIds = $v.optionIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuOptionOrderDto other) {
    _$v = other as _$AdminMenuOptionOrderDto;
  }

  @override
  void update(void Function(AdminMenuOptionOrderDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuOptionOrderDto build() => _build();

  _$AdminMenuOptionOrderDto _build() {
    _$AdminMenuOptionOrderDto _$result;
    try {
      _$result =
          _$v ?? _$AdminMenuOptionOrderDto._(optionIds: optionIds.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'optionIds';
        optionIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuOptionOrderDto',
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
