// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_edit_choices_items_inner_option_groups_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner
    extends AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final int minChoices;
  @override
  final int maxChoices;
  @override
  final BuiltList<CustomerQuoteDtoOutputLinesInnerOptionsInner> options;

  factory _$AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner([
    void Function(
      AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInnerBuilder,
    )?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner._({
    required this.id,
    required this.name,
    required this.minChoices,
    required this.maxChoices,
    required this.options,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner rebuild(
    void Function(
      AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInnerBuilder
  toBuilder() =>
      AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner &&
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
            r'AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('minChoices', minChoices)
          ..add('maxChoices', maxChoices)
          ..add('options', options))
        .toString();
  }
}

class AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner,
          AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner? _$v;

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

  ListBuilder<CustomerQuoteDtoOutputLinesInnerOptionsInner>? _options;
  ListBuilder<CustomerQuoteDtoOutputLinesInnerOptionsInner> get options =>
      _$this._options ??=
          ListBuilder<CustomerQuoteDtoOutputLinesInnerOptionsInner>();
  set options(
    ListBuilder<CustomerQuoteDtoOutputLinesInnerOptionsInner>? options,
  ) => _$this._options = options;

  AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInnerBuilder() {
    AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner._defaults(
      this,
    );
  }

  AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInnerBuilder
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
    AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner other,
  ) {
    _$v =
        other
            as _$AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner;
  }

  @override
  void update(
    void Function(
      AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner build() =>
      _build();

  _$AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner _build() {
    _$AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner',
              'name',
            ),
            minChoices: BuiltValueNullFieldError.checkNotNull(
              minChoices,
              r'AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner',
              'minChoices',
            ),
            maxChoices: BuiltValueNullFieldError.checkNotNull(
              maxChoices,
              r'AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner',
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
          r'AdminOrderDtoOutputOrderEditChoicesItemsInnerOptionGroupsInner',
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
