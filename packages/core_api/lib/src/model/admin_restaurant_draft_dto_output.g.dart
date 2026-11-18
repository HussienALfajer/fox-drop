// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_draft_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AdminRestaurantDraftDtoOutput extends AdminRestaurantDraftDtoOutput {
  @override
  final String id;
  @override
  final String cityId;
  @override
  final String accountStatus;
  @override
  final AdminRestaurantDraftDtoOutputBasics basics;
  @override
  final AdminRestaurantDraftDtoOutputLocation location;
  @override
  final AdminRestaurantDraftDtoOutputOperations operations;
  @override
  final AdminRestaurantDraftsDtoOutputDraftsInnerSteps steps;

  factory _$AdminRestaurantDraftDtoOutput([
    void Function(AdminRestaurantDraftDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantDraftDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantDraftDtoOutput._({
    required this.id,
    required this.cityId,
    required this.accountStatus,
    required this.basics,
    required this.location,
    required this.operations,
    required this.steps,
  }) : super._();
  @override
  AdminRestaurantDraftDtoOutput rebuild(
    void Function(AdminRestaurantDraftDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantDraftDtoOutputBuilder toBuilder() =>
      AdminRestaurantDraftDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantDraftDtoOutput &&
        id == other.id &&
        cityId == other.cityId &&
        accountStatus == other.accountStatus &&
        basics == other.basics &&
        location == other.location &&
        operations == other.operations &&
        steps == other.steps;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jc(_$hash, basics.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jc(_$hash, operations.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantDraftDtoOutput')
          ..add('id', id)
          ..add('cityId', cityId)
          ..add('accountStatus', accountStatus)
          ..add('basics', basics)
          ..add('location', location)
          ..add('operations', operations)
          ..add('steps', steps))
        .toString();
  }
}

class AdminRestaurantDraftDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantDraftDtoOutput,
          AdminRestaurantDraftDtoOutputBuilder
        > {
  _$AdminRestaurantDraftDtoOutput? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _accountStatus;
  String? get accountStatus => _$this._accountStatus;
  set accountStatus(String? accountStatus) =>
      _$this._accountStatus = accountStatus;

  AdminRestaurantDraftDtoOutputBasicsBuilder? _basics;
  AdminRestaurantDraftDtoOutputBasicsBuilder get basics =>
      _$this._basics ??= AdminRestaurantDraftDtoOutputBasicsBuilder();
  set basics(AdminRestaurantDraftDtoOutputBasicsBuilder? basics) =>
      _$this._basics = basics;

  AdminRestaurantDraftDtoOutputLocationBuilder? _location;
  AdminRestaurantDraftDtoOutputLocationBuilder get location =>
      _$this._location ??= AdminRestaurantDraftDtoOutputLocationBuilder();
  set location(AdminRestaurantDraftDtoOutputLocationBuilder? location) =>
      _$this._location = location;

  AdminRestaurantDraftDtoOutputOperationsBuilder? _operations;
  AdminRestaurantDraftDtoOutputOperationsBuilder get operations =>
      _$this._operations ??= AdminRestaurantDraftDtoOutputOperationsBuilder();
  set operations(AdminRestaurantDraftDtoOutputOperationsBuilder? operations) =>
      _$this._operations = operations;

  AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder? _steps;
  AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder get steps =>
      _$this._steps ??= AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder();
  set steps(AdminRestaurantDraftsDtoOutputDraftsInnerStepsBuilder? steps) =>
      _$this._steps = steps;

  AdminRestaurantDraftDtoOutputBuilder() {
    AdminRestaurantDraftDtoOutput._defaults(this);
  }

  AdminRestaurantDraftDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _cityId = $v.cityId;
      _accountStatus = $v.accountStatus;
      _basics = $v.basics.toBuilder();
      _location = $v.location.toBuilder();
      _operations = $v.operations.toBuilder();
      _steps = $v.steps.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantDraftDtoOutput other) {
    _$v = other as _$AdminRestaurantDraftDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantDraftDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantDraftDtoOutput build() => _build();

  _$AdminRestaurantDraftDtoOutput _build() {
    _$AdminRestaurantDraftDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantDraftDtoOutput._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminRestaurantDraftDtoOutput',
              'id',
            ),
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminRestaurantDraftDtoOutput',
              'cityId',
            ),
            accountStatus: BuiltValueNullFieldError.checkNotNull(
              accountStatus,
              r'AdminRestaurantDraftDtoOutput',
              'accountStatus',
            ),
            basics: basics.build(),
            location: location.build(),
            operations: operations.build(),
            steps: steps.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'basics';
        basics.build();
        _$failedField = 'location';
        location.build();
        _$failedField = 'operations';
        operations.build();
        _$failedField = 'steps';
        steps.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantDraftDtoOutput',
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
