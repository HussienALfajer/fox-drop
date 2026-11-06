// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'captain_current_offer_dto_output_offer_customer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CaptainCurrentOfferDtoOutputOfferCustomer
    extends CaptainCurrentOfferDtoOutputOfferCustomer {
  @override
  final String neighbourhood;
  @override
  final int tripMetres;

  factory _$CaptainCurrentOfferDtoOutputOfferCustomer([
    void Function(CaptainCurrentOfferDtoOutputOfferCustomerBuilder)? updates,
  ]) => (CaptainCurrentOfferDtoOutputOfferCustomerBuilder()..update(updates))
      ._build();

  _$CaptainCurrentOfferDtoOutputOfferCustomer._({
    required this.neighbourhood,
    required this.tripMetres,
  }) : super._();
  @override
  CaptainCurrentOfferDtoOutputOfferCustomer rebuild(
    void Function(CaptainCurrentOfferDtoOutputOfferCustomerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CaptainCurrentOfferDtoOutputOfferCustomerBuilder toBuilder() =>
      CaptainCurrentOfferDtoOutputOfferCustomerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CaptainCurrentOfferDtoOutputOfferCustomer &&
        neighbourhood == other.neighbourhood &&
        tripMetres == other.tripMetres;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, neighbourhood.hashCode);
    _$hash = $jc(_$hash, tripMetres.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CaptainCurrentOfferDtoOutputOfferCustomer',
          )
          ..add('neighbourhood', neighbourhood)
          ..add('tripMetres', tripMetres))
        .toString();
  }
}

class CaptainCurrentOfferDtoOutputOfferCustomerBuilder
    implements
        Builder<
          CaptainCurrentOfferDtoOutputOfferCustomer,
          CaptainCurrentOfferDtoOutputOfferCustomerBuilder
        > {
  _$CaptainCurrentOfferDtoOutputOfferCustomer? _$v;

  String? _neighbourhood;
  String? get neighbourhood => _$this._neighbourhood;
  set neighbourhood(String? neighbourhood) =>
      _$this._neighbourhood = neighbourhood;

  int? _tripMetres;
  int? get tripMetres => _$this._tripMetres;
  set tripMetres(int? tripMetres) => _$this._tripMetres = tripMetres;

  CaptainCurrentOfferDtoOutputOfferCustomerBuilder() {
    CaptainCurrentOfferDtoOutputOfferCustomer._defaults(this);
  }

  CaptainCurrentOfferDtoOutputOfferCustomerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _neighbourhood = $v.neighbourhood;
      _tripMetres = $v.tripMetres;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CaptainCurrentOfferDtoOutputOfferCustomer other) {
    _$v = other as _$CaptainCurrentOfferDtoOutputOfferCustomer;
  }

  @override
  void update(
    void Function(CaptainCurrentOfferDtoOutputOfferCustomerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CaptainCurrentOfferDtoOutputOfferCustomer build() => _build();

  _$CaptainCurrentOfferDtoOutputOfferCustomer _build() {
    final _$result =
        _$v ??
        _$CaptainCurrentOfferDtoOutputOfferCustomer._(
          neighbourhood: BuiltValueNullFieldError.checkNotNull(
            neighbourhood,
            r'CaptainCurrentOfferDtoOutputOfferCustomer',
            'neighbourhood',
          ),
          tripMetres: BuiltValueNullFieldError.checkNotNull(
            tripMetres,
            r'CaptainCurrentOfferDtoOutputOfferCustomer',
            'tripMetres',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
