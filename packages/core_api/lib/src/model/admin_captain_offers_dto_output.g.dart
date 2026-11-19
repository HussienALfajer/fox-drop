// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_offers_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminCaptainOffersDtoOutput extends AdminCaptainOffersDtoOutput {
  @override
  final BuiltList<AdminCaptainOffersDtoOutputOffersInner> offers;

  factory _$AdminCaptainOffersDtoOutput([
    void Function(AdminCaptainOffersDtoOutputBuilder)? updates,
  ]) => (AdminCaptainOffersDtoOutputBuilder()..update(updates))._build();

  _$AdminCaptainOffersDtoOutput._({required this.offers}) : super._();
  @override
  AdminCaptainOffersDtoOutput rebuild(
    void Function(AdminCaptainOffersDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainOffersDtoOutputBuilder toBuilder() =>
      AdminCaptainOffersDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainOffersDtoOutput && offers == other.offers;
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
      r'AdminCaptainOffersDtoOutput',
    )..add('offers', offers)).toString();
  }
}

class AdminCaptainOffersDtoOutputBuilder
    implements
        Builder<
          AdminCaptainOffersDtoOutput,
          AdminCaptainOffersDtoOutputBuilder
        > {
  _$AdminCaptainOffersDtoOutput? _$v;

  ListBuilder<AdminCaptainOffersDtoOutputOffersInner>? _offers;
  ListBuilder<AdminCaptainOffersDtoOutputOffersInner> get offers =>
      _$this._offers ??= ListBuilder<AdminCaptainOffersDtoOutputOffersInner>();
  set offers(ListBuilder<AdminCaptainOffersDtoOutputOffersInner>? offers) =>
      _$this._offers = offers;

  AdminCaptainOffersDtoOutputBuilder() {
    AdminCaptainOffersDtoOutput._defaults(this);
  }

  AdminCaptainOffersDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _offers = $v.offers.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainOffersDtoOutput other) {
    _$v = other as _$AdminCaptainOffersDtoOutput;
  }

  @override
  void update(void Function(AdminCaptainOffersDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainOffersDtoOutput build() => _build();

  _$AdminCaptainOffersDtoOutput _build() {
    _$AdminCaptainOffersDtoOutput _$result;
    try {
      _$result = _$v ?? _$AdminCaptainOffersDtoOutput._(offers: offers.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'offers';
        offers.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminCaptainOffersDtoOutput',
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
