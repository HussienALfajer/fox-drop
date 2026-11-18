// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_sort_weight_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantSortWeightDto extends AdminRestaurantSortWeightDto {
  @override
  final int sortWeight;

  factory _$AdminRestaurantSortWeightDto([
    void Function(AdminRestaurantSortWeightDtoBuilder)? updates,
  ]) => (AdminRestaurantSortWeightDtoBuilder()..update(updates))._build();

  _$AdminRestaurantSortWeightDto._({required this.sortWeight}) : super._();
  @override
  AdminRestaurantSortWeightDto rebuild(
    void Function(AdminRestaurantSortWeightDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantSortWeightDtoBuilder toBuilder() =>
      AdminRestaurantSortWeightDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantSortWeightDto &&
        sortWeight == other.sortWeight;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, sortWeight.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminRestaurantSortWeightDto',
    )..add('sortWeight', sortWeight)).toString();
  }
}

class AdminRestaurantSortWeightDtoBuilder
    implements
        Builder<
          AdminRestaurantSortWeightDto,
          AdminRestaurantSortWeightDtoBuilder
        > {
  _$AdminRestaurantSortWeightDto? _$v;

  int? _sortWeight;
  int? get sortWeight => _$this._sortWeight;
  set sortWeight(int? sortWeight) => _$this._sortWeight = sortWeight;

  AdminRestaurantSortWeightDtoBuilder() {
    AdminRestaurantSortWeightDto._defaults(this);
  }

  AdminRestaurantSortWeightDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _sortWeight = $v.sortWeight;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantSortWeightDto other) {
    _$v = other as _$AdminRestaurantSortWeightDto;
  }

  @override
  void update(void Function(AdminRestaurantSortWeightDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantSortWeightDto build() => _build();

  _$AdminRestaurantSortWeightDto _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantSortWeightDto._(
          sortWeight: BuiltValueNullFieldError.checkNotNull(
            sortWeight,
            r'AdminRestaurantSortWeightDto',
            'sortWeight',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
