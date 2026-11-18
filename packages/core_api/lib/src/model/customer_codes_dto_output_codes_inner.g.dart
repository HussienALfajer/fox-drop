// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_codes_dto_output_codes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerCodesDtoOutputCodesInnerKindEnum
_$customerCodesDtoOutputCodesInnerKindEnum_percentage =
    const CustomerCodesDtoOutputCodesInnerKindEnum._('percentage');
const CustomerCodesDtoOutputCodesInnerKindEnum
_$customerCodesDtoOutputCodesInnerKindEnum_fixedAmount =
    const CustomerCodesDtoOutputCodesInnerKindEnum._('fixedAmount');
const CustomerCodesDtoOutputCodesInnerKindEnum
_$customerCodesDtoOutputCodesInnerKindEnum_freeDelivery =
    const CustomerCodesDtoOutputCodesInnerKindEnum._('freeDelivery');

CustomerCodesDtoOutputCodesInnerKindEnum
_$customerCodesDtoOutputCodesInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'percentage':
      return _$customerCodesDtoOutputCodesInnerKindEnum_percentage;
    case 'fixedAmount':
      return _$customerCodesDtoOutputCodesInnerKindEnum_fixedAmount;
    case 'freeDelivery':
      return _$customerCodesDtoOutputCodesInnerKindEnum_freeDelivery;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerCodesDtoOutputCodesInnerKindEnum>
_$customerCodesDtoOutputCodesInnerKindEnumValues =
    BuiltSet<CustomerCodesDtoOutputCodesInnerKindEnum>(
      const <CustomerCodesDtoOutputCodesInnerKindEnum>[
        _$customerCodesDtoOutputCodesInnerKindEnum_percentage,
        _$customerCodesDtoOutputCodesInnerKindEnum_fixedAmount,
        _$customerCodesDtoOutputCodesInnerKindEnum_freeDelivery,
      ],
    );

Serializer<CustomerCodesDtoOutputCodesInnerKindEnum>
_$customerCodesDtoOutputCodesInnerKindEnumSerializer =
    _$CustomerCodesDtoOutputCodesInnerKindEnumSerializer();

class _$CustomerCodesDtoOutputCodesInnerKindEnumSerializer
    implements PrimitiveSerializer<CustomerCodesDtoOutputCodesInnerKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'percentage': 'percentage',
    'fixedAmount': 'fixed_amount',
    'freeDelivery': 'free_delivery',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'percentage': 'percentage',
    'fixed_amount': 'fixedAmount',
    'free_delivery': 'freeDelivery',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerCodesDtoOutputCodesInnerKindEnum,
  ];
  @override
  final String wireName = 'CustomerCodesDtoOutputCodesInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerCodesDtoOutputCodesInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerCodesDtoOutputCodesInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerCodesDtoOutputCodesInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerCodesDtoOutputCodesInner
    extends CustomerCodesDtoOutputCodesInner {
  @override
  final String code;
  @override
  final CustomerCodesDtoOutputCodesInnerKindEnum kind;
  @override
  final int? percentBp;
  @override
  final String? amount;
  @override
  final String? maxDiscount;
  @override
  final String? minOrder;
  @override
  final BuiltList<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?> restaurants;
  @override
  final BuiltList<String> zones;
  @override
  final CustomerQuoteDtoOutputAvailableCodesInnerHours? hours;
  @override
  final DateTime validTo;
  @override
  final int? usesLeft;
  @override
  final CustomerCodesDtoOutputCodesInnerEnded? ended;

  factory _$CustomerCodesDtoOutputCodesInner([
    void Function(CustomerCodesDtoOutputCodesInnerBuilder)? updates,
  ]) => (CustomerCodesDtoOutputCodesInnerBuilder()..update(updates))._build();

  _$CustomerCodesDtoOutputCodesInner._({
    required this.code,
    required this.kind,
    this.percentBp,
    this.amount,
    this.maxDiscount,
    this.minOrder,
    required this.restaurants,
    required this.zones,
    this.hours,
    required this.validTo,
    this.usesLeft,
    this.ended,
  }) : super._();
  @override
  CustomerCodesDtoOutputCodesInner rebuild(
    void Function(CustomerCodesDtoOutputCodesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerCodesDtoOutputCodesInnerBuilder toBuilder() =>
      CustomerCodesDtoOutputCodesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerCodesDtoOutputCodesInner &&
        code == other.code &&
        kind == other.kind &&
        percentBp == other.percentBp &&
        amount == other.amount &&
        maxDiscount == other.maxDiscount &&
        minOrder == other.minOrder &&
        restaurants == other.restaurants &&
        zones == other.zones &&
        hours == other.hours &&
        validTo == other.validTo &&
        usesLeft == other.usesLeft &&
        ended == other.ended;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, percentBp.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, maxDiscount.hashCode);
    _$hash = $jc(_$hash, minOrder.hashCode);
    _$hash = $jc(_$hash, restaurants.hashCode);
    _$hash = $jc(_$hash, zones.hashCode);
    _$hash = $jc(_$hash, hours.hashCode);
    _$hash = $jc(_$hash, validTo.hashCode);
    _$hash = $jc(_$hash, usesLeft.hashCode);
    _$hash = $jc(_$hash, ended.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerCodesDtoOutputCodesInner')
          ..add('code', code)
          ..add('kind', kind)
          ..add('percentBp', percentBp)
          ..add('amount', amount)
          ..add('maxDiscount', maxDiscount)
          ..add('minOrder', minOrder)
          ..add('restaurants', restaurants)
          ..add('zones', zones)
          ..add('hours', hours)
          ..add('validTo', validTo)
          ..add('usesLeft', usesLeft)
          ..add('ended', ended))
        .toString();
  }
}

