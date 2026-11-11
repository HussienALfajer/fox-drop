// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_offers_dto_output_offers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderOffersDtoOutputOffersInnerKindEnum
_$adminOrderOffersDtoOutputOffersInnerKindEnum_manual =
    const AdminOrderOffersDtoOutputOffersInnerKindEnum._('manual');
const AdminOrderOffersDtoOutputOffersInnerKindEnum
_$adminOrderOffersDtoOutputOffersInnerKindEnum_auto =
    const AdminOrderOffersDtoOutputOffersInnerKindEnum._('auto');

AdminOrderOffersDtoOutputOffersInnerKindEnum
_$adminOrderOffersDtoOutputOffersInnerKindEnumValueOf(String name) {
  switch (name) {
    case 'manual':
      return _$adminOrderOffersDtoOutputOffersInnerKindEnum_manual;
    case 'auto':
      return _$adminOrderOffersDtoOutputOffersInnerKindEnum_auto;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderOffersDtoOutputOffersInnerKindEnum>
_$adminOrderOffersDtoOutputOffersInnerKindEnumValues =
    BuiltSet<AdminOrderOffersDtoOutputOffersInnerKindEnum>(
      const <AdminOrderOffersDtoOutputOffersInnerKindEnum>[
        _$adminOrderOffersDtoOutputOffersInnerKindEnum_manual,
        _$adminOrderOffersDtoOutputOffersInnerKindEnum_auto,
      ],
    );

const AdminOrderOffersDtoOutputOffersInnerStatusEnum
_$adminOrderOffersDtoOutputOffersInnerStatusEnum_open =
    const AdminOrderOffersDtoOutputOffersInnerStatusEnum._('open');
const AdminOrderOffersDtoOutputOffersInnerStatusEnum
_$adminOrderOffersDtoOutputOffersInnerStatusEnum_accepted =
    const AdminOrderOffersDtoOutputOffersInnerStatusEnum._('accepted');
const AdminOrderOffersDtoOutputOffersInnerStatusEnum
_$adminOrderOffersDtoOutputOffersInnerStatusEnum_declined =
    const AdminOrderOffersDtoOutputOffersInnerStatusEnum._('declined');
const AdminOrderOffersDtoOutputOffersInnerStatusEnum
_$adminOrderOffersDtoOutputOffersInnerStatusEnum_expired =
    const AdminOrderOffersDtoOutputOffersInnerStatusEnum._('expired');
const AdminOrderOffersDtoOutputOffersInnerStatusEnum
_$adminOrderOffersDtoOutputOffersInnerStatusEnum_withdrawn =
    const AdminOrderOffersDtoOutputOffersInnerStatusEnum._('withdrawn');

AdminOrderOffersDtoOutputOffersInnerStatusEnum
_$adminOrderOffersDtoOutputOffersInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'open':
      return _$adminOrderOffersDtoOutputOffersInnerStatusEnum_open;
    case 'accepted':
      return _$adminOrderOffersDtoOutputOffersInnerStatusEnum_accepted;
    case 'declined':
      return _$adminOrderOffersDtoOutputOffersInnerStatusEnum_declined;
    case 'expired':
      return _$adminOrderOffersDtoOutputOffersInnerStatusEnum_expired;
    case 'withdrawn':
      return _$adminOrderOffersDtoOutputOffersInnerStatusEnum_withdrawn;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderOffersDtoOutputOffersInnerStatusEnum>
_$adminOrderOffersDtoOutputOffersInnerStatusEnumValues =
    BuiltSet<AdminOrderOffersDtoOutputOffersInnerStatusEnum>(
      const <AdminOrderOffersDtoOutputOffersInnerStatusEnum>[
        _$adminOrderOffersDtoOutputOffersInnerStatusEnum_open,
        _$adminOrderOffersDtoOutputOffersInnerStatusEnum_accepted,
        _$adminOrderOffersDtoOutputOffersInnerStatusEnum_declined,
        _$adminOrderOffersDtoOutputOffersInnerStatusEnum_expired,
        _$adminOrderOffersDtoOutputOffersInnerStatusEnum_withdrawn,
      ],
    );

Serializer<AdminOrderOffersDtoOutputOffersInnerKindEnum>
_$adminOrderOffersDtoOutputOffersInnerKindEnumSerializer =
    _$AdminOrderOffersDtoOutputOffersInnerKindEnumSerializer();
Serializer<AdminOrderOffersDtoOutputOffersInnerStatusEnum>
_$adminOrderOffersDtoOutputOffersInnerStatusEnumSerializer =
    _$AdminOrderOffersDtoOutputOffersInnerStatusEnumSerializer();

class _$AdminOrderOffersDtoOutputOffersInnerKindEnumSerializer
    implements
        PrimitiveSerializer<AdminOrderOffersDtoOutputOffersInnerKindEnum> {
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
    AdminOrderOffersDtoOutputOffersInnerKindEnum,
  ];
  @override
  final String wireName = 'AdminOrderOffersDtoOutputOffersInnerKindEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderOffersDtoOutputOffersInnerKindEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderOffersDtoOutputOffersInnerKindEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderOffersDtoOutputOffersInnerKindEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderOffersDtoOutputOffersInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminOrderOffersDtoOutputOffersInnerStatusEnum> {
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
    AdminOrderOffersDtoOutputOffersInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminOrderOffersDtoOutputOffersInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderOffersDtoOutputOffersInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderOffersDtoOutputOffersInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderOffersDtoOutputOffersInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderOffersDtoOutputOffersInner
    extends AdminOrderOffersDtoOutputOffersInner {
  @override
  final String id;
  @override
  final CustomerLocationDtoOutputZone? captain;
  @override
  final AdminOrderOffersDtoOutputOffersInnerKindEnum kind;
  @override
  final bool handover;
  @override
  final DateTime offeredAt;
  @override
  final DateTime expiresAt;
  @override
  final AdminOrderOffersDtoOutputOffersInnerStatusEnum status;
  @override
  final DateTime? respondedAt;
  @override
  final int? responseSec;

  factory _$AdminOrderOffersDtoOutputOffersInner([
    void Function(AdminOrderOffersDtoOutputOffersInnerBuilder)? updates,
  ]) =>
      (AdminOrderOffersDtoOutputOffersInnerBuilder()..update(updates))._build();

  _$AdminOrderOffersDtoOutputOffersInner._({
    required this.id,
    this.captain,
    required this.kind,
    required this.handover,
    required this.offeredAt,
    required this.expiresAt,
    required this.status,
    this.respondedAt,
    this.responseSec,
  }) : super._();
  @override
  AdminOrderOffersDtoOutputOffersInner rebuild(
    void Function(AdminOrderOffersDtoOutputOffersInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderOffersDtoOutputOffersInnerBuilder toBuilder() =>
      AdminOrderOffersDtoOutputOffersInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderOffersDtoOutputOffersInner &&
        id == other.id &&
        captain == other.captain &&
        kind == other.kind &&
        handover == other.handover &&
        offeredAt == other.offeredAt &&
        expiresAt == other.expiresAt &&
        status == other.status &&
        respondedAt == other.respondedAt &&
        responseSec == other.responseSec;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, captain.hashCode);
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, handover.hashCode);
    _$hash = $jc(_$hash, offeredAt.hashCode);
    _$hash = $jc(_$hash, expiresAt.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, respondedAt.hashCode);
    _$hash = $jc(_$hash, responseSec.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderOffersDtoOutputOffersInner')
          ..add('id', id)
          ..add('captain', captain)
          ..add('kind', kind)
          ..add('handover', handover)
          ..add('offeredAt', offeredAt)
          ..add('expiresAt', expiresAt)
          ..add('status', status)
          ..add('respondedAt', respondedAt)
          ..add('responseSec', responseSec))
        .toString();
  }
}

class AdminOrderOffersDtoOutputOffersInnerBuilder
    implements
        Builder<
          AdminOrderOffersDtoOutputOffersInner,
          AdminOrderOffersDtoOutputOffersInnerBuilder
        > {
  _$AdminOrderOffersDtoOutputOffersInner? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  CustomerLocationDtoOutputZoneBuilder? _captain;
  CustomerLocationDtoOutputZoneBuilder get captain =>
      _$this._captain ??= CustomerLocationDtoOutputZoneBuilder();
  set captain(CustomerLocationDtoOutputZoneBuilder? captain) =>
      _$this._captain = captain;

  AdminOrderOffersDtoOutputOffersInnerKindEnum? _kind;
  AdminOrderOffersDtoOutputOffersInnerKindEnum? get kind => _$this._kind;
  set kind(AdminOrderOffersDtoOutputOffersInnerKindEnum? kind) =>
      _$this._kind = kind;

  bool? _handover;
  bool? get handover => _$this._handover;
  set handover(bool? handover) => _$this._handover = handover;

  DateTime? _offeredAt;
  DateTime? get offeredAt => _$this._offeredAt;
  set offeredAt(DateTime? offeredAt) => _$this._offeredAt = offeredAt;

  DateTime? _expiresAt;
  DateTime? get expiresAt => _$this._expiresAt;
  set expiresAt(DateTime? expiresAt) => _$this._expiresAt = expiresAt;

  AdminOrderOffersDtoOutputOffersInnerStatusEnum? _status;
  AdminOrderOffersDtoOutputOffersInnerStatusEnum? get status => _$this._status;
  set status(AdminOrderOffersDtoOutputOffersInnerStatusEnum? status) =>
      _$this._status = status;

  DateTime? _respondedAt;
  DateTime? get respondedAt => _$this._respondedAt;
  set respondedAt(DateTime? respondedAt) => _$this._respondedAt = respondedAt;

  int? _responseSec;
  int? get responseSec => _$this._responseSec;
  set responseSec(int? responseSec) => _$this._responseSec = responseSec;

  AdminOrderOffersDtoOutputOffersInnerBuilder() {
    AdminOrderOffersDtoOutputOffersInner._defaults(this);
  }

  AdminOrderOffersDtoOutputOffersInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _captain = $v.captain?.toBuilder();
      _kind = $v.kind;
      _handover = $v.handover;
      _offeredAt = $v.offeredAt;
      _expiresAt = $v.expiresAt;
      _status = $v.status;
      _respondedAt = $v.respondedAt;
      _responseSec = $v.responseSec;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderOffersDtoOutputOffersInner other) {
    _$v = other as _$AdminOrderOffersDtoOutputOffersInner;
  }

  @override
  void update(
    void Function(AdminOrderOffersDtoOutputOffersInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderOffersDtoOutputOffersInner build() => _build();

  _$AdminOrderOffersDtoOutputOffersInner _build() {
    _$AdminOrderOffersDtoOutputOffersInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderOffersDtoOutputOffersInner._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AdminOrderOffersDtoOutputOffersInner',
              'id',
            ),
            captain: _captain?.build(),
            kind: BuiltValueNullFieldError.checkNotNull(
              kind,
              r'AdminOrderOffersDtoOutputOffersInner',
              'kind',
            ),
            handover: BuiltValueNullFieldError.checkNotNull(
              handover,
              r'AdminOrderOffersDtoOutputOffersInner',
              'handover',
            ),
            offeredAt: BuiltValueNullFieldError.checkNotNull(
              offeredAt,
              r'AdminOrderOffersDtoOutputOffersInner',
              'offeredAt',
            ),
            expiresAt: BuiltValueNullFieldError.checkNotNull(
              expiresAt,
              r'AdminOrderOffersDtoOutputOffersInner',
              'expiresAt',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminOrderOffersDtoOutputOffersInner',
              'status',
            ),
            respondedAt: respondedAt,
            responseSec: responseSec,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'captain';
        _captain?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderOffersDtoOutputOffersInner',
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
