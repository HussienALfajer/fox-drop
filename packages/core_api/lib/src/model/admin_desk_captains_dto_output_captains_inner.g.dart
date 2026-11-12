// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_desk_captains_dto_output_captains_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum
_$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_active =
    const AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum._('active');
const AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum
_$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_suspended =
    const AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum._('suspended');
const AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum
_$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_terminated =
    const AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum._('terminated');

AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum
_$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_active;
    case 'suspended':
      return _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_suspended;
    case 'terminated':
      return _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_terminated;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum>
_$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnumValues =
    BuiltSet<AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum>(
      const <AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum>[
        _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_active,
        _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_suspended,
        _$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnum_terminated,
      ],
    );

Serializer<AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum>
_$adminDeskCaptainsDtoOutputCaptainsInnerStatusEnumSerializer =
    _$AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnumSerializer();

class _$AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'suspended': 'suspended',
    'terminated': 'terminated',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminDeskCaptainsDtoOutputCaptainsInner
    extends AdminDeskCaptainsDtoOutputCaptainsInner {
  @override
  final String id;
  @override
  final String name;
  @override
  final AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum status;

  factory _$AdminDeskCaptainsDtoOutputCaptainsInner([
    void Function(AdminDeskCaptainsDtoOutputCaptainsInnerBuilder)? updates,
  ]) => (AdminDeskCaptainsDtoOutputCaptainsInnerBuilder()..update(updates))
      ._build();

  _$AdminDeskCaptainsDtoOutputCaptainsInner._({
    required this.id,
    required this.name,
    required this.status,
  }) : super._();
  @override
  AdminDeskCaptainsDtoOutputCaptainsInner rebuild(
    void Function(AdminDeskCaptainsDtoOutputCaptainsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminDeskCaptainsDtoOutputCaptainsInnerBuilder toBuilder() =>
      AdminDeskCaptainsDtoOutputCaptainsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminDeskCaptainsDtoOutputCaptainsInner &&
        id == other.id &&
        name == other.name &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminDeskCaptainsDtoOutputCaptainsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('status', status))
        .toString();
  }
}

class AdminDeskCaptainsDtoOutputCaptainsInnerBuilder
    implements
        Builder<
          AdminDeskCaptainsDtoOutputCaptainsInner,
          AdminDeskCaptainsDtoOutputCaptainsInnerBuilder
        > {
  _$AdminDeskCaptainsDtoOutputCaptainsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum? _status;
  AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminDeskCaptainsDtoOutputCaptainsInnerStatusEnum? status) =>
      _$this._status = status;

  AdminDeskCaptainsDtoOutputCaptainsInnerBuilder() {
    AdminDeskCaptainsDtoOutputCaptainsInner._defaults(this);
  }

  AdminDeskCaptainsDtoOutputCaptainsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminDeskCaptainsDtoOutputCaptainsInner other) {
    _$v = other as _$AdminDeskCaptainsDtoOutputCaptainsInner;
  }

  @override
  void update(
    void Function(AdminDeskCaptainsDtoOutputCaptainsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminDeskCaptainsDtoOutputCaptainsInner build() => _build();

  _$AdminDeskCaptainsDtoOutputCaptainsInner _build() {
    final _$result =
        _$v ??
        _$AdminDeskCaptainsDtoOutputCaptainsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminDeskCaptainsDtoOutputCaptainsInner',
            'id',
          ),
          name: BuiltValueNullFieldError.checkNotNull(
            name,
            r'AdminDeskCaptainsDtoOutputCaptainsInner',
            'name',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminDeskCaptainsDtoOutputCaptainsInner',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
