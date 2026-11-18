// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_actions_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantActionsDtoOutputAccountStatusEnum
_$adminRestaurantActionsDtoOutputAccountStatusEnum_draft =
    const AdminRestaurantActionsDtoOutputAccountStatusEnum._('draft');
const AdminRestaurantActionsDtoOutputAccountStatusEnum
_$adminRestaurantActionsDtoOutputAccountStatusEnum_test =
    const AdminRestaurantActionsDtoOutputAccountStatusEnum._('test');
const AdminRestaurantActionsDtoOutputAccountStatusEnum
_$adminRestaurantActionsDtoOutputAccountStatusEnum_active =
    const AdminRestaurantActionsDtoOutputAccountStatusEnum._('active');
const AdminRestaurantActionsDtoOutputAccountStatusEnum
_$adminRestaurantActionsDtoOutputAccountStatusEnum_suspended =
    const AdminRestaurantActionsDtoOutputAccountStatusEnum._('suspended');
const AdminRestaurantActionsDtoOutputAccountStatusEnum
_$adminRestaurantActionsDtoOutputAccountStatusEnum_terminated =
    const AdminRestaurantActionsDtoOutputAccountStatusEnum._('terminated');

AdminRestaurantActionsDtoOutputAccountStatusEnum
_$adminRestaurantActionsDtoOutputAccountStatusEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$adminRestaurantActionsDtoOutputAccountStatusEnum_draft;
    case 'test':
      return _$adminRestaurantActionsDtoOutputAccountStatusEnum_test;
    case 'active':
      return _$adminRestaurantActionsDtoOutputAccountStatusEnum_active;
    case 'suspended':
      return _$adminRestaurantActionsDtoOutputAccountStatusEnum_suspended;
    case 'terminated':
      return _$adminRestaurantActionsDtoOutputAccountStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantActionsDtoOutputAccountStatusEnum>
_$adminRestaurantActionsDtoOutputAccountStatusEnumValues =
    BuiltSet<AdminRestaurantActionsDtoOutputAccountStatusEnum>(
      const <AdminRestaurantActionsDtoOutputAccountStatusEnum>[
        _$adminRestaurantActionsDtoOutputAccountStatusEnum_draft,
        _$adminRestaurantActionsDtoOutputAccountStatusEnum_test,
        _$adminRestaurantActionsDtoOutputAccountStatusEnum_active,
        _$adminRestaurantActionsDtoOutputAccountStatusEnum_suspended,
        _$adminRestaurantActionsDtoOutputAccountStatusEnum_terminated,
      ],
    );

Serializer<AdminRestaurantActionsDtoOutputAccountStatusEnum>
_$adminRestaurantActionsDtoOutputAccountStatusEnumSerializer =
    _$AdminRestaurantActionsDtoOutputAccountStatusEnumSerializer();