class CustomerCodesDtoOutputCodesInnerBuilder
    implements
        Builder<
          CustomerCodesDtoOutputCodesInner,
          CustomerCodesDtoOutputCodesInnerBuilder
        > {
  _$CustomerCodesDtoOutputCodesInner? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CustomerCodesDtoOutputCodesInnerKindEnum? _kind;
  CustomerCodesDtoOutputCodesInnerKindEnum? get kind => _$this._kind;
  set kind(CustomerCodesDtoOutputCodesInnerKindEnum? kind) =>
      _$this._kind = kind;

  int? _percentBp;
  int? get percentBp => _$this._percentBp;
  set percentBp(int? percentBp) => _$this._percentBp = percentBp;

  String? _amount;
  String? get amount => _$this._amount;
  set amount(String? amount) => _$this._amount = amount;

  String? _maxDiscount;
  String? get maxDiscount => _$this._maxDiscount;
  set maxDiscount(String? maxDiscount) => _$this._maxDiscount = maxDiscount;

  String? _minOrder;
  String? get minOrder => _$this._minOrder;
  set minOrder(String? minOrder) => _$this._minOrder = minOrder;

  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>? _restaurants;
  ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>
  get restaurants => _$this._restaurants ??=
      ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>();
  set restaurants(
    ListBuilder<CaptainPeakBonusDtoOutputWindowsInnerZonesInner?>? restaurants,
  ) => _$this._restaurants = restaurants;

  ListBuilder<String>? _zones;
  ListBuilder<String> get zones => _$this._zones ??= ListBuilder<String>();
  set zones(ListBuilder<String>? zones) => _$this._zones = zones;

  CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder? _hours;
  CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder get hours =>
      _$this._hours ??= CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder();
  set hours(CustomerQuoteDtoOutputAvailableCodesInnerHoursBuilder? hours) =>
      _$this._hours = hours;

  DateTime? _validTo;
  DateTime? get validTo => _$this._validTo;
  set validTo(DateTime? validTo) => _$this._validTo = validTo;

  int? _usesLeft;
  int? get usesLeft => _$this._usesLeft;
  set usesLeft(int? usesLeft) => _$this._usesLeft = usesLeft;

  CustomerCodesDtoOutputCodesInnerEndedBuilder? _ended;
  CustomerCodesDtoOutputCodesInnerEndedBuilder get ended =>
      _$this._ended ??= CustomerCodesDtoOutputCodesInnerEndedBuilder();
  set ended(CustomerCodesDtoOutputCodesInnerEndedBuilder? ended) =>
      _$this._ended = ended;

  CustomerCodesDtoOutputCodesInnerBuilder() {
    CustomerCodesDtoOutputCodesInner._defaults(this);
  }

  CustomerCodesDtoOutputCodesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _kind = $v.kind;
      _percentBp = $v.percentBp;
      _amount = $v.amount;
      _maxDiscount = $v.maxDiscount;
      _minOrder = $v.minOrder;
      _restaurants = $v.restaurants.toBuilder();
      _zones = $v.zones.toBuilder();
      _hours = $v.hours?.toBuilder();
      _validTo = $v.validTo;
      _usesLeft = $v.usesLeft;
      _ended = $v.ended?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerCodesDtoOutputCodesInner other) {
    _$v = other as _$CustomerCodesDtoOutputCodesInner;
  }

  @override
  void update(void Function(CustomerCodesDtoOutputCodesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CustomerCodesDtoOutputCodesInner build() => _build();

  _$CustomerCodesDtoOutputCodesInner _build() {
    _$CustomerCodesDtoOutputCodesInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerCodesDtoOutputCodesInner._(
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'CustomerCodesDtoOutputCodesInner',
              'code',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'CustomerCodesDtoOutputCodesInner',
              'kind',
            ),
            percentBp: percentBp,
            amount: amount,
            maxDiscount: maxDiscount,
            minOrder: minOrder,
            restaurants: restaurants.build(),
            zones: zones.build(),
            hours: _hours?.build(),
            validTo: BuiltValueNullFieldError.checkNotNull(
              validTo,
              r'CustomerCodesDtoOutputCodesInner',
              'validTo',
            ),
            usesLeft: usesLeft,
            ended: _ended?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurants';
        restaurants.build();
        _$failedField = 'zones';
        zones.build();
        _$failedField = 'hours';
        _hours?.build();

        _$failedField = 'ended';
        _ended?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerCodesDtoOutputCodesInner',
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
