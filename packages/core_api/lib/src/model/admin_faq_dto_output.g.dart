// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_faq_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminFaqDtoOutput extends AdminFaqDtoOutput {
  @override
  final BuiltList<AdminFaqsDtoOutputCustomerInner> items;

  factory _$AdminFaqDtoOutput([
    void Function(AdminFaqDtoOutputBuilder)? updates,
  ]) => (AdminFaqDtoOutputBuilder()..update(updates))._build();

  _$AdminFaqDtoOutput._({required this.items}) : super._();
  @override
  AdminFaqDtoOutput rebuild(void Function(AdminFaqDtoOutputBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminFaqDtoOutputBuilder toBuilder() =>
      AdminFaqDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminFaqDtoOutput && items == other.items;
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
      r'AdminFaqDtoOutput',
    )..add('items', items)).toString();
  }
}

class AdminFaqDtoOutputBuilder
    implements Builder<AdminFaqDtoOutput, AdminFaqDtoOutputBuilder> {
  _$AdminFaqDtoOutput? _$v;

  ListBuilder<AdminFaqsDtoOutputCustomerInner>? _items;
  ListBuilder<AdminFaqsDtoOutputCustomerInner> get items =>
      _$this._items ??= ListBuilder<AdminFaqsDtoOutputCustomerInner>();
  set items(ListBuilder<AdminFaqsDtoOutputCustomerInner>? items) =>
      _$this._items = items;

  AdminFaqDtoOutputBuilder() {
    AdminFaqDtoOutput._defaults(this);
  }

  AdminFaqDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminFaqDtoOutput other) {
    _$v = other as _$AdminFaqDtoOutput;
  }

  @override
  void update(void Function(AdminFaqDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminFaqDtoOutput build() => _build();

  _$AdminFaqDtoOutput _build() {
    _$AdminFaqDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminFaqDtoOutput._(items: items.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminFaqDtoOutput',
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
