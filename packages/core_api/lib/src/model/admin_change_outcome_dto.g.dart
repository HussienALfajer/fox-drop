// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_change_outcome_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminChangeOutcomeDtoOutcomeEnum _$adminChangeOutcomeDtoOutcomeEnum_free =
    const AdminChangeOutcomeDtoOutcomeEnum._('free');
const AdminChangeOutcomeDtoOutcomeEnum _$adminChangeOutcomeDtoOutcomeEnum_fake =
    const AdminChangeOutcomeDtoOutcomeEnum._('fake');
const AdminChangeOutcomeDtoOutcomeEnum
_$adminChangeOutcomeDtoOutcomeEnum_damaged =
    const AdminChangeOutcomeDtoOutcomeEnum._('damaged');
const AdminChangeOutcomeDtoOutcomeEnum
_$adminChangeOutcomeDtoOutcomeEnum_wrongRefused =
    const AdminChangeOutcomeDtoOutcomeEnum._('wrongRefused');
const AdminChangeOutcomeDtoOutcomeEnum
_$adminChangeOutcomeDtoOutcomeEnum_failedOther =
    const AdminChangeOutcomeDtoOutcomeEnum._('failedOther');

AdminChangeOutcomeDtoOutcomeEnum _$adminChangeOutcomeDtoOutcomeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'free':
      return _$adminChangeOutcomeDtoOutcomeEnum_free;
    case 'fake':
      return _$adminChangeOutcomeDtoOutcomeEnum_fake;
    case 'damaged':
      return _$adminChangeOutcomeDtoOutcomeEnum_damaged;
    case 'wrongRefused':
      return _$adminChangeOutcomeDtoOutcomeEnum_wrongRefused;
    case 'failedOther':
      return _$adminChangeOutcomeDtoOutcomeEnum_failedOther;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChangeOutcomeDtoOutcomeEnum>
_$adminChangeOutcomeDtoOutcomeEnumValues =
    BuiltSet<AdminChangeOutcomeDtoOutcomeEnum>(
      const <AdminChangeOutcomeDtoOutcomeEnum>[
        _$adminChangeOutcomeDtoOutcomeEnum_free,
        _$adminChangeOutcomeDtoOutcomeEnum_fake,
        _$adminChangeOutcomeDtoOutcomeEnum_damaged,
        _$adminChangeOutcomeDtoOutcomeEnum_wrongRefused,
        _$adminChangeOutcomeDtoOutcomeEnum_failedOther,
      ],
    );

const AdminChangeOutcomeDtoResponsibleEnum
_$adminChangeOutcomeDtoResponsibleEnum_restaurant =
    const AdminChangeOutcomeDtoResponsibleEnum._('restaurant');
const AdminChangeOutcomeDtoResponsibleEnum
_$adminChangeOutcomeDtoResponsibleEnum_captain =
    const AdminChangeOutcomeDtoResponsibleEnum._('captain');
const AdminChangeOutcomeDtoResponsibleEnum
_$adminChangeOutcomeDtoResponsibleEnum_customer =
    const AdminChangeOutcomeDtoResponsibleEnum._('customer');
const AdminChangeOutcomeDtoResponsibleEnum
_$adminChangeOutcomeDtoResponsibleEnum_platform =
    const AdminChangeOutcomeDtoResponsibleEnum._('platform');

AdminChangeOutcomeDtoResponsibleEnum
_$adminChangeOutcomeDtoResponsibleEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminChangeOutcomeDtoResponsibleEnum_restaurant;
    case 'captain':
      return _$adminChangeOutcomeDtoResponsibleEnum_captain;
    case 'customer':
      return _$adminChangeOutcomeDtoResponsibleEnum_customer;
    case 'platform':
      return _$adminChangeOutcomeDtoResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChangeOutcomeDtoResponsibleEnum>