class _$AdminRestaurantActionsDtoOutputAccountStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminRestaurantActionsDtoOutputAccountStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'test': 'test',
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'test': 'test',
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantActionsDtoOutputAccountStatusEnum,
  ];
  @override
  final String wireName = 'AdminRestaurantActionsDtoOutputAccountStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantActionsDtoOutputAccountStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantActionsDtoOutputAccountStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantActionsDtoOutputAccountStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantActionsDtoOutput
    extends AdminRestaurantActionsDtoOutput {
  @override
  final String nameAr;
  @override
  final AdminRestaurantActionsDtoOutputAccountStatusEnum accountStatus;
  @override
  final String? suspensionReason;
  @override
  final bool visible;
  @override
  final int sortWeight;
  @override
  final int sortWeightMax;
  @override
  final int? commissionBp;
  @override
  final AdminRestaurantActionsDtoOutputNextCommission? nextCommission;
  @override
  final BuiltList<AdminRestaurantActionsDtoOutputCommissionHistoryInner>
  commissionHistory;

  factory _$AdminRestaurantActionsDtoOutput([
    void Function(AdminRestaurantActionsDtoOutputBuilder)? updates,
  ]) => (AdminRestaurantActionsDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantActionsDtoOutput._({
    required this.nameAr,
    required this.accountStatus,
    this.suspensionReason,
    required this.visible,
    required this.sortWeight,
    required this.sortWeightMax,
    this.commissionBp,
    this.nextCommission,
    required this.commissionHistory,
  }) : super._();
  @override
  AdminRestaurantActionsDtoOutput rebuild(
    void Function(AdminRestaurantActionsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantActionsDtoOutputBuilder toBuilder() =>
      AdminRestaurantActionsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantActionsDtoOutput &&
        nameAr == other.nameAr &&
        accountStatus == other.accountStatus &&
        suspensionReason == other.suspensionReason &&
        visible == other.visible &&
        sortWeight == other.sortWeight &&
        sortWeightMax == other.sortWeightMax &&
        commissionBp == other.commissionBp &&
        nextCommission == other.nextCommission &&
        commissionHistory == other.commissionHistory;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jc(_$hash, suspensionReason.hashCode);
    _$hash = $jc(_$hash, visible.hashCode);
    _$hash = $jc(_$hash, sortWeight.hashCode);
    _$hash = $jc(_$hash, sortWeightMax.hashCode);
    _$hash = $jc(_$hash, commissionBp.hashCode);
    _$hash = $jc(_$hash, nextCommission.hashCode);
    _$hash = $jc(_$hash, commissionHistory.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantActionsDtoOutput')
          ..add('nameAr', nameAr)
          ..add('accountStatus', accountStatus)
          ..add('suspensionReason', suspensionReason)
          ..add('visible', visible)
          ..add('sortWeight', sortWeight)
          ..add('sortWeightMax', sortWeightMax)
          ..add('commissionBp', commissionBp)
          ..add('nextCommission', nextCommission)
          ..add('commissionHistory', commissionHistory))
        .toString();
  }
}

class AdminRestaurantActionsDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantActionsDtoOutput,
          AdminRestaurantActionsDtoOutputBuilder
        > {
  _$AdminRestaurantActionsDtoOutput? _$v;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  AdminRestaurantActionsDtoOutputAccountStatusEnum? _accountStatus;
  AdminRestaurantActionsDtoOutputAccountStatusEnum? get accountStatus =>
      _$this._accountStatus;
  set accountStatus(
    AdminRestaurantActionsDtoOutputAccountStatusEnum? accountStatus,
  ) => _$this._accountStatus = accountStatus;

  String? _suspensionReason;
  String? get suspensionReason => _$this._suspensionReason;
  set suspensionReason(String? suspensionReason) =>
      _$this._suspensionReason = suspensionReason;

  bool? _visible;
  bool? get visible => _$this._visible;
  set visible(bool? visible) => _$this._visible = visible;

  int? _sortWeight;
  int? get sortWeight => _$this._sortWeight;
  set sortWeight(int? sortWeight) => _$this._sortWeight = sortWeight;

  int? _sortWeightMax;
  int? get sortWeightMax => _$this._sortWeightMax;
  set sortWeightMax(int? sortWeightMax) =>
      _$this._sortWeightMax = sortWeightMax;

  int? _commissionBp;
  int? get commissionBp => _$this._commissionBp;
  set commissionBp(int? commissionBp) => _$this._commissionBp = commissionBp;

  AdminRestaurantActionsDtoOutputNextCommissionBuilder? _nextCommission;
  AdminRestaurantActionsDtoOutputNextCommissionBuilder get nextCommission =>
      _$this._nextCommission ??=
          AdminRestaurantActionsDtoOutputNextCommissionBuilder();
  set nextCommission(
    AdminRestaurantActionsDtoOutputNextCommissionBuilder? nextCommission,
  ) => _$this._nextCommission = nextCommission;

  ListBuilder<AdminRestaurantActionsDtoOutputCommissionHistoryInner>?
  _commissionHistory;
  ListBuilder<AdminRestaurantActionsDtoOutputCommissionHistoryInner>
  get commissionHistory => _$this._commissionHistory ??=
      ListBuilder<AdminRestaurantActionsDtoOutputCommissionHistoryInner>();
  set commissionHistory(
    ListBuilder<AdminRestaurantActionsDtoOutputCommissionHistoryInner>?
    commissionHistory,
  ) => _$this._commissionHistory = commissionHistory;

  AdminRestaurantActionsDtoOutputBuilder() {
    AdminRestaurantActionsDtoOutput._defaults(this);
  }

  AdminRestaurantActionsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _nameAr = $v.nameAr;
      _accountStatus = $v.accountStatus;
      _suspensionReason = $v.suspensionReason;
      _visible = $v.visible;
      _sortWeight = $v.sortWeight;
      _sortWeightMax = $v.sortWeightMax;
      _commissionBp = $v.commissionBp;
      _nextCommission = $v.nextCommission?.toBuilder();
      _commissionHistory = $v.commissionHistory.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantActionsDtoOutput other) {
    _$v = other as _$AdminRestaurantActionsDtoOutput;
  }

  @override
  void update(void Function(AdminRestaurantActionsDtoOutputBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantActionsDtoOutput build() => _build();

  _$AdminRestaurantActionsDtoOutput _build() {
    _$AdminRestaurantActionsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantActionsDtoOutput._(
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'AdminRestaurantActionsDtoOutput',
              'nameAr',
            ),
            accountStatus: BuiltValueNullFieldError.checkNotNull(
              accountStatus,
              r'AdminRestaurantActionsDtoOutput',
              'accountStatus',
            ),
            suspensionReason: suspensionReason,
            visible: BuiltValueNullFieldError.checkNotNull(
              visible,
              r'AdminRestaurantActionsDtoOutput',
              'visible',
            ),
            sortWeight: BuiltValueNullFieldError.checkNotNull(
              sortWeight,
              r'AdminRestaurantActionsDtoOutput',
              'sortWeight',
            ),
            sortWeightMax: BuiltValueNullFieldError.checkNotNull(
              sortWeightMax,
              r'AdminRestaurantActionsDtoOutput',
              'sortWeightMax',
            ),
            commissionBp: commissionBp,
            nextCommission: _nextCommission?.build(),
            commissionHistory: commissionHistory.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'nextCommission';
        _nextCommission?.build();
        _$failedField = 'commissionHistory';
        commissionHistory.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantActionsDtoOutput',
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
