// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_live_map_dto_output_orders_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminLiveMapDtoOutputOrdersInnerStatusEnum
_$adminLiveMapDtoOutputOrdersInnerStatusEnum_placed =
    const AdminLiveMapDtoOutputOrdersInnerStatusEnum._('placed');
const AdminLiveMapDtoOutputOrdersInnerStatusEnum
_$adminLiveMapDtoOutputOrdersInnerStatusEnum_accepted =
    const AdminLiveMapDtoOutputOrdersInnerStatusEnum._('accepted');
const AdminLiveMapDtoOutputOrdersInnerStatusEnum
_$adminLiveMapDtoOutputOrdersInnerStatusEnum_ready =
    const AdminLiveMapDtoOutputOrdersInnerStatusEnum._('ready');
const AdminLiveMapDtoOutputOrdersInnerStatusEnum
_$adminLiveMapDtoOutputOrdersInnerStatusEnum_pickedUp =
    const AdminLiveMapDtoOutputOrdersInnerStatusEnum._('pickedUp');
const AdminLiveMapDtoOutputOrdersInnerStatusEnum
_$adminLiveMapDtoOutputOrdersInnerStatusEnum_arrived =
    const AdminLiveMapDtoOutputOrdersInnerStatusEnum._('arrived');

AdminLiveMapDtoOutputOrdersInnerStatusEnum
_$adminLiveMapDtoOutputOrdersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'placed':
      return _$adminLiveMapDtoOutputOrdersInnerStatusEnum_placed;
    case 'accepted':
      return _$adminLiveMapDtoOutputOrdersInnerStatusEnum_accepted;
    case 'ready':
      return _$adminLiveMapDtoOutputOrdersInnerStatusEnum_ready;
    case 'pickedUp':
      return _$adminLiveMapDtoOutputOrdersInnerStatusEnum_pickedUp;
    case 'arrived':
      return _$adminLiveMapDtoOutputOrdersInnerStatusEnum_arrived;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminLiveMapDtoOutputOrdersInnerStatusEnum>
_$adminLiveMapDtoOutputOrdersInnerStatusEnumValues =
    BuiltSet<AdminLiveMapDtoOutputOrdersInnerStatusEnum>(
      const <AdminLiveMapDtoOutputOrdersInnerStatusEnum>[
        _$adminLiveMapDtoOutputOrdersInnerStatusEnum_placed,
        _$adminLiveMapDtoOutputOrdersInnerStatusEnum_accepted,
        _$adminLiveMapDtoOutputOrdersInnerStatusEnum_ready,
        _$adminLiveMapDtoOutputOrdersInnerStatusEnum_pickedUp,
        _$adminLiveMapDtoOutputOrdersInnerStatusEnum_arrived,
      ],
    );

Serializer<AdminLiveMapDtoOutputOrdersInnerStatusEnum>
_$adminLiveMapDtoOutputOrdersInnerStatusEnumSerializer =
    _$AdminLiveMapDtoOutputOrdersInnerStatusEnumSerializer();

