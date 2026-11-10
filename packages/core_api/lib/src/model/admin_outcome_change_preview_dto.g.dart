// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_outcome_change_preview_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOutcomeChangePreviewDtoOutcomeEnum
_$adminOutcomeChangePreviewDtoOutcomeEnum_free =
    const AdminOutcomeChangePreviewDtoOutcomeEnum._('free');
const AdminOutcomeChangePreviewDtoOutcomeEnum
_$adminOutcomeChangePreviewDtoOutcomeEnum_fake =
    const AdminOutcomeChangePreviewDtoOutcomeEnum._('fake');
const AdminOutcomeChangePreviewDtoOutcomeEnum
_$adminOutcomeChangePreviewDtoOutcomeEnum_damaged =
    const AdminOutcomeChangePreviewDtoOutcomeEnum._('damaged');
const AdminOutcomeChangePreviewDtoOutcomeEnum
_$adminOutcomeChangePreviewDtoOutcomeEnum_wrongRefused =
    const AdminOutcomeChangePreviewDtoOutcomeEnum._('wrongRefused');
const AdminOutcomeChangePreviewDtoOutcomeEnum
_$adminOutcomeChangePreviewDtoOutcomeEnum_failedOther =
    const AdminOutcomeChangePreviewDtoOutcomeEnum._('failedOther');

