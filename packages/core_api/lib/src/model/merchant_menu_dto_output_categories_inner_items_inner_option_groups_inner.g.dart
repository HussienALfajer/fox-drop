// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_dto_output_categories_inner_items_inner_option_groups_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner
    extends MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final int minChoices;
  @override
  final int maxChoices;
  @override
  final BuiltList<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
  >
  options;

  factory _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner([
    void Function(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder,
    )?
    updates,
  ]) =>
      (MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner._({
    required this.id,
    required this.name,
    required this.minChoices,
    required this.maxChoices,
    required this.options,
  }) : super._();
  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner rebuild(
    void Function(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder
  toBuilder() =>
      MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner &&
        id == other.id &&
        name == other.name &&
        minChoices == other.minChoices &&
        maxChoices == other.maxChoices &&
        options == other.options;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, minChoices.hashCode);
    _$hash = $jc(_$hash, maxChoices.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('minChoices', minChoices)
          ..add('maxChoices', maxChoices)
          ..add('options', options))
        .toString();
  }
}

class MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder
    implements
        Builder<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner,
          MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder
        > {
  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner? _$v;

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

  ListBuilder<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
  >?
  _options;
  ListBuilder<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
  >
  get options => _$this._options ??=
      ListBuilder<
        MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
      >();
  set options(
    ListBuilder<
      MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerOptionsInner
    >?
    options,
  ) => _$this._options = options;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder() {
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner._defaults(
      this,
    );
  }

  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _minChoices = $v.minChoices;
      _maxChoices = $v.maxChoices;
      _options = $v.options.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner other,
  ) {
    _$v =
        other
            as _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner;
  }

  @override
  void update(
    void Function(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner build() =>
      _build();

  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner _build() {
    _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner',
              'name',
            ),
            minChoices: BuiltValueNullFieldError.checkNotNull(
              minChoices,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner',
              'minChoices',
            ),
            maxChoices: BuiltValueNullFieldError.checkNotNull(
              maxChoices,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner',
              'maxChoices',
            ),
            options: options.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'options';
        options.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuDtoOutputCategoriesInnerItemsInnerOptionGroupsInner',
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
