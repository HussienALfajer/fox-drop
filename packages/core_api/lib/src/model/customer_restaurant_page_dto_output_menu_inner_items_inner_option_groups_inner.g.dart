// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_page_dto_output_menu_inner_items_inner_option_groups_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner
    extends
        CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner {
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
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
  >
  options;

  factory _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner([
    void Function(
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerBuilder,
    )?
    updates,
  ]) =>
      (CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerBuilder()
            ..update(updates))
          ._build();

  _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner._({
    required this.id,
    required this.name,
    required this.minChoices,
    required this.maxChoices,
    required this.options,
  }) : super._();
  @override
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner rebuild(
    void Function(
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerBuilder
  toBuilder() =>
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner &&
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
            r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('minChoices', minChoices)
          ..add('maxChoices', maxChoices)
          ..add('options', options))
        .toString();
  }
}

class CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerBuilder
    implements
        Builder<
          CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner,
          CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerBuilder
        > {
  _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner? _$v;

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
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
  >?
  _options;
  ListBuilder<
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
  >
  get options => _$this._options ??=
      ListBuilder<
        CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
      >();
  set options(
    ListBuilder<
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerOptionsInner
    >?
    options,
  ) => _$this._options = options;

  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerBuilder() {
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner._defaults(
      this,
    );
  }

  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerBuilder
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
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner other,
  ) {
    _$v =
        other
            as _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner;
  }

  @override
  void update(
    void Function(
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner build() =>
      _build();

  _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner
  _build() {
    _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner
    _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner',
              'name',
            ),
            minChoices: BuiltValueNullFieldError.checkNotNull(
              minChoices,
              r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner',
              'minChoices',
            ),
            maxChoices: BuiltValueNullFieldError.checkNotNull(
              maxChoices,
              r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner',
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
          r'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner',
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
