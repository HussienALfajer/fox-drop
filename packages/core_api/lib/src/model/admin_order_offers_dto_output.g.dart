// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_offers_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderOffersDtoOutput extends AdminOrderOffersDtoOutput {
  @override
  final BuiltList<AdminOrderOffersDtoOutputOffersInner> offers;

  factory _$AdminOrderOffersDtoOutput([
    void Function(AdminOrderOffersDtoOutputBuilder)? updates,
  ]) => (AdminOrderOffersDtoOutputBuilder()..update(updates))._build();

  _$AdminOrderOffersDtoOutput._({required this.offers}) : super._();
  @override
  AdminOrderOffersDtoOutput rebuild(
    void Function(AdminOrderOffersDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderOffersDtoOutputBuilder toBuilder() =>
      AdminOrderOffersDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderOffersDtoOutput && offers == other.offers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, offers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminOrderOffersDtoOutput',
    )..add('offers', offers)).toString();
  }
}

class AdminOrderOffersDtoOutputBuilder
    implements
        Builder<AdminOrderOffersDtoOutput, AdminOrderOffersDtoOutputBuilder> {
  _$AdminOrderOffersDtoOutput? _$v;

  ListBuilder<AdminOrderOffersDtoOutputOffersInner>? _offers;
  ListBuilder<AdminOrderOffersDtoOutputOffersInner> get offers =>
      _$this._offers ??= ListBuilder<AdminOrderOffersDtoOutputOffersInner>();
  set offers(ListBuilder<AdminOrderOffersDtoOutputOffersInner>? offers) =>
      _$this._offers = offers;

  AdminOrderOffersDtoOutputBuilder() {
    AdminOrderOffersDtoOutput._defaults(this);
  }

  AdminOrderOffersDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _offers = $v.offers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderOffersDtoOutput other) {
    _$v = other as _$AdminOrderOffersDtoOutput;
  }

  @override
  void update(void Function(AdminOrderOffersDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderOffersDtoOutput build() => _build();

  _$AdminOrderOffersDtoOutput _build() {
    _$AdminOrderOffersDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminOrderOffersDtoOutput._(offers: offers.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'offers';
        offers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderOffersDtoOutput',
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
