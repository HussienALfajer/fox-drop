// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_delivery_recorded_by.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum
_$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnum_captain =
    const AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum._('captain');
const AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum
_$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnum_admin =
    const AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum._('admin');

AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum
_$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnumValueOf(String name) {
  switch (name) {
    case 'captain':
      return _$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnum_captain;
    case 'admin':
      return _$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnum_admin;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum>
_$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum>(
      const <AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum>[
        _$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnum_captain,
        _$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnum_admin,
      ],
    );

Serializer<AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum>
_$adminOrderDtoOutputOrderDeliveryRecordedByTypeEnumSerializer =
    _$AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnumSerializer();

class _$AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'captain': 'captain',
    'admin': 'admin',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'captain': 'captain',
    'admin': 'admin',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum,
  ];
  @override
  final String wireName = 'AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderDeliveryRecordedBy
    extends AdminOrderDtoOutputOrderDeliveryRecordedBy {
  @override
  final AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum type;
  @override
  final String id;
  @override
  final String? reason;

  factory _$AdminOrderDtoOutputOrderDeliveryRecordedBy([
    void Function(AdminOrderDtoOutputOrderDeliveryRecordedByBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderDeliveryRecordedByBuilder()..update(updates))
      ._build();

  _$AdminOrderDtoOutputOrderDeliveryRecordedBy._({
    required this.type,
    required this.id,
    this.reason,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderDeliveryRecordedBy rebuild(
    void Function(AdminOrderDtoOutputOrderDeliveryRecordedByBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderDeliveryRecordedByBuilder toBuilder() =>
      AdminOrderDtoOutputOrderDeliveryRecordedByBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderDeliveryRecordedBy &&
        type == other.type &&
        id == other.id &&
        reason == other.reason;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, reason.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderDeliveryRecordedBy',
          )
          ..add('type', type)
          ..add('id', id)
          ..add('reason', reason))
        .toString();
  }
}

class AdminOrderDtoOutputOrderDeliveryRecordedByBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderDeliveryRecordedBy,
          AdminOrderDtoOutputOrderDeliveryRecordedByBuilder
        > {
  _$AdminOrderDtoOutputOrderDeliveryRecordedBy? _$v;

  AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum? _type;
  AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum? get type => _$this._type;
  set type(AdminOrderDtoOutputOrderDeliveryRecordedByTypeEnum? type) =>
      _$this._type = type;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _reason;
  String? get reason => _$this._reason;
  set reason(String? reason) => _$this._reason = reason;

  AdminOrderDtoOutputOrderDeliveryRecordedByBuilder() {
    AdminOrderDtoOutputOrderDeliveryRecordedBy._defaults(this);
  }

  AdminOrderDtoOutputOrderDeliveryRecordedByBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _type = $v.type;
      _id = $v.id;
      _reason = $v.reason;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderDeliveryRecordedBy other) {
    _$v = other as _$AdminOrderDtoOutputOrderDeliveryRecordedBy;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderDeliveryRecordedByBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderDeliveryRecordedBy build() => _build();

  _$AdminOrderDtoOutputOrderDeliveryRecordedBy _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderDeliveryRecordedBy._(
          type: BuiltValueNullFieldError.checkNotNull(
            type,
            r'AdminOrderDtoOutputOrderDeliveryRecordedBy',
            'type',
          ),
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminOrderDtoOutputOrderDeliveryRecordedBy',
            'id',
          ),
          reason: reason,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
