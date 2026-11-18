// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_search_dto_output_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum
_$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_tomorrow =
    const CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum._('tomorrow');
const CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum
_$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_window =
    const CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum._('window');
const CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum
_$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_unavailable =
    const CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum._(
      'unavailable',
    );

CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum
_$customerSearchDtoOutputItemsInnerUnavailableReasonEnumValueOf(String name) {
  switch (name) {
    case 'tomorrow':
      return _$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_tomorrow;
    case 'window':
      return _$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_window;
    case 'unavailable':
      return _$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_unavailable;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum>
_$customerSearchDtoOutputItemsInnerUnavailableReasonEnumValues =
    BuiltSet<CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum>(
      const <CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum>[
        _$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_tomorrow,
        _$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_window,
        _$customerSearchDtoOutputItemsInnerUnavailableReasonEnum_unavailable,
      ],
    );

Serializer<CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum>
_$customerSearchDtoOutputItemsInnerUnavailableReasonEnumSerializer =
    _$CustomerSearchDtoOutputItemsInnerUnavailableReasonEnumSerializer();

class _$CustomerSearchDtoOutputItemsInnerUnavailableReasonEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'tomorrow': 'tomorrow',
    'window': 'window',
    'unavailable': 'unavailable',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'tomorrow': 'tomorrow',
    'window': 'window',
    'unavailable': 'unavailable',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum,
  ];
  @override
  final String wireName =
      'CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerSearchDtoOutputItemsInner
    extends CustomerSearchDtoOutputItemsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? photoKey;
  @override
  final CaptainWentOfflineDtoOutputHandIn? price;
  @override
  final CustomerSearchDtoOutputItemsInnerFromPrice? fromPrice;
  @override
  final bool available;
  @override
  final CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum?
  unavailableReason;
  @override
  final BuiltList<CustomerSearchDtoOutputItemsInnerOptionGroupsInner>
  optionGroups;
  @override
  final String restaurantId;
  @override
  final String restaurantName;
  @override
  final CustomerRestaurantListDtoOutputRestaurantsInnerState restaurantState;

  factory _$CustomerSearchDtoOutputItemsInner([
    void Function(CustomerSearchDtoOutputItemsInnerBuilder)? updates,
  ]) => (CustomerSearchDtoOutputItemsInnerBuilder()..update(updates))._build();

  _$CustomerSearchDtoOutputItemsInner._({
    required this.id,
    required this.name,
    this.description,
    this.photoKey,
    this.price,
    this.fromPrice,
    required this.available,
    this.unavailableReason,
    required this.optionGroups,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantState,
  }) : super._();
  @override
  CustomerSearchDtoOutputItemsInner rebuild(
    void Function(CustomerSearchDtoOutputItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerSearchDtoOutputItemsInnerBuilder toBuilder() =>
      CustomerSearchDtoOutputItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerSearchDtoOutputItemsInner &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        photoKey == other.photoKey &&
        price == other.price &&
        fromPrice == other.fromPrice &&
        available == other.available &&
        unavailableReason == other.unavailableReason &&
        optionGroups == other.optionGroups &&
        restaurantId == other.restaurantId &&
        restaurantName == other.restaurantName &&
        restaurantState == other.restaurantState;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, photoKey.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, fromPrice.hashCode);
    _$hash = $jc(_$hash, available.hashCode);
    _$hash = $jc(_$hash, unavailableReason.hashCode);
    _$hash = $jc(_$hash, optionGroups.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, restaurantState.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CustomerSearchDtoOutputItemsInner')
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('photoKey', photoKey)
          ..add('price', price)
          ..add('fromPrice', fromPrice)
          ..add('available', available)
          ..add('unavailableReason', unavailableReason)
          ..add('optionGroups', optionGroups)
          ..add('restaurantId', restaurantId)
          ..add('restaurantName', restaurantName)
          ..add('restaurantState', restaurantState))
        .toString();
  }
}

