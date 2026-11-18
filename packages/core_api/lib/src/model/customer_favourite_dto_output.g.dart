// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_favourite_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerFavouriteDtoOutput extends CustomerFavouriteDtoOutput {
  @override
  final String restaurantId;
  @override
  final bool favourite;

  factory _$CustomerFavouriteDtoOutput([
    void Function(CustomerFavouriteDtoOutputBuilder)? updates,
  ]) => (CustomerFavouriteDtoOutputBuilder()..update(updates))._build();

  _$CustomerFavouriteDtoOutput._({
    required this.restaurantId,
    required this.favourite,
  }) : super._();
  @override
  CustomerFavouriteDtoOutput rebuild(
    void Function(CustomerFavouriteDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerFavouriteDtoOutputBuilder toBuilder() =>
      CustomerFavouriteDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerFavouriteDtoOutput &&
        restaurantId == other.restaurantId &&
        favourite == other.favourite;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, favourite.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerFavouriteDtoOutput')
          ..add('restaurantId', restaurantId)
          ..add('favourite', favourite))
        .toString();
  }
}

class CustomerFavouriteDtoOutputBuilder
    implements
        Builder<CustomerFavouriteDtoOutput, CustomerFavouriteDtoOutputBuilder> {
  _$CustomerFavouriteDtoOutput? _$v;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  bool? _favourite;
  bool? get favourite => _$this._favourite;
  set favourite(bool? favourite) => _$this._favourite = favourite;

  CustomerFavouriteDtoOutputBuilder() {
    CustomerFavouriteDtoOutput._defaults(this);
  }

  CustomerFavouriteDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurantId = $v.restaurantId;
      _favourite = $v.favourite;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerFavouriteDtoOutput other) {
    _$v = other as _$CustomerFavouriteDtoOutput;
  }

  @override
  void update(void Function(CustomerFavouriteDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerFavouriteDtoOutput build() => _build();

  _$CustomerFavouriteDtoOutput _build() {
    final _$result =
        _$v ??
        _$CustomerFavouriteDtoOutput._(
          restaurantId: BuiltValueNullFieldError.checkNotNull(
            restaurantId,
            r'CustomerFavouriteDtoOutput',
            'restaurantId',
          ),
          favourite: BuiltValueNullFieldError.checkNotNull(
            favourite,
            r'CustomerFavouriteDtoOutput',
            'favourite',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
