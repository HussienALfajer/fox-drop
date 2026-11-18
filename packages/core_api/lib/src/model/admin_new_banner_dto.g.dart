// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_new_banner_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminNewBannerDtoTargetEnum _$adminNewBannerDtoTargetEnum_restaurant =
    const AdminNewBannerDtoTargetEnum._('restaurant');
const AdminNewBannerDtoTargetEnum _$adminNewBannerDtoTargetEnum_category =
    const AdminNewBannerDtoTargetEnum._('category');
const AdminNewBannerDtoTargetEnum _$adminNewBannerDtoTargetEnum_restaurants =
    const AdminNewBannerDtoTargetEnum._('restaurants');
const AdminNewBannerDtoTargetEnum _$adminNewBannerDtoTargetEnum_code =
    const AdminNewBannerDtoTargetEnum._('code');

AdminNewBannerDtoTargetEnum _$adminNewBannerDtoTargetEnumValueOf(String name) {
  switch (name) {
    case 'restaurant':
      return _$adminNewBannerDtoTargetEnum_restaurant;
    case 'category':
      return _$adminNewBannerDtoTargetEnum_category;
    case 'restaurants':
      return _$adminNewBannerDtoTargetEnum_restaurants;
    case 'code':
      return _$adminNewBannerDtoTargetEnum_code;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminNewBannerDtoTargetEnum>
_$adminNewBannerDtoTargetEnumValues =
    BuiltSet<AdminNewBannerDtoTargetEnum>(const <AdminNewBannerDtoTargetEnum>[
      _$adminNewBannerDtoTargetEnum_restaurant,
      _$adminNewBannerDtoTargetEnum_category,
      _$adminNewBannerDtoTargetEnum_restaurants,
      _$adminNewBannerDtoTargetEnum_code,
    ]);

Serializer<AdminNewBannerDtoTargetEnum>
_$adminNewBannerDtoTargetEnumSerializer =
    _$AdminNewBannerDtoTargetEnumSerializer();

class _$AdminNewBannerDtoTargetEnumSerializer
    implements PrimitiveSerializer<AdminNewBannerDtoTargetEnum> {
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
  final Iterable<Type> types = const <Type>[AdminNewBannerDtoTargetEnum];
  @override
  final String wireName = 'AdminNewBannerDtoTargetEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminNewBannerDtoTargetEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminNewBannerDtoTargetEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminNewBannerDtoTargetEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminNewBannerDto extends AdminNewBannerDto {
  @override
  final String cityId;
  @override
  final String title;
  @override
  final AdminNewBannerDtoTargetEnum target;
  @override
  final BuiltList<String> restaurantIds;
  @override
  final String? categoryId;
  @override
  final String? codeId;
  @override
  final BuiltList<String> zoneIds;
  @override
  final DateTime startsAt;
  @override
  final DateTime endsAt;
  @override
  final String uploadId;

  factory _$AdminNewBannerDto([
    void Function(AdminNewBannerDtoBuilder)? updates,
  ]) => (AdminNewBannerDtoBuilder()..update(updates))._build();

  _$AdminNewBannerDto._({
    required this.cityId,
    required this.title,
    required this.target,
    required this.restaurantIds,
    this.categoryId,
    this.codeId,
    required this.zoneIds,
    required this.startsAt,
    required this.endsAt,
    required this.uploadId,
  }) : super._();
  @override
  AdminNewBannerDto rebuild(void Function(AdminNewBannerDtoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AdminNewBannerDtoBuilder toBuilder() =>
      AdminNewBannerDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminNewBannerDto &&
        cityId == other.cityId &&
        title == other.title &&
        target == other.target &&
        restaurantIds == other.restaurantIds &&
        categoryId == other.categoryId &&
        codeId == other.codeId &&
        zoneIds == other.zoneIds &&
        startsAt == other.startsAt &&
        endsAt == other.endsAt &&
        uploadId == other.uploadId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, target.hashCode);
    _$hash = $jc(_$hash, restaurantIds.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, codeId.hashCode);
    _$hash = $jc(_$hash, zoneIds.hashCode);
    _$hash = $jc(_$hash, startsAt.hashCode);
    _$hash = $jc(_$hash, endsAt.hashCode);
    _$hash = $jc(_$hash, uploadId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminNewBannerDto')
          ..add('cityId', cityId)
          ..add('title', title)
          ..add('target', target)
          ..add('restaurantIds', restaurantIds)
          ..add('categoryId', categoryId)
          ..add('codeId', codeId)
          ..add('zoneIds', zoneIds)
          ..add('startsAt', startsAt)
          ..add('endsAt', endsAt)
          ..add('uploadId', uploadId))
        .toString();
  }
}

class AdminNewBannerDtoBuilder
    implements Builder<AdminNewBannerDto, AdminNewBannerDtoBuilder> {
  _$AdminNewBannerDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  AdminNewBannerDtoTargetEnum? _target;
  AdminNewBannerDtoTargetEnum? get target => _$this._target;
  set target(AdminNewBannerDtoTargetEnum? target) => _$this._target = target;

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

  ListBuilder<String>? _zoneIds;
  ListBuilder<String> get zoneIds => _$this._zoneIds ??= ListBuilder<String>();
  set zoneIds(ListBuilder<String>? zoneIds) => _$this._zoneIds = zoneIds;

  DateTime? _startsAt;
  DateTime? get startsAt => _$this._startsAt;
  set startsAt(DateTime? startsAt) => _$this._startsAt = startsAt;

  DateTime? _endsAt;
  DateTime? get endsAt => _$this._endsAt;
  set endsAt(DateTime? endsAt) => _$this._endsAt = endsAt;

  String? _uploadId;
  String? get uploadId => _$this._uploadId;
  set uploadId(String? uploadId) => _$this._uploadId = uploadId;

  AdminNewBannerDtoBuilder() {
    AdminNewBannerDto._defaults(this);
  }

  AdminNewBannerDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _title = $v.title;
      _target = $v.target;
      _restaurantIds = $v.restaurantIds.toBuilder();
      _categoryId = $v.categoryId;
      _codeId = $v.codeId;
      _zoneIds = $v.zoneIds.toBuilder();
      _startsAt = $v.startsAt;
      _endsAt = $v.endsAt;
      _uploadId = $v.uploadId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminNewBannerDto other) {
    _$v = other as _$AdminNewBannerDto;
  }

  @override
  void update(void Function(AdminNewBannerDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminNewBannerDto build() => _build();

  _$AdminNewBannerDto _build() {
    _$AdminNewBannerDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminNewBannerDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminNewBannerDto',
              'cityId',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'AdminNewBannerDto',
              'title',
            ),
            target: BuiltValueNullFieldError.checkNotNull(
              target,
              r'AdminNewBannerDto',
              'target',
            ),
            restaurantIds: restaurantIds.build(),
            categoryId: categoryId,
            codeId: codeId,
            zoneIds: zoneIds.build(),
            startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt,
              r'AdminNewBannerDto',
              'startsAt',
            ),
            endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt,
              r'AdminNewBannerDto',
              'endsAt',
            ),
            uploadId: BuiltValueNullFieldError.checkNotNull(
              uploadId,
              r'AdminNewBannerDto',
              'uploadId',
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
          r'AdminNewBannerDto',
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
