// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_order_dto_output_order_edits_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const AdminOrderDtoOutputOrderEditsInnerStatusEnum
_$adminOrderDtoOutputOrderEditsInnerStatusEnum_placed =
    const AdminOrderDtoOutputOrderEditsInnerStatusEnum._('placed');
const AdminOrderDtoOutputOrderEditsInnerStatusEnum
_$adminOrderDtoOutputOrderEditsInnerStatusEnum_accepted =
    const AdminOrderDtoOutputOrderEditsInnerStatusEnum._('accepted');
const AdminOrderDtoOutputOrderEditsInnerStatusEnum
_$adminOrderDtoOutputOrderEditsInnerStatusEnum_ready =
    const AdminOrderDtoOutputOrderEditsInnerStatusEnum._('ready');
const AdminOrderDtoOutputOrderEditsInnerStatusEnum
_$adminOrderDtoOutputOrderEditsInnerStatusEnum_pickedUp =
    const AdminOrderDtoOutputOrderEditsInnerStatusEnum._('pickedUp');
const AdminOrderDtoOutputOrderEditsInnerStatusEnum
_$adminOrderDtoOutputOrderEditsInnerStatusEnum_arrived =
    const AdminOrderDtoOutputOrderEditsInnerStatusEnum._('arrived');
const AdminOrderDtoOutputOrderEditsInnerStatusEnum
_$adminOrderDtoOutputOrderEditsInnerStatusEnum_delivered =
    const AdminOrderDtoOutputOrderEditsInnerStatusEnum._('delivered');
const AdminOrderDtoOutputOrderEditsInnerStatusEnum
_$adminOrderDtoOutputOrderEditsInnerStatusEnum_rejected =
    const AdminOrderDtoOutputOrderEditsInnerStatusEnum._('rejected');
const AdminOrderDtoOutputOrderEditsInnerStatusEnum
_$adminOrderDtoOutputOrderEditsInnerStatusEnum_cancelled =
    const AdminOrderDtoOutputOrderEditsInnerStatusEnum._('cancelled');
const AdminOrderDtoOutputOrderEditsInnerStatusEnum
_$adminOrderDtoOutputOrderEditsInnerStatusEnum_failed =
    const AdminOrderDtoOutputOrderEditsInnerStatusEnum._('failed');

AdminOrderDtoOutputOrderEditsInnerStatusEnum
_$adminOrderDtoOutputOrderEditsInnerStatusEnumValueOf(String name) {
  switch (name) {
    case 'placed':
      return _$adminOrderDtoOutputOrderEditsInnerStatusEnum_placed;
    case 'accepted':
      return _$adminOrderDtoOutputOrderEditsInnerStatusEnum_accepted;
    case 'ready':
      return _$adminOrderDtoOutputOrderEditsInnerStatusEnum_ready;
    case 'pickedUp':
      return _$adminOrderDtoOutputOrderEditsInnerStatusEnum_pickedUp;
    case 'arrived':
      return _$adminOrderDtoOutputOrderEditsInnerStatusEnum_arrived;
    case 'delivered':
      return _$adminOrderDtoOutputOrderEditsInnerStatusEnum_delivered;
    case 'rejected':
      return _$adminOrderDtoOutputOrderEditsInnerStatusEnum_rejected;
    case 'cancelled':
      return _$adminOrderDtoOutputOrderEditsInnerStatusEnum_cancelled;
    case 'failed':
      return _$adminOrderDtoOutputOrderEditsInnerStatusEnum_failed;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<AdminOrderDtoOutputOrderEditsInnerStatusEnum>
_$adminOrderDtoOutputOrderEditsInnerStatusEnumValues =
    BuiltSet<AdminOrderDtoOutputOrderEditsInnerStatusEnum>(
      const <AdminOrderDtoOutputOrderEditsInnerStatusEnum>[
        _$adminOrderDtoOutputOrderEditsInnerStatusEnum_placed,
        _$adminOrderDtoOutputOrderEditsInnerStatusEnum_accepted,
        _$adminOrderDtoOutputOrderEditsInnerStatusEnum_ready,
        _$adminOrderDtoOutputOrderEditsInnerStatusEnum_pickedUp,
        _$adminOrderDtoOutputOrderEditsInnerStatusEnum_arrived,
        _$adminOrderDtoOutputOrderEditsInnerStatusEnum_delivered,
        _$adminOrderDtoOutputOrderEditsInnerStatusEnum_rejected,
        _$adminOrderDtoOutputOrderEditsInnerStatusEnum_cancelled,
        _$adminOrderDtoOutputOrderEditsInnerStatusEnum_failed,
      ],
    );

Serializer<AdminOrderDtoOutputOrderEditsInnerStatusEnum>
_$adminOrderDtoOutputOrderEditsInnerStatusEnumSerializer =
    _$AdminOrderDtoOutputOrderEditsInnerStatusEnumSerializer();

class _$AdminOrderDtoOutputOrderEditsInnerStatusEnumSerializer
    implements
        PrimitiveSerializer<AdminOrderDtoOutputOrderEditsInnerStatusEnum> {
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
    AdminOrderDtoOutputOrderEditsInnerStatusEnum,
  ];
  @override
  final String wireName = 'AdminOrderDtoOutputOrderEditsInnerStatusEnum';

  @override
  Object serialize(
    Serializers serializers,
    AdminOrderDtoOutputOrderEditsInnerStatusEnum object, {
    FullType specifiedType = FullType.unspecified,
  }) => _toWire[object.name] ?? object.name;

  @override
  AdminOrderDtoOutputOrderEditsInnerStatusEnum deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) => AdminOrderDtoOutputOrderEditsInnerStatusEnum.valueOf(
    _fromWire[serialized] ?? (serialized is String ? serialized : ''),
  );
}