class CustomerSearchDtoOutputItemsInnerBuilder
    implements
        Builder<
          CustomerSearchDtoOutputItemsInner,
          CustomerSearchDtoOutputItemsInnerBuilder
        > {
  _$CustomerSearchDtoOutputItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _photoKey;
  String? get photoKey => _$this._photoKey;
  set photoKey(String? photoKey) => _$this._photoKey = photoKey;

  CaptainWentOfflineDtoOutputHandInBuilder? _price;
  CaptainWentOfflineDtoOutputHandInBuilder get price =>
      _$this._price ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set price(CaptainWentOfflineDtoOutputHandInBuilder? price) =>
      _$this._price = price;

  CustomerSearchDtoOutputItemsInnerFromPriceBuilder? _fromPrice;
  CustomerSearchDtoOutputItemsInnerFromPriceBuilder get fromPrice =>
      _$this._fromPrice ??= CustomerSearchDtoOutputItemsInnerFromPriceBuilder();
  set fromPrice(CustomerSearchDtoOutputItemsInnerFromPriceBuilder? fromPrice) =>
      _$this._fromPrice = fromPrice;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum? _unavailableReason;
  CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum?
  get unavailableReason => _$this._unavailableReason;
  set unavailableReason(
    CustomerSearchDtoOutputItemsInnerUnavailableReasonEnum? unavailableReason,
  ) => _$this._unavailableReason = unavailableReason;

  ListBuilder<CustomerSearchDtoOutputItemsInnerOptionGroupsInner>?
  _optionGroups;
  ListBuilder<CustomerSearchDtoOutputItemsInnerOptionGroupsInner>
  get optionGroups => _$this._optionGroups ??=
      ListBuilder<CustomerSearchDtoOutputItemsInnerOptionGroupsInner>();
  set optionGroups(
    ListBuilder<CustomerSearchDtoOutputItemsInnerOptionGroupsInner>?
    optionGroups,
  ) => _$this._optionGroups = optionGroups;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder? _restaurantState;
  CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder
  get restaurantState => _$this._restaurantState ??=
      CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder();
  set restaurantState(
    CustomerRestaurantListDtoOutputRestaurantsInnerStateBuilder?
    restaurantState,
  ) => _$this._restaurantState = restaurantState;

  CustomerSearchDtoOutputItemsInnerBuilder() {
    CustomerSearchDtoOutputItemsInner._defaults(this);
  }

  CustomerSearchDtoOutputItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _photoKey = $v.photoKey;
      _price = $v.price?.toBuilder();
      _fromPrice = $v.fromPrice?.toBuilder();
      _available = $v.available;
      _unavailableReason = $v.unavailableReason;
      _optionGroups = $v.optionGroups.toBuilder();
      _restaurantId = $v.restaurantId;
      _restaurantName = $v.restaurantName;
      _restaurantState = $v.restaurantState.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerSearchDtoOutputItemsInner other) {
    _$v = other as _$CustomerSearchDtoOutputItemsInner;
  }

  @override
  void update(
    void Function(CustomerSearchDtoOutputItemsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerSearchDtoOutputItemsInner build() => _build();

  _$CustomerSearchDtoOutputItemsInner _build() {
    _$CustomerSearchDtoOutputItemsInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerSearchDtoOutputItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerSearchDtoOutputItemsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CustomerSearchDtoOutputItemsInner',
              'name',
            ),
            description: description,
            photoKey: photoKey,
            price: _price?.build(),
            fromPrice: _fromPrice?.build(),
            available: BuiltValueNullFieldError.checkNotNull(
              available,
              r'CustomerSearchDtoOutputItemsInner',
              'available',
            ),
            unavailableReason: unavailableReason,
            optionGroups: optionGroups.build(),
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'CustomerSearchDtoOutputItemsInner',
              'restaurantId',
            ),
            restaurantName: BuiltValueNullFieldError.checkNotNull(
              restaurantName,
              r'CustomerSearchDtoOutputItemsInner',
              'restaurantName',
            ),
            restaurantState: restaurantState.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'price';
        _price?.build();
        _$failedField = 'fromPrice';
        _fromPrice?.build();

        _$failedField = 'optionGroups';
        optionGroups.build();

        _$failedField = 'restaurantState';
        restaurantState.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerSearchDtoOutputItemsInner',
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
