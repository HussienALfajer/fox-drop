// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_item_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminMenuItemDtoBadgeEnum _$adminMenuItemDtoBadgeEnum_new_ =
    const AdminMenuItemDtoBadgeEnum._('new_');
const AdminMenuItemDtoBadgeEnum _$adminMenuItemDtoBadgeEnum_mostOrdered =
    const AdminMenuItemDtoBadgeEnum._('mostOrdered');
const AdminMenuItemDtoBadgeEnum _$adminMenuItemDtoBadgeEnum_spicy =
    const AdminMenuItemDtoBadgeEnum._('spicy');

AdminMenuItemDtoBadgeEnum _$adminMenuItemDtoBadgeEnumValueOf(String name) {
  switch (name) {
    case 'new_':
      return _$adminMenuItemDtoBadgeEnum_new_;
    case 'mostOrdered':
      return _$adminMenuItemDtoBadgeEnum_mostOrdered;
    case 'spicy':
      return _$adminMenuItemDtoBadgeEnum_spicy;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMenuItemDtoBadgeEnum> _$adminMenuItemDtoBadgeEnumValues =
    BuiltSet<AdminMenuItemDtoBadgeEnum>(const <AdminMenuItemDtoBadgeEnum>[
      _$adminMenuItemDtoBadgeEnum_new_,
      _$adminMenuItemDtoBadgeEnum_mostOrdered,
      _$adminMenuItemDtoBadgeEnum_spicy,
    ]);

Serializer<AdminMenuItemDtoBadgeEnum> _$adminMenuItemDtoBadgeEnumSerializer =
    _$AdminMenuItemDtoBadgeEnumSerializer();

class _$AdminMenuItemDtoBadgeEnumSerializer
    implements PrimitiveSerializer<AdminMenuItemDtoBadgeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'new_': 'new',
    'mostOrdered': 'most_ordered',
    'spicy': 'spicy',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'new': 'new_',
    'most_ordered': 'mostOrdered',
    'spicy': 'spicy',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminMenuItemDtoBadgeEnum];
  @override
  final String wireName = 'AdminMenuItemDtoBadgeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuItemDtoBadgeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminMenuItemDtoBadgeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminMenuItemDtoBadgeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminMenuItemDto extends AdminMenuItemDto {
  @override
  final String categoryId;
  @override
  final String? code;
  @override
  final String name;
  @override
  final String? description;
  @override
  final AdminMenuMoney price;
  @override
  final bool hidden;
  @override
  final AdminMenuItemDtoBadgeEnum? badge;

  factory _$AdminMenuItemDto([
    void Function(AdminMenuItemDtoBuilder)? updates,
  ]) => (AdminMenuItemDtoBuilder()..update(updates))._build();

  _$AdminMenuItemDto._({
    required this.categoryId,
    this.code,
    required this.name,
    this.description,
    required this.price,
    required this.hidden,
    this.badge,
  }) : super._();
  @override
  AdminMenuItemDto rebuild(void Function(AdminMenuItemDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminMenuItemDtoBuilder toBuilder() =>
      AdminMenuItemDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuItemDto &&
        categoryId == other.categoryId &&
        code == other.code &&
        name == other.name &&
        description == other.description &&
        price == other.price &&
        hidden == other.hidden &&
        badge == other.badge;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, hidden.hashCode);
    _$hash = $jc(_$hash, badge.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminMenuItemDto')
          ..add('categoryId', categoryId)
          ..add('code', code)
          ..add('name', name)
          ..add('description', description)
          ..add('price', price)
          ..add('hidden', hidden)
          ..add('badge', badge))
        .toString();
  }
}

class AdminMenuItemDtoBuilder
    implements Builder<AdminMenuItemDto, AdminMenuItemDtoBuilder> {
  _$AdminMenuItemDto? _$v;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  AdminMenuMoneyBuilder? _price;
  AdminMenuMoneyBuilder get price => _$this._price ??= AdminMenuMoneyBuilder();
  set price(AdminMenuMoneyBuilder? price) => _$this._price = price;

  bool? _hidden;
  bool? get hidden => _$this._hidden;
  set hidden(bool? hidden) => _$this._hidden = hidden;

  AdminMenuItemDtoBadgeEnum? _badge;
  AdminMenuItemDtoBadgeEnum? get badge => _$this._badge;
  set badge(AdminMenuItemDtoBadgeEnum? badge) => _$this._badge = badge;

  AdminMenuItemDtoBuilder() {
    AdminMenuItemDto._defaults(this);
  }

  AdminMenuItemDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _categoryId = $v.categoryId;
      _code = $v.code;
      _name = $v.name;
      _description = $v.description;
      _price = $v.price.toBuilder();
      _hidden = $v.hidden;
      _badge = $v.badge;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuItemDto other) {
    _$v = other as _$AdminMenuItemDto;
  }

  @override
  void update(void Function(AdminMenuItemDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuItemDto build() => _build();

  _$AdminMenuItemDto _build() {
    _$AdminMenuItemDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuItemDto._(
            categoryId: BuiltValueNullFieldError.checkNotNull(
              categoryId,
              r'AdminMenuItemDto',
              'categoryId',
            ),
            code: code,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminMenuItemDto',
              'name',
            ),
            description: description,
            price: price.build(),
            hidden: BuiltValueNullFieldError.checkNotNull(
              hidden,
              r'AdminMenuItemDto',
              'hidden',
            ),
            badge: badge,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'price';
        price.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuItemDto',
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