class _$AdminOrderDtoOutputOrderEditsInner
    extends AdminOrderDtoOutputOrderEditsInner {
  @override
  final DateTime at;
  @override
  final String adminId;
  @override
  final AdminOrderDtoOutputOrderEditsInnerStatusEnum status;
  @override
  final BuiltList<AdminEditPreviewAnswerDtoOutputChangesInner> changes;
  @override
  final bool addsItems;
  @override
  final AdminOrderDtoOutputOrderEditsInnerItemsValue itemsValue;
  @override
  final AdminOrderDtoOutputOrderEditsInnerItemsValue deliveryFee;
  @override
  final AdminOrderDtoOutputOrderEditsInnerItemsValue total;
  @override
  final int? extraPrepMin;
  @override
  final DateTime? acknowledgedAt;

  factory _$AdminOrderDtoOutputOrderEditsInner([
    void Function(AdminOrderDtoOutputOrderEditsInnerBuilder)? updates,
  ]) => (AdminOrderDtoOutputOrderEditsInnerBuilder()..update(updates))._build();

  _$AdminOrderDtoOutputOrderEditsInner._({
    required this.at,
    required this.adminId,
    required this.status,
    required this.changes,
    required this.addsItems,
    required this.itemsValue,
    required this.deliveryFee,
    required this.total,
    this.extraPrepMin,
    this.acknowledgedAt,
  }) : super._();
  @override
  AdminOrderDtoOutputOrderEditsInner rebuild(
    void Function(AdminOrderDtoOutputOrderEditsInnerBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AdminOrderDtoOutputOrderEditsInnerBuilder toBuilder() =>
      AdminOrderDtoOutputOrderEditsInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AdminOrderDtoOutputOrderEditsInner &&
        at == other.at &&
        adminId == other.adminId &&
        status == other.status &&
        changes == other.changes &&
        addsItems == other.addsItems &&
        itemsValue == other.itemsValue &&
        deliveryFee == other.deliveryFee &&
        total == other.total &&
        extraPrepMin == other.extraPrepMin &&
        acknowledgedAt == other.acknowledgedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, at.hashCode);
    _$hash = $jc(_$hash, adminId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, changes.hashCode);
    _$hash = $jc(_$hash, addsItems.hashCode);
    _$hash = $jc(_$hash, itemsValue.hashCode);
    _$hash = $jc(_$hash, deliveryFee.hashCode);
    _$hash = $jc(_$hash, total.hashCode);
    _$hash = $jc(_$hash, extraPrepMin.hashCode);
    _$hash = $jc(_$hash, acknowledgedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AdminOrderDtoOutputOrderEditsInner')
          ..add('at', at)
          ..add('adminId', adminId)
          ..add('status', status)
          ..add('changes', changes)
          ..add('addsItems', addsItems)
          ..add('itemsValue', itemsValue)
          ..add('deliveryFee', deliveryFee)
          ..add('total', total)
          ..add('extraPrepMin', extraPrepMin)
          ..add('acknowledgedAt', acknowledgedAt))
        .toString();
  }
}

