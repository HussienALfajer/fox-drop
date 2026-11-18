// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_search_dto_output_items_inner_option_groups_inner_options_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner
    extends CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final CaptainAvailabilityDtoOutputCustodyLimit priceDelta;
  @override
  final bool available;

  factory _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner([
    void Function(
      CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder,
    )?
    updates,
  ]) =>
      (CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder()
            ..update(updates))
          ._build();

  _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner._({
    required this.id,
    required this.name,
    required this.priceDelta,
    required this.available,
  }) : super._();
  @override
  CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner rebuild(
    void Function(
      CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder
  toBuilder() =>
      CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner &&
        id == other.id &&
        name == other.name &&
        priceDelta == other.priceDelta &&
        available == other.available;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, priceDelta.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('priceDelta', priceDelta)
          ..add('available', available))
        .toString();
  }
}

class CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder
    implements
        Builder<
          CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner,
          CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder
        > {
  _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  CaptainAvailabilityDtoOutputCustodyLimitBuilder? _priceDelta;
  CaptainAvailabilityDtoOutputCustodyLimitBuilder get priceDelta =>
      _$this._priceDelta ??= CaptainAvailabilityDtoOutputCustodyLimitBuilder();
  set priceDelta(CaptainAvailabilityDtoOutputCustodyLimitBuilder? priceDelta) =>
      _$this._priceDelta = priceDelta;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder() {
    CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner._defaults(
      this,
    );
  }

  CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _priceDelta = $v.priceDelta.toBuilder();
      _available = $v.available;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner other,
  ) {
    _$v =
        other
            as _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner;
  }

  @override
  void update(
    void Function(
      CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner build() =>
      _build();

  _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner _build() {
    _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner',
              'name',
            ),
            priceDelta: priceDelta.build(),
            available: BuiltValueNullFieldError.checkNotNull(
              available,
              r'CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner',
              'available',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'priceDelta';
        priceDelta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerSearchDtoOutputItemsInnerOptionGroupsInnerOptionsInner',
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
