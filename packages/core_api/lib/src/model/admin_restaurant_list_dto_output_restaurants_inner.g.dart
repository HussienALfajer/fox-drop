// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_list_dto_output_restaurants_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
_$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_draft =
    const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum._(
      'draft',
    );
const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
_$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_test =
    const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum._(
      'test',
    );
const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
_$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_active =
    const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum._(
      'active',
    );
const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
_$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_suspended =
    const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum._(
      'suspended',
    );
const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
_$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_terminated =
    const AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum._(
      'terminated',
    );

AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
_$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'draft':
      return _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_draft;
    case 'test':
      return _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_test;
    case 'active':
      return _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_active;
    case 'suspended':
      return _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_suspended;
    case 'terminated':
      return _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum>
_$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnumValues =
    BuiltSet<
      AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
    >(const <AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum>[
      _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_draft,
      _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_test,
      _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_active,
      _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_suspended,
      _$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum_terminated,
    ]);

const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum
_$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_open =
    const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum._('open');
const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum
_$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_busy =
    const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum._('busy');
const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum
_$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_paused =
    const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum._('paused');
const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum
_$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_closed =
    const AdminRestaurantListDtoOutputRestaurantsInnerStateEnum._('closed');

AdminRestaurantListDtoOutputRestaurantsInnerStateEnum
_$adminRestaurantListDtoOutputRestaurantsInnerStateEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_open;
    case 'busy':
      return _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_busy;
    case 'paused':
      return _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_paused;
    case 'closed':
      return _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantListDtoOutputRestaurantsInnerStateEnum>
_$adminRestaurantListDtoOutputRestaurantsInnerStateEnumValues =
    BuiltSet<AdminRestaurantListDtoOutputRestaurantsInnerStateEnum>(
      const <AdminRestaurantListDtoOutputRestaurantsInnerStateEnum>[
        _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_open,
        _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_busy,
        _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_paused,
        _$adminRestaurantListDtoOutputRestaurantsInnerStateEnum_closed,
      ],
    );

Serializer<AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum>
_$adminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnumSerializer =
    _$AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnumSerializer();
Serializer<AdminRestaurantListDtoOutputRestaurantsInnerStateEnum>
_$adminRestaurantListDtoOutputRestaurantsInnerStateEnumSerializer =
    _$AdminRestaurantListDtoOutputRestaurantsInnerStateEnumSerializer();

