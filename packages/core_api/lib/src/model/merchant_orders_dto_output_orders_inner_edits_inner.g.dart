// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_edits_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputOrdersInnerEditsInner
    extends MerchantOrdersDtoOutputOrdersInnerEditsInner {
  @override
  final DateTime at;
  @override
  final bool addsItems;
  @override
  final BuiltList<MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner>
  changes;
  @override
  final String itemsValue;
  @override
  final int? extraPrepMin;

  factory _$MerchantOrdersDtoOutputOrdersInnerEditsInner([
    void Function(MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder)? updates,
  ]) => (MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder()..update(updates))
      ._build();

  _$MerchantOrdersDtoOutputOrdersInnerEditsInner._({
    required this.at,
    required this.addsItems,
    required this.changes,
    required this.itemsValue,
    this.extraPrepMin,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerEditsInner rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerEditsInner &&
        at == other.at &&
        addsItems == other.addsItems &&
        changes == other.changes &&
        itemsValue == other.itemsValue &&
        extraPrepMin == other.extraPrepMin;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, addsItems.hashCode);
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jc(_$hash, extraPrepMin.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerEditsInner',
          )
          ..add('at', at)
          ..add('addsItems', addsItems)
          ..add('changes', changes)
          ..add('itemsValue', itemsValue)
          ..add('extraPrepMin', extraPrepMin))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerEditsInner,
          MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerEditsInner? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  bool? _addsItems;
  bool? get addsItems => _$this._addsItems;
  set addsItems(bool? addsItems) => _$this._addsItems = addsItems;

  ListBuilder<MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner>?
  _changes;
  ListBuilder<MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner>
  get changes => _$this._changes ??=
      ListBuilder<MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner>();
  set changes(
    ListBuilder<MerchantOrdersDtoOutputOrdersInnerEditsInnerChangesInner>?
    changes,
  ) => _$this._changes = changes;

  String? _itemsValue;
  String? get itemsValue => _$this._itemsValue;
  set itemsValue(String? itemsValue) => _$this._itemsValue = itemsValue;

  int? _extraPrepMin;
  int? get extraPrepMin => _$this._extraPrepMin;
  set extraPrepMin(int? extraPrepMin) => _$this._extraPrepMin = extraPrepMin;

  MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder() {
    MerchantOrdersDtoOutputOrdersInnerEditsInner._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _addsItems = $v.addsItems;
      _changes = $v.changes.toBuilder();
      _itemsValue = $v.itemsValue;
      _extraPrepMin = $v.extraPrepMin;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerEditsInner other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerEditsInner;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerEditsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerEditsInner build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerEditsInner _build() {
    _$MerchantOrdersDtoOutputOrdersInnerEditsInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantOrdersDtoOutputOrdersInnerEditsInner._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'MerchantOrdersDtoOutputOrdersInnerEditsInner',
              'at',
            ),
            addsItems: BuiltValueNullFieldError.checkNotNull(
              addsItems,
              r'MerchantOrdersDtoOutputOrdersInnerEditsInner',
              'addsItems',
            ),
            changes: changes.build(),
            itemsValue: BuiltValueNullFieldError.checkNotNull(
              itemsValue,
              r'MerchantOrdersDtoOutputOrdersInnerEditsInner',
              'itemsValue',
            ),
            extraPrepMin: extraPrepMin,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'changes';
        changes.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantOrdersDtoOutputOrdersInnerEditsInner',
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
