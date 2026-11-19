// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_application_kit_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainApplicationKitDto extends AdminCaptainApplicationKitDto {
  @override
  final BuiltList<AdminCaptainApplicationKitDtoItemsInner> items;

  factory _$AdminCaptainApplicationKitDto([
    void Function(AdminCaptainApplicationKitDtoBuilder)? updates,
  ]) => (AdminCaptainApplicationKitDtoBuilder()..update(updates))._build();

  _$AdminCaptainApplicationKitDto._({required this.items}) : super._();
  @override
  AdminCaptainApplicationKitDto rebuild(
    void Function(AdminCaptainApplicationKitDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainApplicationKitDtoBuilder toBuilder() =>
      AdminCaptainApplicationKitDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainApplicationKitDto && items == other.items;
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
      r'AdminCaptainApplicationKitDto',
    )..add('items', items)).toString();
  }
}

class AdminCaptainApplicationKitDtoBuilder
    implements
        Builder<
          AdminCaptainApplicationKitDto,
          AdminCaptainApplicationKitDtoBuilder
        > {
  _$AdminCaptainApplicationKitDto? _$v;

  ListBuilder<AdminCaptainApplicationKitDtoItemsInner>? _items;
  ListBuilder<AdminCaptainApplicationKitDtoItemsInner> get items =>
      _$this._items ??= ListBuilder<AdminCaptainApplicationKitDtoItemsInner>();
  set items(ListBuilder<AdminCaptainApplicationKitDtoItemsInner>? items) =>
      _$this._items = items;

  AdminCaptainApplicationKitDtoBuilder() {
    AdminCaptainApplicationKitDto._defaults(this);
  }

  AdminCaptainApplicationKitDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainApplicationKitDto other) {
    _$v = other as _$AdminCaptainApplicationKitDto;
  }

  @override
  void update(void Function(AdminCaptainApplicationKitDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainApplicationKitDto build() => _build();

  _$AdminCaptainApplicationKitDto _build() {
    _$AdminCaptainApplicationKitDto _$result;
    try {
      _$result = _$v ?? _$AdminCaptainApplicationKitDto._(items: items.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainApplicationKitDto',
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
