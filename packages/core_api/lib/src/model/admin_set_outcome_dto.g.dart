// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_set_outcome_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSetOutcomeDtoOutcomeEnum _$adminSetOutcomeDtoOutcomeEnum_free =
    const AdminSetOutcomeDtoOutcomeEnum._('free');
const AdminSetOutcomeDtoOutcomeEnum _$adminSetOutcomeDtoOutcomeEnum_fake =
    const AdminSetOutcomeDtoOutcomeEnum._('fake');
const AdminSetOutcomeDtoOutcomeEnum _$adminSetOutcomeDtoOutcomeEnum_damaged =
    const AdminSetOutcomeDtoOutcomeEnum._('damaged');
const AdminSetOutcomeDtoOutcomeEnum
_$adminSetOutcomeDtoOutcomeEnum_wrongRefused =
    const AdminSetOutcomeDtoOutcomeEnum._('wrongRefused');
const AdminSetOutcomeDtoOutcomeEnum
_$adminSetOutcomeDtoOutcomeEnum_failedOther =
    const AdminSetOutcomeDtoOutcomeEnum._('failedOther');

AdminSetOutcomeDtoOutcomeEnum _$adminSetOutcomeDtoOutcomeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'free':
      return _$adminSetOutcomeDtoOutcomeEnum_free;
    case 'fake':
      return _$adminSetOutcomeDtoOutcomeEnum_fake;
    case 'damaged':
      return _$adminSetOutcomeDtoOutcomeEnum_damaged;
    case 'wrongRefused':
      return _$adminSetOutcomeDtoOutcomeEnum_wrongRefused;
    case 'failedOther':
      return _$adminSetOutcomeDtoOutcomeEnum_failedOther;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSetOutcomeDtoOutcomeEnum>
_$adminSetOutcomeDtoOutcomeEnumValues = BuiltSet<AdminSetOutcomeDtoOutcomeEnum>(
  const <AdminSetOutcomeDtoOutcomeEnum>[
    _$adminSetOutcomeDtoOutcomeEnum_free,
    _$adminSetOutcomeDtoOutcomeEnum_fake,
    _$adminSetOutcomeDtoOutcomeEnum_damaged,
    _$adminSetOutcomeDtoOutcomeEnum_wrongRefused,
    _$adminSetOutcomeDtoOutcomeEnum_failedOther,
  ],
);

const AdminSetOutcomeDtoResponsibleEnum
_$adminSetOutcomeDtoResponsibleEnum_restaurant =
    const AdminSetOutcomeDtoResponsibleEnum._('restaurant');
const AdminSetOutcomeDtoResponsibleEnum
_$adminSetOutcomeDtoResponsibleEnum_captain =
    const AdminSetOutcomeDtoResponsibleEnum._('captain');
const AdminSetOutcomeDtoResponsibleEnum
_$adminSetOutcomeDtoResponsibleEnum_customer =
    const AdminSetOutcomeDtoResponsibleEnum._('customer');
const AdminSetOutcomeDtoResponsibleEnum
_$adminSetOutcomeDtoResponsibleEnum_platform =
    const AdminSetOutcomeDtoResponsibleEnum._('platform');

