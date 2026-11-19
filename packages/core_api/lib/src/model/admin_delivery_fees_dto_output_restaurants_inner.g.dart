// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_delivery_fees_dto_output_restaurants_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminDeliveryFeesDtoOutputRestaurantsInner
    extends AdminDeliveryFeesDtoOutputRestaurantsInner {
  @override
  final String id;
  @override
  final String nameAr;
  @override
  final AdminDeliveryFeesDtoOutputRestaurantsInnerLocation location;
  @override
  final AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRule? ownRule;

  factory _$AdminDeliveryFeesDtoOutputRestaurantsInner([
    void Function(AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder)? updates,
  ]) => (AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder()..update(updates))
      ._build();

  _$AdminDeliveryFeesDtoOutputRestaurantsInner._({
    required this.id,
    required this.nameAr,
    required this.location,
    this.ownRule,
  }) : super._();
  @override
  AdminDeliveryFeesDtoOutputRestaurantsInner rebuild(
    void Function(AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder toBuilder() =>
      AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeliveryFeesDtoOutputRestaurantsInner &&
        id == other.id &&
        nameAr == other.nameAr &&
        location == other.location &&
        ownRule == other.ownRule;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, ownRule.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDeliveryFeesDtoOutputRestaurantsInner',
          )
          ..add('id', id)
          ..add('nameAr', nameAr)
          ..add('location', location)
          ..add('ownRule', ownRule))
        .toString();
  }
}

class AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder
    implements
        Builder<
          AdminDeliveryFeesDtoOutputRestaurantsInner,
          AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder
        > {
  _$AdminDeliveryFeesDtoOutputRestaurantsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  AdminDeliveryFeesDtoOutputRestaurantsInnerLocationBuilder? _location;
  AdminDeliveryFeesDtoOutputRestaurantsInnerLocationBuilder get location =>
      _$this._location ??=
          AdminDeliveryFeesDtoOutputRestaurantsInnerLocationBuilder();
  set location(
    AdminDeliveryFeesDtoOutputRestaurantsInnerLocationBuilder? location,
  ) => _$this._location = location;

  AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder? _ownRule;
  AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder get ownRule =>
      _$this._ownRule ??=
          AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder();
  set ownRule(
    AdminDeliveryFeesDtoOutputRestaurantsInnerOwnRuleBuilder? ownRule,
  ) => _$this._ownRule = ownRule;

  AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder() {
    AdminDeliveryFeesDtoOutputRestaurantsInner._defaults(this);
  }

  AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nameAr = $v.nameAr;
      _location = $v.location.toBuilder();
      _ownRule = $v.ownRule?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeliveryFeesDtoOutputRestaurantsInner other) {
    _$v = other as _$AdminDeliveryFeesDtoOutputRestaurantsInner;
  }

  @override
  void update(
    void Function(AdminDeliveryFeesDtoOutputRestaurantsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeliveryFeesDtoOutputRestaurantsInner build() => _build();

  _$AdminDeliveryFeesDtoOutputRestaurantsInner _build() {
    _$AdminDeliveryFeesDtoOutputRestaurantsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminDeliveryFeesDtoOutputRestaurantsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminDeliveryFeesDtoOutputRestaurantsInner',
              'id',
            ),
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'AdminDeliveryFeesDtoOutputRestaurantsInner',
              'nameAr',
            ),
            location: location.build(),
            ownRule: _ownRule?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
        _$failedField = 'ownRule';
        _ownRule?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminDeliveryFeesDtoOutputRestaurantsInner',
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
