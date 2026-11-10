// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_handover_handovers_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
_$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_declined =
    const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum._(
      'declined',
    );
const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
_$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_expired =
    const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum._(
      'expired',
    );
const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
_$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_withdrawn =
    const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum._(
      'withdrawn',
    );
const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
_$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_ended =
    const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum._(
      'ended',
    );
const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
_$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_replaced =
    const AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum._(
      'replaced',
    );

AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
_$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnumValueOf(
  String name,
) {
  switch (name) {
    case 'declined':
      return _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_declined;
    case 'expired':
      return _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_expired;
    case 'withdrawn':
      return _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_withdrawn;
    case 'ended':
      return _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_ended;
    case 'replaced':
      return _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_replaced;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum>
_$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnumValues =
    BuiltSet<
      AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
    >(const <AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum>[
      _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_declined,
      _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_expired,
      _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_withdrawn,
      _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_ended,
      _$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum_replaced,
    ]);

Serializer<AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum>
_$adminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnumSerializer =
    _$AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnumSerializer();

class _$AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnumSerializer
    implements
        PrimitiveSerializer<
          AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum
        > {
  static const Map<String, Object> _toWire = const <String, Object>{
    'declined': 'declined',
    'expired': 'expired',
    'withdrawn': 'withdrawn',
    'ended': 'ended',
    'replaced': 'replaced',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'declined': 'declined',
    'expired': 'expired',
    'withdrawn': 'withdrawn',
    'ended': 'ended',
    'replaced': 'replaced',
  };

  @override
  final Iterable<Type> types = const <Type>[
    AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum,
  ];
  @override
  final String wireName =
      'AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderHandoverHandoversInner
    extends AdminOrderDtoOutputOrderHandoverHandoversInner {
  @override
  final DateTime openedAt;
  @override
  final String fromCaptainId;
  @override
  final String? fromCaptainName;
  @override
  final String toCaptainId;
  @override
  final String? toCaptainName;
  @override
  final bool offered;
  @override
  final DateTime? assignedAt;
  @override
  final DateTime? receivedAt;
  @override
  final DateTime? closedAt;
  @override
  final AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum?
  closeReason;
  @override
  final String note;
  @override
  final String adminId;

  factory _$AdminOrderDtoOutputOrderHandoverHandoversInner([
    void Function(AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder)?
    updates,
  ]) =>
      (AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder()..update(updates))
          ._build();

  _$AdminOrderDtoOutputOrderHandoverHandoversInner._({
    required this.openedAt,
    required this.fromCaptainId,
    this.fromCaptainName,
    required this.toCaptainId,
    this.toCaptainName,
    required this.offered,
    this.assignedAt,
    this.receivedAt,
    this.closedAt,
    this.closeReason,
    required this.note,
    required this.adminId,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderHandoverHandoversInner rebuild(
    void Function(AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder)
    updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderHandoverHandoversInner &&
        openedAt == other.openedAt &&
        fromCaptainId == other.fromCaptainId &&
        fromCaptainName == other.fromCaptainName &&
        toCaptainId == other.toCaptainId &&
        toCaptainName == other.toCaptainName &&
        offered == other.offered &&
        assignedAt == other.assignedAt &&
        receivedAt == other.receivedAt &&
        closedAt == other.closedAt &&
        closeReason == other.closeReason &&
        note == other.note &&
        adminId == other.adminId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, openedAt.hashCode);
    _$hash = $jc(_$hash, fromCaptainId.hashCode);
    _$hash = $jc(_$hash, fromCaptainName.hashCode);
    _$hash = $jc(_$hash, toCaptainId.hashCode);
    _$hash = $jc(_$hash, toCaptainName.hashCode);
    _$hash = $jc(_$hash, offered.hashCode);
    _$hash = $jc(_$hash, assignedAt.hashCode);
    _$hash = $jc(_$hash, receivedAt.hashCode);
    _$hash = $jc(_$hash, closedAt.hashCode);
    _$hash = $jc(_$hash, closeReason.hashCode);
    _$hash = $jc(_$hash, note.hashCode);
    _$hash = $jc(_$hash, adminId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(
            r'AdminOrderDtoOutputOrderHandoverHandoversInner',
          )
          ..add('openedAt', openedAt)
          ..add('fromCaptainId', fromCaptainId)
          ..add('fromCaptainName', fromCaptainName)
          ..add('toCaptainId', toCaptainId)
          ..add('toCaptainName', toCaptainName)
          ..add('offered', offered)
          ..add('assignedAt', assignedAt)
          ..add('receivedAt', receivedAt)
          ..add('closedAt', closedAt)
          ..add('closeReason', closeReason)
          ..add('note', note)
          ..add('adminId', adminId))
        .toString();
  }
}

class AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderHandoverHandoversInner,
          AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderHandoverHandoversInner? _$v;

  DateTime? _openedAt;
  DateTime? get openedAt => _$this._openedAt;
  set openedAt(DateTime? openedAt) => _$this._openedAt = openedAt;

  String? _fromCaptainId;
  String? get fromCaptainId => _$this._fromCaptainId;
  set fromCaptainId(String? fromCaptainId) =>
      _$this._fromCaptainId = fromCaptainId;

  String? _fromCaptainName;
  String? get fromCaptainName => _$this._fromCaptainName;
  set fromCaptainName(String? fromCaptainName) =>
      _$this._fromCaptainName = fromCaptainName;

  String? _toCaptainId;
  String? get toCaptainId => _$this._toCaptainId;
  set toCaptainId(String? toCaptainId) => _$this._toCaptainId = toCaptainId;

  String? _toCaptainName;
  String? get toCaptainName => _$this._toCaptainName;
  set toCaptainName(String? toCaptainName) =>
      _$this._toCaptainName = toCaptainName;

  bool? _offered;
  bool? get offered => _$this._offered;
  set offered(bool? offered) => _$this._offered = offered;

  DateTime? _assignedAt;
  DateTime? get assignedAt => _$this._assignedAt;
  set assignedAt(DateTime? assignedAt) => _$this._assignedAt = assignedAt;

  DateTime? _receivedAt;
  DateTime? get receivedAt => _$this._receivedAt;
  set receivedAt(DateTime? receivedAt) => _$this._receivedAt = receivedAt;

  DateTime? _closedAt;
  DateTime? get closedAt => _$this._closedAt;
  set closedAt(DateTime? closedAt) => _$this._closedAt = closedAt;

  AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum? _closeReason;
  AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum?
  get closeReason => _$this._closeReason;
  set closeReason(
    AdminOrderDtoOutputOrderHandoverHandoversInnerCloseReasonEnum? closeReason,
  ) => _$this._closeReason = closeReason;

  String? _note;
  String? get note => _$this._note;
  set note(String? note) => _$this._note = note;

  String? _adminId;
  String? get adminId => _$this._adminId;
  set adminId(String? adminId) => _$this._adminId = adminId;

  AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder() {
    AdminOrderDtoOutputOrderHandoverHandoversInner._defaults(this);
  }

  AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _openedAt = $v.openedAt;
      _fromCaptainId = $v.fromCaptainId;
      _fromCaptainName = $v.fromCaptainName;
      _toCaptainId = $v.toCaptainId;
      _toCaptainName = $v.toCaptainName;
      _offered = $v.offered;
      _assignedAt = $v.assignedAt;
      _receivedAt = $v.receivedAt;
      _closedAt = $v.closedAt;
      _closeReason = $v.closeReason;
      _note = $v.note;
      _adminId = $v.adminId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderHandoverHandoversInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderHandoverHandoversInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderHandoverHandoversInnerBuilder)?
    updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderHandoverHandoversInner build() => _build();

  _$AdminOrderDtoOutputOrderHandoverHandoversInner _build() {
    final _$result =
        _$v ??
        _$AdminOrderDtoOutputOrderHandoverHandoversInner._(
          openedAt: BuiltValueNullFieldError.checkNotNull(
            openedAt,
            r'AdminOrderDtoOutputOrderHandoverHandoversInner',
            'openedAt',
          ),
          fromCaptainId: BuiltValueNullFieldError.checkNotNull(
            fromCaptainId,
            r'AdminOrderDtoOutputOrderHandoverHandoversInner',
            'fromCaptainId',
          ),
          fromCaptainName: fromCaptainName,
          toCaptainId: BuiltValueNullFieldError.checkNotNull(
            toCaptainId,
            r'AdminOrderDtoOutputOrderHandoverHandoversInner',
            'toCaptainId',
          ),
          toCaptainName: toCaptainName,
          offered: BuiltValueNullFieldError.checkNotNull(
            offered,
            r'AdminOrderDtoOutputOrderHandoverHandoversInner',
            'offered',
          ),
          assignedAt: assignedAt,
          receivedAt: receivedAt,
          closedAt: closedAt,
          closeReason: closeReason,
          note: BuiltValueNullFieldError.checkNotNull(
            note,
            r'AdminOrderDtoOutputOrderHandoverHandoversInner',
            'note',
          ),
          adminId: BuiltValueNullFieldError.checkNotNull(
            adminId,
            r'AdminOrderDtoOutputOrderHandoverHandoversInner',
            'adminId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
