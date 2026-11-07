// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_faq_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminFaqDto extends AdminFaqDto {
  @override
  final BuiltList<AdminFaqDtoItemsInner> items;

  factory _$AdminFaqDto([void Function(AdminFaqDtoBuilder)? updates]) =>
      (AdminFaqDtoBuilder()..update(updates))._build();

  _$AdminFaqDto._({required this.items}) : super._();
  @override
  AdminFaqDto rebuild(void Function(AdminFaqDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminFaqDtoBuilder toBuilder() => AdminFaqDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminFaqDto && items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminFaqDto',
    )..add('items', items)).toString();
  }
}

class AdminFaqDtoBuilder implements Builder<AdminFaqDto, AdminFaqDtoBuilder> {
  _$AdminFaqDto? _$v;

  ListBuilder<AdminFaqDtoItemsInner>? _items;
  ListBuilder<AdminFaqDtoItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminFaqDtoItemsInner>();
  set items(ListBuilder<AdminFaqDtoItemsInner>? items) => _$this._items = items;

  AdminFaqDtoBuilder() {
    AdminFaqDto._defaults(this);
  }

  AdminFaqDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminFaqDto other) {
    _$v = other as _$AdminFaqDto;
  }

  @override
  void update(void Function(AdminFaqDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminFaqDto build() => _build();

  _$AdminFaqDto _build() {
    _$AdminFaqDto _$result;
    try {
      _$result = _$v ?? _$AdminFaqDto._(items: items.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminFaqDto',
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
