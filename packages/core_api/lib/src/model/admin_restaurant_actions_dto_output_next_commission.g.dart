// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_actions_dto_output_next_commission.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantActionsDtoOutputNextCommission
    extends AdminRestaurantActionsDtoOutputNextCommission {
  @override
  final int rateBp;
  @override
  final DateTime from;

  factory _$AdminRestaurantActionsDtoOutputNextCommission([
    void Function(AdminRestaurantActionsDtoOutputNextCommissionBuilder)?
    updates,
  ]) =>
      (AdminRestaurantActionsDtoOutputNextCommissionBuilder()..update(updates))
          ._build();

  _$AdminRestaurantActionsDtoOutputNextCommission._({
    required this.rateBp,
    required this.from,
  }) : super._();
  @override
  AdminRestaurantActionsDtoOutputNextCommission rebuild(
    void Function(AdminRestaurantActionsDtoOutputNextCommissionBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantActionsDtoOutputNextCommissionBuilder toBuilder() =>
      AdminRestaurantActionsDtoOutputNextCommissionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantActionsDtoOutputNextCommission &&
        rateBp == other.rateBp &&
        from == other.from;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, rateBp.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantActionsDtoOutputNextCommission',
          )
          ..add('rateBp', rateBp)
          ..add('from', from))
        .toString();
  }
}

class AdminRestaurantActionsDtoOutputNextCommissionBuilder
    implements
        Builder<
          AdminRestaurantActionsDtoOutputNextCommission,
          AdminRestaurantActionsDtoOutputNextCommissionBuilder
        > {
  _$AdminRestaurantActionsDtoOutputNextCommission? _$v;

  int? _rateBp;
  int? get rateBp => _$this._rateBp;
  set rateBp(int? rateBp) => _$this._rateBp = rateBp;

  DateTime? _from;
  DateTime? get from => _$this._from;
  set from(DateTime? from) => _$this._from = from;

  AdminRestaurantActionsDtoOutputNextCommissionBuilder() {
    AdminRestaurantActionsDtoOutputNextCommission._defaults(this);
  }

  AdminRestaurantActionsDtoOutputNextCommissionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _rateBp = $v.rateBp;
      _from = $v.from;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantActionsDtoOutputNextCommission other) {
    _$v = other as _$AdminRestaurantActionsDtoOutputNextCommission;
  }

  @override
  void update(
    void Function(AdminRestaurantActionsDtoOutputNextCommissionBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantActionsDtoOutputNextCommission build() => _build();

  _$AdminRestaurantActionsDtoOutputNextCommission _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantActionsDtoOutputNextCommission._(
          rateBp: BuiltValueNullFieldError.checkNotNull(
            rateBp,
            r'AdminRestaurantActionsDtoOutputNextCommission',
            'rateBp',
          ),
          from: BuiltValueNullFieldError.checkNotNull(
            from,
            r'AdminRestaurantActionsDtoOutputNextCommission',
            'from',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