AdminOutcomeChangePreviewDtoOutcomeEnum
_$adminOutcomeChangePreviewDtoOutcomeEnumValueOf(String name) {
  switch (name) {
    case 'free':
      return _$adminOutcomeChangePreviewDtoOutcomeEnum_free;
    case 'fake':
      return _$adminOutcomeChangePreviewDtoOutcomeEnum_fake;
    case 'damaged':
      return _$adminOutcomeChangePreviewDtoOutcomeEnum_damaged;
    case 'wrongRefused':
      return _$adminOutcomeChangePreviewDtoOutcomeEnum_wrongRefused;
    case 'failedOther':
      return _$adminOutcomeChangePreviewDtoOutcomeEnum_failedOther;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOutcomeChangePreviewDtoOutcomeEnum>
_$adminOutcomeChangePreviewDtoOutcomeEnumValues =
    BuiltSet<AdminOutcomeChangePreviewDtoOutcomeEnum>(
      const <AdminOutcomeChangePreviewDtoOutcomeEnum>[
        _$adminOutcomeChangePreviewDtoOutcomeEnum_free,
        _$adminOutcomeChangePreviewDtoOutcomeEnum_fake,
        _$adminOutcomeChangePreviewDtoOutcomeEnum_damaged,
        _$adminOutcomeChangePreviewDtoOutcomeEnum_wrongRefused,
        _$adminOutcomeChangePreviewDtoOutcomeEnum_failedOther,
      ],
    );

const AdminOutcomeChangePreviewDtoResponsibleEnum
_$adminOutcomeChangePreviewDtoResponsibleEnum_restaurant =
    const AdminOutcomeChangePreviewDtoResponsibleEnum._('restaurant');
const AdminOutcomeChangePreviewDtoResponsibleEnum
_$adminOutcomeChangePreviewDtoResponsibleEnum_captain =
    const AdminOutcomeChangePreviewDtoResponsibleEnum._('captain');
const AdminOutcomeChangePreviewDtoResponsibleEnum
_$adminOutcomeChangePreviewDtoResponsibleEnum_customer =
    const AdminOutcomeChangePreviewDtoResponsibleEnum._('customer');
const AdminOutcomeChangePreviewDtoResponsibleEnum
_$adminOutcomeChangePreviewDtoResponsibleEnum_platform =
    const AdminOutcomeChangePreviewDtoResponsibleEnum._('platform');

AdminOutcomeChangePreviewDtoResponsibleEnum
_$adminOutcomeChangePreviewDtoResponsibleEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminOutcomeChangePreviewDtoResponsibleEnum_restaurant;
    case 'captain':
      return _$adminOutcomeChangePreviewDtoResponsibleEnum_captain;
    case 'customer':
      return _$adminOutcomeChangePreviewDtoResponsibleEnum_customer;
    case 'platform':
      return _$adminOutcomeChangePreviewDtoResponsibleEnum_platform;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOutcomeChangePreviewDtoResponsibleEnum>
_$adminOutcomeChangePreviewDtoResponsibleEnumValues =
    BuiltSet<AdminOutcomeChangePreviewDtoResponsibleEnum>(
      const <AdminOutcomeChangePreviewDtoResponsibleEnum>[
        _$adminOutcomeChangePreviewDtoResponsibleEnum_restaurant,
        _$adminOutcomeChangePreviewDtoResponsibleEnum_captain,
        _$adminOutcomeChangePreviewDtoResponsibleEnum_customer,
        _$adminOutcomeChangePreviewDtoResponsibleEnum_platform,
      ],
    );

const AdminOutcomeChangePreviewDtoFoodEnum
_$adminOutcomeChangePreviewDtoFoodEnum_keptByCaptain =
    const AdminOutcomeChangePreviewDtoFoodEnum._('keptByCaptain');
const AdminOutcomeChangePreviewDtoFoodEnum
_$adminOutcomeChangePreviewDtoFoodEnum_returnedToRestaurant =
    const AdminOutcomeChangePreviewDtoFoodEnum._('returnedToRestaurant');
const AdminOutcomeChangePreviewDtoFoodEnum
_$adminOutcomeChangePreviewDtoFoodEnum_destroyed =
    const AdminOutcomeChangePreviewDtoFoodEnum._('destroyed');

AdminOutcomeChangePreviewDtoFoodEnum
_$adminOutcomeChangePreviewDtoFoodEnumValueOf(String name) {
  switch (name) {
    case 'keptByCaptain':
      return _$adminOutcomeChangePreviewDtoFoodEnum_keptByCaptain;
    case 'returnedToRestaurant':
      return _$adminOutcomeChangePreviewDtoFoodEnum_returnedToRestaurant;
    case 'destroyed':
      return _$adminOutcomeChangePreviewDtoFoodEnum_destroyed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOutcomeChangePreviewDtoFoodEnum>
_$adminOutcomeChangePreviewDtoFoodEnumValues =
    BuiltSet<AdminOutcomeChangePreviewDtoFoodEnum>(
      const <AdminOutcomeChangePreviewDtoFoodEnum>[
        _$adminOutcomeChangePreviewDtoFoodEnum_keptByCaptain,
        _$adminOutcomeChangePreviewDtoFoodEnum_returnedToRestaurant,
        _$adminOutcomeChangePreviewDtoFoodEnum_destroyed,
      ],
    );

Serializer<AdminOutcomeChangePreviewDtoOutcomeEnum>
_$adminOutcomeChangePreviewDtoOutcomeEnumSerializer =
    _$AdminOutcomeChangePreviewDtoOutcomeEnumSerializer();
Serializer<AdminOutcomeChangePreviewDtoResponsibleEnum>
_$adminOutcomeChangePreviewDtoResponsibleEnumSerializer =
    _$AdminOutcomeChangePreviewDtoResponsibleEnumSerializer();
Serializer<AdminOutcomeChangePreviewDtoFoodEnum>
_$adminOutcomeChangePreviewDtoFoodEnumSerializer =
    _$AdminOutcomeChangePreviewDtoFoodEnumSerializer();

class _$AdminOutcomeChangePreviewDtoOutcomeEnumSerializer
    implements PrimitiveSerializer<AdminOutcomeChangePreviewDtoOutcomeEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminOutcomeChangePreviewDtoOutcomeEnum,
  ];
  @override
  final String wireName = 'AdminOutcomeChangePreviewDtoOutcomeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomeChangePreviewDtoOutcomeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOutcomeChangePreviewDtoOutcomeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOutcomeChangePreviewDtoOutcomeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOutcomeChangePreviewDtoResponsibleEnumSerializer
    implements
        PrimitiveSerializer<AdminOutcomeChangePreviewDtoResponsibleEnum> {
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
    AdminOutcomeChangePreviewDtoResponsibleEnum,
  ];
  @override
  final String wireName = 'AdminOutcomeChangePreviewDtoResponsibleEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomeChangePreviewDtoResponsibleEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOutcomeChangePreviewDtoResponsibleEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOutcomeChangePreviewDtoResponsibleEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOutcomeChangePreviewDtoFoodEnumSerializer
    implements PrimitiveSerializer<AdminOutcomeChangePreviewDtoFoodEnum> {
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
  final Iterable<Type> types = const <Type>[
    AdminOutcomeChangePreviewDtoFoodEnum,
  ];
  @override
  final String wireName = 'AdminOutcomeChangePreviewDtoFoodEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOutcomeChangePreviewDtoFoodEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOutcomeChangePreviewDtoFoodEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOutcomeChangePreviewDtoFoodEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOutcomeChangePreviewDto extends AdminOutcomeChangePreviewDto {
  @override
  final AdminOutcomeChangePreviewDtoOutcomeEnum outcome;
  @override
  final AdminOutcomeChangePreviewDtoResponsibleEnum responsible;
  @override
  final bool delivered;
  @override
  final AdminOutcomeChangePreviewDtoFoodEnum? food;

  factory _$AdminOutcomeChangePreviewDto([
    void Function(AdminOutcomeChangePreviewDtoBuilder)? updates,
  ]) => (AdminOutcomeChangePreviewDtoBuilder()..update(updates))._build();

  _$AdminOutcomeChangePreviewDto._({
    required this.outcome,
    required this.responsible,
    required this.delivered,
    this.food,
  }) : super._();
  @override
  AdminOutcomeChangePreviewDto rebuild(
    void Function(AdminOutcomeChangePreviewDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOutcomeChangePreviewDtoBuilder toBuilder() =>
      AdminOutcomeChangePreviewDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOutcomeChangePreviewDto &&
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
    return (newBuiltValueToStringHelper(r'AdminOutcomeChangePreviewDto')
          ..add('outcome', outcome)
          ..add('responsible', responsible)
          ..add('delivered', delivered)
          ..add('food', food))
        .toString();
  }
}

class AdminOutcomeChangePreviewDtoBuilder
    implements
        Builder<
          AdminOutcomeChangePreviewDto,
          AdminOutcomeChangePreviewDtoBuilder
        > {
  _$AdminOutcomeChangePreviewDto? _$v;

  AdminOutcomeChangePreviewDtoOutcomeEnum? _outcome;
  AdminOutcomeChangePreviewDtoOutcomeEnum? get outcome => _$this._outcome;
  set outcome(AdminOutcomeChangePreviewDtoOutcomeEnum? outcome) =>
      _$this._outcome = outcome;

  AdminOutcomeChangePreviewDtoResponsibleEnum? _responsible;
  AdminOutcomeChangePreviewDtoResponsibleEnum? get responsible =>
      _$this._responsible;
  set responsible(AdminOutcomeChangePreviewDtoResponsibleEnum? responsible) =>
      _$this._responsible = responsible;

  bool? _delivered;
  bool? get delivered => _$this._delivered;
  set delivered(bool? delivered) => _$this._delivered = delivered;

  AdminOutcomeChangePreviewDtoFoodEnum? _food;
  AdminOutcomeChangePreviewDtoFoodEnum? get food => _$this._food;
  set food(AdminOutcomeChangePreviewDtoFoodEnum? food) => _$this._food = food;

  AdminOutcomeChangePreviewDtoBuilder() {
    AdminOutcomeChangePreviewDto._defaults(this);
  }

  AdminOutcomeChangePreviewDtoBuilder get _$this {
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
  void replace(AdminOutcomeChangePreviewDto other) {
    _$v = other as _$AdminOutcomeChangePreviewDto;
  }

  @override
  void update(void Function(AdminOutcomeChangePreviewDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminOutcomeChangePreviewDto build() => _build();

  _$AdminOutcomeChangePreviewDto _build() {
    final _$result =
        _$v ??
        _$AdminOutcomeChangePreviewDto._(
          outcome: BuiltValueNullFieldError.checkNotNull(
            outcome,
            r'AdminOutcomeChangePreviewDto',
            'outcome',
          ),
          responsible: BuiltValueNullFieldError.checkNotNull(
            responsible,
            r'AdminOutcomeChangePreviewDto',
            'responsible',
          ),
          delivered: BuiltValueNullFieldError.checkNotNull(
            delivered,
            r'AdminOutcomeChangePreviewDto',
            'delivered',
          ),
          food: food,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
