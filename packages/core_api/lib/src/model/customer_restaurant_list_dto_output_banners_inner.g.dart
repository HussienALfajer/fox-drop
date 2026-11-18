// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_restaurant_list_dto_output_banners_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const CustomerRestaurantListDtoOutputBannersInnerTargetEnum
_$customerRestaurantListDtoOutputBannersInnerTargetEnum_restaurant =
    const CustomerRestaurantListDtoOutputBannersInnerTargetEnum._('restaurant');
const CustomerRestaurantListDtoOutputBannersInnerTargetEnum
_$customerRestaurantListDtoOutputBannersInnerTargetEnum_category =
    const CustomerRestaurantListDtoOutputBannersInnerTargetEnum._('category');
const CustomerRestaurantListDtoOutputBannersInnerTargetEnum
_$customerRestaurantListDtoOutputBannersInnerTargetEnum_restaurants =
    const CustomerRestaurantListDtoOutputBannersInnerTargetEnum._(
      'restaurants',
    );
const CustomerRestaurantListDtoOutputBannersInnerTargetEnum
_$customerRestaurantListDtoOutputBannersInnerTargetEnum_code =
    const CustomerRestaurantListDtoOutputBannersInnerTargetEnum._('code');

CustomerRestaurantListDtoOutputBannersInnerTargetEnum
_$customerRestaurantListDtoOutputBannersInnerTargetEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$customerRestaurantListDtoOutputBannersInnerTargetEnum_restaurant;
    case 'category':
      return _$customerRestaurantListDtoOutputBannersInnerTargetEnum_category;
    case 'restaurants':
      return _$customerRestaurantListDtoOutputBannersInnerTargetEnum_restaurants;
    case 'code':
      return _$customerRestaurantListDtoOutputBannersInnerTargetEnum_code;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<CustomerRestaurantListDtoOutputBannersInnerTargetEnum>
_$customerRestaurantListDtoOutputBannersInnerTargetEnumValues =
    BuiltSet<CustomerRestaurantListDtoOutputBannersInnerTargetEnum>(
      const <CustomerRestaurantListDtoOutputBannersInnerTargetEnum>[
        _$customerRestaurantListDtoOutputBannersInnerTargetEnum_restaurant,
        _$customerRestaurantListDtoOutputBannersInnerTargetEnum_category,
        _$customerRestaurantListDtoOutputBannersInnerTargetEnum_restaurants,
        _$customerRestaurantListDtoOutputBannersInnerTargetEnum_code,
      ],
    );

Serializer<CustomerRestaurantListDtoOutputBannersInnerTargetEnum>
_$customerRestaurantListDtoOutputBannersInnerTargetEnumSerializer =
    _$CustomerRestaurantListDtoOutputBannersInnerTargetEnumSerializer();