_$adminChangeOutcomeDtoResponsibleEnumValues =
    BuiltSet<AdminChangeOutcomeDtoResponsibleEnum>(
      const <AdminChangeOutcomeDtoResponsibleEnum>[
        _$adminChangeOutcomeDtoResponsibleEnum_restaurant,
        _$adminChangeOutcomeDtoResponsibleEnum_captain,
        _$adminChangeOutcomeDtoResponsibleEnum_customer,
        _$adminChangeOutcomeDtoResponsibleEnum_platform,
      ],
    );

const AdminChangeOutcomeDtoFoodEnum
_$adminChangeOutcomeDtoFoodEnum_keptByCaptain =
    const AdminChangeOutcomeDtoFoodEnum._('keptByCaptain');
const AdminChangeOutcomeDtoFoodEnum
_$adminChangeOutcomeDtoFoodEnum_returnedToRestaurant =
    const AdminChangeOutcomeDtoFoodEnum._('returnedToRestaurant');
const AdminChangeOutcomeDtoFoodEnum _$adminChangeOutcomeDtoFoodEnum_destroyed =
    const AdminChangeOutcomeDtoFoodEnum._('destroyed');

AdminChangeOutcomeDtoFoodEnum _$adminChangeOutcomeDtoFoodEnumValueOf(
  String name,
) {
  switch (name) {
    case 'keptByCaptain':
      return _$adminChangeOutcomeDtoFoodEnum_keptByCaptain;
    case 'returnedToRestaurant':
      return _$adminChangeOutcomeDtoFoodEnum_returnedToRestaurant;
    case 'destroyed':
      return _$adminChangeOutcomeDtoFoodEnum_destroyed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminChangeOutcomeDtoFoodEnum>
_$adminChangeOutcomeDtoFoodEnumValues = BuiltSet<AdminChangeOutcomeDtoFoodEnum>(
  const <AdminChangeOutcomeDtoFoodEnum>[
    _$adminChangeOutcomeDtoFoodEnum_keptByCaptain,
    _$adminChangeOutcomeDtoFoodEnum_returnedToRestaurant,
    _$adminChangeOutcomeDtoFoodEnum_destroyed,
  ],
);

Serializer<AdminChangeOutcomeDtoOutcomeEnum>
_$adminChangeOutcomeDtoOutcomeEnumSerializer =
    _$AdminChangeOutcomeDtoOutcomeEnumSerializer();
Serializer<AdminChangeOutcomeDtoResponsibleEnum>
_$adminChangeOutcomeDtoResponsibleEnumSerializer =
    _$AdminChangeOutcomeDtoResponsibleEnumSerializer();
Serializer<AdminChangeOutcomeDtoFoodEnum>
_$adminChangeOutcomeDtoFoodEnumSerializer =
    _$AdminChangeOutcomeDtoFoodEnumSerializer();

class _$AdminChangeOutcomeDtoOutcomeEnumSerializer
    implements PrimitiveSerializer<AdminChangeOutcomeDtoOutcomeEnum> {
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
  final Iterable<Type> types = const <Type>[AdminChangeOutcomeDtoOutcomeEnum];
  @override
  final String wireName = 'AdminChangeOutcomeDtoOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeOutcomeDtoOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChangeOutcomeDtoOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChangeOutcomeDtoOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChangeOutcomeDtoResponsibleEnumSerializer
    implements PrimitiveSerializer<AdminChangeOutcomeDtoResponsibleEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminChangeOutcomeDtoResponsibleEnum,
  ];
  @override
  final String wireName = 'AdminChangeOutcomeDtoResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeOutcomeDtoResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChangeOutcomeDtoResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChangeOutcomeDtoResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChangeOutcomeDtoFoodEnumSerializer
    implements PrimitiveSerializer<AdminChangeOutcomeDtoFoodEnum> {
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
  final Iterable<Type> types = const <Type>[AdminChangeOutcomeDtoFoodEnum];
  @override
  final String wireName = 'AdminChangeOutcomeDtoFoodEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminChangeOutcomeDtoFoodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminChangeOutcomeDtoFoodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminChangeOutcomeDtoFoodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminChangeOutcomeDto extends AdminChangeOutcomeDto {
  @override
  final AdminChangeOutcomeDtoOutcomeEnum outcome;
  @override
  final AdminChangeOutcomeDtoResponsibleEnum responsible;
  @override
  final bool delivered;
  @override
  final AdminChangeOutcomeDtoFoodEnum? food;
  @override
  final int version;
  @override
  final String reason;

  factory _$AdminChangeOutcomeDto([
    void Function(AdminChangeOutcomeDtoBuilder)? updates,
  ]) => (AdminChangeOutcomeDtoBuilder()..update(updates))._build();

  _$AdminChangeOutcomeDto._({
    required this.outcome,
    required this.responsible,
    required this.delivered,
    this.food,
    required this.version,
    required this.reason,
  }) : super._();
  @override
  AdminChangeOutcomeDto rebuild(
    void Function(AdminChangeOutcomeDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminChangeOutcomeDtoBuilder toBuilder() =>
      AdminChangeOutcomeDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminChangeOutcomeDto &&
        outcome == other.outcome &&
        responsible == other.responsible &&
        delivered == other.delivered &&
        food == other.food &&
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
    _$hash = $jc(_$hash, version.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminChangeOutcomeDto')
          ..add('outcome', outcome)
          ..add('responsible', responsible)
          ..add('delivered', delivered)
          ..add('food', food)
          ..add('version', version)
          ..add('reason', reason))
        .toString();
  }
}

class AdminChangeOutcomeDtoBuilder
    implements Builder<AdminChangeOutcomeDto, AdminChangeOutcomeDtoBuilder> {
  _$AdminChangeOutcomeDto? _$v;

  AdminChangeOutcomeDtoOutcomeEnum? _outcome;
  AdminChangeOutcomeDtoOutcomeEnum? get outcome => _$this._outcome;
  set outcome(AdminChangeOutcomeDtoOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  AdminChangeOutcomeDtoResponsibleEnum? _responsible;
  AdminChangeOutcomeDtoResponsibleEnum? get responsible => _$this._responsible;
  set responsible(AdminChangeOutcomeDtoResponsibleEnum? responsible) =>
      _$this._responsible = responsible;

  bool? _delivered;
  bool? get delivered => _$this._delivered;
  set delivered(bool? delivered) => _$this._delivered = delivered;

  AdminChangeOutcomeDtoFoodEnum? _food;
  AdminChangeOutcomeDtoFoodEnum? get food => _$this._food;
  set food(AdminChangeOutcomeDtoFoodEnum? food) => _$this._food = food;

  int? _version;
  int? get version => _$this._version;
  set version(int? version) => _$this._version = version;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminChangeOutcomeDtoBuilder() {
    AdminChangeOutcomeDto._defaults(this);
  }

  AdminChangeOutcomeDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _outcome = $v.outcome;
      _responsible = $v.responsible;
      _delivered = $v.delivered;
      _food = $v.food;
      _version = $v.version;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminChangeOutcomeDto other) {
    _$v = other as _$AdminChangeOutcomeDto;
  }

  @override
  void update(void Function(AdminChangeOutcomeDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminChangeOutcomeDto build() => _build();

  _$AdminChangeOutcomeDto _build() {
    final _$result =
        _$v ??
        _$AdminChangeOutcomeDto._(
          outcome: BuiltValueNullFieldError.checkNotNull(
            outcome,
            r'AdminChangeOutcomeDto',
            'outcome',
          ),
          responsible: BuiltValueNullFieldError.checkNotNull(
            responsible,
            r'AdminChangeOutcomeDto',
            'responsible',
          ),
          delivered: BuiltValueNullFieldError.checkNotNull(
            delivered,
            r'AdminChangeOutcomeDto',
            'delivered',
          ),
          food: food,
          version: BuiltValueNullFieldError.checkNotNull(
            version,
            r'AdminChangeOutcomeDto',
            'version',
          ),
          reason: BuiltValueNullFieldError.checkNotNull(
            reason,
            r'AdminChangeOutcomeDto',
            'reason',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
