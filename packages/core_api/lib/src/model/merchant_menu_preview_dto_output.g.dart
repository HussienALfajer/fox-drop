// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_preview_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuPreviewDtoOutput extends MerchantMenuPreviewDtoOutput {
  @override
  final BuiltList<MerchantMenuPreviewCategoryOutput> menu;

  factory _$MerchantMenuPreviewDtoOutput([
    void Function(MerchantMenuPreviewDtoOutputBuilder)? updates,
  ]) => (MerchantMenuPreviewDtoOutputBuilder()..update(updates))._build();

  _$MerchantMenuPreviewDtoOutput._({required this.menu}) : super._();
  @override
  MerchantMenuPreviewDtoOutput rebuild(
    void Function(MerchantMenuPreviewDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuPreviewDtoOutputBuilder toBuilder() =>
      MerchantMenuPreviewDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuPreviewDtoOutput && menu == other.menu;
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
      r'MerchantMenuPreviewDtoOutput',
    )..add('menu', menu)).toString();
  }
}

class MerchantMenuPreviewDtoOutputBuilder
    implements
        Builder<
          MerchantMenuPreviewDtoOutput,
          MerchantMenuPreviewDtoOutputBuilder
        > {
  _$MerchantMenuPreviewDtoOutput? _$v;

  ListBuilder<MerchantMenuPreviewCategoryOutput>? _menu;
  ListBuilder<MerchantMenuPreviewCategoryOutput> get menu =>
      _$this._menu ??= ListBuilder<MerchantMenuPreviewCategoryOutput>();
  set menu(ListBuilder<MerchantMenuPreviewCategoryOutput>? menu) =>
      _$this._menu = menu;

  MerchantMenuPreviewDtoOutputBuilder() {
    MerchantMenuPreviewDtoOutput._defaults(this);
  }

  MerchantMenuPreviewDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _menu = $v.menu.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuPreviewDtoOutput other) {
    _$v = other as _$MerchantMenuPreviewDtoOutput;
  }

  @override
  void update(void Function(MerchantMenuPreviewDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuPreviewDtoOutput build() => _build();

  _$MerchantMenuPreviewDtoOutput _build() {
    _$MerchantMenuPreviewDtoOutput _$result;
    try {
      _$result = _$v ?? _$MerchantMenuPreviewDtoOutput._(menu: menu.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'menu';
        menu.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuPreviewDtoOutput',
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
