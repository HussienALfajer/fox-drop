// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_search_dto_output_items_inner_option_groups_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerSearchDtoOutputItemsInnerOptionGroupsInner
    extends CustomerSearchDtoOutputItemsInnerOptionGroupsInner {
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
    CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner
  >
  options;

  factory _$CustomerSearchDtoOutputItemsInnerOptionGroupsInner([
    void Function(CustomerSearchDtoOutputItemsInnerOptionGroupsInnerBuilder)?
    updates,
  ]) =>
      (CustomerSearchDtoOutputItemsInnerOptionGroupsInnerBuilder()
            ..update(updates))
          ._build();

  _$CustomerSearchDtoOutputItemsInnerOptionGroupsInner._({
    required this.id,
    required this.name,
    required this.minChoices,
    required this.maxChoices,
    required this.options,
  }) : super._();
  @override
  CustomerSearchDtoOutputItemsInnerOptionGroupsInner rebuild(
    void Function(CustomerSearchDtoOutputItemsInnerOptionGroupsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSearchDtoOutputItemsInnerOptionGroupsInnerBuilder toBuilder() =>
      CustomerSearchDtoOutputItemsInnerOptionGroupsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSearchDtoOutputItemsInnerOptionGroupsInner &&
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
            r'CustomerSearchDtoOutputItemsInnerOptionGroupsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('minChoices', minChoices)
          ..add('maxChoices', maxChoices)
          ..add('options', options))
        .toString();
  }
}

class CustomerSearchDtoOutputItemsInnerOptionGroupsInnerBuilder
    implements
        Builder<
          CustomerSearchDtoOutputItemsInnerOptionGroupsInner,
          CustomerSearchDtoOutputItemsInnerOptionGroupsInnerBuilder
        > {
  _$CustomerSearchDtoOutputItemsInnerOptionGroupsInner? _$v;

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

  ListBuilder<CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner>?
  _options;
  ListBuilder<CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner>
  get options => _$this._options ??=
      ListBuilder<
        CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner
      >();
  set options(
    ListBuilder<CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner>?
    options,
  ) => _$this._options = options;

  CustomerSearchDtoOutputItemsInnerOptionGroupsInnerBuilder() {
    CustomerSearchDtoOutputItemsInnerOptionGroupsInner._defaults(this);
  }

  CustomerSearchDtoOutputItemsInnerOptionGroupsInnerBuilder get _$this {
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
  void replace(CustomerSearchDtoOutputItemsInnerOptionGroupsInner other) {
    _$v = other as _$CustomerSearchDtoOutputItemsInnerOptionGroupsInner;
  }

  @override
  void update(
    void Function(CustomerSearchDtoOutputItemsInnerOptionGroupsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSearchDtoOutputItemsInnerOptionGroupsInner build() => _build();

  _$CustomerSearchDtoOutputItemsInnerOptionGroupsInner _build() {
    _$CustomerSearchDtoOutputItemsInnerOptionGroupsInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerSearchDtoOutputItemsInnerOptionGroupsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerSearchDtoOutputItemsInnerOptionGroupsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CustomerSearchDtoOutputItemsInnerOptionGroupsInner',
              'name',
            ),
            minChoices: BuiltValueNullFieldError.checkNotNull(
              minChoices,
              r'CustomerSearchDtoOutputItemsInnerOptionGroupsInner',
              'minChoices',
            ),
            maxChoices: BuiltValueNullFieldError.checkNotNull(
              maxChoices,
              r'CustomerSearchDtoOutputItemsInnerOptionGroupsInner',
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
          r'CustomerSearchDtoOutputItemsInnerOptionGroupsInner',
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
