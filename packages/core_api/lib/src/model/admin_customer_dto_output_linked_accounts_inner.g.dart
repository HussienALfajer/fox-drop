// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_customer_dto_output_linked_accounts_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum
_$adminCustomerDtoOutputLinkedAccountsInnerStatusEnum_active =
    const AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum._('active');
const AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum
_$adminCustomerDtoOutputLinkedAccountsInnerStatusEnum_closed =
    const AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum._('closed');

AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum
_$adminCustomerDtoOutputLinkedAccountsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'active':
      return _$adminCustomerDtoOutputLinkedAccountsInnerStatusEnum_active;
    case 'closed':
      return _$adminCustomerDtoOutputLinkedAccountsInnerStatusEnum_closed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum>
_$adminCustomerDtoOutputLinkedAccountsInnerStatusEnumValues =
    BuiltSet<AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum>(
      const <AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum>[
        _$adminCustomerDtoOutputLinkedAccountsInnerStatusEnum_active,
        _$adminCustomerDtoOutputLinkedAccountsInnerStatusEnum_closed,
      ],
    );

Serializer<AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum>
_$adminCustomerDtoOutputLinkedAccountsInnerStatusEnumSerializer =
    _$AdminCustomerDtoOutputLinkedAccountsInnerStatusEnumSerializer();

class _$AdminCustomerDtoOutputLinkedAccountsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<
          AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'active': 'active',
    'closed': 'closed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'active': 'active',
    'closed': 'closed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCustomerDtoOutputLinkedAccountsInner
    extends AdminCustomerDtoOutputLinkedAccountsInner {
  @override
  final String id;
  @override
  final AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? closedAt;

  factory _$AdminCustomerDtoOutputLinkedAccountsInner([
    void Function(AdminCustomerDtoOutputLinkedAccountsInnerBuilder)? updates,
  ]) => (AdminCustomerDtoOutputLinkedAccountsInnerBuilder()..update(updates))
      ._build();

  _$AdminCustomerDtoOutputLinkedAccountsInner._({
    required this.id,
    required this.status,
    required this.createdAt,
    this.closedAt,
  }) : super._();
  @override
  AdminCustomerDtoOutputLinkedAccountsInner rebuild(
    void Function(AdminCustomerDtoOutputLinkedAccountsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCustomerDtoOutputLinkedAccountsInnerBuilder toBuilder() =>
      AdminCustomerDtoOutputLinkedAccountsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCustomerDtoOutputLinkedAccountsInner &&
        id == other.id &&
        status == other.status &&
        createdAt == other.createdAt &&
        closedAt == other.closedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCustomerDtoOutputLinkedAccountsInner',
          )
          ..add('id', id)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('closedAt', closedAt))
        .toString();
  }
}

class AdminCustomerDtoOutputLinkedAccountsInnerBuilder
    implements
        Builder<
          AdminCustomerDtoOutputLinkedAccountsInner,
          AdminCustomerDtoOutputLinkedAccountsInnerBuilder
        > {
  _$AdminCustomerDtoOutputLinkedAccountsInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum? _status;
  AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminCustomerDtoOutputLinkedAccountsInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  AdminCustomerDtoOutputLinkedAccountsInnerBuilder() {
    AdminCustomerDtoOutputLinkedAccountsInner._defaults(this);
  }

  AdminCustomerDtoOutputLinkedAccountsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _closedAt = $v.closedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCustomerDtoOutputLinkedAccountsInner other) {
    _$v = other as _$AdminCustomerDtoOutputLinkedAccountsInner;
  }

  @override
  void update(
    void Function(AdminCustomerDtoOutputLinkedAccountsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCustomerDtoOutputLinkedAccountsInner build() => _build();

  _$AdminCustomerDtoOutputLinkedAccountsInner _build() {
    final _$result =
        _$v ??
        _$AdminCustomerDtoOutputLinkedAccountsInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCustomerDtoOutputLinkedAccountsInner',
            'id',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminCustomerDtoOutputLinkedAccountsInner',
            'status',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'AdminCustomerDtoOutputLinkedAccountsInner',
            'createdAt',
          ),
          closedAt: closedAt,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
