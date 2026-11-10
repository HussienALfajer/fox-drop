// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_active_orders_dto_output_orders_inner_removed_lines_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner
    extends CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner {
  @override
  final String name;
  @override
  final int quantity;
  @override
  final BuiltList<
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
  >
  options;

  factory _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner([
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder,
    )?
    updates,
  ]) =>
      (CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder()
            ..update(updates))
          ._build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner._({
    required this.name,
    required this.quantity,
    required this.options,
  }) : super._();
  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner rebuild(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder
  toBuilder() =>
      CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner &&
        name == other.name &&
        quantity == other.quantity &&
        options == other.options;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, quantity.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner',
          )
          ..add('name', name)
          ..add('quantity', quantity)
          ..add('options', options))
        .toString();
  }
}

class CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder
    implements
        Builder<
          CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner,
          CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder
        > {
  _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  int? _quantity;
  int? get quantity => _$this._quantity;
  set quantity(int? quantity) => _$this._quantity = quantity;

  ListBuilder<
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
  >?
  _options;
  ListBuilder<
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
  >
  get options => _$this._options ??=
      ListBuilder<
        CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
      >();
  set options(
    ListBuilder<
      CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerOptionsInner
    >?
    options,
  ) => _$this._options = options;

  CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder() {
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner._defaults(this);
  }

  CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _quantity = $v.quantity;
      _options = $v.options.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner other,
  ) {
    _$v = other as _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner;
  }

  @override
  void update(
    void Function(
      CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner build() => _build();

  _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner _build() {
    _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner',
              'name',
            ),
            quantity: BuiltValueNullFieldError.checkNotNull(
              quantity,
              r'CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner',
              'quantity',
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
          r'CustomerActiveOrdersDtoOutputOrdersInnerRemovedLinesInner',
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
