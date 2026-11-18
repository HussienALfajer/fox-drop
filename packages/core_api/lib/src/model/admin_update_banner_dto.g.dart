// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_update_banner_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminUpdateBannerDtoTargetEnum
_$adminUpdateBannerDtoTargetEnum_restaurant =
    const AdminUpdateBannerDtoTargetEnum._('restaurant');
const AdminUpdateBannerDtoTargetEnum _$adminUpdateBannerDtoTargetEnum_category =
    const AdminUpdateBannerDtoTargetEnum._('category');
const AdminUpdateBannerDtoTargetEnum
_$adminUpdateBannerDtoTargetEnum_restaurants =
    const AdminUpdateBannerDtoTargetEnum._('restaurants');
const AdminUpdateBannerDtoTargetEnum _$adminUpdateBannerDtoTargetEnum_code =
    const AdminUpdateBannerDtoTargetEnum._('code');

AdminUpdateBannerDtoTargetEnum _$adminUpdateBannerDtoTargetEnumValueOf(
  String name,
) {
  switch (name) {
    case 'restaurant':
      return _$adminUpdateBannerDtoTargetEnum_restaurant;
    case 'category':
      return _$adminUpdateBannerDtoTargetEnum_category;
    case 'restaurants':
      return _$adminUpdateBannerDtoTargetEnum_restaurants;
    case 'code':
      return _$adminUpdateBannerDtoTargetEnum_code;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminUpdateBannerDtoTargetEnum>
_$adminUpdateBannerDtoTargetEnumValues =
    BuiltSet<AdminUpdateBannerDtoTargetEnum>(
      const <AdminUpdateBannerDtoTargetEnum>[
        _$adminUpdateBannerDtoTargetEnum_restaurant,
        _$adminUpdateBannerDtoTargetEnum_category,
        _$adminUpdateBannerDtoTargetEnum_restaurants,
        _$adminUpdateBannerDtoTargetEnum_code,
      ],
    );

Serializer<AdminUpdateBannerDtoTargetEnum>
_$adminUpdateBannerDtoTargetEnumSerializer =
    _$AdminUpdateBannerDtoTargetEnumSerializer();

class _$AdminUpdateBannerDtoTargetEnumSerializer
    implements PrimitiveSerializer<AdminUpdateBannerDtoTargetEnum> {
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
  final Iterable<Type> types = const <Type>[AdminUpdateBannerDtoTargetEnum];
  @override
  final String wireName = 'AdminUpdateBannerDtoTargetEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminUpdateBannerDtoTargetEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminUpdateBannerDtoTargetEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminUpdateBannerDtoTargetEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminUpdateBannerDto extends AdminUpdateBannerDto {
  @override
  final String cityId;
  @override
  final String title;
  @override
  final AdminUpdateBannerDtoTargetEnum target;
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
  final String? uploadId;

  factory _$AdminUpdateBannerDto([
    void Function(AdminUpdateBannerDtoBuilder)? updates,
  ]) => (AdminUpdateBannerDtoBuilder()..update(updates))._build();

  _$AdminUpdateBannerDto._({
    required this.cityId,
    required this.title,
    required this.target,
    required this.restaurantIds,
    this.categoryId,
    this.codeId,
    required this.zoneIds,
    required this.startsAt,
    required this.endsAt,
    this.uploadId,
  }) : super._();
  @override
  AdminUpdateBannerDto rebuild(
    void Function(AdminUpdateBannerDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminUpdateBannerDtoBuilder toBuilder() =>
      AdminUpdateBannerDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminUpdateBannerDto &&
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
    return (newBuiltValueToStringHelper(r'AdminUpdateBannerDto')
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

class AdminUpdateBannerDtoBuilder
    implements Builder<AdminUpdateBannerDto, AdminUpdateBannerDtoBuilder> {
  _$AdminUpdateBannerDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  AdminUpdateBannerDtoTargetEnum? _target;
  AdminUpdateBannerDtoTargetEnum? get target => _$this._target;
  set target(AdminUpdateBannerDtoTargetEnum? target) => _$this._target = target;

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

  AdminUpdateBannerDtoBuilder() {
    AdminUpdateBannerDto._defaults(this);
  }

  AdminUpdateBannerDtoBuilder get _$this {
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
  void replace(AdminUpdateBannerDto other) {
    _$v = other as _$AdminUpdateBannerDto;
  }

  @override
  void update(void Function(AdminUpdateBannerDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminUpdateBannerDto build() => _build();

  _$AdminUpdateBannerDto _build() {
    _$AdminUpdateBannerDto _$result;
    try {
      _$result =
          _$v ??
          _$AdminUpdateBannerDto._(
            cityId: BuiltValueNullFieldError.checkNotNull(
              cityId,
              r'AdminUpdateBannerDto',
              'cityId',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'AdminUpdateBannerDto',
              'title',
            ),
            target: BuiltValueNullFieldError.checkNotNull(
              target,
              r'AdminUpdateBannerDto',
              'target',
            ),
            restaurantIds: restaurantIds.build(),
            categoryId: categoryId,
            codeId: codeId,
            zoneIds: zoneIds.build(),
            startsAt: BuiltValueNullFieldError.checkNotNull(
              startsAt,
              r'AdminUpdateBannerDto',
              'startsAt',
            ),
            endsAt: BuiltValueNullFieldError.checkNotNull(
              endsAt,
              r'AdminUpdateBannerDto',
              'endsAt',
            ),
            uploadId: uploadId,
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
          r'AdminUpdateBannerDto',
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
