// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_outcome_choices.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminOrderDtoOutputOrderOutcomeChoices
    extends AdminOrderDtoOutputOrderOutcomeChoices {
  @override
  final BuiltList<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner> foods;

  factory _$AdminOrderDtoOutputOrderOutcomeChoices([
    void Function(AdminOrderDtoOutputOrderOutcomeChoicesBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderOutcomeChoicesBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderOutcomeChoices._({required this.foods}) : super._();
  @override
  AdminOrderDtoOutputOrderOutcomeChoices rebuild(
    void Function(AdminOrderDtoOutputOrderOutcomeChoicesBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderOutcomeChoicesBuilder toBuilder() =>
      AdminOrderDtoOutputOrderOutcomeChoicesBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderOutcomeChoices &&
        foods == other.foods;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, foods.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
      r'AdminOrderDtoOutputOrderOutcomeChoices',
    )..add('foods', foods)).toString();
  }
}

class AdminOrderDtoOutputOrderOutcomeChoicesBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderOutcomeChoices,
          AdminOrderDtoOutputOrderOutcomeChoicesBuilder
        > {
  _$AdminOrderDtoOutputOrderOutcomeChoices? _$v;

  ListBuilder<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner>? _foods;
  ListBuilder<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner> get foods =>
      _$this._foods ??=
          ListBuilder<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner>();
  set foods(
    ListBuilder<AdminOrderDtoOutputOrderOutcomeChoicesFoodsInner>? foods,
  ) => _$this._foods = foods;

  AdminOrderDtoOutputOrderOutcomeChoicesBuilder() {
    AdminOrderDtoOutputOrderOutcomeChoices._defaults(this);
  }

  AdminOrderDtoOutputOrderOutcomeChoicesBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _foods = $v.foods.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderOutcomeChoices other) {
    _$v = other as _$AdminOrderDtoOutputOrderOutcomeChoices;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderOutcomeChoicesBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderOutcomeChoices build() => _build();

  _$AdminOrderDtoOutputOrderOutcomeChoices _build() {
    _$AdminOrderDtoOutputOrderOutcomeChoices _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderOutcomeChoices._(foods: foods.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'foods';
        foods.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderOutcomeChoices',
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
