// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_list_dto_output_sections_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerRestaurantListDtoOutputSectionsInnerKindEnum
_$customerRestaurantListDtoOutputSectionsInnerKindEnum_banners =
    const CustomerRestaurantListDtoOutputSectionsInnerKindEnum._('banners');
const CustomerRestaurantListDtoOutputSectionsInnerKindEnum
_$customerRestaurantListDtoOutputSectionsInnerKindEnum_categories =
    const CustomerRestaurantListDtoOutputSectionsInnerKindEnum._('categories');
const CustomerRestaurantListDtoOutputSectionsInnerKindEnum
_$customerRestaurantListDtoOutputSectionsInnerKindEnum_nearest =
    const CustomerRestaurantListDtoOutputSectionsInnerKindEnum._('nearest');
const CustomerRestaurantListDtoOutputSectionsInnerKindEnum
_$customerRestaurantListDtoOutputSectionsInnerKindEnum_mostOrdered =
    const CustomerRestaurantListDtoOutputSectionsInnerKindEnum._('mostOrdered');
const CustomerRestaurantListDtoOutputSectionsInnerKindEnum
_$customerRestaurantListDtoOutputSectionsInnerKindEnum_new_ =
    const CustomerRestaurantListDtoOutputSectionsInnerKindEnum._('new_');
const CustomerRestaurantListDtoOutputSectionsInnerKindEnum
_$customerRestaurantListDtoOutputSectionsInnerKindEnum_offers =
    const CustomerRestaurantListDtoOutputSectionsInnerKindEnum._('offers');
const CustomerRestaurantListDtoOutputSectionsInnerKindEnum
_$customerRestaurantListDtoOutputSectionsInnerKindEnum_custom =
    const CustomerRestaurantListDtoOutputSectionsInnerKindEnum._('custom');

CustomerRestaurantListDtoOutputSectionsInnerKindEnum
_$customerRestaurantListDtoOutputSectionsInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'banners':
      return _$customerRestaurantListDtoOutputSectionsInnerKindEnum_banners;
    case 'categories':
      return _$customerRestaurantListDtoOutputSectionsInnerKindEnum_categories;
    case 'nearest':
      return _$customerRestaurantListDtoOutputSectionsInnerKindEnum_nearest;
    case 'mostOrdered':
      return _$customerRestaurantListDtoOutputSectionsInnerKindEnum_mostOrdered;
    case 'new_':
      return _$customerRestaurantListDtoOutputSectionsInnerKindEnum_new_;
    case 'offers':
      return _$customerRestaurantListDtoOutputSectionsInnerKindEnum_offers;
    case 'custom':
      return _$customerRestaurantListDtoOutputSectionsInnerKindEnum_custom;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerRestaurantListDtoOutputSectionsInnerKindEnum>
_$customerRestaurantListDtoOutputSectionsInnerKindEnumValues =
    BuiltSet<CustomerRestaurantListDtoOutputSectionsInnerKindEnum>(
      const <CustomerRestaurantListDtoOutputSectionsInnerKindEnum>[
        _$customerRestaurantListDtoOutputSectionsInnerKindEnum_banners,
        _$customerRestaurantListDtoOutputSectionsInnerKindEnum_categories,
        _$customerRestaurantListDtoOutputSectionsInnerKindEnum_nearest,
        _$customerRestaurantListDtoOutputSectionsInnerKindEnum_mostOrdered,
        _$customerRestaurantListDtoOutputSectionsInnerKindEnum_new_,
        _$customerRestaurantListDtoOutputSectionsInnerKindEnum_offers,
        _$customerRestaurantListDtoOutputSectionsInnerKindEnum_custom,
      ],
    );

Serializer<CustomerRestaurantListDtoOutputSectionsInnerKindEnum>
_$customerRestaurantListDtoOutputSectionsInnerKindEnumSerializer =
    _$CustomerRestaurantListDtoOutputSectionsInnerKindEnumSerializer();

