// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_drafts_dto_output_drafts_inner_steps.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftsDtoOutputDraftsInnerSteps
    extends AdminRestaurantDraftsDtoOutputDraftsInnerSteps {
  @override
  final bool basics;
  @override
  final bool location;
  @override
  final bool operations;

  factory _$AdminRestaurantDraftsDtoOutputDraftsInnerSteps([
    void Function(AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder)?
    updates,
  ]) =>
      (AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder()..update(updates))
          ._build();

  _$AdminRestaurantDraftsDtoOutputDraftsInnerSteps._({
    required this.basics,
    required this.location,
    required this.operations,
  }) : super._();
  @override
  AdminRestaurantDraftsDtoOutputDraftsInnerSteps rebuild(
    void Function(AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder toBuilder() =>
      AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftsDtoOutputDraftsInnerSteps &&
        basics == other.basics &&
        location == other.location &&
        operations == other.operations;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, basics.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, operations.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantDraftsDtoOutputDraftsInnerSteps',
          )
          ..add('basics', basics)
          ..add('location', location)
          ..add('operations', operations))
        .toString();
  }
}

class AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder
    implements
        Builder<
          AdminRestaurantDraftsDtoOutputDraftsInnerSteps,
          AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder
        > {
  _$AdminRestaurantDraftsDtoOutputDraftsInnerSteps? _$v;

  bool? _basics;
  bool? get basics => _$this._basics;
  set basics(bool? basics) => _$this._basics = basics;

  bool? _location;
  bool? get location => _$this._location;
  set location(bool? location) => _$this._location = location;

  bool? _operations;
  bool? get operations => _$this._operations;
  set operations(bool? operations) => _$this._operations = operations;

  AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder() {
    AdminRestaurantDraftsDtoOutputDraftsInnerSteps._defaults(this);
  }

  AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _basics = $v.basics;
      _location = $v.location;
      _operations = $v.operations;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftsDtoOutputDraftsInnerSteps other) {
    _$v = other as _$AdminRestaurantDraftsDtoOutputDraftsInnerSteps;
  }

  @override
  void update(
    void Function(AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftsDtoOutputDraftsInnerSteps build() => _build();

  _$AdminRestaurantDraftsDtoOutputDraftsInnerSteps _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantDraftsDtoOutputDraftsInnerSteps._(
          basics: BuiltValueNullFieldError.checkNotNull(
            basics,
            r'AdminRestaurantDraftsDtoOutputDraftsInnerSteps',
            'basics',
          ),
          location: BuiltValueNullFieldError.checkNotNull(
            location,
            r'AdminRestaurantDraftsDtoOutputDraftsInnerSteps',
            'location',
          ),
          operations: BuiltValueNullFieldError.checkNotNull(
            operations,
            r'AdminRestaurantDraftsDtoOutputDraftsInnerSteps',
            'operations',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
