// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_orders_dto_output_orders_inner_customer.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MerchantOrdersDtoOutputOrdersInnerCustomer
    extends MerchantOrdersDtoOutputOrdersInnerCustomer {
  @override
  final String? firstName;
  @override
  final String neighbourhood;

  factory _$MerchantOrdersDtoOutputOrdersInnerCustomer([
    void Function(MerchantOrdersDtoOutputOrdersInnerCustomerBuilder)? updates,
  ]) => (MerchantOrdersDtoOutputOrdersInnerCustomerBuilder()..update(updates))
      ._build();

  _$MerchantOrdersDtoOutputOrdersInnerCustomer._({
    this.firstName,
    required this.neighbourhood,
  }) : super._();
  @override
  MerchantOrdersDtoOutputOrdersInnerCustomer rebuild(
    void Function(MerchantOrdersDtoOutputOrdersInnerCustomerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantOrdersDtoOutputOrdersInnerCustomerBuilder toBuilder() =>
      MerchantOrdersDtoOutputOrdersInnerCustomerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MerchantOrdersDtoOutputOrdersInnerCustomer &&
        firstName == other.firstName &&
        neighbourhood == other.neighbourhood;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, firstName.hashCode);
    _$hash = $jc(_$hash, neighbourhood.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantOrdersDtoOutputOrdersInnerCustomer',
          )
          ..add('firstName', firstName)
          ..add('neighbourhood', neighbourhood))
        .toString();
  }
}

class MerchantOrdersDtoOutputOrdersInnerCustomerBuilder
    implements
        Builder<
          MerchantOrdersDtoOutputOrdersInnerCustomer,
          MerchantOrdersDtoOutputOrdersInnerCustomerBuilder
        > {
  _$MerchantOrdersDtoOutputOrdersInnerCustomer? _$v;

  String? _firstName;
  String? get firstName => _$this._firstName;
  set firstName(String? firstName) => _$this._firstName = firstName;

  String? _neighbourhood;
  String? get neighbourhood => _$this._neighbourhood;
  set neighbourhood(String? neighbourhood) =>
      _$this._neighbourhood = neighbourhood;

  MerchantOrdersDtoOutputOrdersInnerCustomerBuilder() {
    MerchantOrdersDtoOutputOrdersInnerCustomer._defaults(this);
  }

  MerchantOrdersDtoOutputOrdersInnerCustomerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _firstName = $v.firstName;
      _neighbourhood = $v.neighbourhood;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MerchantOrdersDtoOutputOrdersInnerCustomer other) {
    _$v = other as _$MerchantOrdersDtoOutputOrdersInnerCustomer;
  }

  @override
  void update(
    void Function(MerchantOrdersDtoOutputOrdersInnerCustomerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantOrdersDtoOutputOrdersInnerCustomer build() => _build();

  _$MerchantOrdersDtoOutputOrdersInnerCustomer _build() {
    final _$result =
        _$v ??
        _$MerchantOrdersDtoOutputOrdersInnerCustomer._(
          firstName: firstName,
          neighbourhood: BuiltValueNullFieldError.checkNotNull(
            neighbourhood,
            r'MerchantOrdersDtoOutputOrdersInnerCustomer',
            'neighbourhood',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