class _$AdminLiveMapDtoOutputOrdersInnerStatusEnumSerializer
    implements PrimitiveSerializer<AdminLiveMapDtoOutputOrdersInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'placed': 'placed',
    'accepted': 'accepted',
    'ready': 'ready',
    'pickedUp': 'picked_up',
    'arrived': 'arrived',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'placed': 'placed',
    'accepted': 'accepted',
    'ready': 'ready',
    'picked_up': 'pickedUp',
    'arrived': 'arrived',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminLiveMapDtoOutputOrdersInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminLiveMapDtoOutputOrdersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminLiveMapDtoOutputOrdersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminLiveMapDtoOutputOrdersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminLiveMapDtoOutputOrdersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminLiveMapDtoOutputOrdersInner
    extends AdminLiveMapDtoOutputOrdersInner {
  @override
  final String id;
  @override
  final String number;
  @override
  final AdminLiveMapDtoOutputOrdersInnerStatusEnum status;
  @override
  final String restaurantId;
  @override
  final String restaurantName;
  @override
  final AdminLiveMapDtoOutputOrdersInnerFrom from;
  @override
  final AdminLiveMapDtoOutputOrdersInnerTo to;
  @override
  final String? captainId;
  @override
  final bool assignable;

  factory _$AdminLiveMapDtoOutputOrdersInner([
    void Function(AdminLiveMapDtoOutputOrdersInnerBuilder)? updates,
  ]) => (AdminLiveMapDtoOutputOrdersInnerBuilder()..update(updates))._build();

  _$AdminLiveMapDtoOutputOrdersInner._({
    required this.id,
    required this.number,
    required this.status,
    required this.restaurantId,
    required this.restaurantName,
    required this.from,
    required this.to,
    this.captainId,
    required this.assignable,
  }) : super._();
  @override
  AdminLiveMapDtoOutputOrdersInner rebuild(
    void Function(AdminLiveMapDtoOutputOrdersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminLiveMapDtoOutputOrdersInnerBuilder toBuilder() =>
      AdminLiveMapDtoOutputOrdersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminLiveMapDtoOutputOrdersInner &&
        id == other.id &&
        number == other.number &&
        status == other.status &&
        restaurantId == other.restaurantId &&
        restaurantName == other.restaurantName &&
        from == other.from &&
        to == other.to &&
        captainId == other.captainId &&
        assignable == other.assignable;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, number.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, restaurantId.hashCode);
    _$hash = $jc(_$hash, restaurantName.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jc(_$hash, captainId.hashCode);
    _$hash = $jc(_$hash, assignable.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminLiveMapDtoOutputOrdersInner')
          ..add('id', id)
          ..add('number', number)
          ..add('status', status)
          ..add('restaurantId', restaurantId)
          ..add('restaurantName', restaurantName)
          ..add('from', from)
          ..add('to', to)
          ..add('captainId', captainId)
          ..add('assignable', assignable))
        .toString();
  }
}

class AdminLiveMapDtoOutputOrdersInnerBuilder
    implements
        Builder<
          AdminLiveMapDtoOutputOrdersInner,
          AdminLiveMapDtoOutputOrdersInnerBuilder
        > {
  _$AdminLiveMapDtoOutputOrdersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _number;
  String? get number => _$this._number;
  set number(String? number) => _$this._number = number;

  AdminLiveMapDtoOutputOrdersInnerStatusEnum? _status;
  AdminLiveMapDtoOutputOrdersInnerStatusEnum? get status => _$this._status;
  set status(AdminLiveMapDtoOutputOrdersInnerStatusEnum? status) =>
      _$this._status = status;

  String? _restaurantId;
  String? get restaurantId => _$this._restaurantId;
  set restaurantId(String? restaurantId) => _$this._restaurantId = restaurantId;

  String? _restaurantName;
  String? get restaurantName => _$this._restaurantName;
  set restaurantName(String? restaurantName) =>
      _$this._restaurantName = restaurantName;

  AdminLiveMapDtoOutputOrdersInnerFromBuilder? _from;
  AdminLiveMapDtoOutputOrdersInnerFromBuilder get from =>
      _$this._from ??= AdminLiveMapDtoOutputOrdersInnerFromBuilder();
  set from(AdminLiveMapDtoOutputOrdersInnerFromBuilder? from) =>
      _$this._from = from;

  AdminLiveMapDtoOutputOrdersInnerToBuilder? _to;
  AdminLiveMapDtoOutputOrdersInnerToBuilder get to =>
      _$this._to ??= AdminLiveMapDtoOutputOrdersInnerToBuilder();
  set to(AdminLiveMapDtoOutputOrdersInnerToBuilder? to) => _$this._to = to;

  String? _captainId;
  String? get captainId => _$this._captainId;
  set captainId(String? captainId) => _$this._captainId = captainId;

  bool? _assignable;
  bool? get assignable => _$this._assignable;
  set assignable(bool? assignable) => _$this._assignable = assignable;

  AdminLiveMapDtoOutputOrdersInnerBuilder() {
    AdminLiveMapDtoOutputOrdersInner._defaults(this);
  }

  AdminLiveMapDtoOutputOrdersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _number = $v.number;
      _status = $v.status;
      _restaurantId = $v.restaurantId;
      _restaurantName = $v.restaurantName;
      _from = $v.from.toBuilder();
      _to = $v.to.toBuilder();
      _captainId = $v.captainId;
      _assignable = $v.assignable;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminLiveMapDtoOutputOrdersInner other) {
    _$v = other as _$AdminLiveMapDtoOutputOrdersInner;
  }

  @override
  void update(void Function(AdminLiveMapDtoOutputOrdersInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AdminLiveMapDtoOutputOrdersInner build() => _build();

  _$AdminLiveMapDtoOutputOrdersInner _build() {
    _$AdminLiveMapDtoOutputOrdersInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminLiveMapDtoOutputOrdersInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminLiveMapDtoOutputOrdersInner',
              'id',
            ),
            number: BuiltValueNullFieldError.checkNotNull(
              number,
              r'AdminLiveMapDtoOutputOrdersInner',
              'number',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminLiveMapDtoOutputOrdersInner',
              'status',
            ),
            restaurantId: BuiltValueNullFieldError.checkNotNull(
              restaurantId,
              r'AdminLiveMapDtoOutputOrdersInner',
              'restaurantId',
            ),
            restaurantName: BuiltValueNullFieldError.checkNotNull(
              restaurantName,
              r'AdminLiveMapDtoOutputOrdersInner',
              'restaurantName',
            ),
            from: from.build(),
            to: to.build(),
            captainId: captainId,
            assignable: BuiltValueNullFieldError.checkNotNull(
              assignable,
              r'AdminLiveMapDtoOutputOrdersInner',
              'assignable',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'from';
        from.build();
        _$failedField = 'to';
        to.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminLiveMapDtoOutputOrdersInner',
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
