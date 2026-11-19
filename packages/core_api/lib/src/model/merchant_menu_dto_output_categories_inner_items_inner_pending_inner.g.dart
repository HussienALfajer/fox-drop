// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merchant_menu_dto_output_categories_inner_items_inner_pending_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
_$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_created =
    const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum._(
      'created',
    );
const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
_$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_name =
    const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum._(
      'name',
    );
const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
_$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_description =
    const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum._(
      'description',
    );
const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
_$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_photo =
    const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum._(
      'photo',
    );
const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
_$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_choices =
    const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum._(
      'choices',
    );
const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
_$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_items =
    const MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum._(
      'items',
    );

MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
_$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnumValueOf(
  String name,
) {
  switch (name) {
    case 'created':
      return _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_created;
    case 'name':
      return _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_name;
    case 'description':
      return _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_description;
    case 'photo':
      return _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_photo;
    case 'choices':
      return _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_choices;
    case 'items':
      return _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_items;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
>
_$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnumValues =
    BuiltSet<
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
    >(const <
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
    >[
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_created,
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_name,
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_description,
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_photo,
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_choices,
      _$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum_items,
    ]);

Serializer<MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum>
_$merchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnumSerializer =
    _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnumSerializer();

class _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnumSerializer
    implements
        PrimitiveSerializer<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'created': 'created',
    'name': 'name',
    'description': 'description',
    'photo': 'photo',
    'choices': 'choices',
    'items': 'items',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'created': 'created',
    'name': 'name',
    'description': 'description',
    'photo': 'photo',
    'choices': 'choices',
    'items': 'items',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum,
  ];
  @override
  final String wireName =
      'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum';

  @override
  Object serialize(
    Serializers serializers,
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
    object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
  deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum.valueOf(
        _fromWire[serialized] ?? (serialized is String ? serialized : ''),
      );
}

class _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner
    extends MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner {
  @override
  final String requestId;
  @override
  final MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum
  field;
  @override
  final DateTime createdAt;
  @override
  final String? name;
  @override
  final String? description;
  @override
  final String? photoKey;
  @override
  final MerchantPendingMoneyOutput? price;
  @override
  final String? categoryId;
  @override
  final String? groupId;
  @override
  final int? minChoices;
  @override
  final int? maxChoices;
  @override
  final BuiltList<String>? itemIds;
  @override
  final BuiltList<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
  >?
  options;

  factory _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner([
    void Function(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder,
    )?
    updates,
  ]) =>
      (MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder()
            ..update(updates))
          ._build();

  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner._({
    required this.requestId,
    required this.field,
    required this.createdAt,
    this.name,
    this.description,
    this.photoKey,
    this.price,
    this.categoryId,
    this.groupId,
    this.minChoices,
    this.maxChoices,
    this.itemIds,
    this.options,
  }) : super._();
  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner rebuild(
    void Function(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder,
    )
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder
  toBuilder() =>
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder()
        ..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other
            is MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner &&
        requestId == other.requestId &&
        field == other.field &&
        createdAt == other.createdAt &&
        name == other.name &&
        description == other.description &&
        photoKey == other.photoKey &&
        price == other.price &&
        categoryId == other.categoryId &&
        groupId == other.groupId &&
        minChoices == other.minChoices &&
        maxChoices == other.maxChoices &&
        itemIds == other.itemIds &&
        options == other.options;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, requestId.hashCode);
    _$hash = $jc(_$hash, field.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, photoKey.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, groupId.hashCode);
    _$hash = $jc(_$hash, minChoices.hashCode);
    _$hash = $jc(_$hash, maxChoices.hashCode);
    _$hash = $jc(_$hash, itemIds.hashCode);
    _$hash = $jc(_$hash, options.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner',
          )
          ..add('requestId', requestId)
          ..add('field', field)
          ..add('createdAt', createdAt)
          ..add('name', name)
          ..add('description', description)
          ..add('photoKey', photoKey)
          ..add('price', price)
          ..add('categoryId', categoryId)
          ..add('groupId', groupId)
          ..add('minChoices', minChoices)
          ..add('maxChoices', maxChoices)
          ..add('itemIds', itemIds)
          ..add('options', options))
        .toString();
  }
}

class MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder
    implements
        Builder<
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner,
          MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder
        > {
  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner? _$v;

  String? _requestId;
  String? get requestId => _$this._requestId;
  set requestId(String? requestId) => _$this._requestId = requestId;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum? _field;
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum?
  get field => _$this._field;
  set field(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerFieldEnum? field,
  ) => _$this._field = field;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _photoKey;
  String? get photoKey => _$this._photoKey;
  set photoKey(String? photoKey) => _$this._photoKey = photoKey;

  MerchantPendingMoneyOutputBuilder? _price;
  MerchantPendingMoneyOutputBuilder get price =>
      _$this._price ??= MerchantPendingMoneyOutputBuilder();
  set price(MerchantPendingMoneyOutputBuilder? price) => _$this._price = price;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _groupId;
  String? get groupId => _$this._groupId;
  set groupId(String? groupId) => _$this._groupId = groupId;

  int? _minChoices;
  int? get minChoices => _$this._minChoices;
  set minChoices(int? minChoices) => _$this._minChoices = minChoices;

  int? _maxChoices;
  int? get maxChoices => _$this._maxChoices;
  set maxChoices(int? maxChoices) => _$this._maxChoices = maxChoices;

  ListBuilder<String>? _itemIds;
  ListBuilder<String> get itemIds => _$this._itemIds ??= ListBuilder<String>();
  set itemIds(ListBuilder<String>? itemIds) => _$this._itemIds = itemIds;

  ListBuilder<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
  >?
  _options;
  ListBuilder<
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
  >
  get options => _$this._options ??=
      ListBuilder<
        MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
      >();
  set options(
    ListBuilder<
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerOptionsInner
    >?
    options,
  ) => _$this._options = options;

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder() {
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner._defaults(this);
  }

  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _requestId = $v.requestId;
      _field = $v.field;
      _createdAt = $v.createdAt;
      _name = $v.name;
      _description = $v.description;
      _photoKey = $v.photoKey;
      _price = $v.price?.toBuilder();
      _categoryId = $v.categoryId;
      _groupId = $v.groupId;
      _minChoices = $v.minChoices;
      _maxChoices = $v.maxChoices;
      _itemIds = $v.itemIds?.toBuilder();
      _options = $v.options?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(
    MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner other,
  ) {
    _$v = other as _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner;
  }

  @override
  void update(
    void Function(
      MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInnerBuilder,
    )?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner build() =>
      _build();

  _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner _build() {
    _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner _$result;
    try {
      _$result =
          _$v ??
          _$MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner._(
            requestId: BuiltValueNullFieldError.checkNotNull(
              requestId,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner',
              'requestId',
            ),
            field: BuiltValueNullFieldError.checkNotNull(
              field,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner',
              'field',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner',
              'createdAt',
            ),
            name: name,
            description: description,
            photoKey: photoKey,
            price: _price?.build(),
            categoryId: categoryId,
            groupId: groupId,
            minChoices: minChoices,
            maxChoices: maxChoices,
            itemIds: _itemIds?.build(),
            options: _options?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'price';
        _price?.build();

        _$failedField = 'itemIds';
        _itemIds?.build();
        _$failedField = 'options';
        _options?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'MerchantMenuDtoOutputCategoriesInnerItemsInnerPendingInner',
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
