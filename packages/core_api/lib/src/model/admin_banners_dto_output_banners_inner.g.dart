// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_banners_dto_output_banners_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminBannersDtoOutputBannersInnerTargetEnum
_$adminBannersDtoOutputBannersInnerTargetEnum_restaurant =
    const AdminBannersDtoOutputBannersInnerTargetEnum._('restaurant');
const AdminBannersDtoOutputBannersInnerTargetEnum
_$adminBannersDtoOutputBannersInnerTargetEnum_category =
    const AdminBannersDtoOutputBannersInnerTargetEnum._('category');
const AdminBannersDtoOutputBannersInnerTargetEnum
_$adminBannersDtoOutputBannersInnerTargetEnum_restaurants =
    const AdminBannersDtoOutputBannersInnerTargetEnum._('restaurants');
const AdminBannersDtoOutputBannersInnerTargetEnum
_$adminBannersDtoOutputBannersInnerTargetEnum_code =
    const AdminBannersDtoOutputBannersInnerTargetEnum._('code');

AdminBannersDtoOutputBannersInnerTargetEnum
_$adminBannersDtoOutputBannersInnerTargetEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminBannersDtoOutputBannersInnerTargetEnum_restaurant;
    case 'category':
      return _$adminBannersDtoOutputBannersInnerTargetEnum_category;
    case 'restaurants':
      return _$adminBannersDtoOutputBannersInnerTargetEnum_restaurants;
    case 'code':
      return _$adminBannersDtoOutputBannersInnerTargetEnum_code;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminBannersDtoOutputBannersInnerTargetEnum>
_$adminBannersDtoOutputBannersInnerTargetEnumValues =
    BuiltSet<AdminBannersDtoOutputBannersInnerTargetEnum>(
      const <AdminBannersDtoOutputBannersInnerTargetEnum>[
        _$adminBannersDtoOutputBannersInnerTargetEnum_restaurant,
        _$adminBannersDtoOutputBannersInnerTargetEnum_category,
        _$adminBannersDtoOutputBannersInnerTargetEnum_restaurants,
        _$adminBannersDtoOutputBannersInnerTargetEnum_code,
      ],
    );

Serializer<AdminBannersDtoOutputBannersInnerTargetEnum>
_$adminBannersDtoOutputBannersInnerTargetEnumSerializer =
    _$AdminBannersDtoOutputBannersInnerTargetEnumSerializer();

class _$AdminBannersDtoOutputBannersInnerTargetEnumSerializer
    implements
        PrimitiveSerializer<AdminBannersDtoOutputBannersInnerTargetEnum> {
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
    AdminBannersDtoOutputBannersInnerTargetEnum,
  ];
  @override
  final String wireName = 'AdminBannersDtoOutputBannersInnerTargetEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminBannersDtoOutputBannersInnerTargetEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminBannersDtoOutputBannersInnerTargetEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminBannersDtoOutputBannersInnerTargetEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminBannersDtoOutputBannersInner
    extends AdminBannersDtoOutputBannersInner {
  @override
  final String id;
  @override
  final String title;
  @override
  final String imageKey;
  @override
  final AdminBannersDtoOutputBannersInnerTargetEnum target;
  @override
  final BuiltList<String> restaurantIds;
  @override
  final String? categoryId;
  @override
  final String? codeId;
  @override
  final String? code;
  @override
  final BuiltList<String> zoneIds;
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;

  factory _$AdminBannersDtoOutputBannersInner([
    void Function(AdminBannersDtoOutputBannersInnerBuilder)? updates,
  ]) => (AdminBannersDtoOutputBannersInnerBuilder()..update(updates))._build();

  _$AdminBannersDtoOutputBannersInner._({
    required this.id,
    required this.title,
    required this.imageKey,
    required this.target,
    required this.restaurantIds,
    this.categoryId,
    this.codeId,
    this.code,
    required this.zoneIds,
    required this.startsAt,
    required this.endsAt,
  }) : super._();
  @override
  AdminBannersDtoOutputBannersInner rebuild(
    void Function(AdminBannersDtoOutputBannersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminBannersDtoOutputBannersInnerBuilder toBuilder() =>
      AdminBannersDtoOutputBannersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminBannersDtoOutputBannersInner &&
        id == other.id &&
        title == other.title &&
        imageKey == other.imageKey &&
        target == other.target &&
        restaurantIds == other.restaurantIds &&
        categoryId == other.categoryId &&
        codeId == other.codeId &&
        code == other.code &&
        zoneIds == other.zoneIds &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt;
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
    _$hash = $jc(_$hash, codeId.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, zoneIds.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminBannersDtoOutputBannersInner')
          ..add('id', id)
          ..add('title', title)
          ..add('imageKey', imageKey)
          ..add('target', target)
          ..add('restaurantIds', restaurantIds)
          ..add('categoryId', categoryId)
          ..add('codeId', codeId)
          ..add('code', code)
          ..add('zoneIds', zoneIds)
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt))
        .toString();
  }
}