class AdminOrderDtoOutputOrderEditsInnerBuilder
    implements
        Builder<
          AdminOrderDtoOutputOrderEditsInner,
          AdminOrderDtoOutputOrderEditsInnerBuilder
        > {
  _$AdminOrderDtoOutputOrderEditsInner? _$v;

  DateTime? _at;
  DateTime? get at => _$this._at;
  set at(DateTime? at) => _$this._at = at;

  String? _adminId;
  String? get adminId => _$this._adminId;
  set adminId(String? adminId) => _$this._adminId = adminId;

  AdminOrderDtoOutputOrderEditsInnerStatusEnum? _status;
  AdminOrderDtoOutputOrderEditsInnerStatusEnum? get status => _$this._status;
  set status(AdminOrderDtoOutputOrderEditsInnerStatusEnum? status) =>
      _$this._status = status;

  ListBuilder<AdminEditPreviewAnswerDtoOutputChangesInner>? _changes;
  ListBuilder<AdminEditPreviewAnswerDtoOutputChangesInner> get changes =>
      _$this._changes ??=
          ListBuilder<AdminEditPreviewAnswerDtoOutputChangesInner>();
  set changes(
    ListBuilder<AdminEditPreviewAnswerDtoOutputChangesInner>? changes,
  ) => _$this._changes = changes;

  bool? _addsItems;
  bool? get addsItems => _$this._addsItems;
  set addsItems(bool? addsItems) => _$this._addsItems = addsItems;

  AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder? _itemsValue;
  AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder get itemsValue =>
      _$this._itemsValue ??=
          AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder();
  set itemsValue(
    AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder? itemsValue,
  ) => _$this._itemsValue = itemsValue;

  AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder? _deliveryFee;
  AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder get deliveryFee =>
      _$this._deliveryFee ??=
          AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder();
  set deliveryFee(
    AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder? deliveryFee,
  ) => _$this._deliveryFee = deliveryFee;

  AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder? _total;
  AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder get total =>
      _$this._total ??= AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder();
  set total(AdminOrderDtoOutputOrderEditsInnerItemsValueBuilder? total) =>
      _$this._total = total;

  int? _extraPrepMin;
  int? get extraPrepMin => _$this._extraPrepMin;
  set extraPrepMin(int? extraPrepMin) => _$this._extraPrepMin = extraPrepMin;

  DateTime? _acknowledgedAt;
  DateTime? get acknowledgedAt => _$this._acknowledgedAt;
  set acknowledgedAt(DateTime? acknowledgedAt) =>
      _$this._acknowledgedAt = acknowledgedAt;

  AdminOrderDtoOutputOrderEditsInnerBuilder() {
    AdminOrderDtoOutputOrderEditsInner._defaults(this);
  }

  AdminOrderDtoOutputOrderEditsInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _at = $v.at;
      _adminId = $v.adminId;
      _status = $v.status;
      _changes = $v.changes.toBuilder();
      _addsItems = $v.addsItems;
      _itemsValue = $v.itemsValue.toBuilder();
      _deliveryFee = $v.deliveryFee.toBuilder();
      _total = $v.total.toBuilder();
      _extraPrepMin = $v.extraPrepMin;
      _acknowledgedAt = $v.acknowledgedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AdminOrderDtoOutputOrderEditsInner other) {
    _$v = other as _$AdminOrderDtoOutputOrderEditsInner;
  }

  @override
  void update(
    void Function(AdminOrderDtoOutputOrderEditsInnerBuilder)? updates,
  ) {
    if (updates != null) updates(this);
  }

  @override
  AdminOrderDtoOutputOrderEditsInner build() => _build();

  _$AdminOrderDtoOutputOrderEditsInner _build() {
    _$AdminOrderDtoOutputOrderEditsInner _$result;
    try {
      _$result =
          _$v ??
          _$AdminOrderDtoOutputOrderEditsInner._(
            at: BuiltValueNullFieldError.checkNotNull(
              at,
              r'AdminOrderDtoOutputOrderEditsInner',
              'at',
            ),
            adminId: BuiltValueNullFieldError.checkNotNull(
              adminId,
              r'AdminOrderDtoOutputOrderEditsInner',
              'adminId',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AdminOrderDtoOutputOrderEditsInner',
              'status',
            ),
            changes: changes.build(),
            addsItems: BuiltValueNullFieldError.checkNotNull(
              addsItems,
              r'AdminOrderDtoOutputOrderEditsInner',
              'addsItems',
            ),
            itemsValue: itemsValue.build(),
            deliveryFee: deliveryFee.build(),
            total: total.build(),
            extraPrepMin: extraPrepMin,
            acknowledgedAt: acknowledgedAt,
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'changes';
        changes.build();

        _$failedField = 'itemsValue';
        itemsValue.build();
        _$failedField = 'deliveryFee';
        deliveryFee.build();
        _$failedField = 'total';
        total.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AdminOrderDtoOutputOrderEditsInner',
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
