// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customers_found_dto_output_customers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum
_$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_active =
    const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum._('active');
const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum
_$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_blocked =
    const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum._('blocked');
const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum
_$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_duesUnpaid =
    const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum._('duesUnpaid');
const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum
_$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_reviewStop =
    const AdminCustomersFoundDtoOutputCustomersInnerStatusEnum._('reviewStop');

AdminCustomersFoundDtoOutputCustomersInnerStatusEnum
_$adminCustomersFoundDtoOutputCustomersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_active;
    case 'blocked':
      return _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_blocked;
    case 'duesUnpaid':
      return _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_duesUnpaid;
    case 'reviewStop':
      return _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_reviewStop;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCustomersFoundDtoOutputCustomersInnerStatusEnum>
_$adminCustomersFoundDtoOutputCustomersInnerStatusEnumValues =
    BuiltSet<AdminCustomersFoundDtoOutputCustomersInnerStatusEnum>(
      const <AdminCustomersFoundDtoOutputCustomersInnerStatusEnum>[
        _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_active,
        _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_blocked,
        _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_duesUnpaid,
        _$adminCustomersFoundDtoOutputCustomersInnerStatusEnum_reviewStop,
      ],
    );

Serializer<AdminCustomersFoundDtoOutputCustomersInnerStatusEnum>
_$adminCustomersFoundDtoOutputCustomersInnerStatusEnumSerializer =
    _$AdminCustomersFoundDtoOutputCustomersInnerStatusEnumSerializer();

class _$AdminCustomersFoundDtoOutputCustomersInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCustomersFoundDtoOutputCustomersInnerStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'blocked': 'blocked',
    'duesUnpaid': 'dues_unpaid',
    'reviewStop': 'review_stop',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'blocked': 'blocked',
    'dues_unpaid': 'duesUnpaid',
    'review_stop': 'reviewStop',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCustomersFoundDtoOutputCustomersInnerStatusEnum,
  ];
  @override
  final String wireName =
      'AdminCustomersFoundDtoOutputCustomersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomersFoundDtoOutputCustomersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCustomersFoundDtoOutputCustomersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCustomersFoundDtoOutputCustomersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCustomersFoundDtoOutputCustomersInner
    extends AdminCustomersFoundDtoOutputCustomersInner {
  @override
  final String id;
  @override
  final String? name;
  @override
  final String? maskedPhone;
  @override
  final AdminCustomersFoundDtoOutputCustomersInnerStatusEnum status;

  factory _$AdminCustomersFoundDtoOutputCustomersInner([
    void Function(AdminCustomersFoundDtoOutputCustomersInnerBuilder)? updates,
  ]) => (AdminCustomersFoundDtoOutputCustomersInnerBuilder()..update(updates))
      ._build();

  _$AdminCustomersFoundDtoOutputCustomersInner._({
    required this.id,
    this.name,
    this.maskedPhone,
    required this.status,
  }) : super._();
  @override
  AdminCustomersFoundDtoOutputCustomersInner rebuild(
    void Function(AdminCustomersFoundDtoOutputCustomersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomersFoundDtoOutputCustomersInnerBuilder toBuilder() =>
      AdminCustomersFoundDtoOutputCustomersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomersFoundDtoOutputCustomersInner &&
        id == other.id &&
        name == other.name &&
        maskedPhone == other.maskedPhone &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, maskedPhone.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCustomersFoundDtoOutputCustomersInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('maskedPhone', maskedPhone)
          ..add('status', status))
        .toString();
  }
}

class AdminCustomersFoundDtoOutputCustomersInnerBuilder
    implements
        Builder<
          AdminCustomersFoundDtoOutputCustomersInner,
          AdminCustomersFoundDtoOutputCustomersInnerBuilder
        > {
  _$AdminCustomersFoundDtoOutputCustomersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _maskedPhone;
  String? get maskedPhone => _$this._maskedPhone;
  set maskedPhone(String? maskedPhone) => _$this._maskedPhone = maskedPhone;

  AdminCustomersFoundDtoOutputCustomersInnerStatusEnum? _status;
  AdminCustomersFoundDtoOutputCustomersInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminCustomersFoundDtoOutputCustomersInnerStatusEnum? status) =>
      _$this._status = status;

  AdminCustomersFoundDtoOutputCustomersInnerBuilder() {
    AdminCustomersFoundDtoOutputCustomersInner._defaults(this);
  }

  AdminCustomersFoundDtoOutputCustomersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _maskedPhone = $v.maskedPhone;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomersFoundDtoOutputCustomersInner other) {
    _$v = other as _$AdminCustomersFoundDtoOutputCustomersInner;
  }

  @override
  void update(
    void Function(AdminCustomersFoundDtoOutputCustomersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomersFoundDtoOutputCustomersInner build() => _build();

  _$AdminCustomersFoundDtoOutputCustomersInner _build() {
    final _$result =
        _$v ??
        _$AdminCustomersFoundDtoOutputCustomersInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCustomersFoundDtoOutputCustomersInner',
            'id',
          ),
          name: name,
          maskedPhone: maskedPhone,
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminCustomersFoundDtoOutputCustomersInner',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
