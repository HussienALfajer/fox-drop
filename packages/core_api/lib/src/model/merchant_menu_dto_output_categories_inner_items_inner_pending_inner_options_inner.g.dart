// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_dto_output_categories_inner_items_inner_pending_inner_options_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
    extends
        MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final MerchantPendingMoneyOutput priceDelta;

  factory _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner([
    void Function(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder,
    )?
    updates,
  ]) =>
      (MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner._({
    required this.id,
    required this.name,
    required this.priceDelta,
  }) : super._();
  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
  rebuild(
    void Function(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder
  toBuilder() =>
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner &&
        id == other.id &&
        name == other.name &&
        priceDelta == other.priceDelta;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, priceDelta.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('priceDelta', priceDelta))
        .toString();
  }
}

class MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder
    implements
        Builder<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner,
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder
        > {
  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantPendingMoneyOutputBuilder? _priceDelta;
  MerchantPendingMoneyOutputBuilder get priceDelta =>
      _$this._priceDelta ??= MerchantPendingMoneyOutputBuilder();
  set priceDelta(MerchantPendingMoneyOutputBuilder? priceDelta) =>
      _$this._priceDelta = priceDelta;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder() {
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner._defaults(
      this,
    );
  }

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder
  get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _priceDelta = $v.priceDelta.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
    other,
  ) {
    _$v =
        other
            as _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner;
  }

  @override
  void update(
    void Function(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
  build() => _build();

  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
  _build() {
    _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
    _$result;
    try {
      _$result =
          _$v ??
          _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner',
              'name',
            ),
            priceDelta: priceDelta.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'priceDelta';
        priceDelta.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner',
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
