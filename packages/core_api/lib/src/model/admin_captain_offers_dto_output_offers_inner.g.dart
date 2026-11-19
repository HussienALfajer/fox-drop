// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_captain_offers_dto_output_offers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminCaptainOffersDtoOutputOffersInnerKindEnum
_$adminCaptainOffersDtoOutputOffersInnerKindEnum_manual =
    const AdminCaptainOffersDtoOutputOffersInnerKindEnum._('manual');
const AdminCaptainOffersDtoOutputOffersInnerKindEnum
_$adminCaptainOffersDtoOutputOffersInnerKindEnum_auto =
    const AdminCaptainOffersDtoOutputOffersInnerKindEnum._('auto');

AdminCaptainOffersDtoOutputOffersInnerKindEnum
_$adminCaptainOffersDtoOutputOffersInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'manual':
      return _$adminCaptainOffersDtoOutputOffersInnerKindEnum_manual;
    case 'auto':
      return _$adminCaptainOffersDtoOutputOffersInnerKindEnum_auto;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainOffersDtoOutputOffersInnerKindEnum>
_$adminCaptainOffersDtoOutputOffersInnerKindEnumValues =
    BuiltSet<AdminCaptainOffersDtoOutputOffersInnerKindEnum>(
      const <AdminCaptainOffersDtoOutputOffersInnerKindEnum>[
        _$adminCaptainOffersDtoOutputOffersInnerKindEnum_manual,
        _$adminCaptainOffersDtoOutputOffersInnerKindEnum_auto,
      ],
    );

const AdminCaptainOffersDtoOutputOffersInnerStatusEnum
_$adminCaptainOffersDtoOutputOffersInnerStatusEnum_open =
    const AdminCaptainOffersDtoOutputOffersInnerStatusEnum._('open');
const AdminCaptainOffersDtoOutputOffersInnerStatusEnum
_$adminCaptainOffersDtoOutputOffersInnerStatusEnum_accepted =
    const AdminCaptainOffersDtoOutputOffersInnerStatusEnum._('accepted');
const AdminCaptainOffersDtoOutputOffersInnerStatusEnum
_$adminCaptainOffersDtoOutputOffersInnerStatusEnum_declined =
    const AdminCaptainOffersDtoOutputOffersInnerStatusEnum._('declined');
const AdminCaptainOffersDtoOutputOffersInnerStatusEnum
_$adminCaptainOffersDtoOutputOffersInnerStatusEnum_expired =
    const AdminCaptainOffersDtoOutputOffersInnerStatusEnum._('expired');
const AdminCaptainOffersDtoOutputOffersInnerStatusEnum
_$adminCaptainOffersDtoOutputOffersInnerStatusEnum_withdrawn =
    const AdminCaptainOffersDtoOutputOffersInnerStatusEnum._('withdrawn');

AdminCaptainOffersDtoOutputOffersInnerStatusEnum
_$adminCaptainOffersDtoOutputOffersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_open;
    case 'accepted':
      return _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_accepted;
    case 'declined':
      return _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_declined;
    case 'expired':
      return _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_expired;
    case 'withdrawn':
      return _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_withdrawn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminCaptainOffersDtoOutputOffersInnerStatusEnum>
_$adminCaptainOffersDtoOutputOffersInnerStatusEnumValues =
    BuiltSet<AdminCaptainOffersDtoOutputOffersInnerStatusEnum>(
      const <AdminCaptainOffersDtoOutputOffersInnerStatusEnum>[
        _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_open,
        _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_accepted,
        _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_declined,
        _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_expired,
        _$adminCaptainOffersDtoOutputOffersInnerStatusEnum_withdrawn,
      ],
    );

Serializer<AdminCaptainOffersDtoOutputOffersInnerKindEnum>
_$adminCaptainOffersDtoOutputOffersInnerKindEnumSerializer =
    _$AdminCaptainOffersDtoOutputOffersInnerKindEnumSerializer();
Serializer<AdminCaptainOffersDtoOutputOffersInnerStatusEnum>
_$adminCaptainOffersDtoOutputOffersInnerStatusEnumSerializer =
    _$AdminCaptainOffersDtoOutputOffersInnerStatusEnumSerializer();

