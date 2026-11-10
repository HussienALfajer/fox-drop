// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_edit_choices.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderEditChoices
    extends AdminOrderDtoOutputOrderEditChoices {
  @override
  final bool afterPickup;
  @override
  final int extraPrepMaxMin;
  @override
  final BuiltList<AdminOrderDtoOutputOrderEditChoicesItemsInner> items;

  factory _$AdminOrderDtoOutputOrderEditChoices([
    void Function(AdminOrderDtoOutputOrderEditChoicesBuilder)? updates,
  ]) =>
      (AdminOrderDtoOutputOrderEditChoicesBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderEditChoices._({
    required this.afterPickup,
    required this.extraPrepMaxMin,
    required this.items,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderEditChoices rebuild(
    void Function(AdminOrderDtoOutputOrderEditChoicesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderEditChoicesBuilder toBuilder() =>
      AdminOrderDtoOutputOrderEditChoicesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderEditChoices &&
        afterPickup == other.afterPickup &&
        extraPrepMaxMin == other.extraPrepMaxMin &&
        items == other.items;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, afterPickup.hashCode);
    _$hash = $jc(_$hash, extraPrepMaxMin.hashCode);
    _$hash = $jc(_$hash, items.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderEditChoices')
          ..add('afterPickup', afterPickup)
          ..add('extraPrepMaxMin', extraPrepMaxMin)
          ..add('items', items))
        .toString();
  }
}

class AdminOrderDtoOutputOrderEditChoicesBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderEditChoices,
          AdminOrderDtoOutputOrderEditChoicesBuilder
        > {
  _$AdminOrderDtoOutputOrderEditChoices? _$v;

  bool? _afterPickup;
  bool? get afterPickup => _$this._afterPickup;
  set afterPickup(bool? afterPickup) => _$this._afterPickup = afterPickup;

  int? _extraPrepMaxMin;
  int? get extraPrepMaxMin => _$this._extraPrepMaxMin;
  set extraPrepMaxMin(int? extraPrepMaxMin) =>
      _$this._extraPrepMaxMin = extraPrepMaxMin;

  ListBuilder<AdminOrderDtoOutputOrderEditChoicesItemsInner>? _items;
  ListBuilder<AdminOrderDtoOutputOrderEditChoicesItemsInner> get items =>
      _$this._items ??=
          ListBuilder<AdminOrderDtoOutputOrderEditChoicesItemsInner>();
  set items(
    ListBuilder<AdminOrderDtoOutputOrderEditChoicesItemsInner>? items,
  ) => _$this._items = items;

  AdminOrderDtoOutputOrderEditChoicesBuilder() {
    AdminOrderDtoOutputOrderEditChoices._defaults(this);
  }

  AdminOrderDtoOutputOrderEditChoicesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _afterPickup = $v.afterPickup;
      _extraPrepMaxMin = $v.extraPrepMaxMin;
      _items = $v.items.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderEditChoices other) {
    _$v = other as _$AdminOrderDtoOutputOrderEditChoices;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderEditChoicesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderEditChoices build() => _build();

  _$AdminOrderDtoOutputOrderEditChoices _build() {
    _$AdminOrderDtoOutputOrderEditChoices _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderEditChoices._(
            afterPickup: BuiltValueNullFieldError.checkNotNull(
              afterPickup,
              r'AdminOrderDtoOutputOrderEditChoices',
              'afterPickup',
            ),
            extraPrepMaxMin: BuiltValueNullFieldError.checkNotNull(
              extraPrepMaxMin,
              r'AdminOrderDtoOutputOrderEditChoices',
              'extraPrepMaxMin',
            ),
            items: items.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'items';
        items.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderEditChoices',
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
