// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_page_dto_output_menu_inner_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
_$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_tomorrow =
    const CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum._(
      'tomorrow',
    );
const CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
_$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_window =
    const CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum._(
      'window',
    );
const CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
_$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_unavailable =
    const CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum._(
      'unavailable',
    );

CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
_$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnumValueOf(
  String name,
) {
  switch (name) {
    case 'tomorrow':
      return _$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_tomorrow;
    case 'window':
      return _$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_window;
    case 'unavailable':
      return _$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_unavailable;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
>
_$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnumValues =
    BuiltSet<
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
    >(const <
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
    >[
      _$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_tomorrow,
      _$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_window,
      _$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_unavailable,
    ]);

Serializer<
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
>
_$customerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnumSerializer =
    _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnumSerializer();

class _$CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
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
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum,
  ];
  @override
  final String wireName =
      'CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
    object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
  deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum.valueOf(
        _fromWire[serialized] ?? (serialized is String ? serialized : ''),
      );
}

class _$CustomerRestaurantPageDtoOutputMenuInnerItemsInner
    extends CustomerRestaurantPageDtoOutputMenuInnerItemsInner {
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
  final CaptainWentOfflineDtoOutputHandIn? fromPrice;
  @override
  final bool available;
  @override
  final CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum?
  unavailableReason;
  @override
  final BuiltList<
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner
  >
  optionGroups;

  factory _$CustomerRestaurantPageDtoOutputMenuInnerItemsInner([
    void Function(CustomerRestaurantPageDtoOutputMenuInnerItemsInnerBuilder)?
    updates,
  ]) =>
      (CustomerRestaurantPageDtoOutputMenuInnerItemsInnerBuilder()
            ..update(updates))
          ._build();

  _$CustomerRestaurantPageDtoOutputMenuInnerItemsInner._({
    required this.id,
    required this.name,
    this.description,
    this.photoKey,
    this.price,
    this.fromPrice,
    required this.available,
    this.unavailableReason,
    required this.optionGroups,
  }) : super._();
  @override
  CustomerRestaurantPageDtoOutputMenuInnerItemsInner rebuild(
    void Function(CustomerRestaurantPageDtoOutputMenuInnerItemsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerBuilder toBuilder() =>
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantPageDtoOutputMenuInnerItemsInner &&
        id == other.id &&
        name == other.name &&
        description == other.description &&
        photoKey == other.photoKey &&
        price == other.price &&
        fromPrice == other.fromPrice &&
        available == other.available &&
        unavailableReason == other.unavailableReason &&
        optionGroups == other.optionGroups;
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
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerRestaurantPageDtoOutputMenuInnerItemsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('description', description)
          ..add('photoKey', photoKey)
          ..add('price', price)
          ..add('fromPrice', fromPrice)
          ..add('available', available)
          ..add('unavailableReason', unavailableReason)
          ..add('optionGroups', optionGroups))
        .toString();
  }
}

class CustomerRestaurantPageDtoOutputMenuInnerItemsInnerBuilder
    implements
        Builder<
          CustomerRestaurantPageDtoOutputMenuInnerItemsInner,
          CustomerRestaurantPageDtoOutputMenuInnerItemsInnerBuilder
        > {
  _$CustomerRestaurantPageDtoOutputMenuInnerItemsInner? _$v;

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

  CaptainWentOfflineDtoOutputHandInBuilder? _fromPrice;
  CaptainWentOfflineDtoOutputHandInBuilder get fromPrice =>
      _$this._fromPrice ??= CaptainWentOfflineDtoOutputHandInBuilder();
  set fromPrice(CaptainWentOfflineDtoOutputHandInBuilder? fromPrice) =>
      _$this._fromPrice = fromPrice;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum?
  _unavailableReason;
  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum?
  get unavailableReason => _$this._unavailableReason;
  set unavailableReason(
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerUnavailableReasonEnum?
    unavailableReason,
  ) => _$this._unavailableReason = unavailableReason;

  ListBuilder<
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner
  >?
  _optionGroups;
  ListBuilder<
    CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner
  >
  get optionGroups => _$this._optionGroups ??=
      ListBuilder<
        CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner
      >();
  set optionGroups(
    ListBuilder<
      CustomerRestaurantPageDtoOutputMenuInnerItemsInnerOptionGroupsInner
    >?
    optionGroups,
  ) => _$this._optionGroups = optionGroups;

  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerBuilder() {
    CustomerRestaurantPageDtoOutputMenuInnerItemsInner._defaults(this);
  }

  CustomerRestaurantPageDtoOutputMenuInnerItemsInnerBuilder get _$this {
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
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRestaurantPageDtoOutputMenuInnerItemsInner other) {
    _$v = other as _$CustomerRestaurantPageDtoOutputMenuInnerItemsInner;
  }

  @override
  void update(
    void Function(CustomerRestaurantPageDtoOutputMenuInnerItemsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantPageDtoOutputMenuInnerItemsInner build() => _build();

  _$CustomerRestaurantPageDtoOutputMenuInnerItemsInner _build() {
    _$CustomerRestaurantPageDtoOutputMenuInnerItemsInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRestaurantPageDtoOutputMenuInnerItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerRestaurantPageDtoOutputMenuInnerItemsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'CustomerRestaurantPageDtoOutputMenuInnerItemsInner',
              'name',
            ),
            description: description,
            photoKey: photoKey,
            price: _price?.build(),
            fromPrice: _fromPrice?.build(),
            available: BuiltValueNullFieldError.checkNotNull(
              available,
              r'CustomerRestaurantPageDtoOutputMenuInnerItemsInner',
              'available',
            ),
            unavailableReason: unavailableReason,
            optionGroups: optionGroups.build(),
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
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRestaurantPageDtoOutputMenuInnerItemsInner',
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
