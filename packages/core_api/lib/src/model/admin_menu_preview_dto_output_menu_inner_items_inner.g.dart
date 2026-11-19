// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_preview_dto_output_menu_inner_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
_$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_tomorrow =
    const AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum._(
      'tomorrow',
    );
const AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
_$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_window =
    const AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum._(
      'window',
    );
const AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
_$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_unavailable =
    const AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum._(
      'unavailable',
    );

AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
_$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnumValueOf(
  String name,
) {
  switch (name) {
    case 'tomorrow':
      return _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_tomorrow;
    case 'window':
      return _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_window;
    case 'unavailable':
      return _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_unavailable;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
  AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
>
_$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnumValues =
    BuiltSet<
      AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
    >(const <AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum>[
      _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_tomorrow,
      _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_window,
      _$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum_unavailable,
    ]);

Serializer<AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum>
_$adminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnumSerializer =
    _$AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnumSerializer();

class _$AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnumSerializer
    implements
        PrimitiveSerializer<
          AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum
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
    AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum,
  ];
  @override
  final String wireName =
      'AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum.valueOf(
        _fromWire[serialized] ?? (serialized is String ? serialized : ''),
      );
}

class _$AdminMenuPreviewDtoOutputMenuInnerItemsInner
    extends AdminMenuPreviewDtoOutputMenuInnerItemsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? photoKey;
  @override
  final CaptainAvailabilityDtoOutputCustodyLimit price;
  @override
  final CustomerSearchDtoOutputItemsInnerFromPrice? fromPrice;
  @override
  final bool available;
  @override
  final AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum?
  unavailableReason;
  @override
  final BuiltList<CustomerSearchDtoOutputItemsInnerOptionGroupsInner>
  optionGroups;

  factory _$AdminMenuPreviewDtoOutputMenuInnerItemsInner([
    void Function(AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder)? updates,
  ]) => (AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder()..update(updates))
      ._build();

  _$AdminMenuPreviewDtoOutputMenuInnerItemsInner._({
    required this.id,
    required this.name,
    this.description,
    this.photoKey,
    required this.price,
    this.fromPrice,
    required this.available,
    this.unavailableReason,
    required this.optionGroups,
  }) : super._();
  @override
  AdminMenuPreviewDtoOutputMenuInnerItemsInner rebuild(
    void Function(AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder toBuilder() =>
      AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuPreviewDtoOutputMenuInnerItemsInner &&
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
            r'AdminMenuPreviewDtoOutputMenuInnerItemsInner',
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

class AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder
    implements
        Builder<
          AdminMenuPreviewDtoOutputMenuInnerItemsInner,
          AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder
        > {
  _$AdminMenuPreviewDtoOutputMenuInnerItemsInner? _$v;

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

  CaptainAvailabilityDtoOutputCustodyLimitBuilder? _price;
  CaptainAvailabilityDtoOutputCustodyLimitBuilder get price =>
      _$this._price ??= CaptainAvailabilityDtoOutputCustodyLimitBuilder();
  set price(CaptainAvailabilityDtoOutputCustodyLimitBuilder? price) =>
      _$this._price = price;

  CustomerSearchDtoOutputItemsInnerFromPriceBuilder? _fromPrice;
  CustomerSearchDtoOutputItemsInnerFromPriceBuilder get fromPrice =>
      _$this._fromPrice ??= CustomerSearchDtoOutputItemsInnerFromPriceBuilder();
  set fromPrice(CustomerSearchDtoOutputItemsInnerFromPriceBuilder? fromPrice) =>
      _$this._fromPrice = fromPrice;

  bool? _available;
  bool? get available => _$this._available;
  set available(bool? available) => _$this._available = available;

  AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum?
  _unavailableReason;
  AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum?
  get unavailableReason => _$this._unavailableReason;
  set unavailableReason(
    AdminMenuPreviewDtoOutputMenuInnerItemsInnerUnavailableReasonEnum?
    unavailableReason,
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

  AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder() {
    AdminMenuPreviewDtoOutputMenuInnerItemsInner._defaults(this);
  }

  AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _description = $v.description;
      _photoKey = $v.photoKey;
      _price = $v.price.toBuilder();
      _fromPrice = $v.fromPrice?.toBuilder();
      _available = $v.available;
      _unavailableReason = $v.unavailableReason;
      _optionGroups = $v.optionGroups.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuPreviewDtoOutputMenuInnerItemsInner other) {
    _$v = other as _$AdminMenuPreviewDtoOutputMenuInnerItemsInner;
  }

  @override
  void update(
    void Function(AdminMenuPreviewDtoOutputMenuInnerItemsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuPreviewDtoOutputMenuInnerItemsInner build() => _build();

  _$AdminMenuPreviewDtoOutputMenuInnerItemsInner _build() {
    _$AdminMenuPreviewDtoOutputMenuInnerItemsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuPreviewDtoOutputMenuInnerItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminMenuPreviewDtoOutputMenuInnerItemsInner',
              'id',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminMenuPreviewDtoOutputMenuInnerItemsInner',
              'name',
            ),
            description: description,
            photoKey: photoKey,
            price: price.build(),
            fromPrice: _fromPrice?.build(),
            available: BuiltValueNullFieldError.checkNotNull(
              available,
              r'AdminMenuPreviewDtoOutputMenuInnerItemsInner',
              'available',
            ),
            unavailableReason: unavailableReason,
            optionGroups: optionGroups.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'price';
        price.build();
        _$failedField = 'fromPrice';
        _fromPrice?.build();

        _$failedField = 'optionGroups';
        optionGroups.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuPreviewDtoOutputMenuInnerItemsInner',
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
