// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_restaurant_list_query_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminRestaurantListQueryDtoStatusEnum
_$adminRestaurantListQueryDtoStatusEnum_draft =
    const AdminRestaurantListQueryDtoStatusEnum._('draft');
const AdminRestaurantListQueryDtoStatusEnum
_$adminRestaurantListQueryDtoStatusEnum_test =
    const AdminRestaurantListQueryDtoStatusEnum._('test');
const AdminRestaurantListQueryDtoStatusEnum
_$adminRestaurantListQueryDtoStatusEnum_active =
    const AdminRestaurantListQueryDtoStatusEnum._('active');
const AdminRestaurantListQueryDtoStatusEnum
_$adminRestaurantListQueryDtoStatusEnum_suspended =
    const AdminRestaurantListQueryDtoStatusEnum._('suspended');
const AdminRestaurantListQueryDtoStatusEnum
_$adminRestaurantListQueryDtoStatusEnum_terminated =
    const AdminRestaurantListQueryDtoStatusEnum._('terminated');

AdminRestaurantListQueryDtoStatusEnum
_$adminRestaurantListQueryDtoStatusEnumValueOf(String name) {
  switch (name) {
    case 'draft':
      return _$adminRestaurantListQueryDtoStatusEnum_draft;
    case 'test':
      return _$adminRestaurantListQueryDtoStatusEnum_test;
    case 'active':
      return _$adminRestaurantListQueryDtoStatusEnum_active;
    case 'suspended':
      return _$adminRestaurantListQueryDtoStatusEnum_suspended;
    case 'terminated':
      return _$adminRestaurantListQueryDtoStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminRestaurantListQueryDtoStatusEnum>
_$adminRestaurantListQueryDtoStatusEnumValues =
    BuiltSet<AdminRestaurantListQueryDtoStatusEnum>(
      const <AdminRestaurantListQueryDtoStatusEnum>[
        _$adminRestaurantListQueryDtoStatusEnum_draft,
        _$adminRestaurantListQueryDtoStatusEnum_test,
        _$adminRestaurantListQueryDtoStatusEnum_active,
        _$adminRestaurantListQueryDtoStatusEnum_suspended,
        _$adminRestaurantListQueryDtoStatusEnum_terminated,
      ],
    );

Serializer<AdminRestaurantListQueryDtoStatusEnum>
_$adminRestaurantListQueryDtoStatusEnumSerializer =
    _$AdminRestaurantListQueryDtoStatusEnumSerializer();

class _$AdminRestaurantListQueryDtoStatusEnumSerializer
    implements PrimitiveSerializer<AdminRestaurantListQueryDtoStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'draft': 'draft',
    'test': 'test',
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'draft': 'draft',
    'test': 'test',
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminRestaurantListQueryDtoStatusEnum,
  ];
  @override
  final String wireName = 'AdminRestaurantListQueryDtoStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminRestaurantListQueryDtoStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminRestaurantListQueryDtoStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminRestaurantListQueryDtoStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminRestaurantListQueryDto extends AdminRestaurantListQueryDto {
  @override
  final String cityId;
  @override
  final AdminRestaurantListQueryDtoStatusEnum? status;
  @override
  final String? categoryId;
  @override
  final String? zoneId;
  @override
  final String? q;

  factory _$AdminRestaurantListQueryDto([
    void Function(AdminRestaurantListQueryDtoBuilder)? updates,
  ]) => (AdminRestaurantListQueryDtoBuilder()..update(updates))._build();

  _$AdminRestaurantListQueryDto._({
    required this.cityId,
    this.status,
    this.categoryId,
    this.zoneId,
    this.q,
  }) : super._();
  @override
  AdminRestaurantListQueryDto rebuild(
    void Function(AdminRestaurantListQueryDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminRestaurantListQueryDtoBuilder toBuilder() =>
      AdminRestaurantListQueryDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminRestaurantListQueryDto &&
        cityId == other.cityId &&
        status == other.status &&
        categoryId == other.categoryId &&
        zoneId == other.zoneId &&
        q == other.q;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, categoryId.hashCode);
    _$hash = $jc(_$hash, zoneId.hashCode);
    _$hash = $jc(_$hash, q.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminRestaurantListQueryDto')
          ..add('cityId', cityId)
          ..add('status', status)
          ..add('categoryId', categoryId)
          ..add('zoneId', zoneId)
          ..add('q', q))
        .toString();
  }
}

class AdminRestaurantListQueryDtoBuilder
    implements
        Builder<
          AdminRestaurantListQueryDto,
          AdminRestaurantListQueryDtoBuilder
        > {
  _$AdminRestaurantListQueryDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  AdminRestaurantListQueryDtoStatusEnum? _status;
  AdminRestaurantListQueryDtoStatusEnum? get status => _$this._status;
  set status(AdminRestaurantListQueryDtoStatusEnum? status) =>
      _$this._status = status;

  String? _categoryId;
  String? get categoryId => _$this._categoryId;
  set categoryId(String? categoryId) => _$this._categoryId = categoryId;

  String? _zoneId;
  String? get zoneId => _$this._zoneId;
  set zoneId(String? zoneId) => _$this._zoneId = zoneId;

  String? _q;
  String? get q => _$this._q;
  set q(String? q) => _$this._q = q;

  AdminRestaurantListQueryDtoBuilder() {
    AdminRestaurantListQueryDto._defaults(this);
  }

  AdminRestaurantListQueryDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _status = $v.status;
      _categoryId = $v.categoryId;
      _zoneId = $v.zoneId;
      _q = $v.q;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminRestaurantListQueryDto other) {
    _$v = other as _$AdminRestaurantListQueryDto;
  }

  @override
  void update(void Function(AdminRestaurantListQueryDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminRestaurantListQueryDto build() => _build();

  _$AdminRestaurantListQueryDto _build() {
    final _$result =
        _$v ??
        _$AdminRestaurantListQueryDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminRestaurantListQueryDto',
            'cityId',
          ),
          status: status,
          categoryId: categoryId,
          zoneId: zoneId,
          q: q,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