class _$CustomerRestaurantListDtoOutputBannersInnerTargetEnumSerializer
    implements
        PrimitiveSerializer<
          CustomerRestaurantListDtoOutputBannersInnerTargetEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'restaurant': 'restaurant',
    'category': 'category',
    'restaurants': 'restaurants',
    'code': 'code',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'restaurant': 'restaurant',
    'category': 'category',
    'restaurants': 'restaurants',
    'code': 'code',
  };

  @override
  final Iterable<Type> types = const <Type>[
    CustomerRestaurantListDtoOutputBannersInnerTargetEnum,
  ];
  @override
  final String wireName =
      'CustomerRestaurantListDtoOutputBannersInnerTargetEnum';

  @override
  Object serialize(
    Serializers serializers,
    CustomerRestaurantListDtoOutputBannersInnerTargetEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  CustomerRestaurantListDtoOutputBannersInnerTargetEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => CustomerRestaurantListDtoOutputBannersInnerTargetEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$CustomerRestaurantListDtoOutputBannersInner
    extends CustomerRestaurantListDtoOutputBannersInner {
  @override
  final String id;
  @override
  final String title;
  @override
  final String imageKey;
  @override
  final CustomerRestaurantListDtoOutputBannersInnerTargetEnum target;
  @override
  final BuiltList<String> restaurantIds;
  @override
  final String? categoryId;
  @override
  final String? code;

  factory _$CustomerRestaurantListDtoOutputBannersInner([
    void Function(CustomerRestaurantListDtoOutputBannersInnerBuilder)? updates,
  ]) => (CustomerRestaurantListDtoOutputBannersInnerBuilder()..update(updates))
      ._build();

  _$CustomerRestaurantListDtoOutputBannersInner._({
    required this.id,
    required this.title,
    required this.imageKey,
    required this.target,
    required this.restaurantIds,
    this.categoryId,
    this.code,
  }) : super._();
  @override
  CustomerRestaurantListDtoOutputBannersInner rebuild(
    void Function(CustomerRestaurantListDtoOutputBannersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  CustomerRestaurantListDtoOutputBannersInnerBuilder toBuilder() =>
      CustomerRestaurantListDtoOutputBannersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CustomerRestaurantListDtoOutputBannersInner &&
        id == other.id &&
        title == other.title &&
        imageKey == other.imageKey &&
        target == other.target &&
        restaurantIds == other.restaurantIds &&
        categoryId == other.categoryId &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, imageKey.hashCode);
    _$hash = $jc(_$hash, target.hashCode);
    _$hash = $jc(_$hash, restaurantIds.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'CustomerRestaurantListDtoOutputBannersInner',
          )
          ..add('id', id)
          ..add('title', title)
          ..add('imageKey', imageKey)
          ..add('target', target)
          ..add('restaurantIds', restaurantIds)
          ..add('categoryId', categoryId)
          ..add('code', code))
        .toString();
  }
}

class CustomerRestaurantListDtoOutputBannersInnerBuilder
    implements
        Builder<
          CustomerRestaurantListDtoOutputBannersInner,
          CustomerRestaurantListDtoOutputBannersInnerBuilder
        > {
  _$CustomerRestaurantListDtoOutputBannersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _imageKey;
  String? get imageKey => _$this._imageKey;
  set imageKey(String? imageKey) => _$this._imageKey = imageKey;

  CustomerRestaurantListDtoOutputBannersInnerTargetEnum? _target;
  CustomerRestaurantListDtoOutputBannersInnerTargetEnum? get target =>
      _$this._target;
  set target(CustomerRestaurantListDtoOutputBannersInnerTargetEnum? target) =>
      _$this._target = target;

  ListBuilder<String>? _restaurantIds;
  ListBuilder<String> get restaurantIds =>
      _$this._restaurantIds ??= ListBuilder<String>();
  set restaurantIds(ListBuilder<String>? restaurantIds) =>
      _$this._restaurantIds = restaurantIds;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  CustomerRestaurantListDtoOutputBannersInnerBuilder() {
    CustomerRestaurantListDtoOutputBannersInner._defaults(this);
  }

  CustomerRestaurantListDtoOutputBannersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _imageKey = $v.imageKey;
      _target = $v.target;
      _restaurantIds = $v.restaurantIds.toBuilder();
      _categoryId = $v.categoryId;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CustomerRestaurantListDtoOutputBannersInner other) {
    _$v = other as _$CustomerRestaurantListDtoOutputBannersInner;
  }

  @override
  void update(
    void Function(CustomerRestaurantListDtoOutputBannersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  CustomerRestaurantListDtoOutputBannersInner build() => _build();

  _$CustomerRestaurantListDtoOutputBannersInner _build() {
    _$CustomerRestaurantListDtoOutputBannersInner _$result;
    try {
      _$result =
          _$v ??
          _$CustomerRestaurantListDtoOutputBannersInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'CustomerRestaurantListDtoOutputBannersInner',
              'id',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'CustomerRestaurantListDtoOutputBannersInner',
              'title',
            ),
            imageKey: BuiltValueNullFieldError.checkNotNull(
              imageKey,
              r'CustomerRestaurantListDtoOutputBannersInner',
              'imageKey',
            ),
            target: BuiltValueNullFieldError.checkNotNull(
              target,
              r'CustomerRestaurantListDtoOutputBannersInner',
              'target',
            ),
            restaurantIds: restaurantIds.build(),
            categoryId: categoryId,
            code: code,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurantIds';
        restaurantIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'CustomerRestaurantListDtoOutputBannersInner',
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
