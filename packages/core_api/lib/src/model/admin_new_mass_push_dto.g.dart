// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_new_mass_push_dto.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminNewMassPushDtoAudienceEnum _$adminNewMassPushDtoAudienceEnum_all =
    const AdminNewMassPushDtoAudienceEnum._('all');
const AdminNewMassPushDtoAudienceEnum _$adminNewMassPushDtoAudienceEnum_zone =
    const AdminNewMassPushDtoAudienceEnum._('zone');
const AdminNewMassPushDtoAudienceEnum
_$adminNewMassPushDtoAudienceEnum_inactive =
    const AdminNewMassPushDtoAudienceEnum._('inactive');
const AdminNewMassPushDtoAudienceEnum
_$adminNewMassPushDtoAudienceEnum_neverOrdered =
    const AdminNewMassPushDtoAudienceEnum._('neverOrdered');

AdminNewMassPushDtoAudienceEnum _$adminNewMassPushDtoAudienceEnumValueOf(
  String name,
) {
  switch (name) {
    case 'all':
      return _$adminNewMassPushDtoAudienceEnum_all;
    case 'zone':
      return _$adminNewMassPushDtoAudienceEnum_zone;
    case 'inactive':
      return _$adminNewMassPushDtoAudienceEnum_inactive;
    case 'neverOrdered':
      return _$adminNewMassPushDtoAudienceEnum_neverOrdered;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminNewMassPushDtoAudienceEnum>
_$adminNewMassPushDtoAudienceEnumValues =
    BuiltSet<AdminNewMassPushDtoAudienceEnum>(
      const <AdminNewMassPushDtoAudienceEnum>[
        _$adminNewMassPushDtoAudienceEnum_all,
        _$adminNewMassPushDtoAudienceEnum_zone,
        _$adminNewMassPushDtoAudienceEnum_inactive,
        _$adminNewMassPushDtoAudienceEnum_neverOrdered,
      ],
    );

const AdminNewMassPushDtoTargetEnum _$adminNewMassPushDtoTargetEnum_home =
    const AdminNewMassPushDtoTargetEnum._('home');
const AdminNewMassPushDtoTargetEnum _$adminNewMassPushDtoTargetEnum_restaurant =
    const AdminNewMassPushDtoTargetEnum._('restaurant');
const AdminNewMassPushDtoTargetEnum _$adminNewMassPushDtoTargetEnum_code =
    const AdminNewMassPushDtoTargetEnum._('code');

AdminNewMassPushDtoTargetEnum _$adminNewMassPushDtoTargetEnumValueOf(
  String name,
) {
  switch (name) {
    case 'home':
      return _$adminNewMassPushDtoTargetEnum_home;
    case 'restaurant':
      return _$adminNewMassPushDtoTargetEnum_restaurant;
    case 'code':
      return _$adminNewMassPushDtoTargetEnum_code;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminNewMassPushDtoTargetEnum>
_$adminNewMassPushDtoTargetEnumValues = BuiltSet<AdminNewMassPushDtoTargetEnum>(
  const <AdminNewMassPushDtoTargetEnum>[
    _$adminNewMassPushDtoTargetEnum_home,
    _$adminNewMassPushDtoTargetEnum_restaurant,
    _$adminNewMassPushDtoTargetEnum_code,
  ],
);

Serializer<AdminNewMassPushDtoAudienceEnum>
_$adminNewMassPushDtoAudienceEnumSerializer =
    _$AdminNewMassPushDtoAudienceEnumSerializer();
Serializer<AdminNewMassPushDtoTargetEnum>
_$adminNewMassPushDtoTargetEnumSerializer =
    _$AdminNewMassPushDtoTargetEnumSerializer();

class _$AdminNewMassPushDtoAudienceEnumSerializer
    implements PrimitiveSerializer<AdminNewMassPushDtoAudienceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'all': 'all',
    'zone': 'zone',
    'inactive': 'inactive',
    'neverOrdered': 'never_ordered',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'all': 'all',
    'zone': 'zone',
    'inactive': 'inactive',
    'never_ordered': 'neverOrdered',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminNewMassPushDtoAudienceEnum];
  @override
  final String wireName = 'AdminNewMassPushDtoAudienceEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminNewMassPushDtoAudienceEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminNewMassPushDtoAudienceEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminNewMassPushDtoAudienceEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminNewMassPushDtoTargetEnumSerializer
    implements PrimitiveSerializer<AdminNewMassPushDtoTargetEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'home': 'home',
    'restaurant': 'restaurant',
    'code': 'code',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'home': 'home',
    'restaurant': 'restaurant',
    'code': 'code',
  };

  @override
  final Iterable<Type> types = const <Type>[AdminNewMassPushDtoTargetEnum];
  @override
  final String wireName = 'AdminNewMassPushDtoTargetEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminNewMassPushDtoTargetEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminNewMassPushDtoTargetEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminNewMassPushDtoTargetEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminNewMassPushDto extends AdminNewMassPushDto {
  @override
  final String cityId;
  @override
  final String title;
  @override
  final String body;
  @override
  final AdminNewMassPushDtoAudienceEnum audience;
  @override
  final String? zoneId;
  @override
  final int? inactiveDays;
  @override
  final AdminNewMassPushDtoTargetEnum target;
  @override
  final String? restaurantId;
  @override
  final String? codeId;
  @override
  final DateTime? sendAt;
  @override
  final int audienceSize;

  factory _$AdminNewMassPushDto([
    void Function(AdminNewMassPushDtoBuilder)? updates,
  ]) => (AdminNewMassPushDtoBuilder()..update(updates))._build();

  _$AdminNewMassPushDto._({
    required this.cityId,
    required this.title,
    required this.body,
    required this.audience,
    this.zoneId,
    this.inactiveDays,
    required this.target,
    this.restaurantId,
    this.codeId,
    this.sendAt,
    required this.audienceSize,
  }) : super._();
  @override
  AdminNewMassPushDto rebuild(
    void Function(AdminNewMassPushDtoBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminNewMassPushDtoBuilder toBuilder() =>
      AdminNewMassPushDtoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminNewMassPushDto &&
        cityId == other.cityId &&
        title == other.title &&
        body == other.body &&
        audience == other.audience &&
        zoneId == other.zoneId &&
        inactiveDays == other.inactiveDays &&
        target == other.target &&
        restaurantId == other.restaurantId &&
        codeId == other.codeId &&
        sendAt == other.sendAt &&
        audienceSize == other.audienceSize;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, cityId.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, audience.hashCode);
    _$hash = $jc(_$hash, zoneId.hashCode);
    _$hash = $jc(_$hash, inactiveDays.hashCode);
    _$hash = $jc(_$hash, target.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, codeId.hashCode);
    _$hash = $jc(_$hash, sendAt.hashCode);
    _$hash = $jc(_$hash, audienceSize.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminNewMassPushDto')
          ..add('cityId', cityId)
          ..add('title', title)
          ..add('body', body)
          ..add('audience', audience)
          ..add('zoneId', zoneId)
          ..add('inactiveDays', inactiveDays)
          ..add('target', target)
          ..add('restaurantId', restaurantId)
          ..add('codeId', codeId)
          ..add('sendAt', sendAt)
          ..add('audienceSize', audienceSize))
        .toString();
  }
}

class AdminNewMassPushDtoBuilder
    implements Builder<AdminNewMassPushDto, AdminNewMassPushDtoBuilder> {
  _$AdminNewMassPushDto? _$v;

  String? _cityId;
  String? get cityId => _$this._cityId;
  set cityId(String? cityId) => _$this._cityId = cityId;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  AdminNewMassPushDtoAudienceEnum? _audience;
  AdminNewMassPushDtoAudienceEnum? get audience => _$this._audience;
  set audience(AdminNewMassPushDtoAudienceEnum? audience) =>
      _$this._audience = audience;

  String? _zoneId;
  String? get zoneId => _$this._zoneId;
  set zoneId(String? zoneId) => _$this._zoneId = zoneId;

  int? _inactiveDays;
  int? get inactiveDays => _$this._inactiveDays;
  set inactiveDays(int? inactiveDays) => _$this._inactiveDays = inactiveDays;

  AdminNewMassPushDtoTargetEnum? _target;
  AdminNewMassPushDtoTargetEnum? get target => _$this._target;
  set target(AdminNewMassPushDtoTargetEnum? target) => _$this._target = target;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _codeId;
  String? get codeId => _$this._codeId;
  set codeId(String? codeId) => _$this._codeId = codeId;

  DateTime? _sendAt;
  DateTime? get sendAt => _$this._sendAt;
  set sendAt(DateTime? sendAt) => _$this._sendAt = sendAt;

  int? _audienceSize;
  int? get audienceSize => _$this._audienceSize;
  set audienceSize(int? audienceSize) => _$this._audienceSize = audienceSize;

  AdminNewMassPushDtoBuilder() {
    AdminNewMassPushDto._defaults(this);
  }

  AdminNewMassPushDtoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _cityId = $v.cityId;
      _title = $v.title;
      _body = $v.body;
      _audience = $v.audience;
      _zoneId = $v.zoneId;
      _inactiveDays = $v.inactiveDays;
      _target = $v.target;
      _restaurantId = $v.restaurantId;
      _codeId = $v.codeId;
      _sendAt = $v.sendAt;
      _audienceSize = $v.audienceSize;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminNewMassPushDto other) {
    _$v = other as _$AdminNewMassPushDto;
  }

  @override
  void update(void Function(AdminNewMassPushDtoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminNewMassPushDto build() => _build();

  _$AdminNewMassPushDto _build() {
    final _$result =
        _$v ??
        _$AdminNewMassPushDto._(
          cityId: BuiltValueNullFieldError.checkNotNull(
            cityId,
            r'AdminNewMassPushDto',
            'cityId',
          ),
          title: BuiltValueNullFieldError.checkNotNull(
            title,
            r'AdminNewMassPushDto',
            'title',
          ),
          body: BuiltValueNullFieldError.checkNotNull(
            body,
            r'AdminNewMassPushDto',
            'body',
          ),
          audience: BuiltValueNullFieldError.checkNotNull(
            audience,
            r'AdminNewMassPushDto',
            'audience',
          ),
          zoneId: zoneId,
          inactiveDays: inactiveDays,
          target: BuiltValueNullFieldError.checkNotNull(
            target,
            r'AdminNewMassPushDto',
            'target',
          ),
          restaurantId: restaurantId,
          codeId: codeId,
          sendAt: sendAt,
          audienceSize: BuiltValueNullFieldError.checkNotNull(
            audienceSize,
            r'AdminNewMassPushDto',
            'audienceSize',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
