// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_dto_output_option_groups_inner_options_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInner
    extends MerchantMenuDtoOutputOptionGroupsInnerOptionsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final MerchantMenuDtoOutputCategoriesInnerItemsInnerPrice priceDelta;
  @override
  final MerchantMenuDtoOutputCategoriesInnerSwitchedOff? switchedOff;
  @override
  final BuiltList<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>
  pending;

  factory _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInner([
    void Function(MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder)?
    updates,
  ]) =>
      (MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInner._({
    required this.id,
    required this.name,
    required this.priceDelta,
    this.switchedOff,
    required this.pending,
  }) : super._();
  @override
  MerchantMenuDtoOutputOptionGroupsInnerOptionsInner rebuild(
    void Function(MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder toBuilder() =>
      MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantMenuDtoOutputOptionGroupsInnerOptionsInner &&
        id == other.id &&
        name == other.name &&
        priceDelta == other.priceDelta &&
        switchedOff == other.switchedOff &&
        pending == other.pending;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, priceDelta.hashCode);
    _$hash = $jc(_$hash, switchedOff.hashCode);
    _$hash = $jc(_$hash, pending.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantMenuDtoOutputOptionGroupsInnerOptionsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('priceDelta', priceDelta)
          ..add('switchedOff', switchedOff)
          ..add('pending', pending))
        .toString();
  }
}

class MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder
    implements
        Builder<
          MerchantMenuDtoOutputOptionGroupsInnerOptionsInner,
          MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder
        > {
  _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder? _priceDelta;
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder get priceDelta =>
      _$this._priceDelta ??=
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder();
  set priceDelta(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPriceBuilder? priceDelta,
  ) => _$this._priceDelta = priceDelta;

  MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder? _switchedOff;
  MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder get switchedOff =>
      _$this._switchedOff ??=
          MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder();
  set switchedOff(
    MerchantMenuDtoOutputCategoriesInnerSwitchedOffBuilder? switchedOff,
  ) => _$this._switchedOff = switchedOff;

  ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>?
  _pending;
  ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>
  get pending => _$this._pending ??=
      ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>();
  set pending(
    ListBuilder<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner>?
    pending,
  ) => _$this._pending = pending;

  MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder() {
    MerchantMenuDtoOutputOptionGroupsInnerOptionsInner._defaults(this);
  }

  MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _priceDelta = $v.priceDelta.toBuilder();
      _switchedOff = $v.switchedOff?.toBuilder();
      _pending = $v.pending.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantMenuDtoOutputOptionGroupsInnerOptionsInner other) {
    _$v = other as _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInner;
  }

  @override
  void update(
    void Function(MerchantMenuDtoOutputOptionGroupsInnerOptionsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuDtoOutputOptionGroupsInnerOptionsInner build() => _build();

  _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInner _build() {
    _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantMenuDtoOutputOptionGroupsInnerOptionsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'MerchantMenuDtoOutputOptionGroupsInnerOptionsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'MerchantMenuDtoOutputOptionGroupsInnerOptionsInner',
              'name',
            ),
            priceDelta: priceDelta.build(),
            switchedOff: _switchedOff?.build(),
            pending: pending.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'priceDelta';
        priceDelta.build();
        _$failedField = 'switchedOff';
        _switchedOff?.build();
        _$failedField = 'pending';
        pending.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuDtoOutputOptionGroupsInnerOptionsInner',
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