AdminSetOutcomeDtoResponsibleEnum _$adminSetOutcomeDtoResponsibleEnumValueOf(
  String name,
) {
  switch (name) {
    case 'restaurant':
      return _$adminSetOutcomeDtoResponsibleEnum_restaurant;
    case 'captain':
      return _$adminSetOutcomeDtoResponsibleEnum_captain;
    case 'customer':
      return _$adminSetOutcomeDtoResponsibleEnum_customer;
    case 'platform':
      return _$adminSetOutcomeDtoResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSetOutcomeDtoResponsibleEnum>
_$adminSetOutcomeDtoResponsibleEnumValues =
    BuiltSet<AdminSetOutcomeDtoResponsibleEnum>(
      const <AdminSetOutcomeDtoResponsibleEnum>[
        _$adminSetOutcomeDtoResponsibleEnum_restaurant,
        _$adminSetOutcomeDtoResponsibleEnum_captain,
        _$adminSetOutcomeDtoResponsibleEnum_customer,
        _$adminSetOutcomeDtoResponsibleEnum_platform,
      ],
    );

const AdminSetOutcomeDtoFoodEnum _$adminSetOutcomeDtoFoodEnum_keptByCaptain =
    const AdminSetOutcomeDtoFoodEnum._('keptByCaptain');
const AdminSetOutcomeDtoFoodEnum
_$adminSetOutcomeDtoFoodEnum_returnedToRestaurant =
    const AdminSetOutcomeDtoFoodEnum._('returnedToRestaurant');
const AdminSetOutcomeDtoFoodEnum _$adminSetOutcomeDtoFoodEnum_destroyed =
    const AdminSetOutcomeDtoFoodEnum._('destroyed');

AdminSetOutcomeDtoFoodEnum _$adminSetOutcomeDtoFoodEnumValueOf(String name) {
  switch (name) {
    case 'keptByCaptain':
      return _$adminSetOutcomeDtoFoodEnum_keptByCaptain;
    case 'returnedToRestaurant':
      return _$adminSetOutcomeDtoFoodEnum_returnedToRestaurant;
    case 'destroyed':
      return _$adminSetOutcomeDtoFoodEnum_destroyed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSetOutcomeDtoFoodEnum> _$adminSetOutcomeDtoFoodEnumValues =
    BuiltSet<AdminSetOutcomeDtoFoodEnum>(const <AdminSetOutcomeDtoFoodEnum>[
      _$adminSetOutcomeDtoFoodEnum_keptByCaptain,
      _$adminSetOutcomeDtoFoodEnum_returnedToRestaurant,
      _$adminSetOutcomeDtoFoodEnum_destroyed,
    ]);

Serializer<AdminSetOutcomeDtoOutcomeEnum>
_$adminSetOutcomeDtoOutcomeEnumSerializer =
    _$AdminSetOutcomeDtoOutcomeEnumSerializer();
Serializer<AdminSetOutcomeDtoResponsibleEnum>
_$adminSetOutcomeDtoResponsibleEnumSerializer =
    _$AdminSetOutcomeDtoResponsibleEnumSerializer();
Serializer<AdminSetOutcomeDtoFoodEnum> _$adminSetOutcomeDtoFoodEnumSerializer =
    _$AdminSetOutcomeDtoFoodEnumSerializer();

class _$AdminSetOutcomeDtoOutcomeEnumSerializer
    implements PrimitiveSerializer<AdminSetOutcomeDtoOutcomeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'free': 'free',
    'fake': 'fake',
    'damaged': 'damaged',
    'wrongRefused': 'wrong_refused',
    'failedOther': 'failed_other',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'free': 'free',
    'fake': 'fake',
    'damaged': 'damaged',
    'wrong_refused': 'wrongRefused',
    'failed_other': 'failedOther',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminSetOutcomeDtoOutcomeEnum];
  @override
  final String wireName = 'AdminSetOutcomeDtoOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSetOutcomeDtoOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSetOutcomeDtoOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSetOutcomeDtoOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSetOutcomeDtoResponsibleEnumSerializer
    implements PrimitiveSerializer<AdminSetOutcomeDtoResponsibleEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurant': 'restaurant',
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant': 'restaurant',
    'captain': 'captain',
    'customer': 'customer',
    'platform': 'platform',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminSetOutcomeDtoResponsibleEnum];
  @override
  final String wireName = 'AdminSetOutcomeDtoResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSetOutcomeDtoResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSetOutcomeDtoResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSetOutcomeDtoResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSetOutcomeDtoFoodEnumSerializer
    implements PrimitiveSerializer<AdminSetOutcomeDtoFoodEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'keptByCaptain': 'kept_by_captain',
    'returnedToRestaurant': 'returned_to_restaurant',
    'destroyed': 'destroyed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'kept_by_captain': 'keptByCaptain',
    'returned_to_restaurant': 'returnedToRestaurant',
    'destroyed': 'destroyed',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminSetOutcomeDtoFoodEnum];
  @override
  final String wireName = 'AdminSetOutcomeDtoFoodEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSetOutcomeDtoFoodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSetOutcomeDtoFoodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSetOutcomeDtoFoodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSetOutcomeDto extends AdminSetOutcomeDto {
  @override
  final AdminSetOutcomeDtoOutcomeEnum outcome;
  @override
  final AdminSetOutcomeDtoResponsibleEnum responsible;
  @override
  final bool delivered;
  @override
  final AdminSetOutcomeDtoFoodEnum? food;
  @override
  final String? amountToCollect;
  @override
  final int version;
  @override
  final String reason;

  factory _$AdminSetOutcomeDto([
    void Function(AdminSetOutcomeDtoBuilder)? updates,
  ]) => (AdminSetOutcomeDtoBuilder()..update(updates))._build();

  _$AdminSetOutcomeDto._({
    required this.outcome,
    required this.responsible,
    required this.delivered,
    this.food,
    this.amountToCollect,
    required this.version,
    required this.reason,
  }) : super._();
  @override
  AdminSetOutcomeDto rebuild(
    void Function(AdminSetOutcomeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSetOutcomeDtoBuilder toBuilder() =>
      AdminSetOutcomeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSetOutcomeDto &&
        outcome == other.outcome &&
        responsible == other.responsible &&
        delivered == other.delivered &&
        food == other.food &&
        amountToCollect == other.amountToCollect &&
        version == other.version &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jc(_$hash, delivered.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jc(_$hash, amountToCollect.hashCode);
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminSetOutcomeDto')
          ..add('outcome', outcome)
          ..add('responsible', responsible)
          ..add('delivered', delivered)
          ..add('food', food)
          ..add('amountToCollect', amountToCollect)
          ..add('version', version)
          ..add('reason', reason))
        .toString();
  }
}

class AdminSetOutcomeDtoBuilder
    implements Builder<AdminSetOutcomeDto, AdminSetOutcomeDtoBuilder> {
  _$AdminSetOutcomeDto? _$v;

  AdminSetOutcomeDtoOutcomeEnum? _outcome;
  AdminSetOutcomeDtoOutcomeEnum? get outcome => _$this._outcome;
  set outcome(AdminSetOutcomeDtoOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  AdminSetOutcomeDtoResponsibleEnum? _responsible;
  AdminSetOutcomeDtoResponsibleEnum? get responsible => _$this._responsible;
  set responsible(AdminSetOutcomeDtoResponsibleEnum? responsible) =>
      _$this._responsible = responsible;

  bool? _delivered;
  bool? get delivered => _$this._delivered;
  set delivered(bool? delivered) => _$this._delivered = delivered;

  AdminSetOutcomeDtoFoodEnum? _food;
  AdminSetOutcomeDtoFoodEnum? get food => _$this._food;
  set food(AdminSetOutcomeDtoFoodEnum? food) => _$this._food = food;

  String? _amountToCollect;
  String? get amountToCollect => _$this._amountToCollect;
  set amountToCollect(String? amountToCollect) =>
      _$this._amountToCollect = amountToCollect;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminSetOutcomeDtoBuilder() {
    AdminSetOutcomeDto._defaults(this);
  }

  AdminSetOutcomeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _outcome = $v.outcome;
      _responsible = $v.responsible;
      _delivered = $v.delivered;
      _food = $v.food;
      _amountToCollect = $v.amountToCollect;
      _version = $v.version;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSetOutcomeDto other) {
    _$v = other as _$AdminSetOutcomeDto;
  }

  @override
  void update(void Function(AdminSetOutcomeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminSetOutcomeDto build() => _build();

  _$AdminSetOutcomeDto _build() {
    final _$result =
        _$v ??
        _$AdminSetOutcomeDto._(
          outcome: BuiltValueNullFieldError.checkNotNull(
            outcome,
            r'AdminSetOutcomeDto',
            'outcome',
          ),
          responsible: BuiltValueNullFieldError.checkNotNull(
            responsible,
            r'AdminSetOutcomeDto',
            'responsible',
          ),
          delivered: BuiltValueNullFieldError.checkNotNull(
            delivered,
            r'AdminSetOutcomeDto',
            'delivered',
          ),
          food: food,
          amountToCollect: amountToCollect,
          version: BuiltValueNullFieldError.checkNotNull(
            version,
            r'AdminSetOutcomeDto',
            'version',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminSetOutcomeDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
