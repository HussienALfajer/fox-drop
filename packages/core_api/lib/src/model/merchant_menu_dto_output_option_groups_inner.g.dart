// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_dto_output_option_groups_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuDtoOutputOptionGroupsInner
    extends MerchantMenuDtoOutputOptionGroupsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final int minChoices;
  @override
  final int maxChoices;
  @override
  final BuiltList<String> itemIds;
  @override
  final BuiltList<MerchantMenuDtoOutputOptionGroupsInnerOptionsInner> options;
  @override
  final BuiltList<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>
  pending;

  factory _$MerchantMenuDtoOutputOptionGroupsInner([
    void Function(MerchantMenuDtoOutputOptionGroupsInnerBuilder)? updates,
  ]) => (MerchantMenuDtoOutputOptionGroupsInnerBuilder()..update(updates))
      ._build();

  _$MerchantMenuDtoOutputOptionGroupsInner._({
    required this.id,
    required this.name,
    required this.minChoices,
    required this.maxChoices,
    required this.itemIds,
    required this.options,
    required this.pending,
  }) : super._();
  @override
  MerchantMenuDtoOutputOptionGroupsInner rebuild(
    void Function(MerchantMenuDtoOutputOptionGroupsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuDtoOutputOptionGroupsInnerBuilder toBuilder() =>
      MerchantMenuDtoOutputOptionGroupsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuDtoOutputOptionGroupsInner &&
        id == other.id &&
        name == other.name &&
        minChoices == other.minChoices &&
        maxChoices == other.maxChoices &&
        itemIds == other.itemIds &&
        options == other.options &&
        pending == other.pending;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, minChoices.hashCode);
    _$hash = $jc(_$hash, maxChoices.hashCode);
    _$hash = $jc(_$hash, itemIds.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jc(_$hash, pending.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantMenuDtoOutputOptionGroupsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('minChoices', minChoices)
          ..add('maxChoices', maxChoices)
          ..add('itemIds', itemIds)
          ..add('options', options)
          ..add('pending', pending))
        .toString();
  }
}

class MerchantMenuDtoOutputOptionGroupsInnerBuilder
    implements
        Builder<
          MerchantMenuDtoOutputOptionGroupsInner,
          MerchantMenuDtoOutputOptionGroupsInnerBuilder
        > {
  _$MerchantMenuDtoOutputOptionGroupsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _minChoices;
  int? get minChoices => _$this._minChoices;
  set minChoices(int? minChoices) => _$this._minChoices = minChoices;

  int? _maxChoices;
  int? get maxChoices => _$this._maxChoices;
  set maxChoices(int? maxChoices) => _$this._maxChoices = maxChoices;

  ListBuilder<String>? _itemIds;
  ListBuilder<String> get itemIds => _$this._itemIds ??= ListBuilder<String>();
  set itemIds(ListBuilder<String>? itemIds) => _$this._itemIds = itemIds;

  ListBuilder<MerchantMenuDtoOutputOptionGroupsInnerOptionsInner>? _options;
  ListBuilder<MerchantMenuDtoOutputOptionGroupsInnerOptionsInner> get options =>
      _$this._options ??=
          ListBuilder<MerchantMenuDtoOutputOptionGroupsInnerOptionsInner>();
  set options(
    ListBuilder<MerchantMenuDtoOutputOptionGroupsInnerOptionsInner>? options,
  ) => _$this._options = options;

  ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>?
  _pending;
  ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>
  get pending => _$this._pending ??=
      ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>();
  set pending(
    ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>?
    pending,
  ) => _$this._pending = pending;

  MerchantMenuDtoOutputOptionGroupsInnerBuilder() {
    MerchantMenuDtoOutputOptionGroupsInner._defaults(this);
  }

  MerchantMenuDtoOutputOptionGroupsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _minChoices = $v.minChoices;
      _maxChoices = $v.maxChoices;
      _itemIds = $v.itemIds.toBuilder();
      _options = $v.options.toBuilder();
      _pending = $v.pending.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuDtoOutputOptionGroupsInner other) {
    _$v = other as _$MerchantMenuDtoOutputOptionGroupsInner;
  }

  @override
  void update(
    void Function(MerchantMenuDtoOutputOptionGroupsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuDtoOutputOptionGroupsInner build() => _build();

  _$MerchantMenuDtoOutputOptionGroupsInner _build() {
    _$MerchantMenuDtoOutputOptionGroupsInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantMenuDtoOutputOptionGroupsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantMenuDtoOutputOptionGroupsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantMenuDtoOutputOptionGroupsInner',
              'name',
            ),
            minChoices: BuiltValueNullFieldError.checkNotNull(
              minChoices,
              r'MerchantMenuDtoOutputOptionGroupsInner',
              'minChoices',
            ),
            maxChoices: BuiltValueNullFieldError.checkNotNull(
              maxChoices,
              r'MerchantMenuDtoOutputOptionGroupsInner',
              'maxChoices',
            ),
            itemIds: itemIds.build(),
            options: options.build(),
            pending: pending.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'itemIds';
        itemIds.build();
        _$failedField = 'options';
        options.build();
        _$failedField = 'pending';
        pending.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuDtoOutputOptionGroupsInner',
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
