// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_menu_dto_output_categories_inner_items_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum
_$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_new_ =
    const AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum._('new_');
const AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum
_$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_mostOrdered =
    const AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum._('mostOrdered');
const AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum
_$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_spicy =
    const AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum._('spicy');

AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum
_$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnumValueOf(String name) {
  switch (name) {
    case 'new_':
      return _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_new_;
    case 'mostOrdered':
      return _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_mostOrdered;
    case 'spicy':
      return _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_spicy;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum>
_$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnumValues =
    BuiltSet<AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum>(
      const <AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum>[
        _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_new_,
        _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_mostOrdered,
        _$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum_spicy,
      ],
    );

Serializer<AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum>
_$adminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnumSerializer =
    _$AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnumSerializer();

class _$AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnumSerializer
    implements
        PrimitiveSerializer<
          AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum
        > {
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
  final Iterable<Type> types = const <Type>[
    AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum,
  ];
  @override
  final String wireName =
      'AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminMenuDtoOutputCategoriesInnerItemsInner
    extends AdminMenuDtoOutputCategoriesInnerItemsInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String? description;
  @override
  final String? photoKey;
  @override
  final AdminMenuMoneyOutput price;
  @override
  final bool hidden;
  @override
  final AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum? badge;
  @override
  final AdminMenuSwitchedOffOutput? switchedOff;

  factory _$AdminMenuDtoOutputCategoriesInnerItemsInner([
    void Function(AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder)? updates,
  ]) => (AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder()..update(updates))
      ._build();

  _$AdminMenuDtoOutputCategoriesInnerItemsInner._({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    this.photoKey,
    required this.price,
    required this.hidden,
    this.badge,
    this.switchedOff,
  }) : super._();
  @override
  AdminMenuDtoOutputCategoriesInnerItemsInner rebuild(
    void Function(AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder toBuilder() =>
      AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminMenuDtoOutputCategoriesInnerItemsInner &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        description == other.description &&
        photoKey == other.photoKey &&
        price == other.price &&
        hidden == other.hidden &&
        badge == other.badge &&
        switchedOff == other.switchedOff;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, photoKey.hashCode);
    _$hash = $jc(_$hash, price.hashCode);
    _$hash = $jc(_$hash, hidden.hashCode);
    _$hash = $jc(_$hash, badge.hashCode);
    _$hash = $jc(_$hash, switchedOff.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminMenuDtoOutputCategoriesInnerItemsInner',
          )
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('description', description)
          ..add('photoKey', photoKey)
          ..add('price', price)
          ..add('hidden', hidden)
          ..add('badge', badge)
          ..add('switchedOff', switchedOff))
        .toString();
  }
}

class AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder
    implements
        Builder<
          AdminMenuDtoOutputCategoriesInnerItemsInner,
          AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder
        > {
  _$AdminMenuDtoOutputCategoriesInnerItemsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _photoKey;
  String? get photoKey => _$this._photoKey;
  set photoKey(String? photoKey) => _$this._photoKey = photoKey;

  AdminMenuMoneyOutputBuilder? _price;
  AdminMenuMoneyOutputBuilder get price =>
      _$this._price ??= AdminMenuMoneyOutputBuilder();
  set price(AdminMenuMoneyOutputBuilder? price) => _$this._price = price;

  bool? _hidden;
  bool? get hidden => _$this._hidden;
  set hidden(bool? hidden) => _$this._hidden = hidden;

  AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum? _badge;
  AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum? get badge =>
      _$this._badge;
  set badge(AdminMenuDtoOutputCategoriesInnerItemsInnerBadgeEnum? badge) =>
      _$this._badge = badge;

  AdminMenuSwitchedOffOutputBuilder? _switchedOff;
  AdminMenuSwitchedOffOutputBuilder get switchedOff =>
      _$this._switchedOff ??= AdminMenuSwitchedOffOutputBuilder();
  set switchedOff(AdminMenuSwitchedOffOutputBuilder? switchedOff) =>
      _$this._switchedOff = switchedOff;

  AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder() {
    AdminMenuDtoOutputCategoriesInnerItemsInner._defaults(this);
  }

  AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _description = $v.description;
      _photoKey = $v.photoKey;
      _price = $v.price.toBuilder();
      _hidden = $v.hidden;
      _badge = $v.badge;
      _switchedOff = $v.switchedOff?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminMenuDtoOutputCategoriesInnerItemsInner other) {
    _$v = other as _$AdminMenuDtoOutputCategoriesInnerItemsInner;
  }

  @override
  void update(
    void Function(AdminMenuDtoOutputCategoriesInnerItemsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminMenuDtoOutputCategoriesInnerItemsInner build() => _build();

  _$AdminMenuDtoOutputCategoriesInnerItemsInner _build() {
    _$AdminMenuDtoOutputCategoriesInnerItemsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminMenuDtoOutputCategoriesInnerItemsInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminMenuDtoOutputCategoriesInnerItemsInner',
              'id',
            ),
            code: BuiltValueNullFieldError.checkNotNull(
              code,
              r'AdminMenuDtoOutputCategoriesInnerItemsInner',
              'code',
            ),
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'AdminMenuDtoOutputCategoriesInnerItemsInner',
              'name',
            ),
            description: description,
            photoKey: photoKey,
            price: price.build(),
            hidden: BuiltValueNullFieldError.checkNotNull(
              hidden,
              r'AdminMenuDtoOutputCategoriesInnerItemsInner',
              'hidden',
            ),
            badge: badge,
            switchedOff: _switchedOff?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'price';
        price.build();

        _$failedField = 'switchedOff';
        _switchedOff?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminMenuDtoOutputCategoriesInnerItemsInner',
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
