// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_home_sections_dto_output_sections_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminHomeSectionsDtoOutputSectionsInnerKindEnum
_$adminHomeSectionsDtoOutputSectionsInnerKindEnum_banners =
    const AdminHomeSectionsDtoOutputSectionsInnerKindEnum._('banners');
const AdminHomeSectionsDtoOutputSectionsInnerKindEnum
_$adminHomeSectionsDtoOutputSectionsInnerKindEnum_categories =
    const AdminHomeSectionsDtoOutputSectionsInnerKindEnum._('categories');
const AdminHomeSectionsDtoOutputSectionsInnerKindEnum
_$adminHomeSectionsDtoOutputSectionsInnerKindEnum_nearest =
    const AdminHomeSectionsDtoOutputSectionsInnerKindEnum._('nearest');
const AdminHomeSectionsDtoOutputSectionsInnerKindEnum
_$adminHomeSectionsDtoOutputSectionsInnerKindEnum_mostOrdered =
    const AdminHomeSectionsDtoOutputSectionsInnerKindEnum._('mostOrdered');
const AdminHomeSectionsDtoOutputSectionsInnerKindEnum
_$adminHomeSectionsDtoOutputSectionsInnerKindEnum_new_ =
    const AdminHomeSectionsDtoOutputSectionsInnerKindEnum._('new_');
const AdminHomeSectionsDtoOutputSectionsInnerKindEnum
_$adminHomeSectionsDtoOutputSectionsInnerKindEnum_offers =
    const AdminHomeSectionsDtoOutputSectionsInnerKindEnum._('offers');
const AdminHomeSectionsDtoOutputSectionsInnerKindEnum
_$adminHomeSectionsDtoOutputSectionsInnerKindEnum_custom =
    const AdminHomeSectionsDtoOutputSectionsInnerKindEnum._('custom');

AdminHomeSectionsDtoOutputSectionsInnerKindEnum
_$adminHomeSectionsDtoOutputSectionsInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'banners':
      return _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_banners;
    case 'categories':
      return _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_categories;
    case 'nearest':
      return _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_nearest;
    case 'mostOrdered':
      return _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_mostOrdered;
    case 'new_':
      return _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_new_;
    case 'offers':
      return _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_offers;
    case 'custom':
      return _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_custom;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminHomeSectionsDtoOutputSectionsInnerKindEnum>
_$adminHomeSectionsDtoOutputSectionsInnerKindEnumValues =
    BuiltSet<AdminHomeSectionsDtoOutputSectionsInnerKindEnum>(
      const <AdminHomeSectionsDtoOutputSectionsInnerKindEnum>[
        _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_banners,
        _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_categories,
        _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_nearest,
        _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_mostOrdered,
        _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_new_,
        _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_offers,
        _$adminHomeSectionsDtoOutputSectionsInnerKindEnum_custom,
      ],
    );

Serializer<AdminHomeSectionsDtoOutputSectionsInnerKindEnum>
_$adminHomeSectionsDtoOutputSectionsInnerKindEnumSerializer =
    _$AdminHomeSectionsDtoOutputSectionsInnerKindEnumSerializer();