class _$AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
        > {
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
    AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantListDtoOutputRestaurantsInnerStateEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantListDtoOutputRestaurantsInnerStateEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'busy': 'busy',
    'paused': 'paused',
    'closed': 'closed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'busy': 'busy',
    'paused': 'paused',
    'closed': 'closed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantListDtoOutputRestaurantsInnerStateEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantListDtoOutputRestaurantsInnerStateEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantListDtoOutputRestaurantsInnerStateEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantListDtoOutputRestaurantsInnerStateEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantListDtoOutputRestaurantsInnerStateEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantListDtoOutputRestaurantsInner
    extends AdminRestaurantListDtoOutputRestaurantsInner {
  @override
  final String id;
  @override
  final String nameAr;
  @override
  final String? nameEn;
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> categories;
  @override
  final AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum
  accountStatus;
  @override
  final AdminRestaurantListDtoOutputRestaurantsInnerStateEnum? state;
  @override
  final bool visible;
  @override
  final int sortWeight;
  @override
  final String? zoneName;
  @override
  final num? ratingAverage;
  @override
  final int ratingCount;
  @override
  final int ordersToday;
  @override
  final int? acceptanceBp7d;
  @override
  final int? commissionBp;
  @override
  final String balance;
  @override
  final DateTime? lastOrderAt;

  factory _$AdminRestaurantListDtoOutputRestaurantsInner([
    void Function(AdminRestaurantListDtoOutputRestaurantsInnerBuilder)? updates,
  ]) => (AdminRestaurantListDtoOutputRestaurantsInnerBuilder()..update(updates))
      ._build();

  _$AdminRestaurantListDtoOutputRestaurantsInner._({
    required this.id,
    required this.nameAr,
    this.nameEn,
    required this.categories,
    required this.accountStatus,
    this.state,
    required this.visible,
    required this.sortWeight,
    this.zoneName,
    this.ratingAverage,
    required this.ratingCount,
    required this.ordersToday,
    this.acceptanceBp7d,
    this.commissionBp,
    required this.balance,
    this.lastOrderAt,
  }) : super._();
  @override
  AdminRestaurantListDtoOutputRestaurantsInner rebuild(
    void Function(AdminRestaurantListDtoOutputRestaurantsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantListDtoOutputRestaurantsInnerBuilder toBuilder() =>
      AdminRestaurantListDtoOutputRestaurantsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantListDtoOutputRestaurantsInner &&
        id == other.id &&
        nameAr == other.nameAr &&
        nameEn == other.nameEn &&
        categories == other.categories &&
        accountStatus == other.accountStatus &&
        state == other.state &&
        visible == other.visible &&
        sortWeight == other.sortWeight &&
        zoneName == other.zoneName &&
        ratingAverage == other.ratingAverage &&
        ratingCount == other.ratingCount &&
        ordersToday == other.ordersToday &&
        acceptanceBp7d == other.acceptanceBp7d &&
        commissionBp == other.commissionBp &&
        balance == other.balance &&
        lastOrderAt == other.lastOrderAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, nameAr.hashCode);
    _$hash = $jc(_$hash, nameEn.hashCode);
    _$hash = $jc(_$hash, categories.hashCode);
    _$hash = $jc(_$hash, accountStatus.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jc(_$hash, visible.hashCode);
    _$hash = $jc(_$hash, sortWeight.hashCode);
    _$hash = $jc(_$hash, zoneName.hashCode);
    _$hash = $jc(_$hash, ratingAverage.hashCode);
    _$hash = $jc(_$hash, ratingCount.hashCode);
    _$hash = $jc(_$hash, ordersToday.hashCode);
    _$hash = $jc(_$hash, acceptanceBp7d.hashCode);
    _$hash = $jc(_$hash, commissionBp.hashCode);
    _$hash = $jc(_$hash, balance.hashCode);
    _$hash = $jc(_$hash, lastOrderAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminRestaurantListDtoOutputRestaurantsInner',
          )
          ..add('id', id)
          ..add('nameAr', nameAr)
          ..add('nameEn', nameEn)
          ..add('categories', categories)
          ..add('accountStatus', accountStatus)
          ..add('state', state)
          ..add('visible', visible)
          ..add('sortWeight', sortWeight)
          ..add('zoneName', zoneName)
          ..add('ratingAverage', ratingAverage)
          ..add('ratingCount', ratingCount)
          ..add('ordersToday', ordersToday)
          ..add('acceptanceBp7d', acceptanceBp7d)
          ..add('commissionBp', commissionBp)
          ..add('balance', balance)
          ..add('lastOrderAt', lastOrderAt))
        .toString();
  }
}

class AdminRestaurantListDtoOutputRestaurantsInnerBuilder
    implements
        Builder<
          AdminRestaurantListDtoOutputRestaurantsInner,
          AdminRestaurantListDtoOutputRestaurantsInnerBuilder
        > {
  _$AdminRestaurantListDtoOutputRestaurantsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _nameAr;
  String? get nameAr => _$this._nameAr;
  set nameAr(String? nameAr) => _$this._nameAr = nameAr;

  String? _nameEn;
  String? get nameEn => _$this._nameEn;
  set nameEn(String? nameEn) => _$this._nameEn = nameEn;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? _categories;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner> get categories =>
      _$this._categories ??=
          ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>();
  set categories(
    ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner>? categories,
  ) => _$this._categories = categories;

  AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum? _accountStatus;
  AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum?
  get accountStatus => _$this._accountStatus;
  set accountStatus(
    AdminRestaurantListDtoOutputRestaurantsInnerAccountStatusEnum?
    accountStatus,
  ) => _$this._accountStatus = accountStatus;

  AdminRestaurantListDtoOutputRestaurantsInnerStateEnum? _state;
  AdminRestaurantListDtoOutputRestaurantsInnerStateEnum? get state =>
      _$this._state;
  set state(AdminRestaurantListDtoOutputRestaurantsInnerStateEnum? state) =>
      _$this._state = state;

  bool? _visible;
  bool? get visible => _$this._visible;
  set visible(bool? visible) => _$this._visible = visible;

  int? _sortWeight;
  int? get sortWeight => _$this._sortWeight;
  set sortWeight(int? sortWeight) => _$this._sortWeight = sortWeight;

  String? _zoneName;
  String? get zoneName => _$this._zoneName;
  set zoneName(String? zoneName) => _$this._zoneName = zoneName;

  num? _ratingAverage;
  num? get ratingAverage => _$this._ratingAverage;
  set ratingAverage(num? ratingAverage) =>
      _$this._ratingAverage = ratingAverage;

  int? _ratingCount;
  int? get ratingCount => _$this._ratingCount;
  set ratingCount(int? ratingCount) => _$this._ratingCount = ratingCount;

  int? _ordersToday;
  int? get ordersToday => _$this._ordersToday;
  set ordersToday(int? ordersToday) => _$this._ordersToday = ordersToday;

  int? _acceptanceBp7d;
  int? get acceptanceBp7d => _$this._acceptanceBp7d;
  set acceptanceBp7d(int? acceptanceBp7d) =>
      _$this._acceptanceBp7d = acceptanceBp7d;

  int? _commissionBp;
  int? get commissionBp => _$this._commissionBp;
  set commissionBp(int? commissionBp) => _$this._commissionBp = commissionBp;

  String? _balance;
  String? get balance => _$this._balance;
  set balance(String? balance) => _$this._balance = balance;

  DateTime? _lastOrderAt;
  DateTime? get lastOrderAt => _$this._lastOrderAt;
  set lastOrderAt(DateTime? lastOrderAt) => _$this._lastOrderAt = lastOrderAt;

  AdminRestaurantListDtoOutputRestaurantsInnerBuilder() {
    AdminRestaurantListDtoOutputRestaurantsInner._defaults(this);
  }

  AdminRestaurantListDtoOutputRestaurantsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _nameAr = $v.nameAr;
      _nameEn = $v.nameEn;
      _categories = $v.categories.toBuilder();
      _accountStatus = $v.accountStatus;
      _state = $v.state;
      _visible = $v.visible;
      _sortWeight = $v.sortWeight;
      _zoneName = $v.zoneName;
      _ratingAverage = $v.ratingAverage;
      _ratingCount = $v.ratingCount;
      _ordersToday = $v.ordersToday;
      _acceptanceBp7d = $v.acceptanceBp7d;
      _commissionBp = $v.commissionBp;
      _balance = $v.balance;
      _lastOrderAt = $v.lastOrderAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantListDtoOutputRestaurantsInner other) {
    _$v = other as _$AdminRestaurantListDtoOutputRestaurantsInner;
  }

  @override
  void update(
    void Function(AdminRestaurantListDtoOutputRestaurantsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantListDtoOutputRestaurantsInner build() => _build();

  _$AdminRestaurantListDtoOutputRestaurantsInner _build() {
    _$AdminRestaurantListDtoOutputRestaurantsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantListDtoOutputRestaurantsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminRestaurantListDtoOutputRestaurantsInner',
              'id',
            ),
            nameAr: BuiltValueNullFieldError.checkNotNull(
              nameAr,
              r'AdminRestaurantListDtoOutputRestaurantsInner',
              'nameAr',
            ),
            nameEn: nameEn,
            categories: categories.build(),
            accountStatus: BuiltValueNullFieldError.checkNotNull(
              accountStatus,
              r'AdminRestaurantListDtoOutputRestaurantsInner',
              'accountStatus',
            ),
            state: state,
            visible: BuiltValueNullFieldError.checkNotNull(
              visible,
              r'AdminRestaurantListDtoOutputRestaurantsInner',
              'visible',
            ),
            sortWeight: BuiltValueNullFieldError.checkNotNull(
              sortWeight,
              r'AdminRestaurantListDtoOutputRestaurantsInner',
              'sortWeight',
            ),
            zoneName: zoneName,
            ratingAverage: ratingAverage,
            ratingCount: BuiltValueNullFieldError.checkNotNull(
              ratingCount,
              r'AdminRestaurantListDtoOutputRestaurantsInner',
              'ratingCount',
            ),
            ordersToday: BuiltValueNullFieldError.checkNotNull(
              ordersToday,
              r'AdminRestaurantListDtoOutputRestaurantsInner',
              'ordersToday',
            ),
            acceptanceBp7d: acceptanceBp7d,
            commissionBp: commissionBp,
            balance: BuiltValueNullFieldError.checkNotNull(
              balance,
              r'AdminRestaurantListDtoOutputRestaurantsInner',
              'balance',
            ),
            lastOrderAt: lastOrderAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'categories';
        categories.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantListDtoOutputRestaurantsInner',
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
