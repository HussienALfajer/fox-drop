// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_devices_inner_accounts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
_$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_active =
    const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum._('active');
const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
_$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_blocked =
    const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum._(
      'blocked',
    );
const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
_$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_duesUnpaid =
    const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum._(
      'duesUnpaid',
    );
const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
_$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_reviewStop =
    const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum._(
      'reviewStop',
    );
const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
_$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_closed =
    const AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum._('closed');

AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
_$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnumValueOf(
  String name,
) {
  switch (name) {
    case 'active':
      return _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_active;
    case 'blocked':
      return _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_blocked;
    case 'duesUnpaid':
      return _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_duesUnpaid;
    case 'reviewStop':
      return _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_reviewStop;
    case 'closed':
      return _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum>
_$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnumValues =
    BuiltSet<AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum>(
      const <AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum>[
        _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_active,
        _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_blocked,
        _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_duesUnpaid,
        _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_reviewStop,
        _$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum_closed,
      ],
    );

Serializer<AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum>
_$adminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnumSerializer =
    _$AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnumSerializer();

class _$AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'blocked': 'blocked',
    'duesUnpaid': 'dues_unpaid',
    'reviewStop': 'review_stop',
    'closed': 'closed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'blocked': 'blocked',
    'dues_unpaid': 'duesUnpaid',
    'review_stop': 'reviewStop',
    'closed': 'closed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum,
  ];
  @override
  final String wireName =
      'AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCustomerDtoOutputDevicesInnerAccountsInner
    extends AdminCustomerDtoOutputDevicesInnerAccountsInner {
  @override
  final String id;
  @override
  final String? name;
  @override
  final String? maskedPhone;
  @override
  final AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum status;
  @override
  final DateTime lastSignedInAt;

  factory _$AdminCustomerDtoOutputDevicesInnerAccountsInner([
    void Function(AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder)?
    updates,
  ]) =>
      (AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder()
            ..update(updates))
          ._build();

  _$AdminCustomerDtoOutputDevicesInnerAccountsInner._({
    required this.id,
    this.name,
    this.maskedPhone,
    required this.status,
    required this.lastSignedInAt,
  }) : super._();
  @override
  AdminCustomerDtoOutputDevicesInnerAccountsInner rebuild(
    void Function(AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputDevicesInnerAccountsInner &&
        id == other.id &&
        name == other.name &&
        maskedPhone == other.maskedPhone &&
        status == other.status &&
        lastSignedInAt == other.lastSignedInAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, maskedPhone.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, lastSignedInAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCustomerDtoOutputDevicesInnerAccountsInner',
          )
          ..add('id', id)
          ..add('name', name)
          ..add('maskedPhone', maskedPhone)
          ..add('status', status)
          ..add('lastSignedInAt', lastSignedInAt))
        .toString();
  }
}

class AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputDevicesInnerAccountsInner,
          AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder
        > {
  _$AdminCustomerDtoOutputDevicesInnerAccountsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _maskedPhone;
  String? get maskedPhone => _$this._maskedPhone;
  set maskedPhone(String? maskedPhone) => _$this._maskedPhone = maskedPhone;

  AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum? _status;
  AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum? get status =>
      _$this._status;
  set status(
    AdminCustomerDtoOutputDevicesInnerAccountsInnerStatusEnum? status,
  ) => _$this._status = status;

  DateTime? _lastSignedInAt;
  DateTime? get lastSignedInAt => _$this._lastSignedInAt;
  set lastSignedInAt(DateTime? lastSignedInAt) =>
      _$this._lastSignedInAt = lastSignedInAt;

  AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder() {
    AdminCustomerDtoOutputDevicesInnerAccountsInner._defaults(this);
  }

  AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _maskedPhone = $v.maskedPhone;
      _status = $v.status;
      _lastSignedInAt = $v.lastSignedInAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputDevicesInnerAccountsInner other) {
    _$v = other as _$AdminCustomerDtoOutputDevicesInnerAccountsInner;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputDevicesInnerAccountsInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputDevicesInnerAccountsInner build() => _build();

  _$AdminCustomerDtoOutputDevicesInnerAccountsInner _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputDevicesInnerAccountsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCustomerDtoOutputDevicesInnerAccountsInner',
            'id',
          ),
          name: name,
          maskedPhone: maskedPhone,
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminCustomerDtoOutputDevicesInnerAccountsInner',
            'status',
          ),
          lastSignedInAt: BuiltValueNullFieldError.checkNotNull(
            lastSignedInAt,
            r'AdminCustomerDtoOutputDevicesInnerAccountsInner',
            'lastSignedInAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