class _$CustomerRestaurantListDtoOutputSectionsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerRestaurantListDtoOutputSectionsInnerKindEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'banners': 'banners',
    'categories': 'categories',
    'nearest': 'nearest',
    'mostOrdered': 'most_ordered',
    'new_': 'new',
    'offers': 'offers',
    'custom': 'custom',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'banners': 'banners',
    'categories': 'categories',
    'nearest': 'nearest',
    'most_ordered': 'mostOrdered',
    'new': 'new_',
    'offers': 'offers',
    'custom': 'custom',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerRestaurantListDtoOutputSectionsInnerKindEnum,
  ];
  @override
  final String wireName =
      'CustomerRestaurantListDtoOutputSectionsInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantListDtoOutputSectionsInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerRestaurantListDtoOutputSectionsInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerRestaurantListDtoOutputSectionsInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerRestaurantListDtoOutputSectionsInner
    extends CustomerRestaurantListDtoOutputSectionsInner {
  @override
  final CustomerRestaurantListDtoOutputSectionsInnerKindEnum kind;
  @override
  final String? title;
  @override
  final BuiltList<String> restaurantIds;

  factory _$CustomerRestaurantListDtoOutputSectionsInner([
    void Function(CustomerRestaurantListDtoOutputSectionsInnerBuilder)? updates,
  ]) => (CustomerRestaurantListDtoOutputSectionsInnerBuilder()..update(updates))
      ._build();

  _$CustomerRestaurantListDtoOutputSectionsInner._({
    required this.kind,
    this.title,
    required this.restaurantIds,
  }) : super._();
  @override
  CustomerRestaurantListDtoOutputSectionsInner rebuild(
    void Function(CustomerRestaurantListDtoOutputSectionsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantListDtoOutputSectionsInnerBuilder toBuilder() =>
      CustomerRestaurantListDtoOutputSectionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantListDtoOutputSectionsInner &&
        kind == other.kind &&
        title == other.title &&
        restaurantIds == other.restaurantIds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, restaurantIds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerRestaurantListDtoOutputSectionsInner',
          )
          ..add('kind', kind)
          ..add('title', title)
          ..add('restaurantIds', restaurantIds))
        .toString();
  }
}

class CustomerRestaurantListDtoOutputSectionsInnerBuilder
    implements
        Builder<
          CustomerRestaurantListDtoOutputSectionsInner,
          CustomerRestaurantListDtoOutputSectionsInnerBuilder
        > {
  _$CustomerRestaurantListDtoOutputSectionsInner? _$v;

  CustomerRestaurantListDtoOutputSectionsInnerKindEnum? _kind;
  CustomerRestaurantListDtoOutputSectionsInnerKindEnum? get kind =>
      _$this._kind;
  set kind(CustomerRestaurantListDtoOutputSectionsInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  ListBuilder<String>? _restaurantIds;
  ListBuilder<String> get restaurantIds =>
      _$this._restaurantIds ??= ListBuilder<String>();
  set restaurantIds(ListBuilder<String>? restaurantIds) =>
      _$this._restaurantIds = restaurantIds;

  CustomerRestaurantListDtoOutputSectionsInnerBuilder() {
    CustomerRestaurantListDtoOutputSectionsInner._defaults(this);
  }

  CustomerRestaurantListDtoOutputSectionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _title = $v.title;
      _restaurantIds = $v.restaurantIds.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRestaurantListDtoOutputSectionsInner other) {
    _$v = other as _$CustomerRestaurantListDtoOutputSectionsInner;
  }

  @override
  void update(
    void Function(CustomerRestaurantListDtoOutputSectionsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantListDtoOutputSectionsInner build() => _build();

  _$CustomerRestaurantListDtoOutputSectionsInner _build() {
    _$CustomerRestaurantListDtoOutputSectionsInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRestaurantListDtoOutputSectionsInner._(
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'CustomerRestaurantListDtoOutputSectionsInner',
              'kind',
            ),
            title: title,
            restaurantIds: restaurantIds.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurantIds';
        restaurantIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRestaurantListDtoOutputSectionsInner',
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
