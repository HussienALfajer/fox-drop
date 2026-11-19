// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_search_results_dto_output_orders_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminSearchResultsDtoOutputOrdersInnerStatusEnum
_$adminSearchResultsDtoOutputOrdersInnerStatusEnum_placed =
    const AdminSearchResultsDtoOutputOrdersInnerStatusEnum._('placed');
const AdminSearchResultsDtoOutputOrdersInnerStatusEnum
_$adminSearchResultsDtoOutputOrdersInnerStatusEnum_accepted =
    const AdminSearchResultsDtoOutputOrdersInnerStatusEnum._('accepted');
const AdminSearchResultsDtoOutputOrdersInnerStatusEnum
_$adminSearchResultsDtoOutputOrdersInnerStatusEnum_ready =
    const AdminSearchResultsDtoOutputOrdersInnerStatusEnum._('ready');
const AdminSearchResultsDtoOutputOrdersInnerStatusEnum
_$adminSearchResultsDtoOutputOrdersInnerStatusEnum_pickedUp =
    const AdminSearchResultsDtoOutputOrdersInnerStatusEnum._('pickedUp');
const AdminSearchResultsDtoOutputOrdersInnerStatusEnum
_$adminSearchResultsDtoOutputOrdersInnerStatusEnum_arrived =
    const AdminSearchResultsDtoOutputOrdersInnerStatusEnum._('arrived');
const AdminSearchResultsDtoOutputOrdersInnerStatusEnum
_$adminSearchResultsDtoOutputOrdersInnerStatusEnum_delivered =
    const AdminSearchResultsDtoOutputOrdersInnerStatusEnum._('delivered');
const AdminSearchResultsDtoOutputOrdersInnerStatusEnum
_$adminSearchResultsDtoOutputOrdersInnerStatusEnum_rejected =
    const AdminSearchResultsDtoOutputOrdersInnerStatusEnum._('rejected');
const AdminSearchResultsDtoOutputOrdersInnerStatusEnum
_$adminSearchResultsDtoOutputOrdersInnerStatusEnum_cancelled =
    const AdminSearchResultsDtoOutputOrdersInnerStatusEnum._('cancelled');
const AdminSearchResultsDtoOutputOrdersInnerStatusEnum
_$adminSearchResultsDtoOutputOrdersInnerStatusEnum_failed =
    const AdminSearchResultsDtoOutputOrdersInnerStatusEnum._('failed');

AdminSearchResultsDtoOutputOrdersInnerStatusEnum
_$adminSearchResultsDtoOutputOrdersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'placed':
      return _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_placed;
    case 'accepted':
      return _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_accepted;
    case 'ready':
      return _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_ready;
    case 'pickedUp':
      return _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_pickedUp;
    case 'arrived':
      return _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_arrived;
    case 'delivered':
      return _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_delivered;
    case 'rejected':
      return _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_rejected;
    case 'cancelled':
      return _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_cancelled;
    case 'failed':
      return _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminSearchResultsDtoOutputOrdersInnerStatusEnum>
_$adminSearchResultsDtoOutputOrdersInnerStatusEnumValues =
    BuiltSet<AdminSearchResultsDtoOutputOrdersInnerStatusEnum>(
      const <AdminSearchResultsDtoOutputOrdersInnerStatusEnum>[
        _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_placed,
        _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_accepted,
        _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_ready,
        _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_pickedUp,
        _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_arrived,
        _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_delivered,
        _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_rejected,
        _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_cancelled,
        _$adminSearchResultsDtoOutputOrdersInnerStatusEnum_failed,
      ],
    );

Serializer<AdminSearchResultsDtoOutputOrdersInnerStatusEnum>
_$adminSearchResultsDtoOutputOrdersInnerStatusEnumSerializer =
    _$AdminSearchResultsDtoOutputOrdersInnerStatusEnumSerializer();

class _$AdminSearchResultsDtoOutputOrdersInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminSearchResultsDtoOutputOrdersInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'placed': 'placed',
    'accepted': 'accepted',
    'ready': 'ready',
    'pickedUp': 'picked_up',
    'arrived': 'arrived',
    'delivered': 'delivered',
    'rejected': 'rejected',
    'cancelled': 'cancelled',
    'failed': 'failed',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'placed': 'placed',
    'accepted': 'accepted',
    'ready': 'ready',
    'picked_up': 'pickedUp',
    'arrived': 'arrived',
    'delivered': 'delivered',
    'rejected': 'rejected',
    'cancelled': 'cancelled',
    'failed': 'failed',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminSearchResultsDtoOutputOrdersInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminSearchResultsDtoOutputOrdersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminSearchResultsDtoOutputOrdersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminSearchResultsDtoOutputOrdersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminSearchResultsDtoOutputOrdersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminSearchResultsDtoOutputOrdersInner
    extends AdminSearchResultsDtoOutputOrdersInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final AdminSearchResultsDtoOutputOrdersInnerStatusEnum status;

  factory _$AdminSearchResultsDtoOutputOrdersInner([
    void Function(AdminSearchResultsDtoOutputOrdersInnerBuilder)? updates,
  ]) => (AdminSearchResultsDtoOutputOrdersInnerBuilder()..update(updates))
      ._build();

  _$AdminSearchResultsDtoOutputOrdersInner._({
    required this.id,
    required this.number,
    required this.status,
  }) : super._();
  @override
  AdminSearchResultsDtoOutputOrdersInner rebuild(
    void Function(AdminSearchResultsDtoOutputOrdersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminSearchResultsDtoOutputOrdersInnerBuilder toBuilder() =>
      AdminSearchResultsDtoOutputOrdersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminSearchResultsDtoOutputOrdersInner &&
        id == other.id &&
        number == other.number &&
        status == other.status;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminSearchResultsDtoOutputOrdersInner',
          )
          ..add('id', id)
          ..add('number', number)
          ..add('status', status))
        .toString();
  }
}

class AdminSearchResultsDtoOutputOrdersInnerBuilder
    implements
        Builder<
          AdminSearchResultsDtoOutputOrdersInner,
          AdminSearchResultsDtoOutputOrdersInnerBuilder
        > {
  _$AdminSearchResultsDtoOutputOrdersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  AdminSearchResultsDtoOutputOrdersInnerStatusEnum? _status;
  AdminSearchResultsDtoOutputOrdersInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminSearchResultsDtoOutputOrdersInnerStatusEnum? status) =>
      _$this._status = status;

  AdminSearchResultsDtoOutputOrdersInnerBuilder() {
    AdminSearchResultsDtoOutputOrdersInner._defaults(this);
  }

  AdminSearchResultsDtoOutputOrdersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _status = $v.status;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminSearchResultsDtoOutputOrdersInner other) {
    _$v = other as _$AdminSearchResultsDtoOutputOrdersInner;
  }

  @override
  void update(
    void Function(AdminSearchResultsDtoOutputOrdersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminSearchResultsDtoOutputOrdersInner build() => _build();

  _$AdminSearchResultsDtoOutputOrdersInner _build() {
    final _$result =
        _$v ??
        _$AdminSearchResultsDtoOutputOrdersInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminSearchResultsDtoOutputOrdersInner',
            'id',
          ),
          number: BuiltValueNullFieldError.checkNotNull(
            number,
            r'AdminSearchResultsDtoOutputOrdersInner',
            'number',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminSearchResultsDtoOutputOrdersInner',
            'status',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
