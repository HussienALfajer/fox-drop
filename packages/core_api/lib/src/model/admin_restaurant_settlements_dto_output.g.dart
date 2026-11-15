// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_settlements_dto_output.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
_$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_saturday =
    const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum._(
      'saturday',
    );
const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
_$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_sunday =
    const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum._('sunday');
const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
_$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_monday =
    const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum._('monday');
const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
_$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_tuesday =
    const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum._('tuesday');
const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
_$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_wednesday =
    const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum._(
      'wednesday',
    );
const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
_$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_thursday =
    const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum._(
      'thursday',
    );
const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
_$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_friday =
    const AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum._('friday');

AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
_$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnumValueOf(String name) {
  switch (name) {
    case 'saturday':
      return _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_saturday;
    case 'sunday':
      return _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_sunday;
    case 'monday':
      return _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_monday;
    case 'tuesday':
      return _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_tuesday;
    case 'wednesday':
      return _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_wednesday;
    case 'thursday':
      return _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_thursday;
    case 'friday':
      return _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_friday;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum>
_$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnumValues =
    BuiltSet<AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum>(
      const <AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum>[
        _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_saturday,
        _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_sunday,
        _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_monday,
        _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_tuesday,
        _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_wednesday,
        _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_thursday,
        _$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnum_friday,
      ],
    );

Serializer<AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum>
_$adminRestaurantSettlementsDtoOutputSettlementWeekdayEnumSerializer =
    _$AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnumSerializer();

class _$AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnumSerializer
    implements
        PrimitiveSerializer<
          AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'saturday': 'saturday',
    'sunday': 'sunday',
    'monday': 'monday',
    'tuesday': 'tuesday',
    'wednesday': 'wednesday',
    'thursday': 'thursday',
    'friday': 'friday',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'saturday': 'saturday',
    'sunday': 'sunday',
    'monday': 'monday',
    'tuesday': 'tuesday',
    'wednesday': 'wednesday',
    'thursday': 'thursday',
    'friday': 'friday',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum,
  ];
  @override
  final String wireName =
      'AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantSettlementsDtoOutput
    extends AdminRestaurantSettlementsDtoOutput {
  @override
  final String? currency;
  @override
  final AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum
  settlementWeekday;
  @override
  final DateTime nextCutoff;
  @override
  final BuiltList<AdminRestaurantSettlementsDtoOutputRestaurantsInner>
  restaurants;

  factory _$AdminRestaurantSettlementsDtoOutput([
    void Function(AdminRestaurantSettlementsDtoOutputBuilder)? updates,
  ]) =>
      (AdminRestaurantSettlementsDtoOutputBuilder()..update(updates))._build();

  _$AdminRestaurantSettlementsDtoOutput._({
    this.currency,
    required this.settlementWeekday,
    required this.nextCutoff,
    required this.restaurants,
  }) : super._();
  @override
  AdminRestaurantSettlementsDtoOutput rebuild(
    void Function(AdminRestaurantSettlementsDtoOutputBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantSettlementsDtoOutputBuilder toBuilder() =>
      AdminRestaurantSettlementsDtoOutputBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantSettlementsDtoOutput &&
        currency == other.currency &&
        settlementWeekday == other.settlementWeekday &&
        nextCutoff == other.nextCutoff &&
        restaurants == other.restaurants;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, currency.hashCode);
    _$hash = $jc(_$hash, settlementWeekday.hashCode);
    _$hash = $jc(_$hash, nextCutoff.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantSettlementsDtoOutput')
          ..add('currency', currency)
          ..add('settlementWeekday', settlementWeekday)
          ..add('nextCutoff', nextCutoff)
          ..add('restaurants', restaurants))
        .toString();
  }
}

class AdminRestaurantSettlementsDtoOutputBuilder
    implements
        Builder<
          AdminRestaurantSettlementsDtoOutput,
          AdminRestaurantSettlementsDtoOutputBuilder
        > {
  _$AdminRestaurantSettlementsDtoOutput? _$v;

  String? _currency;
  String? get currency => _$this._currency;
  set currency(String? currency) => _$this._currency = currency;

  AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum? _settlementWeekday;
  AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum?
  get settlementWeekday => _$this._settlementWeekday;
  set settlementWeekday(
    AdminRestaurantSettlementsDtoOutputSettlementWeekdayEnum? settlementWeekday,
  ) => _$this._settlementWeekday = settlementWeekday;

  DateTime? _nextCutoff;
  DateTime? get nextCutoff => _$this._nextCutoff;
  set nextCutoff(DateTime? nextCutoff) => _$this._nextCutoff = nextCutoff;

  ListBuilder<AdminRestaurantSettlementsDtoOutputRestaurantsInner>?
  _restaurants;
  ListBuilder<AdminRestaurantSettlementsDtoOutputRestaurantsInner>
  get restaurants => _$this._restaurants ??=
      ListBuilder<AdminRestaurantSettlementsDtoOutputRestaurantsInner>();
  set restaurants(
    ListBuilder<AdminRestaurantSettlementsDtoOutputRestaurantsInner>?
    restaurants,
  ) => _$this._restaurants = restaurants;

  AdminRestaurantSettlementsDtoOutputBuilder() {
    AdminRestaurantSettlementsDtoOutput._defaults(this);
  }

  AdminRestaurantSettlementsDtoOutputBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _currency = $v.currency;
      _settlementWeekday = $v.settlementWeekday;
      _nextCutoff = $v.nextCutoff;
      _restaurants = $v.restaurants.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantSettlementsDtoOutput other) {
    _$v = other as _$AdminRestaurantSettlementsDtoOutput;
  }

  @override
  void update(
    void Function(AdminRestaurantSettlementsDtoOutputBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantSettlementsDtoOutput build() => _build();

  _$AdminRestaurantSettlementsDtoOutput _build() {
    _$AdminRestaurantSettlementsDtoOutput _$result;
    try {
      _$result =
          _$v ??
          _$AdminRestaurantSettlementsDtoOutput._(
            currency: currency,
            settlementWeekday: BuiltValueNullFieldError.checkNotNull(
              settlementWeekday,
              r'AdminRestaurantSettlementsDtoOutput',
              'settlementWeekday',
            ),
            nextCutoff: BuiltValueNullFieldError.checkNotNull(
              nextCutoff,
              r'AdminRestaurantSettlementsDtoOutput',
              'nextCutoff',
            ),
            restaurants: restaurants.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurants';
        restaurants.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminRestaurantSettlementsDtoOutput',
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
