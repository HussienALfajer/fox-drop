// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_outcome_preview_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOutcomePreviewDtoOutcomeEnum
_$adminOutcomePreviewDtoOutcomeEnum_free =
    const AdminOutcomePreviewDtoOutcomeEnum._('free');
const AdminOutcomePreviewDtoOutcomeEnum
_$adminOutcomePreviewDtoOutcomeEnum_fake =
    const AdminOutcomePreviewDtoOutcomeEnum._('fake');
const AdminOutcomePreviewDtoOutcomeEnum
_$adminOutcomePreviewDtoOutcomeEnum_damaged =
    const AdminOutcomePreviewDtoOutcomeEnum._('damaged');
const AdminOutcomePreviewDtoOutcomeEnum
_$adminOutcomePreviewDtoOutcomeEnum_wrongRefused =
    const AdminOutcomePreviewDtoOutcomeEnum._('wrongRefused');
const AdminOutcomePreviewDtoOutcomeEnum
_$adminOutcomePreviewDtoOutcomeEnum_failedOther =
    const AdminOutcomePreviewDtoOutcomeEnum._('failedOther');

AdminOutcomePreviewDtoOutcomeEnum _$adminOutcomePreviewDtoOutcomeEnumValueOf(
  String name,
) {
  switch (name) {
    case 'free':
      return _$adminOutcomePreviewDtoOutcomeEnum_free;
    case 'fake':
      return _$adminOutcomePreviewDtoOutcomeEnum_fake;
    case 'damaged':
      return _$adminOutcomePreviewDtoOutcomeEnum_damaged;
    case 'wrongRefused':
      return _$adminOutcomePreviewDtoOutcomeEnum_wrongRefused;
    case 'failedOther':
      return _$adminOutcomePreviewDtoOutcomeEnum_failedOther;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOutcomePreviewDtoOutcomeEnum>
_$adminOutcomePreviewDtoOutcomeEnumValues =
    BuiltSet<AdminOutcomePreviewDtoOutcomeEnum>(
      const <AdminOutcomePreviewDtoOutcomeEnum>[
        _$adminOutcomePreviewDtoOutcomeEnum_free,
        _$adminOutcomePreviewDtoOutcomeEnum_fake,
        _$adminOutcomePreviewDtoOutcomeEnum_damaged,
        _$adminOutcomePreviewDtoOutcomeEnum_wrongRefused,
        _$adminOutcomePreviewDtoOutcomeEnum_failedOther,
      ],
    );

const AdminOutcomePreviewDtoResponsibleEnum
_$adminOutcomePreviewDtoResponsibleEnum_restaurant =
    const AdminOutcomePreviewDtoResponsibleEnum._('restaurant');
const AdminOutcomePreviewDtoResponsibleEnum
_$adminOutcomePreviewDtoResponsibleEnum_captain =
    const AdminOutcomePreviewDtoResponsibleEnum._('captain');
const AdminOutcomePreviewDtoResponsibleEnum
_$adminOutcomePreviewDtoResponsibleEnum_customer =
    const AdminOutcomePreviewDtoResponsibleEnum._('customer');
const AdminOutcomePreviewDtoResponsibleEnum
_$adminOutcomePreviewDtoResponsibleEnum_platform =
    const AdminOutcomePreviewDtoResponsibleEnum._('platform');

AdminOutcomePreviewDtoResponsibleEnum
_$adminOutcomePreviewDtoResponsibleEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminOutcomePreviewDtoResponsibleEnum_restaurant;
    case 'captain':
      return _$adminOutcomePreviewDtoResponsibleEnum_captain;
    case 'customer':
      return _$adminOutcomePreviewDtoResponsibleEnum_customer;
    case 'platform':
      return _$adminOutcomePreviewDtoResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOutcomePreviewDtoResponsibleEnum>
_$adminOutcomePreviewDtoResponsibleEnumValues =
    BuiltSet<AdminOutcomePreviewDtoResponsibleEnum>(
      const <AdminOutcomePreviewDtoResponsibleEnum>[
        _$adminOutcomePreviewDtoResponsibleEnum_restaurant,
        _$adminOutcomePreviewDtoResponsibleEnum_captain,
        _$adminOutcomePreviewDtoResponsibleEnum_customer,
        _$adminOutcomePreviewDtoResponsibleEnum_platform,
      ],
    );

const AdminOutcomePreviewDtoFoodEnum
_$adminOutcomePreviewDtoFoodEnum_keptByCaptain =
    const AdminOutcomePreviewDtoFoodEnum._('keptByCaptain');
const AdminOutcomePreviewDtoFoodEnum
_$adminOutcomePreviewDtoFoodEnum_returnedToRestaurant =
    const AdminOutcomePreviewDtoFoodEnum._('returnedToRestaurant');
const AdminOutcomePreviewDtoFoodEnum
_$adminOutcomePreviewDtoFoodEnum_destroyed =
    const AdminOutcomePreviewDtoFoodEnum._('destroyed');

AdminOutcomePreviewDtoFoodEnum _$adminOutcomePreviewDtoFoodEnumValueOf(
  String name,
) {
  switch (name) {
    case 'keptByCaptain':
      return _$adminOutcomePreviewDtoFoodEnum_keptByCaptain;
    case 'returnedToRestaurant':
      return _$adminOutcomePreviewDtoFoodEnum_returnedToRestaurant;
    case 'destroyed':
      return _$adminOutcomePreviewDtoFoodEnum_destroyed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOutcomePreviewDtoFoodEnum>
_$adminOutcomePreviewDtoFoodEnumValues =
    BuiltSet<AdminOutcomePreviewDtoFoodEnum>(
      const <AdminOutcomePreviewDtoFoodEnum>[
        _$adminOutcomePreviewDtoFoodEnum_keptByCaptain,
        _$adminOutcomePreviewDtoFoodEnum_returnedToRestaurant,
        _$adminOutcomePreviewDtoFoodEnum_destroyed,
      ],
    );

Serializer<AdminOutcomePreviewDtoOutcomeEnum>
_$adminOutcomePreviewDtoOutcomeEnumSerializer =
    _$AdminOutcomePreviewDtoOutcomeEnumSerializer();
Serializer<AdminOutcomePreviewDtoResponsibleEnum>
_$adminOutcomePreviewDtoResponsibleEnumSerializer =
    _$AdminOutcomePreviewDtoResponsibleEnumSerializer();
Serializer<AdminOutcomePreviewDtoFoodEnum>
_$adminOutcomePreviewDtoFoodEnumSerializer =
    _$AdminOutcomePreviewDtoFoodEnumSerializer();

class _$AdminOutcomePreviewDtoOutcomeEnumSerializer
    implements PrimitiveSerializer<AdminOutcomePreviewDtoOutcomeEnum> {
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
  final Iterable<Type> types = const <Type>[AdminOutcomePreviewDtoOutcomeEnum];
  @override
  final String wireName = 'AdminOutcomePreviewDtoOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomePreviewDtoOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOutcomePreviewDtoOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOutcomePreviewDtoOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOutcomePreviewDtoResponsibleEnumSerializer
    implements PrimitiveSerializer<AdminOutcomePreviewDtoResponsibleEnum> {
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
    AdminOutcomePreviewDtoResponsibleEnum,
  ];
  @override
  final String wireName = 'AdminOutcomePreviewDtoResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomePreviewDtoResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOutcomePreviewDtoResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOutcomePreviewDtoResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOutcomePreviewDtoFoodEnumSerializer
    implements PrimitiveSerializer<AdminOutcomePreviewDtoFoodEnum> {
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
  final Iterable<Type> types = const <Type>[AdminOutcomePreviewDtoFoodEnum];
  @override
  final String wireName = 'AdminOutcomePreviewDtoFoodEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomePreviewDtoFoodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOutcomePreviewDtoFoodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOutcomePreviewDtoFoodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOutcomePreviewDto extends AdminOutcomePreviewDto {
  @override
  final AdminOutcomePreviewDtoOutcomeEnum outcome;
  @override
  final AdminOutcomePreviewDtoResponsibleEnum responsible;
  @override
  final bool delivered;
  @override
  final AdminOutcomePreviewDtoFoodEnum? food;

  factory _$AdminOutcomePreviewDto([
    void Function(AdminOutcomePreviewDtoBuilder)? updates,
  ]) => (AdminOutcomePreviewDtoBuilder()..update(updates))._build();

  _$AdminOutcomePreviewDto._({
    required this.outcome,
    required this.responsible,
    required this.delivered,
    this.food,
  }) : super._();
  @override
  AdminOutcomePreviewDto rebuild(
    void Function(AdminOutcomePreviewDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOutcomePreviewDtoBuilder toBuilder() =>
      AdminOutcomePreviewDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOutcomePreviewDto &&
        outcome == other.outcome &&
        responsible == other.responsible &&
        delivered == other.delivered &&
        food == other.food;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, outcome.hashCode);
    _$hash = $jc(_$hash, responsible.hashCode);
    _$hash = $jc(_$hash, delivered.hashCode);
    _$hash = $jc(_$hash, food.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOutcomePreviewDto')
          ..add('outcome', outcome)
          ..add('responsible', responsible)
          ..add('delivered', delivered)
          ..add('food', food))
        .toString();
  }
}

class AdminOutcomePreviewDtoBuilder
    implements Builder<AdminOutcomePreviewDto, AdminOutcomePreviewDtoBuilder> {
  _$AdminOutcomePreviewDto? _$v;

  AdminOutcomePreviewDtoOutcomeEnum? _outcome;
  AdminOutcomePreviewDtoOutcomeEnum? get outcome => _$this._outcome;
  set outcome(AdminOutcomePreviewDtoOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  AdminOutcomePreviewDtoResponsibleEnum? _responsible;
  AdminOutcomePreviewDtoResponsibleEnum? get responsible => _$this._responsible;
  set responsible(AdminOutcomePreviewDtoResponsibleEnum? responsible) =>
      _$this._responsible = responsible;

  bool? _delivered;
  bool? get delivered => _$this._delivered;
  set delivered(bool? delivered) => _$this._delivered = delivered;

  AdminOutcomePreviewDtoFoodEnum? _food;
  AdminOutcomePreviewDtoFoodEnum? get food => _$this._food;
  set food(AdminOutcomePreviewDtoFoodEnum? food) => _$this._food = food;

  AdminOutcomePreviewDtoBuilder() {
    AdminOutcomePreviewDto._defaults(this);
  }

  AdminOutcomePreviewDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _outcome = $v.outcome;
      _responsible = $v.responsible;
      _delivered = $v.delivered;
      _food = $v.food;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOutcomePreviewDto other) {
    _$v = other as _$AdminOutcomePreviewDto;
  }

  @override
  void update(void Function(AdminOutcomePreviewDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOutcomePreviewDto build() => _build();

  _$AdminOutcomePreviewDto _build() {
    final _$result =
        _$v ??
        _$AdminOutcomePreviewDto._(
          outcome: BuiltValueNullFieldError.checkNotNull(
            outcome,
            r'AdminOutcomePreviewDto',
            'outcome',
          ),
          responsible: BuiltValueNullFieldError.checkNotNull(
            responsible,
            r'AdminOutcomePreviewDto',
            'responsible',
          ),
          delivered: BuiltValueNullFieldError.checkNotNull(
            delivered,
            r'AdminOutcomePreviewDto',
            'delivered',
          ),
          food: food,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
