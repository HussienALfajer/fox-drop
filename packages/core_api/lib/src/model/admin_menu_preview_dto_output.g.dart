// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_preview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminMenuPreviewDtoOutput extends AdminMenuPreviewDtoOutput {
  @override
  final BuiltList<AdminMenuPreviewDtoOutputMenuInner> menu;

  factory _$AdminMenuPreviewDtoOutput([
    void Function(AdminMenuPreviewDtoOutputBuilder)? updates,
  ]) => (AdminMenuPreviewDtoOutputBuilder()..update(updates))._build();

  _$AdminMenuPreviewDtoOutput._({required this.menu}) : super._();
  @override
  AdminMenuPreviewDtoOutput rebuild(
    void Function(AdminMenuPreviewDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuPreviewDtoOutputBuilder toBuilder() =>
      AdminMenuPreviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuPreviewDtoOutput && menu == other.menu;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, menu.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminMenuPreviewDtoOutput',
    )..add('menu', menu)).toString();
  }
}

class AdminMenuPreviewDtoOutputBuilder
    implements
        Builder<AdminMenuPreviewDtoOutput, AdminMenuPreviewDtoOutputBuilder> {
  _$AdminMenuPreviewDtoOutput? _$v;

  ListBuilder<AdminMenuPreviewDtoOutputMenuInner>? _menu;
  ListBuilder<AdminMenuPreviewDtoOutputMenuInner> get menu =>
      _$this._menu ??= ListBuilder<AdminMenuPreviewDtoOutputMenuInner>();
  set menu(ListBuilder<AdminMenuPreviewDtoOutputMenuInner>? menu) =>
      _$this._menu = menu;

  AdminMenuPreviewDtoOutputBuilder() {
    AdminMenuPreviewDtoOutput._defaults(this);
  }

  AdminMenuPreviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _menu = $v.menu.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuPreviewDtoOutput other) {
    _$v = other as _$AdminMenuPreviewDtoOutput;
  }

  @override
  void update(void Function(AdminMenuPreviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuPreviewDtoOutput build() => _build();

  _$AdminMenuPreviewDtoOutput _build() {
    _$AdminMenuPreviewDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminMenuPreviewDtoOutput._(menu: menu.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'menu';
        menu.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuPreviewDtoOutput',
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
