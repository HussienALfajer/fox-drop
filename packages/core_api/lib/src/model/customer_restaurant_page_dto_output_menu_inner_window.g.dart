// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_page_dto_output_menu_inner_window.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CustomerRestaurantPageDtoOutputMenuInnerWindow
    extends CustomerRestaurantPageDtoOutputMenuInnerWindow {
  @override
  final int startsAt;
  @override
  final int endsAt;

  factory _$CustomerRestaurantPageDtoOutputMenuInnerWindow([
    void Function(CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder)?
    updates,
  ]) =>
      (CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder()..update(updates))
          ._build();

  _$CustomerRestaurantPageDtoOutputMenuInnerWindow._({
    required this.startsAt,
    required this.endsAt,
  }) : super._();
  @override
  CustomerRestaurantPageDtoOutputMenuInnerWindow rebuild(
    void Function(CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder toBuilder() =>
      CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantPageDtoOutputMenuInnerWindow &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerRestaurantPageDtoOutputMenuInnerWindow',
          )
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt))
        .toString();
  }
}

class CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder
    implements
        Builder<
          CustomerRestaurantPageDtoOutputMenuInnerWindow,
          CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder
        > {
  _$CustomerRestaurantPageDtoOutputMenuInnerWindow? _$v;

  int? _startsAt;
  int? get startsAt => _$this._startsAt;
  set startsAt(int? startsAt) => _$this._startsAt = startsAt;

  int? _endsAt;
  int? get endsAt => _$this._endsAt;
  set endsAt(int? endsAt) => _$this._endsAt = endsAt;

  CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder() {
    CustomerRestaurantPageDtoOutputMenuInnerWindow._defaults(this);
  }

  CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRestaurantPageDtoOutputMenuInnerWindow other) {
    _$v = other as _$CustomerRestaurantPageDtoOutputMenuInnerWindow;
  }

  @override
  void update(
    void Function(CustomerRestaurantPageDtoOutputMenuInnerWindowBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantPageDtoOutputMenuInnerWindow build() => _build();

  _$CustomerRestaurantPageDtoOutputMenuInnerWindow _build() {
    final _$result =
        _$v ??
        _$CustomerRestaurantPageDtoOutputMenuInnerWindow._(
          startsAt: BuiltValueNullFieldError.checkNotNull(
            startsAt,
            r'CustomerRestaurantPageDtoOutputMenuInnerWindow',
            'startsAt',
          ),
          endsAt: BuiltValueNullFieldError.checkNotNull(
            endsAt,
            r'CustomerRestaurantPageDtoOutputMenuInnerWindow',
            'endsAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
