// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_all_cities_dto_output_cities_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminAllCitiesDtoOutputCitiesInnerStatusEnum
_$adminAllCitiesDtoOutputCitiesInnerStatusEnum_active =
    const AdminAllCitiesDtoOutputCitiesInnerStatusEnum._('active');
const AdminAllCitiesDtoOutputCitiesInnerStatusEnum
_$adminAllCitiesDtoOutputCitiesInnerStatusEnum_inactive =
    const AdminAllCitiesDtoOutputCitiesInnerStatusEnum._('inactive');

AdminAllCitiesDtoOutputCitiesInnerStatusEnum
_$adminAllCitiesDtoOutputCitiesInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$adminAllCitiesDtoOutputCitiesInnerStatusEnum_active;
    case 'inactive':
      return _$adminAllCitiesDtoOutputCitiesInnerStatusEnum_inactive;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminAllCitiesDtoOutputCitiesInnerStatusEnum>
_$adminAllCitiesDtoOutputCitiesInnerStatusEnumValues =
    BuiltSet<AdminAllCitiesDtoOutputCitiesInnerStatusEnum>(
      const <AdminAllCitiesDtoOutputCitiesInnerStatusEnum>[
        _$adminAllCitiesDtoOutputCitiesInnerStatusEnum_active,
        _$adminAllCitiesDtoOutputCitiesInnerStatusEnum_inactive,
      ],
    );

Serializer<AdminAllCitiesDtoOutputCitiesInnerStatusEnum>
_$adminAllCitiesDtoOutputCitiesInnerStatusEnumSerializer =
    _$AdminAllCitiesDtoOutputCitiesInnerStatusEnumSerializer();

class _$AdminAllCitiesDtoOutputCitiesInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminAllCitiesDtoOutputCitiesInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'inactive': 'inactive',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'inactive': 'inactive',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminAllCitiesDtoOutputCitiesInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminAllCitiesDtoOutputCitiesInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminAllCitiesDtoOutputCitiesInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminAllCitiesDtoOutputCitiesInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminAllCitiesDtoOutputCitiesInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminAllCitiesDtoOutputCitiesInner
    extends AdminAllCitiesDtoOutputCitiesInner {
  @override
  final String id;
  @override
  final String code;
  @override
  final String name;
  @override
  final String timeZone;
  @override
  final AdminAllCitiesDtoOutputCitiesInnerStatusEnum status;

  factory _$AdminAllCitiesDtoOutputCitiesInner([
    void Function(AdminAllCitiesDtoOutputCitiesInnerBuilder)? updates,
  ]) => (AdminAllCitiesDtoOutputCitiesInnerBuilder()..update(updates))._build();

  _$AdminAllCitiesDtoOutputCitiesInner._({
    required this.id,
    required this.code,
    required this.name,
    required this.timeZone,
    required this.status,
  }) : super._();
  @override
  AdminAllCitiesDtoOutputCitiesInner rebuild(
    void Function(AdminAllCitiesDtoOutputCitiesInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminAllCitiesDtoOutputCitiesInnerBuilder toBuilder() =>
      AdminAllCitiesDtoOutputCitiesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminAllCitiesDtoOutputCitiesInner &&
        id == other.id &&
        code == other.code &&
        name == other.name &&
        timeZone == other.timeZone &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, timeZone.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminAllCitiesDtoOutputCitiesInner')
          ..add('id', id)
          ..add('code', code)
          ..add('name', name)
          ..add('timeZone', timeZone)
          ..add('status', status))
        .toString();
  }
}

class AdminAllCitiesDtoOutputCitiesInnerBuilder
    implements
        Builder<
          AdminAllCitiesDtoOutputCitiesInner,
          AdminAllCitiesDtoOutputCitiesInnerBuilder
        > {
  _$AdminAllCitiesDtoOutputCitiesInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _timeZone;
  String? get timeZone => _$this._timeZone;
  set timeZone(String? timeZone) => _$this._timeZone = timeZone;

  AdminAllCitiesDtoOutputCitiesInnerStatusEnum? _status;
  AdminAllCitiesDtoOutputCitiesInnerStatusEnum? get status => _$this._status;
  set status(AdminAllCitiesDtoOutputCitiesInnerStatusEnum? status) =>
      _$this._status = status;

  AdminAllCitiesDtoOutputCitiesInnerBuilder() {
    AdminAllCitiesDtoOutputCitiesInner._defaults(this);
  }

  AdminAllCitiesDtoOutputCitiesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _code = $v.code;
      _name = $v.name;
      _timeZone = $v.timeZone;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminAllCitiesDtoOutputCitiesInner other) {
    _$v = other as _$AdminAllCitiesDtoOutputCitiesInner;
  }

  @override
  void update(
    void Function(AdminAllCitiesDtoOutputCitiesInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminAllCitiesDtoOutputCitiesInner build() => _build();

  _$AdminAllCitiesDtoOutputCitiesInner _build() {
    final _$result =
        _$v ??
        _$AdminAllCitiesDtoOutputCitiesInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminAllCitiesDtoOutputCitiesInner',
            'id',
          ),
          code: BuiltValueNullFieldError.checkNotNull(
            code,
            r'AdminAllCitiesDtoOutputCitiesInner',
            'code',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminAllCitiesDtoOutputCitiesInner',
            'name',
          ),
          timeZone: BuiltValueNullFieldError.checkNotNull(
            timeZone,
            r'AdminAllCitiesDtoOutputCitiesInner',
            'timeZone',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminAllCitiesDtoOutputCitiesInner',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