class AdminBannersDtoOutputBannersInnerBuilder
    implements
        Builder<
          AdminBannersDtoOutputBannersInner,
          AdminBannersDtoOutputBannersInnerBuilder
        > {
  _$AdminBannersDtoOutputBannersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _imageKey;
  String? get imageKey => _$this._imageKey;
  set imageKey(String? imageKey) => _$this._imageKey = imageKey;

  AdminBannersDtoOutputBannersInnerTargetEnum? _target;
  AdminBannersDtoOutputBannersInnerTargetEnum? get target => _$this._target;
  set target(AdminBannersDtoOutputBannersInnerTargetEnum? target) =>
      _$this._target = target;

  ListBuilder<String>? _restaurantIds;
  ListBuilder<String> get restaurantIds =>
      _$this._restaurantIds ??= ListBuilder<String>();
  set restaurantIds(ListBuilder<String>? restaurantIds) =>
      _$this._restaurantIds = restaurantIds;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _codeId;
  String? get codeId => _$this._codeId;
  set codeId(String? codeId) => _$this._codeId = codeId;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  ListBuilder<String>? _zoneIds;
  ListBuilder<String> get zoneIds => _$this._zoneIds ??= ListBuilder<String>();
  set zoneIds(ListBuilder<String>? zoneIds) => _$this._zoneIds = zoneIds;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  AdminBannersDtoOutputBannersInnerBuilder() {
    AdminBannersDtoOutputBannersInner._defaults(this);
  }

  AdminBannersDtoOutputBannersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _imageKey = $v.imageKey;
      _target = $v.target;
      _restaurantIds = $v.restaurantIds.toBuilder();
      _categoryId = $v.categoryId;
      _codeId = $v.codeId;
      _code = $v.code;
      _zoneIds = $v.zoneIds.toBuilder();
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminBannersDtoOutputBannersInner other) {
    _$v = other as _$AdminBannersDtoOutputBannersInner;
  }

  @override
  void update(
    void Function(AdminBannersDtoOutputBannersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminBannersDtoOutputBannersInner build() => _build();

  _$AdminBannersDtoOutputBannersInner _build() {
    _$AdminBannersDtoOutputBannersInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminBannersDtoOutputBannersInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminBannersDtoOutputBannersInner',
              'id',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'AdminBannersDtoOutputBannersInner',
              'title',
            ),
            imageKey: BuiltValueNullFieldError.checkNotNull(
              imageKey,
              r'AdminBannersDtoOutputBannersInner',
              'imageKey',
            ),
            target: BuiltValueNullFieldError.checkNotNull(
              target,
              r'AdminBannersDtoOutputBannersInner',
              'target',
            ),
            restaurantIds: restaurantIds.build(),
            categoryId: categoryId,
            codeId: codeId,
            code: code,
            zoneIds: zoneIds.build(),
            startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt,
              r'AdminBannersDtoOutputBannersInner',
              'startsAt',
            ),
            endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt,
              r'AdminBannersDtoOutputBannersInner',
              'endsAt',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'restaurantIds';
        restaurantIds.build();

        _$failedField = 'zoneIds';
        zoneIds.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminBannersDtoOutputBannersInner',
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