class _$AdminHomeSectionsDtoOutputSectionsInnerKindEnumSerializer
    implements
        PrimitiveSerializer<AdminHomeSectionsDtoOutputSectionsInnerKindEnum> {
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
    AdminHomeSectionsDtoOutputSectionsInnerKindEnum,
  ];
  @override
  final String wireName = 'AdminHomeSectionsDtoOutputSectionsInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminHomeSectionsDtoOutputSectionsInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminHomeSectionsDtoOutputSectionsInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminHomeSectionsDtoOutputSectionsInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminHomeSectionsDtoOutputSectionsInner
    extends AdminHomeSectionsDtoOutputSectionsInner {
  @override
  final String key;
  @override
  final AdminHomeSectionsDtoOutputSectionsInnerKindEnum kind;
  @override
  final String? title;
  @override
  final BuiltList<String> restaurantIds;
  @override
  final bool visible;

  factory _$AdminHomeSectionsDtoOutputSectionsInner([
    void Function(AdminHomeSectionsDtoOutputSectionsInnerBuilder)? updates,
  ]) => (AdminHomeSectionsDtoOutputSectionsInnerBuilder()..update(updates))
      ._build();

  _$AdminHomeSectionsDtoOutputSectionsInner._({
    required this.key,
    required this.kind,
    this.title,
    required this.restaurantIds,
    required this.visible,
  }) : super._();
  @override
  AdminHomeSectionsDtoOutputSectionsInner rebuild(
    void Function(AdminHomeSectionsDtoOutputSectionsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminHomeSectionsDtoOutputSectionsInnerBuilder toBuilder() =>
      AdminHomeSectionsDtoOutputSectionsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminHomeSectionsDtoOutputSectionsInner &&
        key == other.key &&
        kind == other.kind &&
        title == other.title &&
        restaurantIds == other.restaurantIds &&
        visible == other.visible;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, key.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, restaurantIds.hashCode);
    _$hash = $jc(_$hash, visible.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminHomeSectionsDtoOutputSectionsInner',
          )
          ..add('key', key)
          ..add('kind', kind)
          ..add('title', title)
          ..add('restaurantIds', restaurantIds)
          ..add('visible', visible))
        .toString();
  }
}

class AdminHomeSectionsDtoOutputSectionsInnerBuilder
    implements
        Builder<
          AdminHomeSectionsDtoOutputSectionsInner,
          AdminHomeSectionsDtoOutputSectionsInnerBuilder
        > {
  _$AdminHomeSectionsDtoOutputSectionsInner? _$v;

  String? _key;
  String? get key => _$this._key;
  set key(String? key) => _$this._key = key;

  AdminHomeSectionsDtoOutputSectionsInnerKindEnum? _kind;
  AdminHomeSectionsDtoOutputSectionsInnerKindEnum? get kind => _$this._kind;
  set kind(AdminHomeSectionsDtoOutputSectionsInnerKindEnum? kind) =>
      _$this._kind = kind;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  ListBuilder<String>? _restaurantIds;
  ListBuilder<String> get restaurantIds =>
      _$this._restaurantIds ??= ListBuilder<String>();
  set restaurantIds(ListBuilder<String>? restaurantIds) =>
      _$this._restaurantIds = restaurantIds;

  bool? _visible;
  bool? get visible => _$this._visible;
  set visible(bool? visible) => _$this._visible = visible;

  AdminHomeSectionsDtoOutputSectionsInnerBuilder() {
    AdminHomeSectionsDtoOutputSectionsInner._defaults(this);
  }

  AdminHomeSectionsDtoOutputSectionsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _key = $v.key;
      _kind = $v.kind;
      _title = $v.title;
      _restaurantIds = $v.restaurantIds.toBuilder();
      _visible = $v.visible;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminHomeSectionsDtoOutputSectionsInner other) {
    _$v = other as _$AdminHomeSectionsDtoOutputSectionsInner;
  }

  @override
  void update(
    void Function(AdminHomeSectionsDtoOutputSectionsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminHomeSectionsDtoOutputSectionsInner build() => _build();

  _$AdminHomeSectionsDtoOutputSectionsInner _build() {
    _$AdminHomeSectionsDtoOutputSectionsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminHomeSectionsDtoOutputSectionsInner._(
            key: BuiltValueNullFieldError.checkNotNull(
              key,
              r'AdminHomeSectionsDtoOutputSectionsInner',
              'key',
            ),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminHomeSectionsDtoOutputSectionsInner',
              'kind',
            ),
            title: title,
            restaurantIds: restaurantIds.build(),
            visible: BuiltValueNullFieldError.checkNotNull(
              visible,
              r'AdminHomeSectionsDtoOutputSectionsInner',
              'visible',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurantIds';
        restaurantIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminHomeSectionsDtoOutputSectionsInner',
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