class _$AdminCaptainOffersDtoOutputOffersInnerKindEnumSerializer
    implements
        PrimitiveSerializer<AdminCaptainOffersDtoOutputOffersInnerKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'manual': 'manual',
    'auto': 'auto',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'manual': 'manual',
    'auto': 'auto',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainOffersDtoOutputOffersInnerKindEnum,
  ];
  @override
  final String wireName = 'AdminCaptainOffersDtoOutputOffersInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainOffersDtoOutputOffersInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainOffersDtoOutputOffersInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainOffersDtoOutputOffersInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainOffersDtoOutputOffersInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminCaptainOffersDtoOutputOffersInnerStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'open': 'open',
    'accepted': 'accepted',
    'declined': 'declined',
    'expired': 'expired',
    'withdrawn': 'withdrawn',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'open': 'open',
    'accepted': 'accepted',
    'declined': 'declined',
    'expired': 'expired',
    'withdrawn': 'withdrawn',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminCaptainOffersDtoOutputOffersInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminCaptainOffersDtoOutputOffersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminCaptainOffersDtoOutputOffersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminCaptainOffersDtoOutputOffersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminCaptainOffersDtoOutputOffersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminCaptainOffersDtoOutputOffersInner
    extends AdminCaptainOffersDtoOutputOffersInner {
  @override
  final String id;
  @override
  final String orderId;
  @override
  final String? orderNumber;
  @override
  final AdminCaptainOffersDtoOutputOffersInnerKindEnum kind;
  @override
  final bool handover;
  @override
  final DateTime offeredAt;
  @override
  final AdminCaptainOffersDtoOutputOffersInnerStatusEnum status;
  @override
  final DateTime? respondedAt;
  @override
  final int? responseSeconds;

  factory _$AdminCaptainOffersDtoOutputOffersInner([
    void Function(AdminCaptainOffersDtoOutputOffersInnerBuilder)? updates,
  ]) => (AdminCaptainOffersDtoOutputOffersInnerBuilder()..update(updates))
      ._build();

  _$AdminCaptainOffersDtoOutputOffersInner._({
    required this.id,
    required this.orderId,
    this.orderNumber,
    required this.kind,
    required this.handover,
    required this.offeredAt,
    required this.status,
    this.respondedAt,
    this.responseSeconds,
  }) : super._();
  @override
  AdminCaptainOffersDtoOutputOffersInner rebuild(
    void Function(AdminCaptainOffersDtoOutputOffersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminCaptainOffersDtoOutputOffersInnerBuilder toBuilder() =>
      AdminCaptainOffersDtoOutputOffersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminCaptainOffersDtoOutputOffersInner &&
        id == other.id &&
        orderId == other.orderId &&
        orderNumber == other.orderNumber &&
        kind == other.kind &&
        handover == other.handover &&
        offeredAt == other.offeredAt &&
        status == other.status &&
        respondedAt == other.respondedAt &&
        responseSeconds == other.responseSeconds;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, orderNumber.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, handover.hashCode);
    _$hash = $jc(_$hash, offeredAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, respondedAt.hashCode);
    _$hash = $jc(_$hash, responseSeconds.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminCaptainOffersDtoOutputOffersInner',
          )
          ..add('id', id)
          ..add('orderId', orderId)
          ..add('orderNumber', orderNumber)
          ..add('kind', kind)
          ..add('handover', handover)
          ..add('offeredAt', offeredAt)
          ..add('status', status)
          ..add('respondedAt', respondedAt)
          ..add('responseSeconds', responseSeconds))
        .toString();
  }
}

class AdminCaptainOffersDtoOutputOffersInnerBuilder
    implements
        Builder<
          AdminCaptainOffersDtoOutputOffersInner,
          AdminCaptainOffersDtoOutputOffersInnerBuilder
        > {
  _$AdminCaptainOffersDtoOutputOffersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  String? _orderNumber;
  String? get orderNumber => _$this._orderNumber;
  set orderNumber(String? orderNumber) => _$this._orderNumber = orderNumber;

  AdminCaptainOffersDtoOutputOffersInnerKindEnum? _kind;
  AdminCaptainOffersDtoOutputOffersInnerKindEnum? get kind => _$this._kind;
  set kind(AdminCaptainOffersDtoOutputOffersInnerKindEnum? kind) =>
      _$this._kind = kind;

  bool? _handover;
  bool? get handover => _$this._handover;
  set handover(bool? handover) => _$this._handover = handover;

  DateTime? _offeredAt;
  DateTime? get offeredAt => _$this._offeredAt;
  set offeredAt(DateTime? offeredAt) => _$this._offeredAt = offeredAt;

  AdminCaptainOffersDtoOutputOffersInnerStatusEnum? _status;
  AdminCaptainOffersDtoOutputOffersInnerStatusEnum? get status =>
      _$this._status;
  set status(AdminCaptainOffersDtoOutputOffersInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _respondedAt;
  DateTime? get respondedAt => _$this._respondedAt;
  set respondedAt(DateTime? respondedAt) => _$this._respondedAt = respondedAt;

  int? _responseSeconds;
  int? get responseSeconds => _$this._responseSeconds;
  set responseSeconds(int? responseSeconds) =>
      _$this._responseSeconds = responseSeconds;

  AdminCaptainOffersDtoOutputOffersInnerBuilder() {
    AdminCaptainOffersDtoOutputOffersInner._defaults(this);
  }

  AdminCaptainOffersDtoOutputOffersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderId = $v.orderId;
      _orderNumber = $v.orderNumber;
      _kind = $v.kind;
      _handover = $v.handover;
      _offeredAt = $v.offeredAt;
      _status = $v.status;
      _respondedAt = $v.respondedAt;
      _responseSeconds = $v.responseSeconds;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminCaptainOffersDtoOutputOffersInner other) {
    _$v = other as _$AdminCaptainOffersDtoOutputOffersInner;
  }

  @override
  void update(
    void Function(AdminCaptainOffersDtoOutputOffersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminCaptainOffersDtoOutputOffersInner build() => _build();

  _$AdminCaptainOffersDtoOutputOffersInner _build() {
    final _$result =
        _$v ??
        _$AdminCaptainOffersDtoOutputOffersInner._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AdminCaptainOffersDtoOutputOffersInner',
            'id',
          ),
          orderId: BuiltValueNullFieldError.checkNotNull(
            orderId,
            r'AdminCaptainOffersDtoOutputOffersInner',
            'orderId',
          ),
          orderNumber: orderNumber,
          kind: BuiltValueNullFieldError.checkNotNull(
            kind,
            r'AdminCaptainOffersDtoOutputOffersInner',
            'kind',
          ),
          handover: BuiltValueNullFieldError.checkNotNull(
            handover,
            r'AdminCaptainOffersDtoOutputOffersInner',
            'handover',
          ),
          offeredAt: BuiltValueNullFieldError.checkNotNull(
            offeredAt,
            r'AdminCaptainOffersDtoOutputOffersInner',
            'offeredAt',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'AdminCaptainOffersDtoOutputOffersInner',
            'status',
          ),
          respondedAt: respondedAt,
          responseSeconds: responseSeconds,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
