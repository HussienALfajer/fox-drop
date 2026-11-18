// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_statement_restaurants_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminStatementRestaurantsDtoOutput
    extends AdminStatementRestaurantsDtoOutput {
  @override
  final BuiltList<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>
  restaurants;

  factory _$AdminStatementRestaurantsDtoOutput([
    void Function(AdminStatementRestaurantsDtoOutputBuilder)? updates,
  ]) => (AdminStatementRestaurantsDtoOutputBuilder()..update(updates))._build();

  _$AdminStatementRestaurantsDtoOutput._({required this.restaurants})
    : super._();
  @override
  AdminStatementRestaurantsDtoOutput rebuild(
    void Function(AdminStatementRestaurantsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminStatementRestaurantsDtoOutputBuilder toBuilder() =>
      AdminStatementRestaurantsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminStatementRestaurantsDtoOutput &&
        restaurants == other.restaurants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminStatementRestaurantsDtoOutput',
    )..add('restaurants', restaurants)).toString();
  }
}

class AdminStatementRestaurantsDtoOutputBuilder
    implements
        Builder<
          AdminStatementRestaurantsDtoOutput,
          AdminStatementRestaurantsDtoOutputBuilder
        > {
  _$AdminStatementRestaurantsDtoOutput? _$v;

  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>?
  _restaurants;
  ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>
  get restaurants => _$this._restaurants ??=
      ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>();
  set restaurants(
    ListBuilder<AdminRestaurantDraftChoicesDtoOutputCategoriesInner>?
    restaurants,
  ) => _$this._restaurants = restaurants;

  AdminStatementRestaurantsDtoOutputBuilder() {
    AdminStatementRestaurantsDtoOutput._defaults(this);
  }

  AdminStatementRestaurantsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _restaurants = $v.restaurants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminStatementRestaurantsDtoOutput other) {
    _$v = other as _$AdminStatementRestaurantsDtoOutput;
  }

  @override
  void update(
    void Function(AdminStatementRestaurantsDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminStatementRestaurantsDtoOutput build() => _build();

  _$AdminStatementRestaurantsDtoOutput _build() {
    _$AdminStatementRestaurantsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminStatementRestaurantsDtoOutput._(
            restaurants: restaurants.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurants';
        restaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminStatementRestaurantsDtoOutput',
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
