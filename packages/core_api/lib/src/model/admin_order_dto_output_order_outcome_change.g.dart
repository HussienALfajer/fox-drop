// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_outcome_change.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderOutcomeChange
    extends AdminOrderDtoOutputOrderOutcomeChange {
  @override
  final DateTime until;
  @override
  final BuiltList<AdminOrderDtoOutputOrderOutcomeChangeFoodsInner> foods;

  factory _$AdminOrderDtoOutputOrderOutcomeChange([
    void Function(AdminOrderDtoOutputOrderOutcomeChangeBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderOutcomeChangeBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderOutcomeChange._({
    required this.until,
    required this.foods,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderOutcomeChange rebuild(
    void Function(AdminOrderDtoOutputOrderOutcomeChangeBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderOutcomeChangeBuilder toBuilder() =>
      AdminOrderDtoOutputOrderOutcomeChangeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderOutcomeChange &&
        until == other.until &&
        foods == other.foods;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, until.hashCode);
    _$hash = $jc(_$hash, foods.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderOutcomeChange',
          )
          ..add('until', until)
          ..add('foods', foods))
        .toString();
  }
}

class AdminOrderDtoOutputOrderOutcomeChangeBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderOutcomeChange,
          AdminOrderDtoOutputOrderOutcomeChangeBuilder
        > {
  _$AdminOrderDtoOutputOrderOutcomeChange? _$v;

  DateTime? _until;
  DateTime? get until => _$this._until;
  set until(DateTime? until) => _$this._until = until;

  ListBuilder<AdminOrderDtoOutputOrderOutcomeChangeFoodsInner>? _foods;
  ListBuilder<AdminOrderDtoOutputOrderOutcomeChangeFoodsInner> get foods =>
      _$this._foods ??=
          ListBuilder<AdminOrderDtoOutputOrderOutcomeChangeFoodsInner>();
  set foods(
    ListBuilder<AdminOrderDtoOutputOrderOutcomeChangeFoodsInner>? foods,
  ) => _$this._foods = foods;

  AdminOrderDtoOutputOrderOutcomeChangeBuilder() {
    AdminOrderDtoOutputOrderOutcomeChange._defaults(this);
  }

  AdminOrderDtoOutputOrderOutcomeChangeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _until = $v.until;
      _foods = $v.foods.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderOutcomeChange other) {
    _$v = other as _$AdminOrderDtoOutputOrderOutcomeChange;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderOutcomeChangeBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderOutcomeChange build() => _build();

  _$AdminOrderDtoOutputOrderOutcomeChange _build() {
    _$AdminOrderDtoOutputOrderOutcomeChange _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderOutcomeChange._(
            until: BuiltValueNullFieldError.checkNotNull(
              until,
              r'AdminOrderDtoOutputOrderOutcomeChange',
              'until',
            ),
            foods: foods.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'foods';
        foods.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderOutcomeChange',
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
